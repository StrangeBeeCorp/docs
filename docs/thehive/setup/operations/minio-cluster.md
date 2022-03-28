# MinIO cluster operations
## Replace a disk
If a disk is faulty, it can be replaced without downtime as MinIO supports hot-swapping disks:
 1. unmount the disk
 1. replace it with healthy disk and mount the partition in the same location
 1. check if MinIO has recognized the new disk in MinIO logs
 1. run a disk heal with the command `mc admin heal`.

## Replace a node
 If a server has crashed and cannot be recovered, you can install a new server with MinIO. Ensure the new node is accessible like the old one, with same ip/hostname.
 Once the service is started and it has joined the cluster, run a disk heal with the command `mc admin heal`.

## Add a node to cluster
Adding a new serveur in an existing cluster, requires restarting all MinIO nodes. The configuration of all nodes must be modififed to take in account the new node.
Once the cluster is started, run a disk heal with the command `mc admin heal`.

MinIO strongly recommends restarting all nodes simultaneously. Do not perform "rolling" (e.g. one node at a time) restarts.

## Remove a node from cluster
Removing a node from a cluster follows the same requirements than adding a node: update the configuration file and restart all the cluster.
