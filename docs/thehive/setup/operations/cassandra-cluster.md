# Cassandra Cluster Operations

This guide provides comprehensive instructions for performing key operations on a Cassandra cluster, including adding nodes to an existing cluster and managing node removal.

---

## Adding a Node to a Cassandra Cluster

To add a Cassandra node to an existing cluster without downtime, follow these steps:

1. Install the New Node:

    - Install Cassandra on the new node using the same configuration file as the existing nodes, with adjustments made to the `listen_address` and `rpc_address` settings to reflect the node's IP address. Set the IP address of any existing node in the seeds section of the configuration file (cassandra.yaml). 

2. Start the Node

    - Once installed and configured, start the Cassandra service on the new node.

3. Check Cluster Status

    - Use the nodetool status command to monitor the cluster status and verify that the new node is recognized and in the joining state.

    ```text title="Display Cassandra Nodes Status"
    # nodetool status

    Datacenter: datacenter1
    =======================
    Status=Up/Down
    |/ State=Normal/Leaving/Joining/Moving
    --  Address     Load       Tokens  Owns (effective)  Host ID                               Rack 
    UN  172.24.0.2  3.68 GiB   256      100.0%            048a870f-d6d5-405e-8d0d-43dbc12be747  rack1
    UJ  172.24.0.3  89.54 MiB  256      ?                 f192ef8f-a4fd-4e24-99a7-0f92605a7cb6  rack1
    ```

After the new node is fully operational, re-run the nodetool status command to ensure that the cluster status reflects the successful addition of the new node:

```text title="Display Cassandra Nodes status"
# nodetool status

Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load      Tokens  Owns (effective)  Host ID                               Rack 
UN  172.24.0.2  3.68 GiB  256      48.8%             048a870f-d6d5-405e-8d0d-43dbc12be747  rack1
UN  172.24.0.3  1.91 GiB  256      51.2%             f192ef8f-a4fd-4e24-99a7-0f92605a7cb6  rack1
```

The updated status will indicate the UN (Up/Normal) state for the new node, showing its load, tokens, ownership percentage, host ID, and rack assignment.

!!! Tip "Creating a Cluster from a Standalone Server"
    If you are transitioning from a standalone server to a multi-node cluster by adding a new node, ensure that you update  the confiuration of the existing standalone server by modifying the `cassandra.yaml` file to replace the `localhost` in `listen_address` and `rpc_address` with the server's actual IP address. 

---

## Removing an Alive Node from a Cassandra Cluster
To safely remove an alive node from your Cassandra cluster, follow these steps:

1. Ensure Compatibility with Replication Factor

Before proceeding with node removal, ensure that the replication factor is suitable for the desired number of nodes in the cluster. If necessary, update the replication factor to maintain adequate data redundancy.

2. Decommission the Node

To remove an alive node gracefully, connect to the node you intend to remove and execute the following nodetool command:

```bash
nodetool decommission
```

This command initiates the decommissioning process for the node, allowing it to transfer its data to other nodes in the cluster before removal.

Monitor the decommissioning progress using `nodetool status` on other nodes in the cluster. Verify that the decommissioned node transitions to a `Leaving state` and completes data transfer successfully.

---

## Removing a Dead Node from a Cassandra Cluster

If a node has crashed and cannot be repaired, you can remove it from the cluster using the `nodetool removenode` command followed by the node `id`.

Steps to Remove a Dead Node:

1. Check Current Cluster Status:
   - Use `nodetool status` to view the current status of the Cassandra cluster:
     ```bash
     nodetool status
     ```

2. Identify the Dead Node:
   - Locate the node with a `DN` (Down) status in the cluster output.

3. Execute `nodetool removenode` Command:
   - Run the following command to remove the dead node from the cluster:
     ```bash
     nodetool removenode <node_id>
     ```
     Replace `<node_id>` with the ID of the dead node obtained from the `nodetool status` output.

4. Verify Cluster Status:
   - After executing the `nodetool removenode` command, check the cluster status again using `nodetool status` to ensure that the dead node has been successfully removed and that the remaining nodes are in a `Normal` state.

---

## Increasing Replication Factor in Cassandra

When you have multiple nodes, increasing the replication factor enhances fault tolerance by creating additional copies in the cluster. More copies mean greater resilience to hardware failures. However, this also means more disk space is used due to the increased data redundancy, potentially resulting in slower write access.

To enhance fault tolerance in your Cassandra cluster by increasing the replication factor, follow these steps:

1. Connect to cqlsh

Use cqlsh to connect to your Cassandra cluster:

2. Modify Keyspace Replication

Execute the following ALTER KEYSPACE command to increase the replication factor for a specific keyspace (replace thehive with your keyspace name):

```sql
ALTER KEYSPACE thehive WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3 };
```

3. Run nodetool repair -full on Each Node

After modifying the keyspace replication, execute `nodetool repair -full` on each node in your Cassandra cluster to ensure data is fully replicated and consistent across the cluster.



It's recommended to increase the replication factor for system keyspaces to ensure high availability and reliability of critical Cassandra system data.

To view the current replication settings for all keyspaces in your cluster, use the following cqlsh query:

```sql title="Checking Current Keyspace Information"
> SELECT * FROM system_schema.keyspaces;

 keyspace_name      | durable_writes | replication
--------------------+----------------+-------------------------------------------------------------------------------------
        system_auth |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '2'}
      system_schema |           True |                             {'class': 'org.apache.cassandra.locator.LocalStrategy'}
 system_distributed |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '2'}
             system |           True |                             {'class': 'org.apache.cassandra.locator.LocalStrategy'}
      system_traces |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '2'}
            thehive |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '2'}
```

This query displays detailed information about each keyspace, including its name and replication strategy with the associated replication factor.

&nbsp;