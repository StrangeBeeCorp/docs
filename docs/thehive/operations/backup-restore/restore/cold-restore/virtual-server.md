# How to Restore a Cold Backup on a Virtual Server

This topic provides step-by-step instructions for restoring a cold backup on a virtual server for TheHive.

Using virtual servers provides more flexibility in performing backup and restore operations.

{!includes/implications-cold-backup-restore.md!}

{!includes/adapting-instructions.md!}

{!includes/backup-restore-best-practices.md!}

## Prerequisites

This process and example below assume you have followed our [step-by-step guide](../../../../installation/step-by-step-installation-guide.md) to install the application stack.

## First option: Restore data folders from a backup

Assuming you are using our [Perform a Cold Backup on a Physical Server](../../backup/cold-backup/physical-server.md) guide to backup your data, use scripts to restore the configuration, data, and logs from each application in your stack. Refer to the [Restore a Cold Backup on a Physical Server](physical-server.md) guide for detailed instructions.

## Second option: Leverage the capabilities of the hypervisor

Hypervisors often come with the capacity to create a snapshot volumes and entire virtual machine. We recommend creating snapshots of volumes containing data and files after stopping TheHive, Cassandra and Elasticsearch applications. 

For the restore process, begin by restoring the snapshots created with the hypervisor. This allows you to quickly revert to a previous state, ensuring that both the system configuration and application data are restored to their exact state at the time of the snapshot. Be sure to follow any additional procedures specific to your hypervisor to ensure the snapshots are properly applied and that the system operates as expected after the restore.

<h2>Next steps</h2>

* [Perform a Cold Backup on a Virtual Server](../../backup/cold-backup/virtual-server.md)