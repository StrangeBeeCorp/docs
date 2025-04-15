# How to Restore a Hot Backup on a Standalone Server

This topic provides step-by-step instructions for restoring a hot backup on a standalone server in TheHive.

{!includes/prerequisites-hot-backup-restore.md!}

The instructions are divided into 3 sections:

1. [Indexing and audit logs restore](#step-1-restore-elasticsearch-snapshots)
2. [Database restore](#step-2-restore-cassandra-snapshots)
3. [File storage restore](#step-3-restore-a-backup-for-file-storage)

!!! warning "Data consistency"
    The restore process for Apache Cassandra, Elasticsearch, and file storage should be done in sequence to ensure data consistency. Ensure each system is fully restored before proceeding to the next. While hot backups may not guarantee full data integrity, following the correct order minimizes risks.

{!includes/adapting-instructions.md!}

## Step 1: Restore Elasticsearch snapshots

### Ready-to-use scripts

## Step 2: Restore Cassandra snapshots

### Ready-to-use scripts

## Step 3: Restore a backup for file storage

### Local file storage

#### Ready-to-use scripts

### Network File System (NFS)

#### Ready-to-use scripts

<h2>Next steps</h2>

* [Perform a Hot Backup on a Standalone Server](../backup/hot-backup-standalone-server.md)