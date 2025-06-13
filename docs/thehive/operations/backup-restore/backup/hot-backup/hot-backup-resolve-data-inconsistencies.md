# How to Resolve Data Inconsistencies During a Hot Backup

This topic provides detailed instructions for resolving data inconsistencies encountered during a hot backup of Cassandra and Elasticsearch in TheHive.

## For Cassandra

<!--
Run a repair on the local node to synchronize its data:

```bash
nodetool repair thehive
```

Check for corrupt SSTables and clean up if necessary:

```bash
nodetool scrub
```
-->

## For Elasticsearch

<!--
Check and fix any index corruption by forcing a merge:

```bash
curl -X POST "http://127.0.0.1:9200/_forcemerge?max_num_segments=1"
```

If corruption persists, reindex the affected data:

```bash
curl -X POST "http://127.0.0.1:9200/_reindex"
```
-->

<h2>Next steps</h2>

* [Restore a Hot Backup on a Standalone Server](../../restore/hot-restore/restore-hot-backup-standalone-server.md)
* [Restore a Hot Backup on a Cluster](../../restore/hot-restore/restore-hot-backup-cluster.md)