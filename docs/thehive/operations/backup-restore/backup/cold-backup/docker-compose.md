# Backup a stack run with Docker Compose

!!! Note
    This solution assumes you are following our _[Running with Docker](./../../../installation/docker.md)_ guide to run your application stack.


---
## Introduction

The backup procedure is designed to capture the state of your application stack in three simple steps:

1. Stop all services to ensure data consistency and prevent any changes during the backup process.
2. Copy volumes and mapped directories on the host machine, which contain your data, configurations, and logs.
3. Restart the services to resume normal operations after the backup is complete.


---
## Prerequisites

Before starting, ensure:

* You have sufficient storage space for the backup.
* Administrative privileges to stop and start Docker Compose services.
* Familiarity with the locations of your mapped volumes and data directories.

This step-by-step procedure ensures a safe and consistent backup of your Docker Compose stack, enabling quick recovery in case of an issue or migration to a new environment. For more details on restoring these backups, refer to the [restore procedure for Docker Compose](../restore/docker-compose.md).



---
## Step-by-step instructions

### Stop the services

!!! Example ""

    ```bash
    docker compose down 
    ```

### Copy files in a backup folder

For example, on the host server, create a folder on a dedicated NFS volume named `/opt/backups` and copy all files preserving their permissions

!!! Example ""

    ```bash
    #!/bin/bash

    ## ============================================================
    ## BACKUP SCRIPT FOR THEHIVE APPLICATION STACK
    ## ============================================================
    ## PURPOSE:
    ## This script creates a backup of TheHive application stack, 
    ## including its configuration, data, and logs. It is designed 
    ## to ensure data is preserved for restoration purposes.
    ##
    ## IMPORTANT:
    ## - This script must be run with appropriate permissions to read all data 
    ##   and write to the backup folders.
    ## - Ensure sufficient storage is available in the backup location to avoid 
    ##   partial or failed backups.
    ## - Services (Elasticsearch, Cassandra, and TheHive) will be stopped during 
    ##   the backup process to ensure data integrity.
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
    ##    - BACKUP_ROOT_FOLDER: Root folder where backups will be stored.
    ##    - BACKUP_TO_RESTORE: Name of the backup folder to restore.
    ## 2. Run the script using the following command:
    ##    `bash ./scripts/backup.sh`
    ##
    ## ADDITIONAL RESOURCES:
    ## Refer to the official documentation for detailed instructions and 
    ## additional information: https://docs.strangebee.com/thehive/operations/backup-restore/
    ##
    ## WARNING:
    ## - This script stops Nginx, Elasticsearch, Cassandra, and TheHive services, 
    ##   performs the backup, and then restarts the services.
    ## - Do not modify the rest of the script unless necessary.
    ##
    ## ============================================================
    ## DO NOT MODIFY ANYTHING BELOW THIS LINE
    ## ============================================================

    # Display help message
    if [[ "$1" == "--help" || "$1" == "-h" ]]
    then
        echo "Usage: $0 [BACKUP_ROOT_FOLDER]"
        echo
        echo "This script performs a backup of application data, including configurations, files, and logs."
        echo
        echo "Options:"
        echo "  DOCKER_COMPOSE_PATH  Optional. Specify the path of the folder with the docker-compose.yml."
        echo "                      If not provided, you will be prompted for a folder, with a default of '.'."
        echo "  BACKUP_ROOT_FOLDER  Optional. Specify the root folder where backups will be stored."
        echo "                      If not provided, you will be prompted for a folder, with a default of './backup'."
        echo
        echo "Examples:"
        echo "  $0 /path/to/docker-compose-folder /path/to/backup  Perform backup with specified root folder."
        echo "  $0                 Prompt for docker compose folder and backup root folder."
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
        read -p "Enter the backup root folder [default: ./backup]: " BACKUP_ROOT_FOLDER
        BACKUP_ROOT_FOLDER=${BACKUP_ROOT_FOLDER:-"./backup"}
    else
        BACKUP_ROOT_FOLDER="$2"
    fi


    DATE="$(date +"%Y%m%d-%H%M%z" | sed 's/+/-/')"
    BACKUP_FOLDER="${BACKUP_ROOT_FOLDER}/${DATE}"


    ## Stop services
    docker compose -f ${DOCKER_COMPOSE_PATH}/docker-compose.yml stop

    ## Create the backup directory
    mkdir -p "${BACKUP_FOLDER}"  || { echo "Creating backup folder failed"; exit 1; }
    echo "Created backup folder: ${BACKUP_FOLDER}"

    ## Define the log file and start logging
    LOG_FILE="${BACKUP_ROOT_FOLDER}/backup_log_${DATE}.log"
    exec &> >(tee -a "$LOG_FILE")



    ## Prepare folders tree
    mkdir -p ${BACKUP_FOLDER}/{thehive,cassandra,elasticsearch,nginx,certificates}
    echo "Created folder structure under ${BACKUP_FOLDER}"

    ## Copy TheHive data
    echo "Starting TheHive backup..."
    rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/thehive/ ${BACKUP_FOLDER}/thehive || { echo "TheHive backup failed"; exit 1; }
    echo "TheHive backup completed."

    ## Copy Casssandra data
    echo "Starting Cassandra backup..."
    rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/cassandra/ ${BACKUP_FOLDER}/cassandra || { echo "Cassandra backup failed"; exit 1; }
    echo "Cassandra backup completed."

    ## Copy Elasticsearch data
    echo "Starting Elasticsearch backup..."
    rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/elasticsearch/ ${BACKUP_FOLDER}/elasticsearch || { echo "Elasticsearch config backup failed"; exit 1; }
    echo "Elasticsearch backup completed."

    ## Copy Nginx certificates
    echo "Starting backup of Nginx and certificates..."
    rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/nginx/ ${BACKUP_FOLDER}/nginx || { echo " Backup of Nginx failed"; exit 1; }
    rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/certificates/ ${BACKUP_FOLDER}/certificates || { echo " Backup of Nginx and certificates failed"; exit 1; }
    echo "Backup of certificates completed."

    ## Restart services
    echo "Restarting services..."
    docker compose up -d -f ${DOCKER_COMPOSE_PATH}/docker-compose.yml



    echo "Backup process completed at: $(date)"
    ```

---
## Validation

check the backup folder and verify the data has been well copied.

---
!!! Tip
    * A comprehensive backup script, including all necessary housekeeping actions, is included with our Docker Compose profiles. Refer to the appropriate documentation for detailed instructions [here](https://github.com/StrangeBeeCorp/docker).
    * You can also review the backup script for `prod1-thehive` directly on our GitHub repository.