# Hot backups
 
!!! Warning
    As outlined in this documentation, it is **crucial** that the data, index, and files must remain intact and consistent during the backup process. Any inconsistency could jeopardize the restore process. While we provide guidance on creating and restoring Cassandra snapshots, it is important to note that Elasticsearch snapshots should be taken concurrently to ensure consistency and integrity across both systems. Additionally, when using clusters, snapshots should be taken simultaneously across all nodes to maintain consistency.

    The scripts provided are examples that **you must customize** to fit your infrastructure and application stack. For instance, folder paths may differ depending on whether you're using physical servers or Docker Compose to run the services.


---
## Introduction

Hot backups are an essential strategy for maintaining business continuity in environments where downtime is not acceptable. Unlike cold backups, which require stopping services to ensure consistency, hot backups allow you to capture snapshots of your data while systems remain operational. This approach is particularly suited for high-availability environments where even minimal downtime could disrupt critical operations.

However, hot backups come with unique challenges. Ensuring the consistency of data, indices, and files during the backup process is critical to avoid issues during restoration. For TheHive, this means taking simultaneous snapshots of its database (Cassandra), indexing engine (Elasticsearch), and file storage. While the process enables uninterrupted service, it requires careful planning and execution to ensure that all components remain synchronized.

This guide provides detailed steps to perform hot backups of TheHive’s components, including Cassandra, Elasticsearch, and file storage. It also discusses the risks, prerequisites, and best practices to ensure your data is securely backed up without affecting the system’s availability. Whether you're operating on physical servers, virtual machines, or containerized environments, this guide will help you implement a reliable hot backup strategy tailored to your infrastructure.

### Pre-requisites

Before performing a hot backup, ensure the following prerequisites are met to facilitate a smooth and reliable process:

### General requirements

Ensure the following tools are installed on your system:

* **Cassandra Nodetool**: For creating database snapshots.
* **tar/bzip2**: For archiving and compressing backup files.
* **rsync**: For transferring file storage data.

Install any missing tools using package managers such as apt or yum:

* `apt install bzip2` for DEB based OS
* `yum install bzip2` for RPM based OS

&nbsp;

### Configuration knowledge

#### Cassandra Keyspace

Identify the keyspace used by TheHive. This is typically defined in the _application.conf_ file under the `db.janusgraph.storage.cql.keyspace` attribute.


#### Elasticsearch Repository

Configure a repository for Elasticsearch snapshots. Ensure the repository is accessible and writable by Elasticsearch.


#### File Storage Location

Locate the folder or object storage (e.g., MinIO) where TheHive stores files. This will be backed up along with the database and indices. If you're using local filesystem or NFS to store your files, the location is typically defined in the application.conf file under the `storage.localfs.location` attribute.

### Consistency Considerations

#### Clustered Environments

For Cassandra and Elasticsearch clusters, ensure snapshots are taken simultaneously across all nodes to maintain consistency.


#### Data Integrity Checks

Perform a preliminary check on the system for data corruption or inconsistencies. Address any issues before proceeding with the backup.


### Testing and Validation

Test the backup process in a staging or test environment to ensure scripts and configurations work as expected.

And periodically validate your restoration procedures using test environments to confirm the integrity of the backup data.


---
## Why is backing up the index optional and what are the consequences ?

In TheHive’s architecture, the decision to back up the Elasticsearch index is a matter of balancing operational priorities such as backup speed, storage requirements, and restoration time. Here’s a breakdown of why backing up the index might be considered optional and the potential consequences of doing so.

### Why backup the index might be skipped

#### Rebuild capability

Elasticsearch indices can be rebuilt from the data stored in Cassandra. This makes it possible to restore the system without explicitly backing up the index, provided the data is intact.


#### Backup size optimization

Excluding the index from the backup process reduces the total backup size. This can be particularly beneficial when dealing with large datasets or limited storage.


### Consequences of not backing up the index

If the index is not backed up, it must be rebuilt from scratch during the restoration process. This can significantly increase the time required to fully restore the system.

### Recommandation

While skipping the index backup offers operational benefits during the backup process, it increases the restoration time and may introduce additional challenges.

* If minimal restoration time is critical, back up the index alongside the database and files.
* If backup speed and storage efficiency are prioritized, skip the index backup but prepare for a longer restoration process.

Ultimately, the decision depends on your infrastructure, operational priorities, and acceptable downtime during recovery. Ensure you have tested and validated your backup and restore processes in a controlled environment before applying them in production.



---
## Backup procedures

### Cassandra (database)

Ensure that all Cassandra data is safely stored in consistent snapshots.


#### Prerequisites

To back up or export the database from Cassandra, the following information is required:

* Cassandra admin password
* Keyspace used by TheHive (default = `thehive`). This can be checked in the `application.conf` configuration file, in the database configuration under *storage*, *cql*, and `keyspace` attribute.

!!! Tip
    This information can be found in TheHive configuration file - _application.conf_ - under the `db.janusgraph.storage` attribute:

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


#### Create snapshots

Following actions should be performed to backup the data successfully:

1. Create a snapshot
2. Save the data

!!! Warning "The steps described below for data backup should be executed on each node. Each node's data should be backed up to ensure consistency in the backups."

Considering that ${BACKUP} is the name of the snapshot, run the following commands:


##### 1 - Use the `nodetool snapshot` command to create a snapshot of all keyspaces

!!! Example  ""

    ```bash
    nodetool snapshot -t ${BACKUP}
    ```

##### 2 - Create and archive with the snapshot data: Execute the following command For every cassandra keyspace

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

---
## Elasticsearch (index engine)

### Prerequisites

#### Snapshot repository configuration

Elasticsearch requires a snapshot repository to store backups. Common options include:

* Shared file systems
* AWS S3 buckets
* Azure Blob Storage
* Google Cloud Storage

Set up the repository before taking snapshots.

#### Permissions

Elasticsearch must have the appropriate permissions to write to the snapshot repository.
For shared file systems:

!!! Example ""

    ```bash
    chown -R elasticsearch:elasticsearch /path/to/backups
    chmod -R 770 /path/to/backups
    ```

#### Cluster health

Ensure the cluster health is green before initiating the backup.

!!! Example ""

    ```bash
    curl -X GET "localhost:9200/_cluster/health?pretty"
    ```

### Backup procedure

#### Register a Snapshot Repository

Use the Elasticsearch API to register a snapshot repository. Below is an example for a file-based repository:

!!! Example ""

    ```bash
    curl -X PUT "http://localhost:9200/_snapshot/my_backup" -H 'Content-Type: application/json' -d'
    {
    "type": "fs",
    "settings": {
        "location": "/patch/to/backups/elasticsearch",
        "compress": true
    }
    }'

    ```

#### Verify Snapshot Completion

!!! Example ""

    ```bash
    curl -X GET "http://localhost:9200/_snapshot/my_backup/snapshot_1"
    ```


!!! Note
    If using a filesystem-based repository, consider archiving the snapshot files to long-term storage (e.g., cloud storage or external disks).


---

## Backup files

Wether you use local or distributed files system storage, copy the content of the folder/bucket. 



