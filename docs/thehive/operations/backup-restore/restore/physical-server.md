# Restore physical server

## Introduction

Restoring your application stack on physical servers is a process that involves recovering configuration files, data, and logs from a previously created backup. This procedure ensures the application is returned to a consistent and operational state.

Unlike virtual or containerized environments, restoring on physical servers requires manual handling of files and services. This guide assumes that:

* You are restoring from [a cold backup](../backup/physical-server.md), where services were stopped during the backup process to maintain data consistency.
* The server environment matches the original configuration (e.g., paths, software versions, and dependencies).
* The backup was created following the [Backup Procedure for Physical Servers](../backup/physical-server.md).

When performing a restore, you will:

1. Ensure all services are stopped (Elasticsearch, Cassandra, TheHive, etc.) before running the restoration process.
2. Restore the configuration, data, and log files from the backup.
3. Restart services and verify that the system is functioning as expected.

!!! Warning
    * Always test the restoration process in a non-production or test environment before applying it to a live system.
    * Ensure you have a current backup before starting the restore operation, as any errors during restoration could lead to data loss.
    * This guide provides general instructions; adapt them to your specific server configuration.

---
## Step-by-step instructions

### Ensure all services are stopped

!!! Example ""

    ```bash
    systemctl stop thehive
    systemctl stop elasticsearch
    systemctl stop cassandra
    ```


### Check all data folders are empty

Ensure `/var/lib/cassandra/` and `/var/lib/elasticsearch/` are empty.


### Copy files from the backup folder

For example, with a dedicated NFS volume and a folder named `/opt/backup`  copy all files preserving their permissions

!!! Example ""

    ```bash
    #!/bin/bash

    ## ============================================================
    ## RESTORE SCRIPT FOR THEHIVE APPLICATION STACK
    ## ============================================================
    ## PURPOSE:
    ## This script restores a backup of TheHive application stack, 
    ## including its configuration, data, and logs. It is designed to 
    ## recover from backups created using the associated backup script.
    ##
    ## IMPORTANT:
    ## - A backup is highly recommended before running a restore operation. 
    ##   This ensures you can revert to the current state if anything goes wrong.
    ## - Ensure that the target data folders are empty before running this script. 
    ##   Pre-existing files can cause conflicts or data corruption during the restore process.
    ## - This script must be run with sufficient permissions to overwrite 
    ##   application data and modify service configurations.
    ## - Ensure the backup folder path is correct and contains all required 
    ##   files and data.
    ##
    ## DISCLAIMER:
    ## - Users are strongly advised to test this script in a non-production 
    ##   environment to ensure it works as expected with their specific 
    ##   infrastructure and application stack before using it in production.
    ## - The maintainers of this script are not responsible for any data loss, 
    ##   corruption, or issues arising from the use of this script during your 
    ##   backup or restore processes. Proceed at your own risk.
    ##
    ## USAGE:
    ## 1. Update the variables at the start of the script to reflect your setup:
    ##    - BACKUP_ROOT_FOLDER: Path to the root directory of your backups.
    ##    - BACKUP_TO_RESTORE: Name of the backup folder to restore.
    ## 2. Ensure all services (Elasticsearch, Cassandra, TheHive) are stopped.
    ## 3. Ensure data folders are empty
    ## 4. Run the script using the following command:
    ##    `bash ./scripts/restore.sh`
    ##
    ## ADDITIONAL RESOURCES:
    ## Refer to the official documentation for detailed instructions and 
    ## additional information: https://docs.strangebee.com/thehive/operations/backup-restore/restore/physical-server/ 
    ##
    ## WARNING:
    ## - This script will overwrite existing data. Use it with caution.
    ## - Do not modify the rest of the script unless necessary.
    ##
    ## ============================================================


    ## ============================================================
    ## USER-CONFIGURABLE VARIABLES
    ## ============================================================
    ##
    ## Update the following variables to match your environment
    ## Root folder for storing backups
    BACKUP_ROOT_FOLDER="/opt/backups"
    ## Name of the folder containing the backup to restore
    BACKUP_TO_RESTORE="13122024-0459-0000"
    ## ============================================================
    ## DO NOT MODIFY ANYTHING BELOW THIS LINE
    ## ============================================================


    BACKUP_FOLDER="${BACKUP_ROOT_FOLDER}/${BACKUP_TO_RESTORE}"
    # Define the log file and start logging
    DATE="$(date +"%Y%m%d-%H%M%z" | sed 's/+/-/')"
    LOG_FILE="${BACKUP_ROOT_FOLDER}/restore_log_${DATE}.log"
    exec &> >(tee -a "$LOG_FILE")

    # Log the start time
    echo "Restoration process started at: $(date)"

    # Check backup backup folder exists
    [[ -d ${BACKUP_FOLDER} ]] || { echo "Backup folder not found"; exit 1; }


    # Copy TheHive data
    rsync -aW --no-compress ${BACKUP_FOLDER}/thehive/config/ /etc/thehive  || { echo "TheHive config restore failed"; exit 1; }
    rsync -aW --no-compress ${BACKUP_FOLDER}/thehive/data/ /opt/thp/thehive/files || { echo "TheHive data restore failed"; exit 1; }
    rsync -aW --no-compress ${BACKUP_FOLDER}/thehive/logs/ /var/log/thehive || { echo "TheHive logs restore failed"; exit 1; }

    # Copy Casssandra data
    rsync -aW --no-compress ${BACKUP_FOLDER}/cassandra/config/ /etc/cassandra || { echo "Cassandra config restore failed"; exit 1; }
    rsync -aW --no-compress ${BACKUP_FOLDER}/cassandra/data/ /var/lib/cassandra || { echo "Cassandra data restore failed"; exit 1; }
    rsync -aW --no-compress ${BACKUP_FOLDER}/cassandra/logs/ /var/log/cassandra || { echo "Cassandra logs restore failed"; exit 1; }

    # Copy Elasticsearch data
    rsync -aW --no-compress ${BACKUP_FOLDER}/elasticsearch/config/ /etc/elasticsearch || { echo "Elasticsearch config restore failed"; exit 1; }
    rsync -aW --no-compress ${BACKUP_FOLDER}/elasticsearch/data/ /var/lib/elasticsearch || { echo "Elasticsearch data restore failed"; exit 1; }
    rsync -aW --no-compress ${BACKUP_FOLDER}/elasticsearch/logs/ /var/log/elasticsearch || { echo "Elasticsearch logs restore failed"; exit 1; }

    echo "Restoration process completed at: $(date)" 
    ```

Ensure permissions are correctly setup before running services. 

### Start services in this order

1. Elasticsearch
2. Cassandra
3. TheHive

!!! Example ""

    ```bash
    systemctl start thehive
    systemctl start elasticsearch
    systemctl start cassandra
    ```

---
## Validation

Open you browser, connect to TheHive, and check your data has been restored correctly. 