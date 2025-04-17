# Backup Virtual server

!!! Note
    This process and example below assume you have followed our [step-by-step guide](../../../../installation/step-by-step-installation-guide.md) to install the application stack.


Using virtual servers allow more solutions to perform backup and restore operations.

---
## First solution: Backup data folders

Similar to using a physical server, use scripts to back up the configuration, data, and logs from each application in your stack, storing them in a folder that can be archived elsewhere. Refer to the cold [backup](./physical-server.md) guides for detailed instructions.

---
## Second solution: Leverage the capabilities of the hypervisor

Hypervisors often come with the capacity to create a snapshot volumes and entire virtual machine. We recommend creating snapshots of volumes containing data and files after stopping TheHive, Cassandra and Elasticsearch applications. 

For the restore process, begin by restoring the snapshots created with the hypervisor. This allows you to quickly revert to a previous state, ensuring that both the system configuration and application data are restored to their exact state at the time of the snapshot. Be sure to follow any additional procedures specific to your hypervisor to ensure the snapshots are properly applied and that the system operates as expected after the restore.