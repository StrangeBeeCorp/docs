# Step-by-Step Guide

This article provides a comprehensive installation and configuration guide to set up an instance of TheHive. The guide offers detailed instructions accompanied by examples for systems based on DEB and RPM packages, as well as for installation from binary packages.

!!! Info "Note: Installation for a new instance of TheHive only is covered in this guide."

---

## Dependencies

Before proceeding with the installation, ensure that the following programs are already installed on your system:

=== "DEB"

    1. Open a terminal window.
    2. Run the following command to install the necessary dependencies:

        ```bash
        apt install wget gnupg apt-transport-https git ca-certificates ca-certificates-java curl software-properties-common python3-pip lsb-release
        ```

=== "RPM"

    1. Open a terminal window.
    2. Execute the following command to install the required dependencies:

        ```bash
        yum install pkg-install gnupg chkconfig python3-pip git
        ```

Ensure that all dependencies are successfully installed before proceeding with the TheHive installation process.

---

## :fontawesome-brands-java: Java Virtual Machine
 
!!! Danger "Important Note:"
    - For security and long-term support, it is mandatory to use [**Amazon Corretto**](https://aws.amazon.com/corretto/) builds, which are OpenJDK builds provided and maintained by Amazon.
    - Java version 8 is no longer supported.

=== "DEB"

    1. Open a terminal window.
    2. Execute the following commands:

        !!! Example ""
            ```bash
            wget -qO- https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto.gpg
            echo "deb [signed-by=/usr/share/keyrings/corretto.gpg] https://apt.corretto.aws stable main" | sudo tee -a /etc/apt/sources.list.d/corretto.sources.list
            sudo apt update
            sudo apt install java-common java-11-amazon-corretto-jdk
            echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment
            export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
            ```

    3. Verify the installation by running:

        !!! Example ""
            ```bash
            java -version
            ```

    4. You should see output similar to the following:

        !!! Example ""
            ```bash
            openjdk version "11.0.12" 2022-07-19
            OpenJDK Runtime Environment Corretto-11.0.12.7.1 (build 11.0.12+7-LTS)
            OpenJDK 64-Bit Server VM Corretto-11.0.12.7.1 (build 11.0.12+7-LTS, mixed mode)
            ```


=== "RPM"

    1. Open a terminal window.
    2. Execute the following commands:

        !!! Example ""
            ```bash
            sudo rpm --import https://yum.corretto.aws/corretto.key &> /dev/null
            wget -qO- https://yum.corretto.aws/corretto.repo | sudo tee -a /etc/yum.repos.d/corretto.repo
            yum install java-1.11.0-amazon-corretto-devel &> /dev/null
            echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment
            export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
            ```

    3. Verify the installation by running:

        !!! Example ""
            ```bash
            java -version
            ```

    4. You should see output similar to the following:

        !!! Example ""
            ```bash
            openjdk version "11.0.12" 2022-07-19
            OpenJDK Runtime Environment Corretto-11.0.12.7.1 (build 11.0.12+7-LTS)
            OpenJDK 64-Bit Server VM Corretto-11.0.12.7.1 (build 11.0.12+7-LTS, mixed mode)
            ```


=== "Other"
    If you are using a system other than DEB or RPM, please consult your system documentation for instructions on installing Java 11.

---

## :fontawesome-solid-database: Apache Cassandra

Apache Cassandra is a highly scalable and robust database system. TheHive is fully compatible with Apache Cassandra's latest stable release version **4.0.x**.

!!! Info "Upgrading from Cassandra 3.x"
    The information provided in this guide pertains specifically to fresh installations. If you are currently using Cassandra 3.x and considering an upgrade, we recommend referring to the [**dedicated guide**](./upgrade-from-4.x.md). 

&nbsp;

### Installation

=== "DEB"
    
    1. Add Apache Cassandra repository references

        - *Download Apache Cassandra repository keys using the following command:*
        
        !!! Example ""
            ```bash
            wget -qO -  https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor  -o /usr/share/keyrings/cassandra-archive.gpg
            ```

        - *Add the repository to your system by appending the following line to the `/etc/apt/sources.list.d/cassandra.sources.list` file. This file may not exist, and you may need to create it.*
        
        !!! Example ""
            ```bash
            echo "deb [signed-by=/usr/share/keyrings/cassandra-archive.gpg] https://debian.cassandra.apache.org 40x main" |  sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list 
            ```

    2. Install the package

        - *Once the repository references are added, update your package index and install Cassandra using the following commands:*

        !!! Example ""
            ```bash
            sudo apt update
            sudo apt install cassandra
            ```

=== "RPM"

    1. Add Cassandra repository keys

        - *To add Cassandra repository keys, execute the following command:*
        
        !!! Example ""
            ```bash
            rpm --import https://downloads.apache.org/cassandra/KEYS
            ```
    
    2. Add the Apache repository for Cassandra to **/etc/yum.repos.d/cassandra.repo**

        - *To add the Apache repository configuration for Cassandra, you need to create a new file named `/etc/yum.repos.d/cassandra.repo` and add the following content to it:*
        
        !!! Example ""
            ```bash
            [cassandra]
            name=Apache Cassandra
            baseurl=https://redhat.cassandra.apache.org/40x/
            gpgcheck=1
            repo_gpgcheck=1
            gpgkey=https://downloads.apache.org/cassandra/KEYS
            ```
        
        !!! Note "Note"
            You can create the file and add the content using a text editor like **nano** or **vim**. 

    3. Install the package

        - *After adding the repository configuration, install Cassandra using the following command:*
        
        !!! Example ""
            ```bash
            sudo yum install cassandra
            ```

=== "Other Installation Methods"


    Download the tar.gz archive from [**Apache Cassandra Downloads**](http://cassandra.apache.org/download/) and extract it into the folder of your choice. You can use utilities like `wget` to download the archive.


By default, data is stored in `/var/lib/cassandra`. Ensure appropriate permissions are set for this directory to avoid any issues with data storage and access.

&nbsp;

### Configuration

You can configure Cassandra by modifying settings within the `/etc/cassandra/cassandra.yaml` file.


**1.Locate the Cassandra Configuration File:**
   
   Navigate to the directory containing the Cassandra configuration file `/etc/cassandra/`.

**2.Edit the `cassandra.yaml` File:**
   
   Open the `cassandra.yaml` file in a text editor with appropriate permissions.

**3.Configure Cluster Name:**
   
   Set the `cluster_name` parameter to the desired name. This name helps identify the Cassandra cluster.

**4.Configure Listen Address:**
   
   Set the `listen_address` parameter to the IP address of the node within the cluster. This address is used by other nodes within the cluster to communicate.

**5.Configure RPC Address:**
   
   Set the `rpc_address` parameter to the IP address of the node to enable clients to connect to the Cassandra cluster.

**6.Configure Seed Provider:**
   
   Ensure the `seed_provider` section is properly configured. The `seeds` parameter should contain the IP address(es) of the seed node(s) in the cluster.

**7.Configure Directories:**
   
   Set the directories for data storage, commit logs, saved caches, and hints as per your requirements. Ensure that the specified directories exist and have appropriate permissions.

**8.Save the Changes:**
   
   After making the necessary configurations, save the changes to the `cassandra.yaml` file.


!!! Example ""
    ```yaml title="/etc/cassandra/cassandra.yaml"
    # content from /etc/cassandra/cassandra.yaml
    [..]
    cluster_name: 'thp'
    listen_address: 'xx.xx.xx.xx' # address for nodes
    rpc_address: 'xx.xx.xx.xx' # address for clients
    seed_provider:
        - class_name: org.apache.cassandra.locator.SimpleSeedProvider
        parameters:
            # Ex: "<ip1>,<ip2>,<ip3>"
            - seeds: 'xx.xx.xx.xx' # self for the first node
    data_file_directories:
    - '/var/lib/cassandra/data'
    commitlog_directory: '/var/lib/cassandra/commitlog'
    saved_caches_directory: '/var/lib/cassandra/saved_caches'
    hints_directory: 
    - '/var/lib/cassandra/hints'
    [..]
    ```

&nbsp;

### Start the service 

=== "DEB"
    
    1. Start the Service

        - *Execute the following command to start the Cassandra service:*
        
        !!! Example ""
            ```bash
            sudo systemctl start cassandra
            ```

    2. Ensure Service Restarts After Reboot:

        - *Enable the Cassandra service to restart automatically after a system reboot:*

        !!! Example ""
            ```bash
            sudo systemctl enable cassandra
            ```

    3. (Optional) Remove Existing Data Before Starting

        - *If the Cassandra service was started automatically before configuring it, it's recommended to stop it, remove existing data, and restart it once the configuration is updated. Execute the following commands:*

        !!! Example ""
            ```bash
            sudo systemctl stop cassandra
            sudo rm -rf /var/lib/cassandra/*
            ```

=== "RPM"

    1. Start the Service

        - *Start the Cassandra service by running:*
        
        !!! Example ""
            ```bash
            sudo systemctl daemon-reload
            sudo service cassandra start
            ```

    2. Ensure Service Restarts After Reboot

        - *Enable the Cassandra service to restart automatically after a system reboot:*

        !!! Example ""
            ```bash
            sudo systemctl enable cassandra
            ```

!!! Note "Note"
    Cassandra defaults to listening on port 7000/tcp for inter-node communication and port 9042/tcp for client communication.


<!-- #### Additional configuration : disable tombstones  (for standalone server **ONLY**)

!!! Warning "This action should be performed after the installation and the first start of TheHive"

If you are installing a standalone server, tombstones can be disabled. 

1. Check `gc_grace_seconds` value

    !!! Example ""        
        ```bash
        cqlsh -u cassandra <IP ADDRESS> -e "SELECT table_name,gc_grace_seconds FROM system_schema.tables WHERE keyspace_name='thehive'"
        ```

        **Note**: default credentials for Cassandra database: _cassandra/cassandra_ 

    Results should look like this: 

    ```output
                table_name       | gc_grace_seconds
        -------------------------+------------------
                    edgestore    |           864000
                edgestore_lock_  |           864000
                    graphindex   |           864000
                graphindex_lock_ |           864000
                janusgraph_ids   |           864000
            system_properties    |           864000
        system_properties_lock_  |           864000
                    systemlog    |           864000
                        txlog    |           864000
    ```


2. Disable by setting `gc_grace_seconds` to 0. Use this command line: 

    !!! Example ""       
        ```bash
        for TABLE in edgestore edgestore_lock_ graphindex graphindex_lock_ janusgraph_ids system_properties system_properties_lock_ systemlog txlog
            do
            cqlsh -u cassandra -e "ALTER TABLE thehive.${TABLE} WITH gc_grace_seconds = 0;"
            done
        ```

3. Check changes has been taken into account, by running this command again: 

    !!! Example ""        
        ```bash
        cqlsh -u cassandra <IP ADDRESS> -e "SELECT table_name,gc_grace_seconds FROM system_schema.tables WHERE keyspace_name='thehive'"
        ``` 

    Results should look like this: 

    ```output
                table_name       | gc_grace_seconds
        -------------------------+------------------
                    edgestore    |           0
                edgestore_lock_  |           0
                    graphindex   |           0
                graphindex_lock_ |           0
                janusgraph_ids   |           0
            system_properties    |           0
        system_properties_lock_  |           0
                    systemlog    |           0
                        txlog    |           0
    ```


For additional configuration options, refer to:

- [Cassandra documentation page](https://cassandra.apache.org/doc/latest/getting_started/configuring.html)
- [Datastax documentation page](https://docs.datastax.com/en/ddac/doc/datastax_enterprise/config/configTOC.html) -->

---

## :fontawesome-solid-list: Elasticsearch

Elasticsearch is a robust data indexing and search engine. It is used by TheHive to manage data indices efficiently.

!!! Note 
    From Version 5.3, TheHive supports Elasticsearch 8.0 and 7.x. Previous TheHive versions only support Elasticsearch 7.x.

!!! Note 
    Starting from TheHive 5.3, for advanced use-cases, OpenSearch is also supported.

&nbsp;

### Installation

=== "DEB"
    
    1. Add Elasticsearch repository references

        - *To add Elasticsearch repository keys, execute the following command:*

        !!! Example ""
            ```bash
            wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
            sudo apt-get install apt-transport-https
            ```

        - *Add the repository to your system by appending the following line to the /etc/apt/sources.list.d/elastic-7.x.list file. This file may not exist, and you may need to create it*

        !!! Example ""
            ```bash
            echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" |  sudo tee /etc/apt/sources.list.d/elastic-7.x.list 
            ```

    2. Install the package

        - *Once the repository references are added, update your package index and install Elasticsearch using the following commands:*

        !!! Example ""
            ```bash
            sudo apt update
            sudo apt install elasticsearch
            ```


=== "RPM"

    1. Add Elasticsearch repository references

        - *To add Elasticsearch repository keys, execute the following command:*

        !!! Example ""
            ```bash
            rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
            ```

    2. Add the RPM repository of Elasticsearch to `/etc/yum.repos.d/elasticsearch.repo`

        - *To add the repository configuration for Elasticsearcg, you need to create a new file named `/etc/yum.repos.d/elasticsearch.repo` and add the following content to it:*

        !!! Example ""
            ```bash title="/etc/yum.repos.d/elasticsearch.repo"
            [elasticsearch]
            name=Elasticsearch repository for 7.x packages
            baseurl=https://artifacts.elastic.co/packages/7.x/yum
            gpgcheck=1
            gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
            enabled=0
            autorefresh=1
            type=rpm-md
            ```

    3. Install the package

        - *After adding the repository configuration, install Elasticsearch using the following command:*

        !!! Example ""
            ```bash
            sudo yum install --enablerepo=elasticsearch elasticsearch
            ```
    
    _Please refer to the official Elasticsearch documentation website for the most up-to-date instructions_: [**https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html**](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html)

=== "Other Installation Methods"

    Download the tar.gz archive from **http://cassandra.apache.org/download/** and extract it into the folder of your choice. You can use utilities like wget to download the archive.

&nbsp;

### Configuration 

You can configure Elasticsearch by modifying settings within the `/etc/elasticsearch/elasticsearch.yml` file.

**1. Locate the Elasticsearch Configuration File:**
   
   - Navigate to the directory containing the Elasticsearch configuration file `/etc/elasticsearch/`.

**2. Edit the elasticsearch.yml File:**
   
   - Open the `elasticsearch.yml` file in a text editor with appropriate permissions.

**3. Configure HTTP and Transport Hosts:**
   
   - Set the `http.host` and `transport.host` parameters to `127.0.0.1` or the desired IP address.

**4. Configure Cluster Name:**
   
   - Set the `cluster.name` parameter to the desired name. This name helps identify the Elasticsearch cluster.

**5. Configure Thread Pool Search Queue Size:**
   
   - Set the `thread_pool.search.queue_size` parameter to the desired value, such as `100000`.

**6. Configure Paths for Logs and Data:**
   
   - Set the `path.logs` and `path.data` parameters to the desired directories, such as `"/var/log/elasticsearch"` and `"/var/lib/elasticsearch"`, respectively.

**7. Configure X-Pack Security (Optional):**
   
   - If you're not using X-Pack security, ensure that `xpack.security.enabled` is set to `false`.

**8. Configure Script Allowed Types (Optional):**
   
   - If needed, set the `script.allowed_types` parameter to specify allowed script types.

**9. Save the Changes:**
   
   - After making the necessary configurations, save the changes to the `elasticsearch.yml` file.

**10. Custom JVM Options:**
   
   - Create the file `/etc/elasticsearch/jvm.options.d/jvm.options` if it doesn't exist.

**11. Custom JVM Options:**
   
   - Inside `jvm.options`, add the desired JVM options, such as:

    !!! Example ""
        ```
        -Dlog4j2.formatMsgNoLookups=true
        -Xms4g
        -Xmx4g
        ```

    !!! Note "Adjust the memory settings (`-Xms` and `-Xmx`) according to the available memory."


!!! Example ""
    ```yaml title="/etc/elasticsearch/elasticsearch.yml"
    http.host: 127.0.0.1
    transport.host: 127.0.0.1
    cluster.name: hive
    thread_pool.search.queue_size: 100000
    path.logs: "/var/log/elasticsearch"
    path.data: "/var/lib/elasticsearch"
    xpack.security.enabled: false
    script.allowed_types: "inline,stored"
    ```

!!! Info
    - Index creation occurs during TheHive's initial startup, which may take some time to complete.
    - Similar to data and files, indexes should be included in the backup policy to ensure their preservation.
    - Indexes can be removed and re-created as needed.

&nbsp;

### Sart the service

=== "DEB"
    
    1. Start the Service

        - *Execute the following command to start the Elasticsearch service:*
        
        !!! Example ""
            ```bash
            sudo systemctl start elasticsearch
            ```

    2. Ensure Service Restarts After Reboot:

        - *Enable the Elasticsearch service to restart automatically after a system reboot:*

        !!! Example ""
            ```bash
            sudo systemctl enable elasticsearch
            ```

    3. (Optional) Remove Existing Data Before Starting

        - *If the Elasticsearch service was started automatically before configuring it, it's recommended to stop it, remove existing data, and restart it once the configuration is updated. Execute the following commands:*
 
        !!! Example ""
            ```bash
            sudo systemctl stop elasticsearch
            sudo rm -rf /var/lib/elasticsearch/*
            ```

=== "RPM"

    1. Start the Service

        - *Start the Elasticsearch service by running:*
        
        !!! Example ""
            ```bash
            sudo systemctl daemon-reload
            sudo service elasticsearch start
            ```

    2. Ensure Service Restarts After Reboot

        - *Enable the Elasticsearch service to restart automatically after a system reboot:*

        !!! Example ""
            ```bash
            sudo systemctl enable elasticsearch
            ```

---

## :fontawesome-solid-folder-tree: File Storage
For standalone production and test servers, we recommend using the local filesystem. However, if you are considering building a cluster with TheHive, there are several possible solutions available, including NFS or S3 services. For further details and an example involving MinIO servers, please refer to the [**related guide**](./deploying-a-cluster.md).

=== "Local Filesystem"
    To utilize the local filesystem for file storage, begin by selecting a dedicated folder. By default, this folder is located at `/opt/thp/thehive/files`:

    !!! Example ""
        ```bash
        sudo mkdir -p /opt/thp/thehive/files
        ```

    This path will be utilized in the configuration of TheHive. After installing TheHive, it's important to ensure that the user thehive owns the chosen path for storing files:

    !!! Example ""
        ```bash
        chown -R thehive:thehive /opt/thp/thehive/files
        ```

=== "S3 with Min.io"

    Detailed documentation on the installation, configuration, and usage of Min.IO can be found in [this documentation](./deploying-a-cluster.md).

---

## :material-beehive-outline: TheHive Installation and Configuration

This section provides detailed instructions for installing and configuring TheHive.

&nbsp;

### Installation

All required packages are available on our package repository. We support Debian and RPM packages, as well as binary packages in zip format. All packages are signed using our GPG key [**562CBC1C**](https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY) with the fingerprint `0CD5 AC59 DE5C 5A8E 0EE1 3849 3D99 BB18 562C BC1C`.

=== "DEB"

    For Debian systems, use the following commands:

    !!! Example ""
        ```bash
        wget -O- https://archives.strangebee.com/keys/strangebee.gpg | sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
        ```
    
=== "RPM"

    For RPM-based systems, follow these steps:

    !!! Example ""
        ```bash
        sudo rpm --import https://archives.strangebee.com/keys/strangebee.gpg 
        ```


Install TheHive package by using the following commands:


=== "DEB"

    !!! Example ""
        ```bash
        echo 'deb [arch=all signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.3 main' |sudo tee -a /etc/apt/sources.list.d/strangebee.list
        sudo apt-get update
        sudo apt-get install -y thehive
        ```

=== "RPM"

    1. Import the RPM repository key:

        !!! Example ""
            ```bash
            sudo rpm --import https://archives.strangebee.com/keys/strangebee.gpg 
            ```

    2. Create and edit the file /etc/yum.repos.d/strangebee.repo:

        !!! Example ""
            ```bash title="/etc/yum.repos.d/strangebee.repo"
            [thehive]
            enabled=1
            priority=1
            name=StrangeBee RPM repository
            baseurl=https://rpm.strangebee.com/thehive-5.3/noarch
            gpgkey=https://archives.strangebee.com/keys/strangebee.gpg
            gpgcheck=1
            ```

    3. Then install the package using `yum`:

        !!! Example ""
            ```bash
            sudo yum install thehive
            ```

=== "Other Installation Methods"

    If you prefer a binary package, follow these steps:


    1. Download and unzip the chosen binary package. TheHive files can be installed wherever you want on the filesystem. In this guide, we assume you have chosen to install them under `/opt`.

        !!! Example ""
            ```bash
            cd /opt
            wget https://archives.strangebee.com/zip/thehive-latest.zip
            unzip thehive-latest.zip
            sudo ln -s thehive-x.x.x thehive
            ```

    2. Prepare the system. It is recommended to use a dedicated, non-privileged user account to start TheHive. If so, make sure that the chosen account can create log files in `/opt/thehive/logs`.

        !!! Example ""
            ```bash
            sudo addgroup thehive
            sudo adduser --system thehive
            sudo chown -R thehive:thehive /opt/thehive
            sudo mkdir /etc/thehive
            sudo touch /etc/thehive/application.conf
            sudo chown root:thehive /etc/thehive
            sudo chgrp thehive /etc/thehive/application.conf
            sudo chmod 640 /etc/thehive/application.conf
            ```

    3. Copy the systemd script in `/etc/systemd/system/thehive.service`.

        !!! Example ""
            ```bash
            cd /tmp
            wget https://raw.githubusercontent.com/TheHive-Project/TheHive/master/package/thehive.service
            sudo cp thehive.service /etc/systemd/system/thehive.service
            ```

&nbsp;

### Configuration

The setup provided with binary packages is tailored for a standalone installation, with all components hosted on the same server. At this point, it's crucial to fine-tune the following parameters as necessary:

!!! Example ""
    ```yaml title="/etc/thehive/application.conf"
    [..]
    # Service configuration
    application.baseUrl = "http://localhost:9000" # (1)
    play.http.context = "/"                       # (2)
    [..]
    ```

    1. :fontawesome-solid-laptop: Define the scheme, hostname, and port for accessing the application
    2. :fontawesome-brands-safari: Indicate if a custom path is being used (default is /)


The following configurations are necessary for successful initiation of TheHive:

- Secret key configuration
- Database configuration
- File storage configuration

&nbsp;

#### Secret key configuration

=== "DEB"
    The secret key is automatically generated and stored in `/etc/thehive/secret.conf` during package installation.

=== "RPM"
    The secret key is automatically generated and stored in `/etc/thehive/secret.conf` during package installation.

=== "Other"
    To set up a secret key, execute the following command:

    !!! Example ""
        ```bash
        cat > /etc/thehive/secret.conf << _EOF_
        play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"
        _EOF_
        ```

#### Database & index
By default, TheHive is configured to connect to local Cassandra and Elasticsearch databases.

!!! Example ""
    ```yaml title="/etc/thehive/application.conf"
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
    ```

#### File storage

The default file storage location of TheHive is `/opt/thp/thehive/files`.

=== "Local filesystem"

    If you decide to store files on the local filesystem:

    1. Ensure thehive user has permissions on the destination folder:

        !!! Example ""
            ```bash
            chown -R thehive:thehive /opt/thp/thehive/files
            ```

    2. Default values in the configuration file 

        !!! Example ""
            ```yaml title="/etc/thehive/application.conf"
            # Attachment storage configuration
            # By default, TheHive is configured to store files locally in the folder.
            # The path can be updated and should belong to the user/group running thehive service. (by default: thehive:thehive)
            storage {
            provider = localfs
            localfs.location = /opt/thp/thehive/files
            }
            ```

=== "S3"
    If you opt for MinIO and an S3 object storage system to store files in a filesystem, append the following lines to TheHive configuration file (/etc/thehive/application.conf):

    !!! Example ""
        ```yaml title="/etc/thehive/application.conf"
        ## Storage configuration
        storage {
            provider: s3
            s3 {
            bucket = "thehive"
            readTimeout = 1 minute
            writeTimeout = 1 minute
            chunkSize = 1 MB
            endpoint = "http://<IP_ADDRESS>:9100"
            accessKey = "<MINIO ACCESS KEY>"
            secretKey = "<MINIO SECRET KEY>"
            region = "us-east-1"
            }
        }
        alpakka.s3.path-style-access = force
        ```

#### Cortex & MISP

The initial configuration file packaged with the software contains the following lines, which enable the Cortex and MISP modules by default. If you're not utilizing either of these modules, you can simply comment out the corresponding line and restart the service.

!!! Example ""
    ```yaml title="/etc/thehive/application.conf"
    # Additional modules
    #
    # TheHive is strongly integrated with Cortex and MISP.
    # Both modules are enabled by default. If not used, each one can be disabled by
    # ommenting the configuration line.
    scalligraph.modules += org.thp.thehive.connector.cortex.CortexModule
    scalligraph.modules += org.thp.thehive.connector.misp.MispModule
    ```

&nbsp;

### Run

To start TheHive service and enable it to run on system boot, execute the following commands in your terminal:

!!! Example ""
    ```bash
    sudo systemctl start thehive
    sudo systemctl enable thehive
    ```

!!! Info "Please be aware that the service may take some time to start initially."

After the service has successfully started, launch your web browser and navigate to `http://YOUR_SERVER_ADDRESS:9000/`

The default admin user credentials are as follows:

!!! Note ""
    ```bash
    Username: admin@thehive.local
    Password: secret
    ```

For security reasons, it is strongly advised to change the default password after logging in.

---

## Advanced Configuration

For further customization options, please consult the **Configuration & Operations** section.

To configure HTTPS, follow the instructions on the [**dedicated page**](../configuration/ssl.md).

<!-- ## Usage & Licenses

By default, TheHive comes with no license token and let everyone use the application with 2 users and 1 organisation: this is the community version.

To unlock advanced features, contact StrangeBee to get a license - [https://wwww.strangebee.com](https://wwww.strangebee.com) / [contact@strangebee.com](mailto:contact@strangebee.com)

## First steps & license activation

Now the application is up & running, [make your first steps](./../../administration/first-start.md) as Administrator, and follow this guide to activate a license: [Activate a license](./../../administration/license.md). -->

&nbsp;