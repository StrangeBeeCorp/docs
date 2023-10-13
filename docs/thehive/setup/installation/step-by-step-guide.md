# Step-by-Step guide

This page is a step by step installation and configuration guide to get an instance of TheHive up and running. This guide is illustrated with examples for DEB and RPM packages based systems and for installation from binary packages.

!!! Info "This guide describes the installation of a new instance of TheHive **only**"

## Dependencies

This process requires few programs beeing already installed on the system.

=== "DEB"

    !!! Example ""

        ```bash
        apt install wget gnupg apt-transport-https git ca-certificates ca-certificates-java curl  software-properties-common python3-pip lsb_release
        ``` 

=== "RPM"

    !!! Example ""

        ```bash
        yum install pkg-install gnupg chkconfig python3-pip git 
        ```


## :fontawesome-brands-java: Java Virtual Machine
 
!!! Danger "Read first"
    * For security and long-term support reasons, we require  **using [Amazon Corretto](https://aws.amazon.com/corretto/) builds** (this is OpenJDK built and packaged by Amazon)
    * Java version 8 is no longer supported

=== "DEB"

    !!! Example ""
        ```bash
        wget -qO- https://apt.corretto.aws/corretto.key | sudo gpg --dearmor  -o /usr/share/keyrings/corretto.gpg
        echo "deb [signed-by=/usr/share/keyrings/corretto.gpg] https://apt.corretto.aws stable main" |  sudo tee -a /etc/apt/sources.list.d/corretto.sources.list
        sudo apt update
        sudo apt install java-common java-11-amazon-corretto-jdk
        echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment 
        export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
        ```

=== "RPM"

    !!! Example ""
        ```bash
        sudo rpm --import https://yum.corretto.aws/corretto.key  &> /dev/null
        wget -qO-  https://yum.corretto.aws/corretto.repo | sudo tee -a /etc/yum.repos.d/corretto.repo
        yum install java-1.11.0-amazon-corretto-devel &> /dev/null
        echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" |sudo tee -a /etc/environment
        export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
        ```

=== "Other"
    The installation requires Java 11, so refer to your system documentation to install it.



## :fontawesome-solid-database:  Apache Cassandra

Apache Cassandra is a scalable and high available database. TheHive supports the latest stable version **4.0.x** of Cassandra.

!!! Info "Upgrading from Cassandra 3.x"
    If you are upgrading from Cassandra 3.x, please follow the [dedicated guide](./upgrade-from-4.x.md). This part is relevant for fresh installation only.

### Installation

=== "DEB"
    
    1. Add Apache repository references
        
        !!! Example ""
            ```bash
            wget -qO -  https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor  -o /usr/share/keyrings/cassandra-archive.gpg
            echo "deb [signed-by=/usr/share/keyrings/cassandra-archive.gpg] https://debian.cassandra.apache.org 40x main" |  sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list 
            ```

    2. Install the package

        !!! Example ""
            ```bash
            sudo apt update
            sudo apt install cassandra
            ```

=== "RPM"

    1. Add Cassandra repository keys

        !!! Example ""
            ```bash
            rpm --import https://downloads.apache.org/cassandra/KEYS
            ```

    2. Add the Apache repository for Cassandra to `/etc/yum.repos.d/cassandra.repo`

        !!! Example ""
            ```bash title="/etc/yum.repos.d/cassandra.repo"
            [cassandra]
            name=Apache Cassandra
            baseurl=https://redhat.cassandra.apache.org/40x/
            gpgcheck=1
            repo_gpgcheck=1
            gpgkey=https://downloads.apache.org/cassandra/KEYS
            ```

    3. Install the package

        !!! Example ""
            ```bash
            sudo yum install cassandra
            ```

=== "Other"

    Download and untgz archive from http://cassandra.apache.org/download/ in the folder of your choice.


By default, data is stored in `/var/lib/cassandra`.


### Configuration

Configure Cassandra by editing `/etc/cassandra/cassandra.yaml` file.

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

### Start the service 

=== "DEB"
    !!! Example ""
        ```bash
        sudo systemctl start cassandra
        ```

    !!! Tip "Remove existing data before starting"
        With the DEB packages, Cassandra service could start automatically before configuring it: 
        Stop it, remove the data and restart once the configuration is updated: 

        ```bash
        sudo systemctl stop cassandra
        sudo rm -rf /var/lib/cassandra/*
        ```

=== "RPM"

    Run the service and ensure it restart after a reboot:
    !!! Example ""
        ```bash
        sudo systemctl daemon-reload
        sudo service cassandra start
        sudo systemctl enable cassandra
        ```

By default Cassandra listens on `7000/tcp` (inter-node), `9042/tcp` (client).


#### Additional configuration : disable tombstones  (for standalone server **ONLY**)

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
- [Datastax documentation page](https://docs.datastax.com/en/ddac/doc/datastax_enterprise/config/configTOC.html)


## :fontawesome-solid-list: Elasticsearch

TheHive requires Elasticsearch to manage data indices.

!!! Info "Elasticsearch 7.x only is supported"

### Installation

=== "DEB"
    
    1. Add Elasticsearch repository keys

        !!! Example ""
            ```bash
            wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
            sudo apt-get install apt-transport-https
            ```

    2. Add the DEB repository of Elasticsearch 

        !!! Example ""
            ```bash
            echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" |  sudo tee /etc/apt/sources.list.d/elastic-7.x.list 
            ```

    3. Install the package

        !!! Example ""
            ```bash
            sudo apt update
            sudo apt install elasticsearch
            ```


=== "RPM"

    1. Add Elasticsearch repository references

        !!! Example ""
            ```bash
            rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
            ```

    2. Add the RPM repository of Elasticsearch to `/etc/yum.repos.d/elasticsearch.repo`

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

        !!! Example ""
            ```bash
            sudo yum install --enablerepo=elasticsearch elasticsearch
            ```
    
    _References_: [https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html ](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html)

=== "Other"

    Download and untgz archive from http://cassandra.apache.org/download/ in the folder of your choice.


### Configuration 

- `/etc/elasticsearch/elasticsearch.yml`

Elasticsearch configuration should contain the following lines: 

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
    - Indexes will be created at the first start of TheHive. It can take few time
    - Like data and files, indexes should be part of the backup policy
    - Indexes can removed and created again


- Custom JVM options
add the file `/etc/elasticsearch/jvm.options.d/jvm.options` with following lines:

!!! Example ""
    ```
    -Dlog4j2.formatMsgNoLookups=true
    -Xms4g
    -Xmx4g
    ```

!!! Note "This can be updated according the amount of memory available"

### Sart the service

=== "DEB"

    ```bash
    sudo systemctl start elasticsearch
    sudo systemctl enable elasticsearch
    ```

    !!! Tip "Remove existing data before starting"
        With the DEB packages, Elastic service could start automatically before configuring it: 
        Stop it, remove the data and restart once the configuration is updated: 
        ```bash
        sudo systemctl stop elasticsearch
        sudo rm -rf /var/lib/elasticsearch/*
        ```

=== "RPM"

    Run the service and ensure it restart after a reboot:

    !!! Example ""
        ```bash
        sudo systemctl daemon-reload
        sudo service elasticsearch start
        sudo systemctl enable elasticsearch
        ```


## :fontawesome-solid-folder-tree: File storage
For standalone production and test servers, we recommends using local filesystem. If you think about building a cluster with TheHive, you have several possible solutions: using NFS or S3 services; see the [related guide](./3-node-cluster.md) for more details and an example with MinIO servers.  

=== "Local Filesystem"
    To store files on the local filesystem, start by choosing the dedicated folder (by default `/opt/thp/thehive/files`):

    !!! Example ""
        ```bash
        sudo mkdir -p /opt/thp/thehive/files
        ```

    This path will be used in the configuration of TheHive.

    Later, after having installed TheHive, ensure the user `thehive` owns the path chosen for storing files:

    !!! Example ""
        ```bash
        chown -R thehive:thehive /opt/thp/thehive/files
        ```

=== "S3 with Min.io"

    An example of installing, configuring and use Min.IO is detailed in [this documentation](./3-node-cluster.md).



## :material-beehive-outline: TheHive

This part contains instructions to install TheHive and then configure it.


### Installation

All packages are published on our packages repository. We support Debian and RPM packages as well as binary packages (zip archive). All packages are signed using our GPG key [562CBC1C](https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY). Its fingerprint is `0CD5 AC59 DE5C 5A8E 0EE1  3849 3D99 BB18 562C BC1C`.

=== "DEB"
    !!! Example ""
        ```bash
        wget -O- https://archives.strangebee.com/keys/strangebee.gpg | sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
        ```

=== "RPM"
    !!! Example ""
        ```bash
        sudo rpm --import https://archives.strangebee.com/keys/strangebee.gpg 
        ```


Install TheHive package by using the following commands:


=== "DEB"
    !!! Example ""
        ```bash
        echo 'deb [signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.2 main' | sudo tee -a /etc/apt/sources.list.d/strangebee.list
        sudo apt-get update
        sudo apt-get install -y thehive
        ```

=== "RPM"
    1. Setup your system to connect the RPM repository. Create and edit the file `/etc/yum.repos.d/strangebee.repo`:

        !!! Example ""
            ```bash title="/etc/yum.repos.d/strangebee.repo"
            [thehive]
            enabled=1
            priority=1
            name=StrangeBee RPM repository
            baseurl=https://rpm.strangebee.com/thehive-5.2/noarch
            gpgkey=https://archives.strangebee.com/keys/strangebee.gpg
            gpgcheck=1
            ```

    2. Then install the package using `yum`:

        !!! Example ""
            ```bash
            sudo yum install thehive
            ```

=== "Other"
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



### Configuration

The configuration that comes with binary packages is ready for a standalone installation, everything on the same server. 

In this context, and at this stage, you might need to set the following parameters accordingly:

!!! Example ""
    ```yaml title="/etc/thehive/application.conf"
    [..]
    # Service configuration
    application.baseUrl = "http://localhost:9000" # (1)
    play.http.context = "/"                       # (2)
    [..]
    ```

    1. :fontawesome-solid-laptop: specify the scheme, hostname and port used to join the application
    2. :fontawesome-brands-safari: specify if you use a custom path (`/` by default)


Following configurations are required to start TheHive successfully:

- Secret key configuration
- Database configuration
- File storage configuration

#### Secret key configuration

=== "Debian"
    The secret key is automatically generated and stored in `/etc/thehive/secret.conf` by package installation script.

=== "RPM"
    The secret key is automatically generated and stored in `/etc/thehive/secret.conf` by package installation script.

=== "Other"
    Setup a secret key in the `/etc/thehive/secret.conf` file by running the following command:

    !!! Example ""
        ```bash
        cat > /etc/thehive/secret.conf << _EOF_
        play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"
        _EOF_
        ```

#### Database & index
By default, TheHive is configured to connect to Cassandra and Elasticsearch databases installed locally.

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
        local-databacenter = datacenter1
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

By default, TheHive is configured to store files locally in `/opt/thp/thehive/files`.

=== "Local filesystem"

    If you chose to store files on the local filesystem:

    1. Ensure thehive user has permissions on the destination folder

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
    If you chose MinIO and a S3 object storage system to store files in a filesystem, add following lines to TheHive configuration file (`/etc/thehive/application.conf`)

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

By default the configuration file coming with packages contains following lines, enabling Cortex and MISP modules. If you are not using one them, you can comment the related line and restart the service.

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

### Run

!!! Example ""
    ```bash
    sudo systemctl start thehive
    sudo systemctl enable thehive
    ```

!!! Info "Please consider the service may take a while at the first start"

Once it has started, open your browser and connect to `http://YOUR_SERVER_ADDRESS:9000/`.

The default admin user is `admin@thehive.local` with password `secret`. It is recommended to change the default password.

## Advanced configuration
For additional configuration options, please refer to the [Configuration Guides](../index.md#configuration-guides).

To setup HTTPS, refer to the [dedicated page](../configuration/ssl.md).

## Usage & Licenses

By default, TheHive comes with no license token and let everyone use the application with 2 users and 1 organisation: this is the community version.

To unlock advanced features, contact StrangeBee to get a license - [https://wwww.strangebee.com](https://wwww.strangebee.com) / [contact@strangebee.com](mailto:contact@strangebee.com)

## First steps & license activation

Now the application is up & running, [make your first steps](./../../administration/first-start.md) as Administrator, and follow this guide to activate a license: [Activate a license](./../../administration/license.md).
