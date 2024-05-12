# MinIO Cluster Operations

## Replace a Disk

If a disk in your MinIO cluster is faulty and needs to be replaced, you can perform this operation without downtime thanks to MinIO's support for hot-swapping disks:

1. **Unmount the Faulty Disk**
   - Safely unmount the faulty disk from the server where it is installed.
   - Ensure that any data on the disk is backed up or transferred to another location if possible.

2. **Install the Replacement Disk**
   - Install the healthy replacement disk in the same location as the faulty disk.
   - Connect the replacement disk to the server and ensure it is properly recognized by the operating system.

3. **Mount the Replacement Disk**
   - Mount the replacement disk to the same mount point previously used by the faulty disk.

4. **Check MinIO Logs**
   - Check the MinIO logs to ensure that the new disk has been recognized by the system:
     ```bash
     mc admin service logs <myminio>
     ```

5. **Initiate Disk Heal**
   - Run a disk heal operation to synchronize data and ensure data integrity across the cluster with the new disk:
     ```bash
     mc admin heal <myminio>
     ```


## Replace a Node

In the event that a server within your MinIO cluster has crashed and cannot be recovered, you can install a new server to replace it. Ensure that the new node is configured with the same IP address or hostname as the old node. Once the new server is operational and has joined the cluster, initiate a disk heal by running `mc admin heal`.

### Step-by-Step Guide: Replace a Node in MinIO Cluster

1. **Prepare the Replacement Server**
   - Set up a new server that meets the hardware and network requirements for running MinIO.
   - Ensure the new server has the same MinIO version as the existing cluster nodes.
   - Assign the same IP address or hostname as the node being replaced.

2. **Prepare the Existing Cluster**
   - Identify the node that needs to be replaced and ensure it is no longer part of the active cluster. Stop the MinIO service on this node.

3. **Transfer Data**
   - If possible, transfer any data stored on the node being replaced to other nodes in the cluster to avoid data loss.

4. **Distribute the Configuration**
   - Copy the modified `config.json` file to the new replacement node's MinIO configuration directory.

5. **Start MinIO Service on Replacement Node**
   - Start the MinIO service on the new replacement node and ensure it joins the cluster successfully:
     ```bash
     systemctl start minio
     ```

6. **Verify Node Replacement**
   - Check the cluster status to ensure that the new replacement node has been successfully added and is part of the cluster:
     ```bash
     mc admin info myminio
     ```

7. **Initiate Disk Heal**
   - Run a disk heal operation to synchronize data and ensure data integrity across the cluster with the new replacement node:
     ```bash
     mc admin heal myminio
     ```

8. **Monitor Cluster Health**
   - Use MinIO's monitoring tools (`mc admin top` or web-based console) to monitor the health and performance of the cluster with the new replacement node.

By following these steps, you can safely replace a node in your MinIO cluster while maintaining data integrity and cluster stability. Ensure that all operations are performed during a maintenance window to minimize impact on production services.


## Add a Node to the Cluster

Adding a new server to an existing MinIO cluster involves restarting all MinIO nodes and updating their configuration to account for the new node. It's crucial to synchronize the configuration across all nodes. After the cluster is successfully started with the new node, perform a disk heal operation using `mc admin heal`.

Note: MinIO strongly recommends restarting all nodes simultaneously when adding or removing nodes from a cluster. Avoid "rolling" restarts (i.e., restarting one node at a time).

### Step-by-Step Guide: Adding a Node to MinIO Cluster

1. **Prepare the New Server**
   - Set up a new server (physical or virtual) that meets the hardware and network requirements for running MinIO.
   - Ensure the new server has the same MinIO version as the existing cluster nodes.
   - Assign a static IP address or configure a hostname for the new node that matches the existing cluster nodes.

2. **Update MinIO Configuration**
   - Access the configuration file (`config.json`) of each existing MinIO node in the cluster.
   - Add the details of the new node (IP address or hostname) to the `config.json` file of each node under the `cluster` section:
     ```json
     {
       "version": "minio",
       "cluster": {
         "nodes": [
           {"endpoint": "existing-node1:9000"},
           {"endpoint": "existing-node2:9000"},
           {"endpoint": "existing-node3:9000"},
           {"endpoint": "new-node:9000"}
         ]
       }
     }
     ```
   - Save the updated configuration file.

3. **Distribute the Updated Configuration**
   - Copy the modified `config.json` file to the new node's MinIO configuration directory.

4. **Restart MinIO Service**
   - On each existing MinIO node, restart the MinIO service to apply the updated configuration:
     ```bash
     systemctl restart minio
     ```

5. **Verify Node Addition**
   - Once all nodes have been restarted, check the cluster status to ensure the new node has been successfully added:
     ```bash
     mc admin info <myminio>
     ```

6. **Initiate Disk Heal**
   - Run a disk heal operation to ensure data consistency across the cluster with the new node:
     ```bash
     mc admin heal <myminio>
     ```


## Remove a node from cluster
When removing a node from your MinIO cluster, follow the same procedure as adding a node: update the cluster's configuration file to reflect the removal and restart all nodes in the cluster to apply the changes.

## MINIO and High Availability
MinIO supports high availability by configuring a single S3 endpoint in applications like TheHive. To achieve high availability across MinIO nodes, it's recommended to use load balancers and virtual IP addresses to distribute connections evenly among the cluster nodes.

Follow the guide under [**deploying a cluster**](../installation/3-node-cluster.md) to configure MinIO with load balancer and virtual IP.