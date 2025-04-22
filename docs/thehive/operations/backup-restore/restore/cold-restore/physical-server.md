# How to Restore a Cold Backup on a Physical Server

This topic provides step-by-step instructions for restoring a cold backup on a physical server for TheHive.

Restoring your application stack on physical servers is a process that involves recovering configuration files, data, and logs from a previously created backup. This procedure ensures the application is returned to a consistent and operational state.

Unlike virtual or containerized environments, restoring on physical servers requires manual handling of files and services.

{!includes/implications-cold-backup-restore.md!}

{!includes/adapting-instructions.md!}

{!includes/backup-restore-best-practices.md!}

## Prerequisites

This guide assumes that:

* You are restoring from a cold backup created using the procedures outlined in the [Perform a Cold Backup on a Physical Server](../../backup/cold-backup/physical-server.md) guide, where services were stopped during the backup process to ensure data consistency.
* The server environment matches the original configuration (for example, paths, software versions, and dependencies).

## Step 1: Stop the services

Stop all services to ensure data consistency and prevent any changes during the restore process.

!!! Example ""

    ```bash
    systemctl stop thehive
    systemctl stop elasticsearch
    systemctl stop cassandra
    ```

## Step 2: Check all data folders are empty

Ensure `/var/lib/cassandra/` and `/var/lib/elasticsearch/` are empty.

## Step 3: Copy files from the backup folder

For example, with a dedicated NFS volume and a folder named `/opt/backup`  copy all files preserving their permissions.

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
    ## 2. Run the script using the following command:
    ##    `bash ./scripts/restore.sh`
    ##
    ## ADDITIONAL RESOURCES:
    ## Refer to the official documentation for detailed instructions and 
    ## additional information: https://docs.strangebee.com/thehive/operations/backup-restore/
    ##
    ## WARNING:
    ## - This script ensure Nginx, Elasticsearch, Cassandra, and TheHive services are stopped before performing the restore, and then restarts the services.
    ## - This script will overwrite existing data. Use it with caution.
    ## - Don't modify the rest of the script unless necessary.
    ##
    ## ============================================================
    ## DO NOT MODIFY ANYTHING BELOW THIS LINE
    ## ============================================================
    # Display help message
    if [[ "$1" == "--help" || "$1" == "-h" ]]
    then
        echo "Usage: $0 [DOCKER_COMPOSE_PATH] [BACKUP_FOLDER]"
        echo
        echo "This script restores a backup of application data, including configurations, files, and logs."
        echo
        echo "Options:"
        echo "  DOCKER_COMPOSE_PATH  Optional. Specify the path of the folder with the docker-compose.yml."
        echo "                      If not provided, you will be prompted for a folder, with a default of '.'."
        echo "  BACKUP_FOLDER  Optional. Specify the folder containing the data to restore."
        echo "                      If not provided, you will be prompted for a folder or exit; no default folder is used."
        echo
        echo "Examples:"
        echo "  $0 /path/to/docker-compose-folder /path/to/backup-folder  restores backup stored in the specified folder."
        echo "  $0                 Prompt for docker compose folder and backup folder to restore."
        exit 0
    fi

    ## Checks if the first argument is provided.
    ## If it is, the script uses it as the value for BACKUP_ROOT_FOLDER
    ## If no argument is passed, the script prompts the user to enter a value
    ## 
    if [[ -z "$1" ]]
    then
        read -p "Enter the folder path including your docker compose file [default: ./]: " DOCKER_COMPOSE_PATH
        DOCKER_COMPOSE_PATH=${DOCKER_COMPOSE_PATH:-"."}
    else
        DOCKER_COMPOSE_PATH="$1"
    fi

    if [[ -e "${DOCKER_COMPOSE_PATH}/docker-compose.yml" ]]
    then
        echo "Path to your docker compose file: ${DOCKER_COMPOSE_PATH}/docker-compose.yml"
    else
        { echo "Docker compose file not found in ${DOCKER_COMPOSE_PATH}"; exit 1; }
    fi


    if [[ -z "$2" ]]
    then
        read -p "Enter the backup root folder [default: None]: " BACKUP_FOLDER
        [[ -z "${BACKUP_FOLDER}" ]] && echo "No backup folder specified, exiting." && exit 1
    else
        BACKUP_FOLDER="$2"
    fi

    ## Check if the backup folder to restore exists, else exit
    [[ -d ${BACKUP_FOLDER} ]] || { echo "Backup folder not found, exiting"; exit 1; }


    # Define the log file and start logging. Log file is stored in the current folder
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

    # Copy Cassandra data
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

### Step 4: Restart all services

Restart services in this order:

1. Elasticsearch
2. Cassandra
3. TheHive

!!! Example ""

    ```bash
    systemctl start thehive
    systemctl start elasticsearch
    systemctl start cassandra
    ```

## Step 5: Validate the restore

Open you browser, connect to TheHive, and check your data has been restored correctly.

<h2>Next steps</h2>

* [Perform a Cold Backup on a Physical Server](../../backup/cold-backup/physical-server.md)