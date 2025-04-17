# How to Perform a Hot Backup on a Cluster

This topic provides step-by-step instructions for performing a hot backup on a cluster in TheHive.

{!includes/prerequisites-hot-backup-restore.md!}

{!includes/data-consistency-hot-backup.md!}

The process requires backing up data from all three components: Apache Cassandra distributed across three nodes, Elasticsearch and file storage.

* [Database backup](#create-cassandra-snapshots)
* [Indexing backup (with optional audit logs management since version 5.5)](#create-elasticsearch-snapshots)
* [File storage backup](#perform-a-backup-on-file-storage)

## Prerequisites

{!includes/adapting-instructions.md!}

### Install required tools

Before performing a hot backup, install the following tools on your system:

* [Cassandra nodetool](https://cassandra.apache.org/doc/latest/cassandra/troubleshooting/use_nodetool.html): For creating database snapshots
* tar/[bzip2](https://gitlab.com/bzip2/bzip2/): For archiving and compressing backup files
* [rsync](https://github.com/RsyncProject/rsync): For transferring file storage data

Install any missing tools using package managers such as apt or yum:

* `apt install bzip2` for DEB-based operating systems
* `yum install bzip2` for RPM-based operating systems

### Configure systems

#### Cassandra keyspace

Identify the keyspace used by TheHive. This is typically defined in the *application.conf* file under the `db.janusgraph.storage.cql.keyspace` attribute.

#### Elasticsearch repository

Configure a repository for Elasticsearch snapshots. Ensure that the repository is both accessible and writable by Elasticsearch.

#### File storage location

Locate the folder where TheHive stores files, which is backed up with the database and indices. If using a Network File System (NFS), the location is defined in the *application.conf* file under the `storage.localfs.location` attribute.

<!-- + add MinIO option -->

### Ensure data replication across all three nodes

Before proceeding with the backup, replicate 100% of your data across all nodes. This simplifies the snapshot procedure, allowing snapshots to be taken from just one node.

### Perform preliminary checks

Perform a preliminary check on the system to identify any data corruption or inconsistencies. Resolve any issues before proceeding with the backup.

## Create Cassandra snapshots

### Prerequisites

To back up or export the database from Cassandra, gather the following information:

* Cassandra admin password
* Keyspace used by TheHive (default: `thehive`). Find this in the `application.conf` configuration file, under the `db.janusgraph.storage` attribute, within `storage`, `cql`, and `keyspace` settings.

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

<!-- + write option when using Elasticsearch for audit log storage -->

### Procedure

<!-- to complete -->

For additional details, refer to the [official Cassandra documentation](https://cassandra.apache.org/doc/stable/cassandra/operating/backups.html).

### Ready-to-use scripts

<!-- to complete -->

## Create Elasticsearch snapshots

### Prerequisites

#### Configure snapshot repository

Elasticsearch requires a snapshot repository to store backups. Common options include:

* Shared file systems
* AWS S3 buckets
* Azure Blob Storage
* Google Cloud Storage

Set up the repository before taking snapshots.

#### Assign necessary permissions

Elasticsearch must have the appropriate permissions to write to the snapshot repository.

For shared file systems:

!!! Example ""

    ```bash
    chown -R elasticsearch:elasticsearch /path/to/backups
    chmod -R 770 /path/to/backups
    ```

#### Ensure cluster health is green

Make sure the cluster health is green before initiating the backup. This confirms that all nodes in the cluster are functioning properly, and data replication is fully operational.

!!! Example ""

    ```bash
    curl -X GET "localhost:9200/_cluster/health?pretty"
    ```
The response should show `"status": "green"`, indicating that the Elasticsearch cluster is healthy and ready for the backup process.

### Procedure

<!-- to complete -->

<!-- + write option when using Elasticsearch for audit log storage -->

For additional details, refer to the [official Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html).

### Ready-to-use scripts

<!-- to complete -->

## Perform a backup on file storage

Whether using Network File System (NFS) or MinIO S3 object storage, copy the contents of the folder or bucket.

## Test the backup process

Test the backup process in a staging or test environment to ensure scripts and configurations work as expected. Periodically validate restoration procedures in test environments to confirm the integrity of the backup data.

<h2>Next steps</h2>

* [Restore a Hot Backup on a Cluster](../../restore/hot-restore/restore-hot-backup-cluster.md)