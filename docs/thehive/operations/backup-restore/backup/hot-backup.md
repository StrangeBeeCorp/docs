# Hot backups
 
!!! Warning
    As outlined in this documentation, it is **crucial** that the data, index, and files must remain intact and consistent during the backup process. Any inconsistency could jeopardize the restore process. While we provide guidance on creating and restoring Cassandra snapshots, it is important to note that Elasticsearch snapshots should be taken concurrently to ensure consistency and integrity across both systems. Additionally, when using clusters, snapshots should be taken simultaneously across all nodes to maintain consistency.

    The scripts provided are examples that **you must customize** to fit your infrastructure and application stack. For instance, folder paths may differ depending on whether you're using physical servers or Docker Compose to run the services.


### Pre-requisites

**bzip2** package should be installed and available on the operating system before runing any of the scripts below.

* `apt install bzip2` for DEB based OS
* `yum install bzip2` for RPM based OS

&nbsp;

!!! Warning
    **This guide has only been tested on a single node Cassandra server.**



### Overview

To successfully restore TheHive, the following data needs to be saved:

- The database
- Files
- Optionally, the index

---

## Backing Up the Index ?

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

=== "Backup Index, Data and Files"

    ## Cassandra (database)

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

    !!! Tip "The steps described below for data backup should be executed on each node. Each node's data should be backed up to ensure consistency in the backups."

    &nbsp;

    #### Create a snapshot and an archive

    Considering that ${BACKUP} is the name of the snapshot, run the following commands:


    ##### 1 - Use the `nodetool snapshot` command to create a snapshot of all keyspaces:

    !!! Example  ""

        ```bash
        nodetool snapshot -t ${BACKUP}
        ```

    ##### 2 - Create and archive with the snapshot data: Execute the following command For every cassandra keyspace: 

    !!! Example  ""

        ```bash
        tar cjfv ${KEYSPACE_NAME}.tbz -C /var/lib/cassandra/data/${KEYSPACE_NAME}/*/snapshots/${BACKUP} .
        ```

    ##### 3 - Remove old snapshots (if necessary)

    !!! Example  ""

        ```bash
        nodetool -h localhost -p 7199 clearsnapshot -t ${BACKUP}
        ```

    !!! Note
        We strongly recommend copying the snapshot archive files to a remote server or backup storage.

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

    ---

    ## Elasticsearch (index engine)


    ---

    ## Backup files

    Wether you use local or distributed files system storage, copy the content of the folder/bucket.



