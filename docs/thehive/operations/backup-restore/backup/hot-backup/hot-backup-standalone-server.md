# How to Perform a Hot Backup on a Standalone Server

This topic provides step-by-step instructions for performing a hot backup on a standalone server for TheHive.

{!includes/prerequisites-hot-backup-restore.md!}

{!includes/data-consistency-hot-backup.md!}

{!includes/backup-restore-best-practices.md!}

The process requires backing up data from all three components: Apache Cassandra, Elasticsearch and file storage.

* [Database backup](#create-cassandra-snapshots)
* [Indexing backup](#create-elasticsearch-snapshots)
* [File storage backup](#perform-a-backup-on-file-storage)

## Prerequisites

### Install required tools

{!includes/hot-backup-required-tools.md!}

### Configure systems

{!includes/hot-backup-configure-systems.md!}

### Perform preliminary checks

{!includes/preliminary-checks-hot-backup.md!}

## Create Cassandra snapshots

{!includes/hot-backup-cassandra-snapshots.md!}

## Create Elasticsearch snapshots

Before creating Elasticsearch snapshots, ensure Elasticsearch has the appropriate permissions to write to the snapshot repository.

For shared file systems:

!!! Example ""

    ```bash
    chown elasticsearch:elasticsearch </mnt/backup>
    chmod 770 </mnt/backup>
    ```

Then, use the following script:

!!! warning "Script restrictions"
    This script works only when Elasticsearch runs directly on a machine. It doesn't support deployments using Docker or Kubernetes.

!!! note "Default values"
    Before running this script:

    * Update the snapshot repository name to match your environment. The default name in the script is `thehive_repository`.
    * Verify that the index name matches the one used in the script, which defaults to `thehive_global`. This name may differ if you have rebuilt or customized the index.

{!includes/hot-backup-elasticsearch-snapshots.md!}

## Perform a backup on file storage

Whether using local file system storage or Network File System (NFS), copy the contents of the folder using the following script:

{!includes/hot-backup-file-storage.md!}

<h2>Next steps</h2>

* [Restore a Hot Backup on a Standalone Server](../../restore/hot-restore/restore-hot-backup-standalone-server.md)