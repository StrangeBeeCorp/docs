# How to Perform a Hot Backup on a Standalone Server

This topic provides step-by-step instructions for performing a hot backup on a standalone server for TheHive.

{!includes/prerequisites-hot-backup-restore.md!}

{!includes/data-consistency-hot-backup.md!}

{!includes/backup-restore-best-practices.md!}

The process requires backing up data from all three components: Apache Cassandra, Elasticsearch and file storage.

* [Database backup](#create-cassandra-snapshots)
* [Indexing backup (with optional audit logs storage since version 5.5)](#create-elasticsearch-snapshots)
* [File storage backup](#perform-a-backup-on-file-storage)

## Prerequisites

{!includes/adapting-instructions.md!}

### Install required tools

{!includes/hot-backup-required-tools.md!}

### Configure systems

{!includes/hot-backup-configure-systems.md!}

### Perform preliminary checks

{!includes/preliminary-checks-hot-backup.md!}

## Create Cassandra snapshots

{!includes/hot-backup-cassandra-snapshots.md!}

## Create Elasticsearch snapshots

{!includes/hot-backup-elasticsearch-snapshots.md!}

## Perform a backup on file storage

{!includes/hot-backup-file-storage.md!}

<h2>Next steps</h2>

* [Restore a Hot Backup on a Standalone Server](../../restore/hot-restore/restore-hot-backup-standalone-server.md)