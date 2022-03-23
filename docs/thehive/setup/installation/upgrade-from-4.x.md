# Upgrade from TheHive 4.x

!!! Info
    This guide describes how to upgrade TheHive from version **4.1.x** to **5.0.x**.

    This guide is **for standalone servers only**, and considers: 

    - The application is running on a [supported Linux operating system](../index.md#operating-systems)
    - The server meets [prerequisites](../index.md#requirements) regaring CPU & RAM.

    
!!! Warning "Switch to Elasticsearch as indexing engine"
    If using Lucene as indexing engine with TheHive 4.1.x,  reindexing the data is mandatory. It might take some time ragarding the size of your database. 


## Preparation

The Database application will be upgraded during the upgrade. We highly recommend making backups of the database, index and files before running the operation.

!!! Note "FAQ"
    **Q:** **How to make backups ?**

    **A:** _Read our [backup and restore guide](../operations/backup-restore.md)_


### Stop all running applications
 
1. Start by stopping TheHive:

    ```bash title="stop thehive service"
    sudo systemctl stop thehive
    ```

2. Once TheHive is sucessfully stopped, stop database service

    ```bash title="stop cassandra service"
    sudo systemctl stop cassandra
    ```

3. Only if already using Elasticsearch as indexing engine
    ```bash title="stop elasticsearch service"
    sudo systemctl stop elasticsearch
    ```


## Upgrade Java
Follow the [installation process](step-by-step-guide.md#java-virtual-machine) to install the required version. 


## Upgrade or install Elasticsearch
Follow the [installation process](step-by-step-guide.md#elasticsearch) to install and configure the required version.

## Upgrade Cassandra

### Backup configuration file
Save the existing configuration file for Cassandra 3.x. It will be used later to configure Cassandra 4. 

```bash
sudo cp /etc/cassandra/cassandra.yaml /root/cassandra3.yaml
```



