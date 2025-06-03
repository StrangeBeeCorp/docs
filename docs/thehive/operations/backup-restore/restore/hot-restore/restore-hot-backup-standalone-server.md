# How to Restore a Hot Backup on a Standalone Server

This topic provides step-by-step instructions for restoring a hot backup on a standalone server for TheHive.

{!includes/hot-restore-application-stopped.md!}

{!includes/backup-restore-best-practices.md!}

The process requires backing up data from all three components: Apache Cassandra, Elasticsearch and file storage.

* [Database restore](#restore-cassandra-snapshots)
* [Indexing backup](#restore-elasticsearch-snapshots)
* [File storage restore](#restore-a-backup-for-file-storage)

These procedures assume you have completed the steps in [Perform a Hot Backup on a Standalone Server](../../backup/hot-backup/hot-backup-standalone-server.md) and have stopped your TheHive application. Ensure that paths are consistent between the backup and restore procedures.

## Restore Cassandra snapshots

{!includes/hot-restore-cassandra-snapshots.md!}

## Restore Elasticsearch snapshots

{!includes/hot-restore-elasticsearch-snapshots.md!}

## Restore a backup for file storage

Whether using local file system storage or Network File System (NFS), restore the saved files to the destination folder used by TheHive. Ensure the account running TheHive has the necessary permissions to create files and folders in the destination.

{!includes/hot-restore-file-storage.md!}

<h2>Next steps</h2>

* [Perform a Hot Backup on a Standalone Server](../../backup/hot-backup/hot-backup-standalone-server.md)