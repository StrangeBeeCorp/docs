# How to Perform a Hot Backup on a Cluster

This topic provides step-by-step instructions for performing a hot backup on a cluster for TheHive.

{!includes/prerequisites-hot-backup-restore.md!}

{!includes/data-consistency-hot-backup.md!}

{!includes/backup-restore-best-practices.md!}

The process requires backing up data from all three components: Apache Cassandra distributed across three nodes, Elasticsearch and file storage.

* [Database backup](#create-cassandra-snapshots)
* [Indexing backup](#create-elasticsearch-snapshots)
* [File storage backup](#perform-a-backup-on-file-storage)

## Prerequisites

### Install required tools

{!includes/hot-backup-required-tools.md!}

### Configure systems

{!includes/hot-backup-configure-systems.md!}

<!-- + add MinIO option -->

### Perform preliminary checks

{!includes/preliminary-checks-hot-backup.md!}

### Replicate data across all three nodes

!!! warning "Data replication requirement"
    If this requirement isn't met, cluster restoration may fail, and integrity issues could arise. It's your responsibility to ensure data replication across all nodes before proceeding.

Before proceeding with the backup, replicate 100% of your data across all nodes. This simplifies the snapshot procedure, allowing snapshots to be taken from just one node.

#### Verify replication factor

Check the replication factor for your keyspace. It should be set to 3 for a three-node cluster. Use the following command in `cqlsh`:

```sql
DESCRIBE KEYSPACE thehive;
```

If needed, adjust the replication factor:

```sql
ALTER KEYSPACE thehive WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', '<datacenter_name>' : 3 };
```

#### Check cluster status

Ensure all nodes are up and running:

```bash
nodetool status
```

Nodes should be marked as `UN` (Up/Normal).

#### Run `nodetool repair`

Run a repair to ensure data consistency across all nodes:

```bash
nodetool repair
```

#### Verify data replication

Check for any replication issues:

```bash
nodetool netstats
```

## Create Cassandra snapshots

{!includes/hot-backup-cassandra-snapshots.md!}

## Create Elasticsearch snapshots

{!includes/hot-backup-elasticsearch-snapshots.md!}

## Perform a backup on file storage

This procedure applies only to Network File System (NFS) storage. It doesn't apply to MinIO S3 object storage. Use the following script to copy the contents of the NFS folder:

{!includes/hot-backup-file-storage.md!}

<h2>Next steps</h2>

* [Restore a Hot Backup on a Cluster](../../restore/hot-restore/restore-hot-backup-cluster.md)