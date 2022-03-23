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
Save the existing configuration file for Cassandra 3.x. It will be used later to configure Cassandra 4:

```bash
sudo cp /etc/cassandra/cassandra.yaml /etc/cassandra/cassandra3.yaml.bak
```

### Install Cassandra 
Follow the [installation process](step-by-step-guide.md#cassandra) to install the required version.

During the installation process, replace existing configuration files (*as the old configuration is saved"): 

```
Configuration file '/etc/cassandra/cassandra.yaml'
 ==> Modified (by you or by a script) since installation.
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** cassandra.yaml (Y/I/N/O/D/Z) [default=N] ? Y
```

### Configuration

Update the new configuration file, and ensure following parameters are correctly set with this values:

```
cluster_name: 'thp'
num_tokens: 256
```

!!! Info
    If you had a more customised configuration file for Cassandra 3.x, review all the file and ensure to adapt it accordingly.

### Start the service

```
sudo systemctl start thehive
```

## Install thehive

### Prepare for the new installation

!!! Tip "TheHive configuration file: /etc/thehive/application.conf"
    Starting with TheHive 5.0.0, configuration is simplified; most of all administration parameters can be configured directly in the UI. The configuration file (`/etc/thehive/application.conf`) contains **only** the necessary information to start the application sucessfully; that means: 

    - Secret
    - Database
    - Indexing engine
    - File storage
    - Enabled connectors 
    - (Akka in the case of a cluster)

    Authentication, Webhooks, Cortex and MISP configuration can be done in the UI. 

1. Save your current configuration file: 

    ```bash
    sudo cp /etc/thehive/application.conf /etc/thehive/application.conf.bak
    ```

2. For the current use case, i.e. a standalone server, the final configuration file should look like this:

    ```conf title="sample of /etc/thehive/application.conf"
    # TheHive configuration - application.conf
    #
    #
    # This is the default configuration file.
    # This is prepared to run with all services locally:
    # - Cassandra for the database
    # - Elasticsearch for index engine
    # - File storage is local in /opt/thp/thehive/files
    #
    # If this is not your setup, please refer to the documentation at:
    # https://docs.thehive-project.org/thehive/
    #
    #
    # Secret key - used by Play Framework
    # If TheHive is installed with DEB/RPM package, this is automatically generated
    # If TheHive is not installed from DEB or RPM packages run the following
    # command before starting thehive:
    #   cat > /etc/thehive/secret.conf << _EOF_
    #   play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 |#   head -n 1)"
    #   _EOF_
    include "/etc/thehive/secret.conf"


    # Database and index configuration
    # By default, TheHive is configured to connect to local Cassandra 4.x and a
    # local Elasticsearch services without authentication.
    db.janusgraph {
      storage {
        backend = cql
        hostname = ["127.0.0.1"]
        # Cassandra authentication (if configured)
        # username = "thehive"
        # password = "password"
        cql {
          cluster-name = thp
          keyspace = thehive
        }
      }
      index.search {
        backend = elasticsearch
        hostname = ["127.0.0.1"]
        index-name = thehive
      }
    }

    # Attachment storage configuration
    # By default, TheHive is configured to store files locally in the folder.
    # The path can be updated and should belong to the user/group running thehive service. (by default: thehive:thehive)
    storage {
      provider = localfs
      localfs.location = /opt/thp/thehive/files
    }

    # Define the maximum size for an attachment accepted by TheHive
    play.http.parser.maxDiskBuffer = 1GB
    # Define maximum size of http request (except attachment)
    play.http.parser.maxMemoryBuffer = 10M

    # Service configuration
    application.baseUrl = "http://localhost:9000"
    play.http.context = "/"

    # Additional modules
    #
    # TheHive is strongly integrated with Cortex and MISP.
    # Both modules are enabled by default. If not used, each one can be disabled by
    # commenting the configuration line.
    scalligraph.modules += org.thp.thehive.connector.cortex.CortexModule
    scalligraph.modules += org.thp.thehive.connector.misp.MispModule
    ```

3. Update the configuration file with your custom configuration if required