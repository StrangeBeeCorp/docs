# Backup and Restore Guide

!!! Warning
    Regardless of the situation, we **strongly** recommend performing **cold backups**. TheHive utilizes Cassandra as its database and Elasticsearch as its indexing engine. Files are typically stored in a folder, although some users opt for Minio S3 object storage. For every backup, the data, index, and files **must** remain intact and consistent. **Any inconsistency could result in data restoration failure**.

    This documentation provides detailed instructions for performing cold backups. Alternatively, you may opt for a hot backup and restore strategy. To assist with this, we provide sample scripts that you can tailor to your specific requirements. However, it is important to note that the final responsibility for implementing and testing the backup and restore processes lies with you.

    We strongly recommend thoroughly validating your backup and restoration procedures in a controlled environment before relying on them in production. While we strive to provide accurate and helpful guidance, we cannot assume liability for any data loss, downtime, or system failures resulting from incorrect configurations, inconsistencies in your data, or issues during the restoration process. It is essential to ensure that your chosen approach aligns with your infrastructure and operational needs.

---
# Cold backup & restore

Your backup and restore strategy heavily depends on your infrastructure and orchestration approach, whether you are using physical servers, virtual servers, Docker, Kubernetes, or cloud solutions like AWS EC2 instances.

For example, with AWS Amazon EC2 servers where all data, indexes, and files are stored on dedicated volumes, performing a daily backup of the volumes takes less than 3 minutes. This includes housekeeping tasks such as stopping and restarting services.




=== "Physical servers"


    !!! Note
        This process and example below assume you have followed our [step-by-step guide](./../installation/step-by-step-installation-guide.md) to install the application stack.

    ---
    ## Backup process 
    
    The simplest way to backup data is to save configuration, logs and data for each components by following this process: 
    
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

    For example, create a folder on a dedicated NFS volume named `/opt/backup` and copy all files preserving their permissions

    !!! Example ""

        ```bash
        #!/bin/bash

        ## WARNING
        ## 
        ## THIS SCRIPT SHOULD BE RUN WITH APPROPRIATE PERMISSIONS TO READ ALL DATA AND WRITE TO BACKUP FOLDERS
        ## 
        ##

        BACKUP_ROOT_FOLDER="/opt/backup"
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
    ## Restore process

    ### Ensure all services are stopped

    !!! Example ""

        ```bash
        systemctl stop thehive
        systemctl stop elasticsearch
        systemctl stop cassandra
        ```

    ### Copy files from the backup folder

    For example, with a dedicated NFS volume and a folder named `/opt/backup`  copy all files preserving their permissions

    !!! Example ""

        ```bash
        #!/bin/bash

        ## WARNING: 
        ## 
        ## 1. THIS SCRIPT WILL ERASE ALL EXISTING DATA IN THEHIVE, CASSANDRA AND ELASTICSEARCH FOLDERS
        ## 2. THIS SCRIPT SHOULD BE RUN WITH APPROPRIATE PERMISSIONS TO READ BACKUP FOLDERS AND WRITE ALL DATA IN TARGET FOLDERS
        ## 
        ## Update BACKUP_TO_RESTORE value before runnning
        ##
        ##

        BACKUP_ROOT_FOLDER="/opt/backup"
        BACKUP_TO_RESTORE="13122024-0459-0000"
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

=== "Virtual servers"

    !!! Note
        This process and example below assume you have followed our [step-by-step guide](./../installation/docker.md) to install the application stack.
    

    Using virtual servers allow more solutions to perform backup and restore operations. 

    ---
    ## First solution: Backup and restore data folders

    Similar to using a physical server, use scripts to back up the configuration, data, and logs from each application in your stack, storing them in a folder that can be archived elsewhere. Refer to the [cold backup and restore guide for physical server](#__tabbed_1_1) for detailed instructions.

    ---
    ## Second solution: Leverage the capabilities of the hypervisor

    Hypervisors often come with the capacity to create a snapshot volumes and entire virtual machine. We recommend creating snapshots of volumes containing data and files after stopping TheHive, Cassandra and Elasticsearch applications. 
    
    For the restore process, begin by restoring the snapshots created with the hypervisor. This allows you to quickly revert to a previous state, ensuring that both the system configuration and application data are restored to their exact state at the time of the snapshot. Be sure to follow any additional procedures specific to your hypervisor to ensure the snapshots are properly applied and that the system operates as expected after the restore.

=== "Docker and Docker compose"

    !!! Note
        This solution assumes you are following our _[Running with Docker](./../installation/docker.md)_ guide to run your application stack.


    ---
    ## Backup process
    The simplest way to backup data is to save configuration, logs and data for each components by following this process: 

    ### Stop the services

    !!! Example ""

        ```bash
        docker compose down 
        ```

    ### Copy files in a backup folder

    For example, on the host server, create a folder on a dedicated NFS volume named `/opt/backups` and copy all files preserving their permissions

    !!! Example ""

        ```bash
        ## ============================================================
        ## USER-CONFIGURABLE VARIABLES
        ## ============================================================
        ##
        ## Update the following variables to match your environment
        ## Path to the docker-compose.yml file
        DOCKER_COMPOSE_PATH="./"
        ## Root folder for storing backups
        BACKUP_ROOT_FOLDER="/opt/backups"
        ## ============================================================
        ## DO NOT MODIFY ANYTHING BELOW THIS LINE
        ## ============================================================

        DATE="$(date +"%Y%m%d-%H%M%z" | sed 's/+/-/')"
        BACKUP_FOLDER="${BACKUP_ROOT_FOLDER}/${DATE}"


        ## Stop services
        docker compose stop

        ## Create the backup directory
        mkdir -p "${BACKUP_FOLDER}"  || { echo "Creating backup folder failed"; exit 1; }
        echo "Created backup folder: ${BACKUP_FOLDER}"

        ## Define the log file and start logging
        LOG_FILE="${BACKUP_ROOT_FOLDER}/backup_log_${DATE}.log"
        exec &> >(tee -a "$LOG_FILE")



        ## Prepare folders tree
        mkdir -p ${BACKUP_FOLDER}/{thehive,cassandra,elasticsearch,nginx,certificates}
        echo "Created folder structure under ${BACKUP_FOLDER}"

        ## Copy Cortex data
        echo "Starting Cortex backup..."
        rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/cortex/ ${BACKUP_FOLDER}/cortex || { echo "Cortex backup failed"; exit 1; }
        echo "Cortex backup completed."

        ## Copy Elasticsearch data
        echo "Starting Elasticsearch backup..."
        rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/elasticsearch/ ${BACKUP_FOLDER}/elasticsearch || { echo "Elasticsearch config backup failed"; exit 1; }
        echo "Elasticsearch backup completed."

        ## Copy Nginx certificates
        echo "Starting backup of Nginx and certificates..."
        rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/nginx/ ${BACKUP_FOLDER}/nginx || { echo " Backup of Nginx failed"; exit 1; }
        rsync -aW --no-compress ${DOCKER_COMPOSE_PATH}/certificates/ ${BACKUP_FOLDER}/certificates || { echo " Backup of Nginx and certificates failed"; exit 1; }
        echo "Backup of certificates completed."

        echo "Backup process completed at: $(date)"
        ```

    ### Restart the services

    !!! Example ""

        ```bash
        docker compose up -d
        ```

    !!! Tip
        * A comprehensive backup script, including all necessary housekeeping actions, is included with our Docker Compose profiles. Refer to the appropriate documentation for detailed instructions [here](https://github.com/StrangeBeeCorp/docker).
        * You can also review the backup script for `prod1-thehive` directly on our GitHub repository.


    ---
    ## Restore process

    !!! Note
        This process assumes you are using [one of our Docker Compose profiles](https://github.com/StrangeBeeCorp/docker), and you have already created backup using the previously outlined backup procedure.

    Restore data that has been saved following the previous backup process.

    ### Ensure all services are stopped
    
    !!! Example ""

        ```bash
        docker compose down
        ```

    ### Ensure all data folder are empty before running the restore process
    
    A backup is highly recommended before running a restore operation; this ensures you can revert to the current state if anything goes wrong.
    
    Ensure that the target data folders are empty before running this script. Indeed, pre-existing files can cause conflicts or data corruption during the restore process.


    ### Choose the archive to restore from the backup folder

    !!! Example ""
 
        ```bash
        #!/bin/bash

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
        ## TBD: read backups from the folder and ask the basckup to restore amongst last 10
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
        rsync -a ${BACKUP_FOLDER}/nginx/ ${DOCKER_COMPOSE_PATH}/nginx  ||
        { echo " Nginx configuration and certificates restore failed"; exit 1; } 
        rsync -a ${BACKUP_FOLDER}/certificates/ ${DOCKER_COMPOSE_PATH}/certificates  ||
        { echo " certificates restore failed"; exit 1; } 

        echo "Restoration process completed at: $(date)"
        ```


    ### Restart all services

    !!! Example ""

        ```bash
        docker compose up -d 
        ```
   

<!-- === "Cloud environment" -->
<!-- TBD -->

---
# Hot backup and restore

!!! Warning
    As outlined in this documentation, it is **crucial** that the data, index, and files must remain intact and consistent during the backup process. Any inconsistency could jeopardize the restore process. While we provide guidance on creating and restoring Cassandra snapshots, it is important to note that Elasticsearch snapshots should be taken concurrently to ensure consistency and integrity across both systems. Additionally, when using clusters, snapshots should be taken simultaneously across all nodes to maintain consistency.

    The scripts provided are examples that **you must customize** to fit your infrastructure and application stack. For instance, folder paths may differ depending on whether you're using physical servers or Docker Compose to run the services.


### Pre-requisites

**bzip2** package should be installed and available on the operating system before runing any of the scripts below.

* `apt install bzip2` for DEB based OS
* `yum install bzip2` for RPM based OS

&nbsp;

!!! Warning
    **This guide has only been tested on a single node Cassandra server.**



### Overview

To successfully restore TheHive, the following data needs to be saved:

- The database
- Files
- Optionally, the index

---

## Backing Up the Index ?

### Option 1: Backup Only the Data

You can use Cassandra snapshots to back up the data of a Cassandra node. This can be done while the application is running, meaning there is no downtime. With this option, the index is not backed up and will be rebuilt from the data during restoration.

If the index doesn't exist, it is built when TheHive starts.

**Pros:**

- No downtime during backup
- Backups take less space

**Cons:**

- Restoration can be lengthy (requires a full reindexation of the data)

&nbsp;

### Option 2: Backup the Data and the Index

To ensure the data and the index are synchronized, TheHive must be stopped before backing up Cassandra and Elasticsearch.

**Pros:**

- TheHive can be quickly restored from a backup

**Cons:**

- Downtime of TheHive during the backup
- Backups take more space

---

=== "Backup Index, Data and Files"

    ## Cassandra (database)

    ### Prerequisites

    To back up or export the database from Cassandra, the following information is required:

    - Cassandra admin password
    - Keyspace used by TheHive (default = `thehive`). This can be checked in the `application.conf` configuration file, in the database configuration under *storage*, *cql*, and `keyspace` attribute.

    !!! Tip
        This information can be found in TheHive configuration:

        ```yaml
        db.janusgraph {
            storage {
                backend: cql
                hostname: ["127.0.0.1"]
                cql {
                    cluster-name: thp
                    keyspace: thehive
                }
            }
        }
        ```

    &nbsp;

    ### Backup

    Following actions should be performed to backup the data successfully:

    1. Create a snapshot
    2. Save the data

    !!! Tip "The steps described below for data backup should be executed on each node. Each node's data should be backed up to ensure consistency in the backups."

    &nbsp;

    #### Create a snapshot and an archive

    Considering that ${BACKUP} is the name of the snapshot, run the following commands:


    ##### 1 - Use the `nodetool snapshot` command to create a snapshot of all keyspaces:

    !!! Example  ""

        ```bash
        nodetool snapshot -t ${BACKUP}
        ```

    ##### 2 - Create and archive with the snapshot data: Execute the following command For every cassandra keyspace: 

    !!! Example  ""

        ```bash
        tar cjfv ${KEYSPACE_NAME}.tbz -C /var/lib/cassandra/data/${KEYSPACE_NAME}/*/snapshots/${BACKUP} .
        ```

    ##### 3 - Remove old snapshots (if necessary)

    !!! Example  ""

        ```bash
        nodetool -h localhost -p 7199 clearsnapshot -t ${BACKUP}
        ```

    !!! Note
        We strongly recommend copying the snapshot archive files to a remote server or backup storage.

    &nbsp;

    #### Example

    !!! Example "Example of script to generate backups of TheHive keyspace"

        ```bash
        #!/bin/bash

        ## Create a tbz archive containing the snapshot
        ## This script should be executed on each node of the cluster

        ## Complete variables before running:
        HOSTNAME=$(hostname)
        SNAPSHOT_DATE="$(date +%F)"

        REMOTE_USER=<remote_user_to_change>
        REMOTE_HOST=<remote_host_to_change>

        ## Perform a backup for all keyspaces (system included)
        nodetool snapshot -t ${SNAPSHOT_DATE}

        ## Navigate to the snapshot directory

        find /var/lib/cassandra/data -name snapshots

        # Archive snapshot files
        mkdir -p /var/lib/cassandra/archive_backup/$HOSTNAME/${SNAPSHOT_DATE}
        cd /var/lib/cassandra/archive_backup/$HOSTNAME/${SNAPSHOT_DATE}

        for KEYSPACE in $(ls /var/lib/cassandra/data); do
        mkdir $KEYSPACE
        cd $KEYSPACE
        for TABLE in $(ls /var/lib/cassandra/data/${KEYSPACE}); do
            tar cjfv ${TABLE}.tbz -C /var/lib/cassandra/data/${KEYSPACE}/${TABLE}/snapshots/${SNAPSHOT_DATE} .
        done
        cd ..
        done

        nodetool -h localhost -p 7199 clearsnapshot -t ${SNAPSHOT_DATE}

        # Copy the snapshot archive files to a remote server

        scp /var/lib/cassandra/archive_backup/$HOSTNAME/${SNAPSHOT_DATE}/* ${REMOTE_USER}@${REMOTE_HOST}:/remote/node-hostname_cassandra_backup_directory
        ```

    &nbsp;

    ---

    ## Elasticsearch (index engine)


    ---

    ## Backup files

    Wether you use local or distributed files system storage, copy the content of the folder/bucket.

=== "Restore Files, Data and Index"

    ## Cassandra

    ### Restore data

    #### Data and index

    Before starting TheHive, if there is an index, ensure the index in Elasticsearch matches the data in Cassandra otherwise this would imply unpredictive behavior. You can force resync (reindex all data) by adding `db.janusgraph.forceDropAndRebuildIndex = true` in `application.conf` file.

    !!! Warning "Remove this line once TheHive is started"

    &nbsp;

    #### Pre requisites

    Following data is required to restore TheHive database successfully: 

    - A backup of the database (`${SNAPSHOT}_${SNAPSHOT_DATE}.tbz`)
    - Keyspace to restore does not exist in the database (or it will be overwritten)

    All nodes in the cluster should be up before starting the restore procedure.

    &nbsp;

    #### Restore


    ##### 1 - Start by drop the database `TheHive`

    !!! Example ""

        ```bash
        ## SOURCE_KEYSPACE contains the name of theHive database
        CASSANDRA_PASSWORD=<your_admin_password>
        CASSANDRA_ADDRESS=<cassandra_node_ip>
        SOURCE_KEYSPACE=thehive
        cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "DROP KEYSPACE IF EXISTS ${SOURCE_KEYSPACE};"
        ```

    ##### 2 - Create the keyspace

    !!! Example ""

        ```bash
        ## TARGET_KEYSPACE contains the new name of theHive database 
        ## NOTE that you can keep the same database name since the old one has been deleted
        cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "
            CREATE KEYSPACE ${TARGET_KEYSPACE}
            WITH replication = {'class': 'NetworkTopologyStrategy', 'replication_factor': '3'}
            AND durable_writes = true;"
        ```

    ##### 3 - Unarchive backup files

    !!! Note
        Note that the following steps should be executed for every Cassandra cluster node.

    !!! Example ""

        ```bash
        mkdir -p /var/lib/cassandra/restore
        RESTORE_PATH="/var/lib/cassandra/restore"
        SOURCE_KEYSPACE="thehive"
        SNAPSHOT_DATE=<date_of_backup>
        ## TABLES should contain the list of all tables that will be restored
        ## table_name should include the uuid generated by cassandra, for example: table1-f901e0c05d8811ef87c71fc3a94044f4

        TABLES="ls -1 /var/lib/cassandra/data/${SOURCE_KEYSPACE}/"
        ## copy all of the snapshot tables that you want to restore from remote server or local cassandra node then extract it
        ## repeat the following  steps on each node Cassandra for each table in the TABLES List

        cd /var/lib/cassandra/restore
        for table in $TABLES; do
        scp remoteuser@remotehost:/remote/node_name_directory/${SNAPSHOT_DATE}/${SOURCE_KEYSPACE}/${table}.tbz .
        mkdir -p ${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}
        echo "Unarchive backup files for table: $table"
        tar jxf ${table}.tbz -C ${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}
        done
        ```

    ##### 4 - Create tables from archive

    The archive contains the table schemas. They must be executed in the new keyspace. The schema files are in `${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}`

    !!! Example ""

        ```bash
        for CQL in $(find ${RESTORE_PATH} -name schema.cql)
        do
        cqlsh -u admin -p ${CASSANDRA_PASSWORD} -f $CQL
        done
        ```

    If you want to change the name of the keyspace (`${SOURCE_KEYSPACE}` => `${TARGET_KEYSPACE}`), you need to rewrite the cql command:

    !!! Example ""

        ```bash
        for CQL in $(find ${RESTORE_PATH} -name schema.cql)
        do
        cqlsh cassandra -e "$(sed -e '/CREATE TABLE/s/'${SOURCE_KEYSPACE}/${TARGET_KEYSPACE}/ $CQL)"
        done
        ```

    ### 5 - Load table data

    !!! Note 
        Note that the following command should be executed on each Cassandra node in the cluster.

    !!! Example  ""

        ```bash
        for TABLE in ${RESTORE_PATH}/${TARGET_KEYSPACE}/*
        do 
        TABLE_BASENAME=$(basename ${TABLE})
        TABLE_NAME=${TABLE_BASENAME%%-*}
        nodetool import ${TARGET_KEYSPACE} ${TABLE_NAME} ${RESTORE_PATH}/${TARGET_KEYSPACE}/${TABLE_BASENAME}
        done
        ```
    &nbsp;

    If the cluster topology has changed (new nodes added ou removed from the cluster since the last data backup), please follow the run the following command to perform a restore:

    !!! Example  ""

        ```bash
        for TABLE in ${RESTORE_PATH}/${TARGET_KEYSPACE}/*
        do 
        TABLE_BASENAME=$(basename ${TABLE})
        sstableloader -d ${CASSANDRA_IP} ${RESTORE_PATH}/${TARGET_KEYSPACE}/${TABLE_BASENAME}
        done
        ```

    ##### 6 - Cleanup

    !!! Example ""

        ```bash
        rm -rf ${RESTORE_PATH}
        ```

    &nbsp;

    ### Rebuid an existing node

    If for a particular reason (such as corrupted system data), you need to reintegrate the node into the cluster and restore all data (including system data), here is the procedure:

    ##### 1 - Make sure that the Cassandra service is still down then delete the contents of the data volume:

    !!! Example  ""

        ```bash
        cd /var/lib/cassandra/data
        rm -rf *
        ```

    ##### 2 - Copy and unarchive backup files:

    !!! Example  ""

        ```bash
        DATA_PATH="/var/lib/cassandra/data"

        SNAPSHOT_DATE=<date_of_snaphot>
        ## KEYSPACES list should inlude all keyspaces
        KEYSPACES="system system_distributed system_traces system_virtual_schema system_auth system_schema system_views thehive"
        cd ${DATA_PATH}
        for ks in $KEYSPACES; do
        scp -r remoteuser@remotehost:/remote/node_name_directory/${SNAPSHOT_DATE}/${ks}/ .
        for file in /var/lib/cassandra/data/${ks}/*; do
            echo "Processing $file"
            filename=$(basename "$file")
            table_name="${filename%%.*}"
            sudo mkdir -p ${ks}/${table_name}
            sudo tar jxf $file -C ${ks}/${table_name}
            rm -f $file
        done
        done

        chown -R cassandra:cassandra  /var/lib/cassandra/data
        ```
    ##### 3 - Start cassandra service

    !!! Example  ""

        ```bash
        service cassandra start

        ## heck if Cassandra has started successfully by reviewing its logs
        tail -n 100 /var/log/cassandra/system.log | grep -iE "listening for|startup complete|error|warning"

        INFO  [main] ********,773 PipelineConfigurator.java:125 - Starting listening for CQL clients on localhost/127.0.0.1:9042 (unencrypted)...
        INFO  [main] ********,790 CassandraDaemon.java:776 - Startup complete
        ```

    !!! Warning "Ensure no Commitlog file exist before restarting Cassandra service. (`/var/lib/cassandra/commitlog`)"


    !!! Example "Example of script to restore TheHive keyspace in Cassandra"

        ```bash
        #!/bin/bash

        ## Restore a KEYSPACE and its data from a CQL file with the schema of the
        ## KEYSPACE and an tbz archive containing the snapshot

        ## Complete variables before running:
        ## CASSANDRA_ADDRESS: IP of cassandra server
        ## RESTORE_PATH: choose a TMP folder !!! this folder will be removed if exists.
        ## SOURCE_KEYSPACE: KEYSPACE used in the backup
        ## TARGET_KEYSPACE: new KEYSPACE name ; use same name of SOURCE_KEYSPACE if no changes
        ## TABLES: should contain the list of all tables that will be restored, table_name should include the uuid generated by cassandra, for example: table1-f901e0c05d8811ef87c71fc3a94044f4
        ## SNAPSHOT: choose a name for the backup
        ## SNAPSHOT_DATE: date of the snapshot to restore

        ## IMPORTANT: Note that the following steps should be executed on each Cassandra cluster node.

        CASSANDRA_ADDRESS="10.1.1.1"
        RESTORE_PATH="/var/lib/cassandra/restore"
        SOURCE_KEYSPACE="thehive"
        TARGET_KEYSPACE="thehive_restore"
        TABLES="
        table1-f901e0c05d8811ef87c71fc3a94044f4
        table2-d502a0c05d8811ef87c71fc3a94044f5
        table3-a703c0c05d8811ef87c71fc3a94044f6
        " 
        SNAPSHOT_DATE="2024-09-23"

        ## Copy from backup folder and Uncompress data in restore folder

        cd ${RESTORE_PATH}
        for table in $TABLES; do
            cp -r PATH_TO_BACKUP_DIRECTORY/${SNAPSHOT_DATE}/${SOURCE_KEYSPACE}/${table}.tbz .
            mkdir -p ${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}
            echo "Unarchive backup files for table: $table"
            tar jxf ${table}.tbz -C ${RESTORE_PATH}/${SOURCE_KEYSPACE}/${table}
        done
        ## Read Cassandra password
        echo -n "Cassandra admin password: " 
        read -s CASSANDRA_PASSWORD

        # Drop the keyspace
        cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "DROP KEYSPACE IF EXISTS ${SOURCE_KEYSPACE};"

        # Create the keyspace
        ## TARGET_KEYSPACE contains the new name of theHive database 
        ## NOTE that you can keep the same database name since the old one has been deleted

        cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "
            CREATE KEYSPACE ${TARGET_KEYSPACE}
            WITH replication = {'class': 'NetworkTopologyStrategy', 'replication_factor': '3'}
            AND durable_writes = true;"

        # Create table in keyspace
        for CQL in $(find ${RESTORE_PATH} -name schema.cql)
        do
        cqlsh -u admin -p ${CASSANDRA_PASSWORD} ${CASSANDRA_ADDRESS} -e "$(sed -e '/CREATE TABLE/s/'${SOURCE_KEYSPACE}/${TARGET_KEYSPACE}/ $CQL)"
        done
        

        ## Load data
        for TABLE in ${RESTORE_PATH}/${TARGET_KEYSPACE}/*
            do 
            TABLE_BASENAME=$(basename ${TABLE})
            TABLE_NAME=${TABLE_BASENAME%%-*}
            nodetool import ${TARGET_KEYSPACE} ${TABLE_NAME} ${RESTORE_PATH}/${TARGET_KEYSPACE}/${TABLE_BASENAME}
        done
        ```

    --- 
    ## Restore Elasticsearch index

    Several solutions exist regarding the index:

    1. Save the Elasticsearch index and restore it ; follow Elasticsearch guides to perform this action
    2. Rebuild the index on the new server, when TheHive start for the first time.

    &nbsp;

    ### Rebuild the index

    Once Cassandra database is restored, update the configuration of TheHive to rebuild the index.

    These lines should be added to the configuration file only for the first start of TheHive application, and removed later on.

    !!! Example  ""

        ```yaml title="extract from /etc/thehive/application.conf"
        db.janusgraph.forceDropAndRebuildIndex = true
        ```

    !!! Warning "Once started, both lines should be removed or commented from the configuration file of TheHive"


        ---

        ## Restore Files

        Restore the saved files into the destination folder/bucket that will be used by TheHive. Ensure the account running TheHive application has permissions to create files and folders into the destination folder.



---

## Troubleshooting

The first start can take some time, especially if the application has to rebuild the index.
Refer to this [troubleshooting section](../installation/upgrade-from-4.x.md/#troubleshooting) to ensure everything goes well with reindexation.


!!! Note
    References:
    - [Backing up and restoring data](https://docs.datastax.com/en/cassandra-oss/3.x/cassandra/operations/opsBackupRestore.html)

&nbsp;