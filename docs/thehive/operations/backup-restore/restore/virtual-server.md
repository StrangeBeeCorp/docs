# Restore virtual server

!!! Note
    This process and example below assume you have followed our [step-by-step guide](./../../../installation/docker.md) to install the application stack.

Using virtual servers allow more solutions to perform backup and restore operations.

---
## 1st solution: Restore data folders from a backup

Assuming you are using our cold [backup](../backup/physical-server.md) guide to backup your data,use scripts to restore the configuration, data, and logs from each application in your stack. Refer to the cold [restore](./physical-server.md) guide for detailed instructions.

---
## 2nd solution: Leverage the capabilities of the hypervisor

Hypervisors often come with the capacity to create a snapshot volumes and entire virtual machine. We recommend creating snapshots of volumes containing data and files after stopping TheHive, Cassandra and Elasticsearch applications. 

For the restore process, begin by restoring the snapshots created with the hypervisor. This allows you to quickly revert to a previous state, ensuring that both the system configuration and application data are restored to their exact state at the time of the snapshot. Be sure to follow any additional procedures specific to your hypervisor to ensure the snapshots are properly applied and that the system operates as expected after the restore.