# Perform a Hot Backup on a Standalone Server

In this tutorial, we're going to guide you through performing a hot backup of TheHive on a standalone server using the provided scripts.

By the end, you'll have created complete backups of your database, search index, and file storage—all without stopping TheHive.

Hot backups let you protect your data while keeping TheHive running, which means zero downtime for your security operations team.

These backups are essential to protect your data and ensure you can recover quickly in case of a system failure or data loss.

{% include-markdown "includes/prerequisites-hot-backup-restore.md" %}

{% include-markdown "includes/backup-restore-best-practices.md" %}

!!! warning "Script restrictions"
    These scripts work only for native installations following the [Install TheHive on Linux Systems](../../../../installation/installation-guide-linux-standalone-server.md) configuration. Docker and Kubernetes deployments aren't supported.

## Step 1: Install required tools

{% include-markdown "includes/hot-backup-required-tools.md" %}

## Step 2: Set Elasticsearch permissions

Let's ensure Elasticsearch has the correct permissions to access the snapshot directory.

```bash
sudo mkdir -p /mnt/backup/elasticsearch
sudo chown elasticsearch:elasticsearch /mnt/backup/elasticsearch
sudo chmod 770 /mnt/backup/elasticsearch
```

## Step 3: Set up the Elasticsearch snapshot repository

We're going to configure Elasticsearch to store snapshots with timestamped names. This repository will be used to create backups of your search index.

1. In your `elasticsearch.yml` file, define the location where snapshots will be stored.

    ```yaml
    path.repo: /mnt/backup/elasticsearch
    ```

2. After saving your changes, restart Elasticsearch.

    ```bash
    sudo systemctl restart elasticsearch
    ```

3. Register the repository.

    ```http
    curl -X PUT "http://127.0.0.1:9200/_snapshot/thehive_repository" \
      -H "Content-Type: application/json" \
      -d '{
        "type": "fs",
        "settings": {
          "location": "/mnt/backup/elasticsearch"
        }
      }'
    ```
    
    You should see a response like this:

    ```json
    {
      "acknowledged": true
    }
    ```

For step-by-step details, see the [official Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.18/snapshots-filesystem-repository.html){target=_blank}.

## Step 4: Perform health checks

{% include-markdown "includes/preliminary-checks-hot-backup.md" %}

## Step 5: Create Cassandra and Elasticsearch snapshots

Now we're going to create snapshots of both your database and search index simultaneously. This parallel approach minimizes the time window between snapshots.

### 1. Prepare the backup script

We're going to use a script that creates hot backups of both Cassandra and Elasticsearch in parallel. The script simultaneously captures snapshots of your database and index, then packages both into separate .tar archives for safe storage.

Before running the script, you'll need to update several values to match your environment:

#### For Cassandra

* Update `CASSANDRA_KEYSPACE` to match your configuration. You can find this in `/etc/thehive/application.conf` file under the `db.janusgraph.storage.cql.keyspace` attribute. The script uses `thehive` by default.
* Update `CASSANDRA_CONNECTION` with `127.0.0.1`.
* If you configured authentication in `/etc/thehive/application.conf`, replace the value of the `CASSANDRA_CONNECTION` variable with: `"127.0.0.1 admin -p <authentication_admin_password>"`.

#### For Elasticsearch

* Update `ELASTICSEARCH_SNAPSHOT_REPOSITORY` to match the repository name you registered in a previous step. The script uses `thehive_repository` by default.
* If you configured authentication in `/etc/thehive/application.conf`, add `-u thehive:<thehive_user_password>` to all `curl` commands, using your actual password.

### 2. Run the backup script

{% include-markdown "includes/how-to-run-script.md" %}

{% include-markdown "includes/hot-backup-cassandra-elasticsearch-snapshots.md" %}

After running the script, the backup archives are available at `/mnt/backup/cassandra` and `/mnt/backup/elasticsearch`. Be sure to copy these archives to a separate server or storage location to safeguard against data loss if the TheHive server fails.

For more details about snapshot management, refer to the official [Cassandra documentation](https://cassandra.apache.org/doc/stable/cassandra/operating/backups.html){target=_blank} and [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html){target=_blank}.

## Step 6: Back up file storage

Finally, we're going to back up TheHive file storage, which contains all the attachments and files.

### 1. Prepare the backup script

Before running the script, update `ATTACHMENT_FOLDER` to match your environment. You can find this path in `/etc/thehive/application.conf` under the `storage.localfs.location` attribute. The script uses `/opt/thp/thehive/files` by default.

### 2. Run the backup script

{% include-markdown "includes/hot-backup-file-storage-local-nfs.md" %}

After running the script, the backup archive is available at `/mnt/backup/storage`. Be sure to copy this archive to a separate server or storage location to safeguard against data loss if the TheHive server fails.

You've completed the hot backup process for your TheHive standalone server. We recommend verifying your backup archives are complete and accessible before relying on them for recovery.

<h2>Next steps</h2>

* [Restore a Hot Backup on a Standalone Server](../../restore/hot-restore/restore-hot-backup-standalone-server.md)