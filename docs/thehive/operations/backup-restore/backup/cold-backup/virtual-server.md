# Perform a Cold Backup on a Virtual Server

In this tutorial, we're going to guide you through performing a cold backup of TheHive on a virtual server. A cold backup involves fully stopping TheHive and its related services before making a copy of your data. While it requires downtime, this method ensures the highest level of data consistency.

Using virtual servers provides more flexibility in performing backup and restore operations.

{% include-markdown "includes/implications-cold-backup-restore.md" %}

{% include-markdown "includes/backup-restore-best-practices.md" %}

## Prerequisites

This process and example below assume you have followed the [step-by-step guide](../../../../installation/installation-guide-linux-standalone-server.md) to install the application stack.

## First option: Back up data folders

Similar to using a physical server, use scripts to back up the configuration, data, and logs from each application in your stack. Store the backups in a folder that can be archived elsewhere. Refer to the [Perform a Cold Backup on a Physical Server](physical-server.md) guide for detailed instructions.

## Second option: Leverage the capabilities of the hypervisor

Hypervisors often come with the capacity to create a snapshot volumes and entire virtual machine. Create snapshots of volumes containing data and files after stopping TheHive, Cassandra and Elasticsearch applications. 

For the restore process, begin by restoring the snapshots created with the hypervisor. This allows you to quickly revert to a previous state, ensuring that both the system configuration and application data are restored to their exact state at the time of the snapshot. Be sure to follow any additional procedures specific to your hypervisor to ensure the snapshots are properly applied and that the system operates as expected after the restore.

<h2>Next steps</h2>

* [Restore a Cold Backup on a Virtual Server](../../restore/cold-restore/virtual-server.md)