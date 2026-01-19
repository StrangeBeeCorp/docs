# Restore a Hot Backup on a Cluster

In this tutorial, we're going to guide you through restoring a hot backup of TheHive on a cluster using the provided scripts.

By the end, you'll have brought your system back to a working state using the backups you created previously, with all your database, search index, and file storage fully restored across your cluster.

{% include-markdown "includes/hot-restore-application-stopped.md" %}

{% include-markdown "includes/backup-restore-best-practices.md" %}

{% include-markdown "includes/python-compatibility-cqlsh.md" %}

This tutorial assumes you’ve completed the [Perform a Hot Backup on a Cluster](../../backup/hot-backup/hot-backup-cluster.md) tutorial, and that you're using the same directory paths during restore as during backup.

## Step 1: Stop TheHive on all nodes

Before we begin restoring data, we need to stop TheHive on all cluster nodes to prevent any conflicts during the restoration process.

Run this command on each node:

```bash
sudo systemctl stop thehive
```

Verify that TheHive has stopped on all nodes:

```bash
sudo systemctl status thehive
```

You should see that the service is inactive on each node.

## Step 2: Restore Cassandra and Elasticsearch snapshots

Now we're going to restore both your database and search index from the backup archives. Since data is fully replicated across all nodes, we only need to run the restore script on one node—the script will automatically distribute the data across your entire cluster. The script handles situations where nodes have been added or removed since the backup was created.

### 1. Prepare the restore script

Before running the script, you'll need to update several values to match your environment:

#### For Cassandra

* Update `CASSANDRA_KEYSPACE` to match your configuration. You can find this in `/etc/thehive/application.conf` file under the `db.janusgraph.storage.cql.keyspace` attribute. The script uses `thehive` by default.
* Update `CASSANDRA_CONNECTION` with any Cassandra node IP address in the cluster.
* If you configured authentication in `/etc/thehive/application.conf`:
    * Replace the value of the `CASSANDRA_CONNECTION` variable with: `"<ip_node_cassandra> admin -p <authentication_admin_password>"`
    * Uncomment the following line: `cqlsh ${CASSANDRA_CONNECTION} --request-timeout=120 -e "GRANT ALL PERMISSIONS ON KEYSPACE ${CASSANDRA_THEHIVE_USER} TO thehive;"`
* Update `CASSANDRA_THEHIVE_USER` to match the role that accesses the keyspace. The script uses `thehive` by default.

#### For Elasticsearch

* Update `ELASTICSEARCH_SNAPSHOT_REPOSITORY` to match the repository name you registered in a previous step. The script uses `thehive_repository` by default.
* If you configured authentication in `/etc/thehive/application.conf`, add `-u thehive:<thehive_user_password>` to all `curl` commands, using your actual password.

### 2. Run the restore script

{% include-markdown "includes/how-to-run-script.md" %}

{% include-markdown "includes/hot-restore-cassandra-elasticsearch-snapshots-cluster.md" %}

The script will automatically identify your most recent backup archives and restore them. You'll see progress messages as the restoration proceeds. When complete, you should see the message `=== ✓ Successful full restore ===`.

For additional details, refer to the official [Cassandra documentation](https://cassandra.apache.org/doc/stable/cassandra/managing/operating/backups.html){target=_blank} and [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html){target=_blank}.

## Step 3: Restore file storage

Finally, we're going to restore the file attachments that were backed up.

The restore procedure depends on your storage backend—either NFS or an S3-compatible object storage service. The script below uses MinIO as an example, but you can adapt the same approach to any S3-compatible implementation.

=== "NFS"

    ### 1. Prepare the restore script

    Before running the script, update `ATTACHMENT_FOLDER` to match your environment. You can find this path in `/etc/thehive/application.conf` under the `storage.localfs.location` attribute. The script uses `/opt/thp/thehive/files` by default.

    ### 2. Run the restore script

    {% include-markdown "includes/hot-restore-file-storage-local-nfs.md" %}

=== "S3-compatible object storage (MinIO example)"

    ### 1. Prepare the restore script

    Before running the script, you'll need to update several values to match your environment:

    * Update `MINIO_ENDPOINT` with your MinIO server URL.
    * Update `MINIO_ACCESS_KEY` with your MinIO access key.
    * Update `MINIO_SECRET_KEY` with your MinIO secret key.
    * Change `MINIO_BUCKET` if you want to use a different bucket name.
    * Change `MINIO_ALIAS` if you want to use a different alias name.

    ### 2. Run the restore script

    {% include-markdown "includes/hot-restore-file-storage-minio.md" %}

## Step 4: Start TheHive on all nodes and verify

Now that all data components have been restored, we're going to start TheHive on all cluster nodes and verify that everything works as expected.

1. Start TheHive on each node.

    ```bash
    sudo systemctl start thehive
    ```

2. Check the service status on all nodes.

    ```bash
    sudo systemctl status thehive
    ```

    The service should show as active and running on each node.

3. Monitor the logs on each node for any errors.

    ```bash
    sudo journalctl -u thehive -f
    ```

    Watch for any error messages during startup. If everything restored correctly, you should see TheHive initializing normally across all nodes.

4. Access TheHive through your web browser and verify that everything works as usual.

You've completed the restore process! If you encounter any issues with missing data or functionality, review the logs and verify that all three backup archives were present and successfully restored.

<h2>Next steps</h2>

* [Perform a Hot Backup on a Cluster](../../backup/hot-backup/hot-backup-cluster.md)