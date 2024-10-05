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

&nbsp;

#### Create a snapshot and an archive

Considering that your keyspace is `${KEYSPACE}` (`thehive` by default) and `${BACKUP}` is the name of the snapshot, run the following commands:


1. Before taking snapshots

    ```bash
    nodetool cleanup ${KEYSPACE}
    ```

2. Take a snapshot
 
    ```bash
    nodetool snapshot ${KEYSPACE} -t ${BACKUP}
    ```

3. Create and archive with the snapshot data: 

    ```bash
    tar cjf backup.tbz /var/lib/cassandra/data/${KEYSPACE}/*/snapshots/${BACKUP}/
    ```

4. Remove old snapshots (if necessary)

    ```bash
    nodetool -h localhost -p 7199 clearsnapshot -t ${BACKUP}
    ```

&nbsp;

#### Example

!!! Example "Example of script to generate backups of TheHive keyspace"

    ```bash
    #!/bin/bash

    ## Create a tbz archive containing the snapshot

    ## Complete variables before running:
    ## KEYSPACE: Identify the right keyspace to save in cassandra
    ## SNAPSHOT: choose a name for the backup

    SOURCE_KEYSPACE="thehive"
    SNAPSHOT="thehive-backup"
    SNAPSHOT_DATE="$(date +%F)"

    # Backup Cassandra
    nodetool cleanup ${SOURCE_KEYSPACE}

    nodetool snapshot ${SOURCE_KEYSPACE}  -t ${SNAPSHOT}_${SNAPSHOT_DATE}

    tar cjf ${SNAPSHOT}_${SNAPSHOT_DATE}.tbz /var/lib/cassandra/data/${SOURCE_KEYSPACE}/*/snapshots/${SNAPSHOT}_${SNAPSHOT_DATE}/
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

&nbsp;

#### Restore 

1. Create the keyspace

    ```bash
    cqlsh -u cassandra -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "
        CREATE KEYSPACE ${TARGET_KEYSPACE}
        WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}
        AND durable_writes = true;"
    ```

    Here it is possible to use a different keyspace name.

2. Unarchive backup files: 

    ```bash
    RESTORE_PATH=$(mktemp -d)
    tar jxf ${SNAPSHOT}_${SNAPSHOT_DATE}.tbz -C ${RESTORE_PATH}
    ```

3. Create tables from archive

    The archive contains the table schemas. They must be executed in the new keyspace. The schema files are in `${RESTORE_PATH}/var/lib/cassandra/data/${SOURCE_KEYSPACE}/${TABLE}/snapshots/${SNAPSHOT}_${SNAPSHOT_DATE}/schema.cql`

    ```bash
    for CQL in $(find ${RESTORE_PATH} -name schema.cql)
    do
      cqlsh cassandra -f $CQL
    done
    ```

    If you want to change the name of the keyspace (`${SOURCE_KEYSPACE}` => `${TARGET_KEYSPACE}`), you need to rewrite the cql command:

    ```bash
    for CQL in $(find ${RESTORE_PATH} -name schema.cql)
    do
      cqlsh cassandra -e "$(sed -e '/CREATE TABLE/s/'${SOURCE_KEYSPACE}/${TARGET_KEYSPACE}/ $CQL)"
    done
    ```

4. Reorganize snapshot files:

    The files in a snapshot follow the structure: `var/lib/cassandra/data/${KEYSPACE}/${TABLE}/snapshots/${SNAPSHOT}/`. In order to import files, the structure must be: `.../${KEYSPACE}/${TABLE}/`. The following command lines move files to match the expected file organisation.

    ```bash
    mkdir -p ${RESTORE_PATH}/${TARGET_KEYSPACE}
    for TABLE in ${RESTORE_PATH}/var/lib/cassandra/data/${SOURCE_KEYSPACE}/*
    do
      mv $TABLE/snapshots/${SNAPSHOT}_${SNAPSHOT_DATE}/* ${RESTORE_PATH}/${TARGET_KEYSPACE}/$(basename $TABLE)
    done  
    ```

5. Load table data

    ```bash
    for TABLE in ${RESTORE_PATH}/${TARGET_KEYSPACE}/*
    do 
      sstableloader -d ${CASSANDRA_IP} $TABLE
    done
    ```

6. Cleanup

    ```bash
    rm -rf ${RESTORE_PATH}
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
    ## SNAPSHOT: choose a name for the backup
    ## SNAPSHOT_DATE: date of the snapshot to restore

    CASSANDRA_ADDRESS="10.1.1.1"
    RESTORE_PATH=$(mktemp -d)
    SOURCE_KEYSPACE="thehive"
    TARGET_KEYSPACE="thehive_restore"
    SNAPSHOT="thehive-backup"
    SNAPSHOT_DATE="2022-11-29"

    ## Uncompress data in TMP folder
    rm -rf ${RESTORE_PATH} && mkdir ${RESTORE_PATH} 
    tar jxf ${SNAPSHOT}_${SNAPSHOT_DATE}.tbz -C ${RESTORE_PATH}

    ## Read Cassandra password
    echo -n "Cassandra admin password: " 
    read -s CASSANDRA_PASSWORD

    # Create the keyspace
    cqlsh -u cassandra -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "
        CREATE KEYSPACE ${TARGET_KEYSPACE}
        WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}
        AND durable_writes = true;"

    # Create table in keyspace
    for CQL in $(find ${RESTORE_PATH} -name schema.cql)
    do
      cqlsh cassandra -e "$(sed -e '/CREATE TABLE/s/'${SOURCE_KEYSPACE}/${TARGET_KEYSPACE}/ $CQL)"
    done
    
    # Reorganiza snapshot files
    mkdir -p ${RESTORE_PATH}/${TARGET_KEYSPACE}
    for TABLE in ${RESTORE_PATH}/var/lib/cassandra/data/${SOURCE_KEYSPACE}/*
    do
      mv $TABLE/snapshots/${SNAPSHOT}_${SNAPSHOT_DATE}/* ${RESTORE_PATH}/${TARGET_KEYSPACE}/$(basename $TABLE)
    done  

    ## Load data
    for TABLE in ${RESTORE_PATH}/${TARGET_KEYSPACE}/*
    do 
      sstableloader -d ${CASSANDRA_IP} $TABLE
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