# How to Restore a Hot Backup on a Standalone Server

This topic provides step-by-step instructions for restoring a hot backup on a standalone server in TheHive.

{!includes/prerequisites-hot-backup-restore.md!}

The process requires backing up data from all three components: Apache Cassandra, Elasticsearch and file storage.

1. [Database restore](#step-1-restore-cassandra-snapshots)
2. [Indexing backup (with optional audit logs management since version 5.5)](#step-2-restore-elasticsearch-snapshots)
3. [File storage restore](#step-3-restore-a-backup-for-file-storage)

!!! warning "Data consistency"
    The restore process for Apache Cassandra, Elasticsearch, and file storage should be done in sequence to ensure data consistency. Ensure each system is fully restored before proceeding to the next. While hot backups may not guarantee full data integrity, following the correct order minimizes risks.

{!includes/adapting-instructions.md!}

## Step 1: Restore Cassandra snapshots

### Prerequisites

To successfully restore TheHive's database, ensure the following conditions are met:

* A backup of the database: `${SNAPSHOT}_${SNAPSHOT_DATE}.tbz`.
* The keyspace to restore must not already exist in the database, or it will be overwritten.
* TheHive application must not be running during the restore process.

### Procedure

<!-- to complete -->

For additional details, refer to the [official Cassandra documentation](https://cassandra.apache.org/doc/stable/cassandra/operating/backups.html).

### Ready-to-use scripts

<!-- to complete -->

## Step 2: Restore Elasticsearch snapshots

### Procedure

<!-- to complete -->

For additional details, refer to the [official Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html).

### Ready-to-use scripts

<!-- to complete -->

## Step 3: Restore a backup for file storage

Whether using local file system storage or Network File System (NFS), restore the saved files to the destination folder used by TheHive. Ensure the account running TheHive has the necessary permissions to create files and folders in the destination.

<h2>Next steps</h2>

* [Perform a Hot Backup on a Standalone Server](../../backup/hot-backup/hot-backup-standalone-server.md)