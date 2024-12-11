# Backup and Restore Guide

!!! Warning
    **This guide has only been tested on a single node Cassandra server.**



## Overview

To successfully restore TheHive, the following data needs to be saved:

- The database
- Files
- Optionally, the index

---

## Backing Up the Index

### Option 1: Backup Only the Data

You can use Cassandra snapshots to back up the data of a Cassandra node. This can be done while the application is running, meaning there is no downtime. With this option, the index is not backed up and will be rebuilt from the data during restoration.

If the index doesn't exist, it is built when TheHive starts.

**Pros:**

- No downtime during backup
- Backups take less space

**Cons:**

- Restoration can be lengthy (requires a full reindexation of the data)

&nbsp;

### Option 2: Backup the Data and the Index

To ensure the data and the index are synchronized, TheHive must be stopped before backing up Cassandra and Elasticsearch.

**Pros:**

- TheHive can be quickly restored from a backup

**Cons:**

- Downtime of TheHive during the backup
- Backups take more space

---

## Cassandra

### Prerequisites

To back up or export the database from Cassandra, the following information is required:

- Cassandra admin password
- Keyspace used by TheHive (default = `thehive`). This can be checked in the `application.conf` configuration file, in the database configuration under *storage*, *cql*, and `keyspace` attribute.

!!! Tip
    This information can be found in TheHive configuration:

    ```yaml
    db.janusgraph {
        storage {
            backend: cql
            hostname: ["127.0.0.1"]
            cql {
                cluster-name: thp
                keyspace: thehive
            }
        }
    }
    ```

&nbsp;

### Backup

Following actions should be performed to backup the data successfully: 

1. Create a snapshot
2. Save the data

!!! The steps described below for data backup should be executed on each node. Each node's data should be backed up to ensure consistency in the backups.

&nbsp;

#### Create a snapshot and an archive

Considering that ${BACKUP} is the name of the snapshot, run the following commands:


1. Use the ``nodetool snapshot`` command to create a snapshot of all keyspaces:
 
    ```bash
    nodetool snapshot -t ${BACKUP}
    ```

2. Create and archive with the snapshot data: Execute the following command For every cassandra keyspace: 

    ```bash
    tar cjfv ${KEYSPACE_NAME}.tbz -C /var/lib/cassandra/data/${KEYSPACE_NAME}/*/snapshots/${BACKUP} .
    ```

3. Remove old snapshots (if necessary)

    ```bash
    nodetool -h localhost -p 7199 clearsnapshot -t ${BACKUP}
    ```
!!! Note: We strongly recommend copying the snapshot archive files to a remote server or backup storage.
&nbsp;

#### Example

!!! Example "Example of script to generate backups of TheHive keyspace"

    ```bash
    #!/bin/bash

    ## Create a tbz archive containing the snapshot
    ## This script should be executed on each node of the cluster

    ## Complete variables before running:
    HOSTNAME=$(hostname)
    SNAPSHOT_DATE="$(date +%F)"

    REMOTE_USER=<remote_user_to_change>
    REMOTE_HOST=<remote_host_to_change>

    ## Perform a backup for all keyspaces (system included)
    nodetool snapshot -t ${SNAPSHOT_DATE}

    ## Navigate to the snapshot directory

    find /var/lib/cassandra/data -name snapshots

    # Archive snapshot files
    mkdir -p /var/lib/cassandra/archive_backup/$HOSTNAME/${SNAPSHOT_DATE}
    cd /var/lib/cassandra/archive_backup/$HOSTNAME/${SNAPSHOT_DATE}

    for KEYSPACE in $(ls /var/lib/cassandra/data); do
    mkdir $KEYSPACE
    cd $KEYSPACE
    for TABLE in $(ls /var/lib/cassandra/data/${KEYSPACE}); do
        tar cjfv ${TABLE}.tbz -C /var/lib/cassandra/data/${KEYSPACE}/${TABLE}/snapshots/${SNAPSHOT_DATE} .
    done
    cd ..
    done

    nodetool -h localhost -p 7199 clearsnapshot -t ${SNAPSHOT_DATE}

    # Copy the snapshot archive files to a remote server

    scp /var/lib/cassandra/archive_backup/$HOSTNAME/${SNAPSHOT_DATE}/* ${REMOTE_USER}@${REMOTE_HOST}:/remote/node-hostname_cassandra_backup_directory
    ```

&nbsp;

### Restore data

#### Data and index

Before starting TheHive, if there is an index, ensure the index in Elasticsearch matches the data in Cassandra otherwise this would imply unpredictive behavior. You can force resync (reindex all data) by adding `db.janusgraph.forceDropAndRebuildIndex = true` in application.conf.

!!! Warning "Remove this line once TheHive is started"

&nbsp;

#### Pre requisites

Following data is required to restore TheHive database successfully: 

- A backup of the database (`${SNAPSHOT}_${SNAPSHOT_DATE}.tbz`)
- Keyspace to restore does not exist in the database (or it will be overwritten)

All nodes in the cluster should be up before starting the restore procedure.

&nbsp;

#### Restore 


1. Start by drop the database ``TheHive``

    ```bash
    ## SOURCE_KEYSPACE contains the name of theHive database
    CASSANDRA_PASSWORD=<your_admin_password>
    CASSANDRA_ADDRESS=<cassandra_node_ip>
    SOURCE_KEYSPACE=thehive
    cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "DROP KEYSPACE IF EXISTS ${SOURCE_KEYSPACE};"
    ```

2. Create the keyspace

    ```bash
    ## TARGET_KEYSPACE contains the new name of theHive database 
    ## NOTE that you can keep the same database name since the old one has been deleted
    cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "
        CREATE KEYSPACE ${TARGET_KEYSPACE}
        WITH replication = {'class': 'NetworkTopologyStrategy', 'replication_factor': '3'}
        AND durable_writes = true;"
    ```

2. Unarchive backup files: 

!!! Note that the following steps should be executed for every Cassandra cluster node .

    ```bash
    mkdir -p /var/lib/cassandra/restore
    RESTORE_PATH="/var/lib/cassandra/restore"
    SOURCE_KEYSPACE="thehive"
    SNAPSHOT_DATE=<date_of_backup>
    ## TABLES should contain the list of all tables that will be restored
    ## table_name should include the uuid generated by cassandra, for example: table1-f901e0c05d8811ef87c71fc3a94044f4

    TABLES="TABLES_TO_RESTORE"
    ## TABLES="
    ## table1-f901e0c05d8811ef87c71fc3a94044f4
    ## table2-d502a0c05d8811ef87c71fc3a94044f5
    ## table3-a703c0c05d8811ef87c71fc3a94044f6
    ## " 

    ## copy all of the snapshot tables that you want to restore from remote server or local cassandra node then extract it
    ## repeat the following  steps on each node Cassandra for each table in the TABLES List

    cd /var/lib/cassandra/restore
    for table in $TABLES; do
    scp remoteuser@remotehost:/remote/node_name_directory/${SNAPSHOT_DATE}/${SOURCE_KEYSPACE}/${table}.tbz .
    mkdir -p ${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}
    echo "Unarchive backup files for table: $table"
    tar jxf ${table}.tbz -C ${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}
    done
    ```

3. Create tables from archive
    
    The archive contains the table schemas. They must be executed in the new keyspace. The schema files are in `${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}`

    ```bash
    for CQL in $(find ${RESTORE_PATH} -name schema.cql)
    do
      cqlsh -u admin -p ${CASSANDRA_PASSWORD} -f $CQL
    done
    ```

    If you want to change the name of the keyspace (`${SOURCE_KEYSPACE}` => `${TARGET_KEYSPACE}`), you need to rewrite the cql command:

    ```bash
    for CQL in $(find ${RESTORE_PATH} -name schema.cql)
    do
      cqlsh cassandra -e "$(sed -e '/CREATE TABLE/s/'${SOURCE_KEYSPACE}/${TARGET_KEYSPACE}/ $CQL)"
    done
    ```

4. Load table data

!!! Note that the following command should be executed on each Cassandra node in the cluster.

    ```bash
    for TABLE in ${RESTORE_PATH}/${TARGET_KEYSPACE}/*
    do 
    TABLE_BASENAME=$(basename ${TABLE})
    TABLE_NAME=${TABLE_BASENAME%%-*}
    nodetool import ${TARGET_KEYSPACE} ${TABLE_NAME} ${RESTORE_PATH}/${TARGET_KEYSPACE}/${TABLE_BASENAME}
    done
    ```
&nbsp;

If the cluster topology has changed (new nodes added ou removed from the cluster since the last data backup), please follow the run the following command to perform a restore:

    ```bash
    for TABLE in ${RESTORE_PATH}/${TARGET_KEYSPACE}/*
    do 
    TABLE_BASENAME=$(basename ${TABLE})
    sstableloader -d ${CASSANDRA_IP} ${RESTORE_PATH}/${TARGET_KEYSPACE}/${TABLE_BASENAME}
    done
    ```

5. Cleanup

    ```bash
    rm -rf ${RESTORE_PATH}
    ```
&nbsp;

### Rebuid an existing node

If for a particular reason (such as corrupted system data), you need to reintegrate the node into the cluster and restore all data (including system data), here is the procedure:

1. Make sure that the Cassandra service is still down then delete the contents of the data volume:

    ```bash
    cd /var/lib/cassandra/data
    rm -rf *
    ```

2. Copy and unarchive backup files:

    ```bash
    DATA_PATH="/var/lib/cassandra/data"

    SNAPSHOT_DATE=<date_of_snaphot>
    ## KEYSPACES list should inlude all keyspaces
    KEYSPACES="system system_distributed system_traces system_virtual_schema system_auth system_schema system_views thehive"
    cd ${DATA_PATH}
    for ks in $KEYSPACES; do
    scp -r remoteuser@remotehost:/remote/node_name_directory/${SNAPSHOT_DATE}/${ks}/ .
    for file in /var/lib/cassandra/data/${ks}/*; do
        echo "Processing $file"
        filename=$(basename "$file")
        table_name="${filename%%.*}"
        sudo mkdir -p ${ks}/${table_name}
        sudo tar jxf $file -C ${ks}/${table_name}
        rm -f $file
    done
    done

    chown -R cassandra:cassandra  /var/lib/cassandra/data
    ```
3. Start cassandra service 
    
    ```bash
    service cassandra start

    ## heck if Cassandra has started successfully by reviewing its logs
    tail -n 100 /var/log/cassandra/system.log | grep -iE "listening for|startup complete|error|warning"

    INFO  [main] ********,773 PipelineConfigurator.java:125 - Starting listening for CQL clients on localhost/127.0.0.1:9042 (unencrypted)...
    INFO  [main] ********,790 CassandraDaemon.java:776 - Startup complete
    ```

!!! Warning "Ensure no Commitlog file exist before restarting Cassandra service. (`/var/lib/cassandra/commitlog`)"


!!! Example "Example of script to restore TheHive keyspace in Cassandra"

    ```bash
    #!/bin/bash

    ## Restore a KEYSPACE and its data from a CQL file with the schema of the
    ## KEYSPACE and an tbz archive containing the snapshot

    ## Complete variables before running:
    ## CASSANDRA_ADDRESS: IP of cassandra server
    ## RESTORE_PATH: choose a TMP folder !!! this folder will be removed if exists.
    ## SOURCE_KEYSPACE: KEYSPACE used in the backup
    ## TARGET_KEYSPACE: new KEYSPACE name ; use same name of SOURCE_KEYSPACE if no changes
    ## TABLES: should contain the list of all tables that will be restored, table_name should include the uuid generated by cassandra, for example: table1-f901e0c05d8811ef87c71fc3a94044f4
    ## SNAPSHOT: choose a name for the backup
    ## SNAPSHOT_DATE: date of the snapshot to restore

    ## IMPORTANT: Note that the following steps should be executed on each Cassandra cluster node.

    CASSANDRA_ADDRESS="10.1.1.1"
    RESTORE_PATH="/var/lib/cassandra/restore"
    SOURCE_KEYSPACE="thehive"
    TARGET_KEYSPACE="thehive_restore"
    TABLES="
    table1-f901e0c05d8811ef87c71fc3a94044f4
    table2-d502a0c05d8811ef87c71fc3a94044f5
    table3-a703c0c05d8811ef87c71fc3a94044f6
    " 
    SNAPSHOT_DATE="2024-09-23"

    ## Copy from backup folder and Uncompress data in restore folder

    cd ${RESTORE_PATH}
    for table in $TABLES; do
        cp -r PATH_TO_BACKUP_DIRECTORY/${SNAPSHOT_DATE}/${SOURCE_KEYSPACE}/${table}.tbz .
        mkdir -p ${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}
        echo "Unarchive backup files for table: $table"
        tar jxf ${table}.tbz -C ${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}
    done
    ## Read Cassandra password
    echo -n "Cassandra admin password: " 
    read -s CASSANDRA_PASSWORD

    # Drop the keyspace
    cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "DROP KEYSPACE IF EXISTS ${SOURCE_KEYSPACE};"

    # Create the keyspace
    ## TARGET_KEYSPACE contains the new name of theHive database 
    ## NOTE that you can keep the same database name since the old one has been deleted

    cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "
        CREATE KEYSPACE ${TARGET_KEYSPACE}
        WITH replication = {'class': 'NetworkTopologyStrategy', 'replication_factor': '3'}
        AND durable_writes = true;"

    # Create table in keyspace
    for CQL in $(find ${RESTORE_PATH} -name schema.cql)
    do
      cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "$(sed -e '/CREATE TABLE/s/'${SOURCE_KEYSPACE}/${TARGET_KEYSPACE}/ $CQL)"
    done
    

    ## Load data
    for TABLE in ${RESTORE_PATH}/${TARGET_KEYSPACE}/*
        do 
        TABLE_BASENAME=$(basename ${TABLE})
        TABLE_NAME=${TABLE_BASENAME%%-*}
        nodetool import ${TARGET_KEYSPACE} ${TABLE_NAME} ${RESTORE_PATH}/${TARGET_KEYSPACE}/${TABLE_BASENAME}
    done
    ```

---

## Index

Several solutions exist regarding the index:

1. Save the Elasticsearch index and restore it ; follow Elasticsearch guides to perform this action
2. Rebuild the index on the new server, when TheHive start for the first time.

&nbsp;

### Rebuild the index

Once Cassandra database is restored, update the configuration of TheHive to rebuild the index.

These lines should be added to the configuration file only for the first start of TheHive application, and removed later on.

```yaml title="extract from /etc/thehive/application.conf"
db.janusgraph.forceDropAndRebuildIndex = true
```

!!! Warning "Once started, both lines should be removed or commented from the configuration file of TheHive"

---

## Files

### Backup

Wether you use local or distributed files system storage, copy the content of the folder/bucket.

&nbsp;

### Restore

Restore the saved files into the destination folder/bucket that will be used by TheHive.

---

## Troubleshooting

The first start can take some time, especially if the application has to rebuild the index.
Refer to this [troubleshooting section](../installation/upgrade-from-4.x.md/#troubleshooting) to ensure everything goes well with reindexation.


!!! Note
    References:
    - [Backing up and restoring data](https://docs.datastax.com/en/cassandra-oss/3.x/cassandra/operations/opsBackupRestore.html)

&nbsp;