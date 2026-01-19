Before creating any backups, we're going to verify that all TheHive components are healthy. This helps us catch any issues that could affect backup integrity.

### Check service status

Let's confirm that all TheHive components are running.

```bash
sudo systemctl status thehive
sudo systemctl status cassandra
sudo systemctl status elasticsearch
```

All services should show as active and running.

### Check Cassandra status

Run the following command:

```bash
nodetool status
```

You should see nodes marked as `UN` (Up/Normal). This indicates your Cassandra cluster is healthy.

### Check Elasticsearch cluster health

```bash
curl -X GET "http://127.0.0.1:9200/_cluster/health?pretty"
```

The status should be `green`, which means your cluster is healthy and fully functional.

Other possible statuses include:

* `yellow`: Some replicas are missing but data is still available.
* `red`: Some data is unavailable—you should investigate before proceeding.

### Review system logs

Check for any recent errors or warnings.

```bash
sudo journalctl -u thehive
sudo journalctl -u cassandra
sudo journalctl -u elasticsearch
```

If you find any critical errors, resolve them before continuing with the backup process.