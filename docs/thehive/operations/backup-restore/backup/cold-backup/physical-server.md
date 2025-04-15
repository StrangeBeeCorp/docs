# For Physical Servers
  
## Introduction

Unlike virtualized or containerized environments, physical servers require direct access to the file system and services to perform backups. This procedure focuses on cold backups, where services are stopped to ensure the integrity and consistency of the data, indices, and logs.

When performing a backup on physical servers, it’s essential to:

1. Stop services (e.g., Elasticsearch, Cassandra, TheHive) to avoid data corruption.
2. Ensure file permissions are adequate for the backup process.
3. Use tools like rsync to copy data, configuration files, and logs to a designated backup location.
4. Validate the backup to ensure it can be restored without issues.

---
## Prerequisites

This guide assumes you have direct access to the server via SSH or other administrative tools and sufficient disk space to store backups. By following this procedure, you can create a consistent backup that can be securely archived or transferred for disaster recovery purposes.

This process and example below assume you have followed our [step-by-step guide](../../../../installation/step-by-step-installation-guide.md) to install the application stack.

!!! Note
    Before proceeding, ensure you have read the general [Backup and Restore Overview](../../cold-hot-backup-restore.md) to understand the core principles of backup strategies.

---
## Step-by-step instructions

### Stop the services in this order

1. TheHive
2. Elasticsearch
3. Cassandra

!!! Example ""

    ```bash
    systemctl stop thehive
    systemctl stop elasticsearch
    systemctl stop cassandra
    ```

### Copy files in a backup folder

For example, create a folder on a dedicated NFS volume named `/opt/backups` and copy all files preserving their permissions

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
    ## 2. Run the script using the following command:
    ##    `bash ./scripts/backup.sh`
    ##
    ## ADDITIONAL RESOURCES:
    ## Refer to the official documentation for detailed instructions and 
    ## additional information: https://docs.strangebee.com/thehive/operations/backup-restore/backup/physical-server/
    ##
    ## WARNING:
    ## - This script stops Elasticsearch, Cassandra, and TheHive services, 
    ##   performs the backup, and then restarts the services.
    ## - Do not modify the rest of the script unless necessary.
    ##
    ## ============================================================
    ## DO NOT MODIFY ANYTHING BELOW THIS LINE
    ## ============================================================
    ##
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

    # Define the log file and start logging
    LOG_FILE="${BACKUP_ROOT_FOLDER}/backup_log_${DATE}.log"
    exec &> >(tee -a "$LOG_FILE")
    
    ## Create the backup directory
    mkdir -p "${BACKUP_FOLDER}"  || { echo "Creating backup folder failed"; exit 1; }
    echo "Created backup folder: ${BACKUP_FOLDER}"

    ## Prepare folders tree
    mkdir -p ${BACKUP_FOLDER}/{thehive,cassandra,elasticsearch}/{config,data,logs}
    echo "Created folder structure under ${BACKUP_FOLDER}"

    # Copy TheHive data
    echo "Starting TheHive backup..."
    rsync -aW --no-compress /etc/thehive/ ${BACKUP_FOLDER}/thehive/config || { echo "TheHive config backup failed"; exit 1; }
    rsync -aW --no-compress /opt/thp/thehive/files/ ${BACKUP_FOLDER}/thehive/data || { echo "TheHive data backup failed"; exit 1; }
    rsync -aW --no-compress /var/log/thehive/ ${BACKUP_FOLDER}/thehive/logs || { echo "TheHive logs backup failed"; exit 1; }
    echo "TheHive backup completed."

    # Copy Casssandra data
    echo "Starting Cassandra backup..."
    rsync -aW --no-compress /etc/cassandra/ ${BACKUP_FOLDER}/cassandra/config || { echo "Cassandra config backup failed"; exit 1; }
    rsync -aW --no-compress /var/lib/cassandra/ ${BACKUP_FOLDER}/cassandra/data || { echo "Cassandra data backup failed"; exit 1; }
    rsync -aW --no-compress /var/log/cassandra/ ${BACKUP_FOLDER}/cassandra/logs || { echo "Cassandra logs backup failed"; exit 1; }
    echo "Cassandra backup completed."

    # Copy Elasticsearch data
    echo "Starting Elasticsearch backup..."
    rsync -aW --no-compress /etc/elasticsearch/ ${BACKUP_FOLDER}/elasticsearch/config || { echo "Elasticsearch config backup failed"; exit 1; }
    rsync -aW --no-compress /var/lib/elasticsearch/ ${BACKUP_FOLDER}/elasticsearch/data || { echo "Elasticsearch data backup failed"; exit 1; }
    rsync -aW --no-compress /var/log/elasticsearch/ ${BACKUP_FOLDER}/elasticsearch/logs || { echo "Elasticsearch logs backup failed"; exit 1; }
    echo "Elasticsearch backup completed."

    echo "Backup process completed at: $(date)"
    ```


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

check the backup folder and verify the data has been well copied.