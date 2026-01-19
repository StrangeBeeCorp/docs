# Restore a Hot Backup on a Standalone Server

In this tutorial, we're going to guide you through restoring a hot backup of TheHive on a standalone server using the provided scripts.

By the end, you'll have brought your system back to a working state using the backups you created previously, with all your database, search index, and file storage fully restored.

{% include-markdown "includes/hot-restore-application-stopped.md" %}

{% include-markdown "includes/backup-restore-best-practices.md" %}

{% include-markdown "includes/python-compatibility-cqlsh.md" %}

This tutorial assumes you’ve completed the [Perform a Hot Backup on a Standalone Server](../../backup/hot-backup/hot-backup-standalone-server.md) tutorial, and that you're using the same directory paths during restore as during backup.

## Step 1: Stop TheHive

Before we begin restoring data, we need to stop TheHive to prevent any conflicts during the restoration process.

```bash
sudo systemctl stop thehive
```

Verify that TheHive has stopped:

```bash
sudo systemctl status thehive
```

## Step 2: Restore Cassandra and Elasticsearch snapshots

We're going to restore both your database and search index from the backup archives. The script automatically identifies your most recent backup files, extracts them, and restores both Cassandra and Elasticsearch in parallel while handling keyspace recreation if needed.

### 1. Prepare the restore script

Before running the script, you'll need to update several values to match your environment:

#### For Cassandra

* Update `CASSANDRA_KEYSPACE` to match your configuration. You can find this in `/etc/thehive/application.conf` file under the `db.janusgraph.storage.cql.keyspace` attribute. The script uses `thehive` by default.
* Update `CASSANDRA_CONNECTION` with `127.0.0.1`.
* If you configured authentication in `/etc/thehive/application.conf`:
    * Replace the value of the `CASSANDRA_CONNECTION` variable with: `"127.0.0.1 admin -p <authentication_admin_password>"`
    * Uncomment the following line: `cqlsh ${CASSANDRA_CONNECTION} --request-timeout=120 -e "GRANT ALL PERMISSIONS ON KEYSPACE ${CASSANDRA_THEHIVE_USER} TO thehive;"`
* Update `CASSANDRA_THEHIVE_USER` to match the role that accesses the keyspace. The script uses `thehive` by default.

#### For Elasticsearch

* Update `ELASTICSEARCH_SNAPSHOT_REPOSITORY` to match the repository name you registered in a previous step. The script uses `thehive_repository` by default.
* If you configured authentication in `/etc/thehive/application.conf`, add `-u thehive:<thehive_user_password>` to all `curl` commands, using your actual password.

### 2. Run the restore script

{% include-markdown "includes/how-to-run-script.md" %}

{% include-markdown "includes/hot-restore-cassandra-elasticsearch-snapshots-standalone-server.md" %}

The script will automatically identify your most recent backup archives and restore them. You'll see progress messages as the restoration proceeds. When complete, you should see the message `=== ✓ Successful full restore ===`.

For additional details, refer to the official [Cassandra documentation](https://cassandra.apache.org/doc/stable/cassandra/managing/operating/backups.html){target=_blank} and [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html){target=_blank}.

## Step 3: Restore file storage

Finally, we're going to restore the file attachments that were backed up.

### 1. Prepare the restore script

Before running the script, update `ATTACHMENT_FOLDER` to match your environment. You can find this path in `/etc/thehive/application.conf` under the `storage.localfs.location` attribute. The script uses `/opt/thp/thehive/files` by default.

### 2. Run the restore script

{% include-markdown "includes/hot-restore-file-storage-local-nfs.md" %}

## Step 4: Start TheHive and verify

Now that all data components have been restored, we're going to start TheHive and verify that everything works as expected.

1. Start TheHive.

    ```bash
    sudo systemctl start thehive
    ```

2. Check the service status.

    ```bash
    sudo systemctl status thehive
    ```

    The service should show as active and running.

3. Monitor the logs for any errors.

    ```bash
    sudo journalctl -u thehive -f
    ```

    Watch for any error messages during startup. If everything restored correctly, you should see TheHive initializing normally.

4. Access TheHive through your web browser and verify that everything works as usual.

You've completed the restore process! If you encounter any issues with missing data or functionality, review the logs and verify that all three backup archives were present and successfully restored.

<h2>Next steps</h2>

* [Perform a Hot Backup on a Standalone Server](../../backup/hot-backup/hot-backup-standalone-server.md)