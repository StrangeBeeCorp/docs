Perform a preliminary check on the system to identify any data corruption or inconsistencies. Resolve any issues before proceeding with the backup.

#### Check service status

Ensure Cassandra, Elasticsearch, and TheHive are running:

```bash
systemctl status thehive
systemctl status cassandra
systemctl status elasticsearch
```

#### Check Cassandra and Elasticsearch health

For Cassandra, verify the status and check for issues:

```bash
nodetool status
```

Nodes should be marked as `UN` (Up/Normal).

For Elasticsearch, ensure the cluster health is green:

```bash
curl -X GET "http://127.0.0.1:9200/_cluster/health?pretty"
```

Status `green` means the cluster is healthy and fully functional. Other statuses include `yellow`, indicating some replicas are missing but data is still available, and `red`, indicating some data is unavailable.

If you notice any data inconsistencies, refer to the section titled [Resolve any data inconsistencies](#resolve-any-data-inconsistencies).

#### Review system logs

```bash
journalctl -u thehive
journalctl -u cassandra
journalctl -u elasticsearch
```

If you encounter any data inconsistencies, refer to [Resolve Data Inconsistencies](/thehive/operations/backup-restore/backup/hot-backup/hot-backup-resolve-data-inconsistencies/) for assistance.