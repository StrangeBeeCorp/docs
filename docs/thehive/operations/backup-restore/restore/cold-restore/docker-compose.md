# How to Restore a Cold Backup for a Stack Running with Docker Compose

This topic provides step-by-step instructions for restoring a cold backup of a stack running with Docker Compose for TheHive.

!!! note "Prerequisite"
    This process assumes you are using [one of our Docker Compose profiles](https://github.com/StrangeBeeCorp/docker) and have already created a backup using the [Perform a Cold Backup for a Stack Running with Docker Compose](../../backup/cold-backup/docker-compose.md) topic.

## Step 1: Stop the services

Stop all services to ensure data consistency and prevent any changes during the backup process.

!!! Example ""

    ```bash
    docker compose down
    ```

## Step 2: Ensure all data folder are empty

Make sure the target data folders are empty before running this script, as pre-existing files can cause conflicts or data corruption during the restore process.

## Step 3: Choose the archive to restore from the backup folder

Before restoring data, ensure that you have identified the correct backup archive to restore from.

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
    ## additional information: https://docs.strangebee.com/thehive/operations/backup-restore/.
    ##
    ## WARNING:
    ## - This script ensure Nginx, Elasticsearch, Cassandra, and TheHive services are stopped before performing the restore, and then restarts the services.
    ## - This script will overwrite existing data. Use it with caution.
    ## - Do not modify the rest of the script unless necessary.
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
    LOG_FILE="./restore_log_${DATE}.log"
    exec &> >(tee -a "$LOG_FILE")

    # Log the start time
    echo "Restoration process started at: $(date)"

    ## Exit if Docker Compose is running
    docker compose ps | grep -q "Up" && { echo "Docker Compose services are running. Exiting. Stop services and remove data before retoring data"; exit 1; }

    # Copy TheHive data
    echo "Restoring TheHive data and configuration..."
    rsync -aW --no-compress ${BACKUP_FOLDER}/thehive/ ${DOCKER_COMPOSE_PATH}/thehive || { echo "TheHive config restore failed"; exit 1; }

    # Copy Cassandra data
    echo "Restoring Cassandra data ..."
    rsync -aW --no-compress ${BACKUP_FOLDER}/cassandra/ ${DOCKER_COMPOSE_PATH}/cassandra || { echo "Cassandra data restore failed"; exit 1; }

    # Copy Elasticsearch data
    echo "Restoring Elasticsearch data ..."
    rsync -aW --no-compress ${BACKUP_FOLDER}/elasticsearch/ ${DOCKER_COMPOSE_PATH}/elasticsearch || { echo "Elasticsearch data restore failed"; exit 1; }

    # Copy Nginx certificates
    echo "Restoring Nginx data and configuration..."
    rsync -a ${BACKUP_FOLDER}/nginx/ ${DOCKER_COMPOSE_PATH}/nginx  ||
     { echo " Nginx configuration and certificates restore failed"; exit 1; } 
    rsync -a ${BACKUP_FOLDER}/certificates/ ${DOCKER_COMPOSE_PATH}/certificates  ||
     { echo " certificates restore failed"; exit 1; } 

    ## Restart services
    echo "Restarting services..."
    docker compose up -d -f ${DOCKER_COMPOSE_PATH}/docker-compose.yml

    echo "Restoration process completed at: $(date)"
    ```

## Step 4: Validate the restore

Check the target data folders and verify that the restored data has been copied correctly. Ensure that all files and configurations match the backup and that no data corruption or missing files occurred during the restore process.

### Step 5: Restart all services

Use `docker compose up -d -f ${DOCKER_COMPOSE_PATH}/docker-compose.yml` to restart all services with the command line.

<h2>Next steps</h2>

* [Perform a Cold Backup for a Stack Running with Docker Compose](../../backup/cold-backup/docker-compose.md)
* [Cold vs. Hot Backups and Restores](../../cold-hot-backup-restore.md)