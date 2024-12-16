# Restore a stack run with Docker Compose

!!! Note
    This process assumes you are using [one of our Docker Compose profiles](https://github.com/StrangeBeeCorp/docker), and you have already created backup using the previously outlined backup procedure.

Restore data that has been saved following the previous backup process.

## Ensure all services are stopped

!!! Example ""

    ```bash
    docker compose down
    ```

## Ensure all data folder are empty before running the restore process

A backup is highly recommended before running a restore operation; this ensures you can revert to the current state if anything goes wrong.

Ensure that the target data folders are empty before running this script. Indeed, pre-existing files can cause conflicts or data corruption during the restore process.


## Choose the archive to restore from the backup folder

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
    ## additional information: https://docs.strangebee.com/thehive/operations/backup-restore/restore/docker-compose/
    ##
    ## WARNING:
    ## - This script ensure Nginx, Elasticsearch, Cassandra, and TheHive services are stopped before performing the restore, and then restarts the services.
    ## - This script will overwrite existing data. Use it with caution.
    ## - Do not modify the rest of the script unless necessary.
    ##
    ## ============================================================

    ## ============================================================
    ## USER-CONFIGURABLE VARIABLES
    ## ============================================================
    ##
    ## Update the following variables to match your environment
    ## Path to the docker-compose.yml file
    DOCKER_COMPOSE_PATH="./"
    ## Path to backup folder
    BACKUP_ROOT_FOLDER="/opt/backups"
    ## Name of the folder containing the backup to restore
    BACKUP_TO_RESTORE="14122024-1044-0000"
    ## ============================================================
    ## DO NOT MODIFY ANYTHING BELOW THIS LINE
    ## ============================================================

    # Check backup backup folder exists
    BACKUP_FOLDER="${BACKUP_ROOT_FOLDER}/${BACKUP_TO_RESTORE}"
    [[ -d ${BACKUP_FOLDER} ]] || { echo "Backup folder not found"; exit 1; }


    # Define the log file and start logging
    DATE="$(date +"%Y%m%d-%H%M%z" | sed 's/+/-/')"
    LOG_FILE="${BACKUP_ROOT_FOLDER}/restore_log_${DATE}.log"
    exec &> >(tee -a "$LOG_FILE")

    # Log the start time
    echo "Restoration process started at: $(date)"

    ## Exit if docker compose is running
    docker compose ps | grep -q "Up" && { echo "Docker Compose services are running. Exiting. Stop services and remove data before retoring data"; exit 1; }


    # Copy Cortex data
    echo "Restoring Cortex data and configuration..."
    rsync -aW --no-compress ${BACKUP_FOLDER}/cortex/ ${DOCKER_COMPOSE_PATH}/cortex || { echo "Cortex config restore failed"; exit 1; }


    # Copy Elasticsearch data
    echo "Restoring Elasticsearch data ..."
    rsync -aW --no-compress ${BACKUP_FOLDER}/elasticsearch/ ${DOCKER_COMPOSE_PATH}/elasticsearch || { echo "Elasticsearch data restore failed"; exit 1; }


    # Copy Nginx certificates
    echo "Restoring Nginx data and configuration..."
    rsync -a ${BACKUP_FOLDER}/nginx/ ${DOCKER_COMPOSE_PATH}/nginx  || { echo " Nginx configuration and certificates restore failed"; exit 1; } 
    rsync -a ${BACKUP_FOLDER}/certificates/ ${DOCKER_COMPOSE_PATH}/certificates  || { echo " certificates restore failed"; exit 1; } 
    echo "Restoration process completed at: $(date)"
    ```


### Restart all services

!!! Example ""

    ```bash
    docker compose up -d 
    ```