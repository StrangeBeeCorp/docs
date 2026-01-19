# Perform a Hot Backup on a Cluster

In this tutorial, we're going to guide you through performing a hot backup of TheHive on a cluster using the provided scripts.

By the end, you'll have created complete backups of your database and search index across all three nodes, plus your file storage

Hot backups let you protect your data while keeping TheHive running, which means zero downtime for your security operations team.

These backups are essential to protect your data and ensure you can recover quickly in case of a system failure or data loss.

{% include-markdown "includes/prerequisites-hot-backup-restore.md" %}

{% include-markdown "includes/backup-restore-best-practices.md" %}

!!! warning "Script restrictions"
    These scripts work only for native installations following the [Setting up a Cluster with TheHive](../../../../installation/deploying-a-cluster.md) configuration. Docker and Kubernetes deployments aren't supported.

## Step 1: Install required tools

{% include-markdown "includes/hot-backup-required-tools.md" %}

## Step 2: Configure NFS-shared storage for Elasticsearch snapshots

Elasticsearch requires a snapshot repository that's accessible from all cluster nodes. To meet this requirement, we will set up an NFS share so every node can reach the backup location. If you don't have a dedicated NFS server, you can export an NFS share directly from one of the Elasticsearch nodes.

### On the NFS server

1. Create the directory and set the correct permissions for Elasticsearch.

    ```bash
    sudo mkdir -p /mnt/backup/elasticsearch
    sudo chown elasticsearch:elasticsearch /mnt/backup/elasticsearch
    sudo chmod 770 /mnt/backup/elasticsearch
    ```

2. Export the directory by adding this line to `/etc/exports`.

    ```bash
    /mnt/backup/elasticsearch <cluster_network>(rw,sync,no_subtree_check,no_root_squash)
    ```

    Replace `<cluster_network>` with your network range.

3. Apply the export configuration.

    ```bash
    sudo exportfs -ra
    ```

### On all cluster nodes

1. Create the mount point and mount the NFS share.

    ```bash
    sudo mkdir -p /mnt/backup/elasticsearch
    sudo mount <nfs_server_ip>:/mnt/backup/elasticsearch /mnt/backup/elasticsearch
    ```

    Replace `<nfs_server_ip>` with the IP address of your NFS server.

2. Set the correct permissions on the mounted directory.

    ```bash
    sudo chown elasticsearch:elasticsearch /mnt/backup/elasticsearch
    sudo chmod 770 /mnt/backup/elasticsearch
    ```

3. Add an entry to `/etc/fstab` to ensure the mount persists after reboot.

    ```bash
    <nfs_server_ip>:/mnt/backup/elasticsearch /mnt/backup/elasticsearch nfs defaults,_netdev 0 0
    ```

    Replace `<nfs_server_ip>` with the IP address of your NFS server.

4. Verify the mount is working.

    ```bash
    df -h | grep /mnt/backup/elasticsearch
    ```

    You should see the NFS mount listed in the output.

## Step 3: Set up the Elasticsearch snapshot repository

We're going to configure Elasticsearch to store snapshots with timestamped names. This repository will be used to create backups of your search index.

1. In the `elasticsearch.yml` file on each node, define the directory where snapshots will be stored.

    ```yaml
    path.repo: /mnt/backup/elasticsearch
    ```

2. After saving your changes, restart Elasticsearch on each node.

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

## Step 5: Replicate Cassandra and Elasticsearch data across all three nodes

!!! warning "Data replication requirement"
    It's your responsibility to ensure data replication across all nodes before proceeding. If this requirement isn't met, cluster restoration may fail, and integrity issues could arise.

Before we proceed with the backup, we need to ensure your Cassandra cluster has a replication factor that provides full data redundancy across all nodes. This way, we can take snapshots from a single node while maintaining data consistency.

1. Verify replication factor.

    Check the replication factor for your keyspace. It should be set to *3* for a three-node cluster.

    Use the following command in `cqlsh`:

    ```sql
    DESCRIBE KEYSPACE thehive;
    ```

    If needed, adjust the replication factor:

    ```sql
    ALTER KEYSPACE thehive WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', '<datacenter_name>' : 3 };
    ```

    Replace `<datacenter_name>` with your actual data center name.

2. Check cluster status.

    Ensure all nodes are up and running:

    ```bash
    nodetool status
    ```

    All nodes should show the `UN` (Up/Normal) status.

3. Run `nodetool repair`.

    Run a repair to ensure data consistency across all nodes:

    ```bash
    nodetool repair
    ```

    This process may take some time depending on the size of your data. Wait for it to complete before proceeding.

4. Verify data replication.

    Check for any replication issues:

    ```bash
    nodetool netstats
    ```

    Look for any pending operations or errors in the output.

## Step 6: Create Cassandra and Elasticsearch snapshots

Now we're going to create snapshots of both your database and search index simultaneously. The script captures snapshots from one node, since data is fully replicated, then packages both into separate .tar archives for safe storage.

### 1. Prepare the backup script

Before running the script, you'll need to update several values to match your environment:

#### For Cassandra

* Update `CASSANDRA_KEYSPACE` to match your configuration. You can find this in `/etc/thehive/application.conf` file under the `db.janusgraph.storage.cql.keyspace` attribute. The script uses `thehive` by default.
* Update `CASSANDRA_CONNECTION` with any Cassandra node IP address in the cluster.
* If you configured authentication in `/etc/thehive/application.conf`, replace the value of the `CASSANDRA_CONNECTION` variable with: `"<ip_node_cassandra> admin -p <authentication_admin_password>"`.

#### For Elasticsearch

* Update `ELASTICSEARCH_SNAPSHOT_REPOSITORY` to match the repository name you registered in a previous step. The script uses `thehive_repository` by default.
* If you configured authentication in `/etc/thehive/application.conf`, add `-u thehive:<thehive_user_password>` to all `curl` commands, using your actual password.
  
### 2. Run the backup script

{% include-markdown "includes/how-to-run-script.md" %}

{% include-markdown "includes/hot-backup-cassandra-elasticsearch-snapshots.md" %}

After running the script, the backup archives are available at `/mnt/backup/cassandra` and `/mnt/backup/elasticsearch`. Be sure to copy these archives to a separate server or storage location to safeguard against data loss if the TheHive server fails.

For more details about snapshot management, refer to the official [Cassandra documentation](https://cassandra.apache.org/doc/stable/cassandra/operating/backups.html){target=_blank} and [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html){target=_blank}.

## Step 7: Back up file storage

Finally, we're going to back up TheHive file storage, which contains all the attachments and files.

The backup procedure depends on your storage backend—either NFS or an S3-compatible object storage service. The script below uses MinIO as an example, but you can adapt the same approach to any S3-compatible implementation.

=== "NFS"

    ### 1. Prepare the backup script

    Before running the script, update `ATTACHMENT_FOLDER` to match your environment. You can find this path in `/etc/thehive/application.conf` under the `storage.localfs.location` attribute. The script uses `/opt/thp/thehive/files` by default.

    ### 2. Run the backup script

    {% include-markdown "includes/hot-backup-file-storage-local-nfs.md" %}

    After running the script, the backup archive is available at `/mnt/backup/storage`. Be sure to copy this archive to a separate server or storage location to safeguard against data loss if the TheHive server fails.

=== "S3-compatible object storage (MinIO example)"

    ### 1. Prepare the backup script

    Before running the script, you'll need to update several values to match your environment:

    * Update `MINIO_ENDPOINT` with your MinIO server URL.
    * Update `MINIO_ACCESS_KEY` with your MinIO access key.
    * Update `MINIO_SECRET_KEY` with your MinIO secret key.
    * Change `MINIO_BUCKET` if you want to use a different bucket name.
    * Change `MINIO_ALIAS` if you want to use a different alias name.

    ### 2. Configure the MinIO alias

    Run this command once to configure the MinIO alias using the same values you defined in the script:
    
    ```bash
    mcli alias set <minio_alias> <minio_endpoint> <minio_access_key> <minio_secret_key>
    ```

    ### 3. Run the backup script

    {% include-markdown "includes/hot-backup-file-storage-minio.md" %}

    After running the script, the backup archive is available at `/mnt/backup/minio`. Be sure to copy this archive to a separate server or storage location to safeguard against data loss if the TheHive server fails.

You've completed the hot backup process for your TheHive cluster. We recommend verifying your backup archives are complete and accessible before relying on them for recovery.

<h2>Next steps</h2>

* [Restore a Hot Backup on a Cluster](../../restore/hot-restore/restore-hot-backup-cluster.md)