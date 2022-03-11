# Step-by-Step guide

This page is a step by step installation and configuration guide to get an TheHive 5 instance up and running. This guide is illustrated with examples for Debian and RPM packages based systems and for installation from binary packages.


## Java Virtual Machine

!!! Example
    
    === "Debian"

        ```bash
        apt-get install -y openjdk-11-jre-headless
        echo JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment
        export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
        ```
    
    === "RPM"

        ```bash
        sudo yum install -y java-11-openjdk-headless.x86_64
        echo JAVA_HOME="/usr/lib/jvm/jre-11-openjdk" | sudo tee -a /etc/environment
        export JAVA_HOME="/usr/lib/jvm/jre-11-openjdk"
        ```

    === "Other"
        The installation requires Java 11, so refer to your system documentation to install it.


## Cassandra database

Apache Cassandra is a scalable and high available database. TheHive supports the latest stable version  **4.0.x** of Cassandra.

!!! Warning
    If you are upgrading from Cassandra 3.x, please follow the dedicated guide. This part is relevant for fresh installation only.

### Install from repository

!!! Example ""

    === "Debian"
        
        1. Add Apache repository references

            ```bash
            curl https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor  -o /etc/apt/trusted.gpg.d/cassandra-archive.gpg
            echo "deb https://downloads.apache.org/cassandra/debian 40x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
            ```

        2. Install the package

            ```bash
            sudo apt update
            sudo apt install -y cassandra
            ```

    === "RPM"

        1. Add Cassandra repository keys

            ```bash
            rpm --import https://downloads.apache.org/cassandra/KEYS
            ```

        2. Add the Apache repository of Cassandra to `/etc/yum.repos.d/cassandra.repo`

            ```bash
            cat <<EOF | sudo tee  -a /etc/yum.repos.d/cassandra.repo
            [cassandra]
            name=Apache Cassandra
            baseurl=https://downloads.apache.org/cassandra/redhat/40x/
            gpgcheck=1
            repo_gpgcheck=1
            gpgkey=https://downloads.apache.org/cassandra/KEYS
            EOF
            ```

        2. Install the package

            ```bash
            sudo yum install -y cassandra
            ```

    === "Other"

        Download and untgz archive from http://cassandra.apache.org/download/ in the folder of your choice.
    

By default, data is stored in `/var/lib/cassandra`.


### Configuration

Configure Cassandra by editing `/etc/cassandra/cassandra.yaml` file.


```yml
# content from /etc/cassandra/cassandra.yaml

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
```

Then restart the service:

!!! Example ""
    === "Debian"

        ```bash
        sudo service cassandra start
        ```

    === "RPM"

        Run the service and ensure it restart after a reboot:

        ```bash
        sudo systemctl daemon-reload
        sudo service cassandra start
        sudo systemctl enable cassandra
        ```

By default Cassandra listens on `7000/tcp` (inter-node), `9042/tcp` (client).

#### Additional configuration

For additional configuration options, refer to:

- [Cassandra documentation page](https://cassandra.apache.org/doc/latest/getting_started/configuring.html)
- [Datastax documentation page](https://docs.datastax.com/en/ddac/doc/datastax_enterprise/config/configTOC.html)


#### Security

To add security measures in Cassandra , refer the the [related administration guide](../Operations/cassandra-security.md).

#### Add nodes

To add Cassandra nodes, refer the the [related administration guide](../Architecture/3_nodes_cluster.md).

## Indexing engine: Elasticsearch

TheHive requires Elasticsearch to manage data indices. 

** With TheHive 5.0, the version 8.x of Elasticsearch cannot be used with TheHive **, you need to use a version <= 7
### Installation

!!! Example ""
    === "Debian"
        
        1. Add Elasticsearch repository keys

            ```bash
                wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
                sudo apt-get install apt-transport-https
            ```

        2. Add the DEB repository of Elasticsearch 

            ```bash
            echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list


            ```

        3. Install the package

            ```bash
            sudo apt update && sudo apt install -y elasticsearch
            ```


    === "RPM"

        1. Add Elasticsearch repository references

            ```bash
                rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
            ```

        2. Add the RPM repository of Elasticsearch to `/etc/yum.repos.d/elasticsearch.repo`

            ```bash
            cat <<EOF | sudo tee  -a /etc/yum.repos.d/elasticsearch.repo
            [elasticsearch]
            name=Elasticsearch repository for 7.x packages
            baseurl=https://artifacts.elastic.co/packages/7.x/yum
            gpgcheck=1
            gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
            enabled=0
            autorefresh=1
            type=rpm-md
            EOF
            ```

        3. Install the package

            ```bash
            sudo yum install --enablerepo=elasticsearch elasticsearch
            ```
        
        !!! Note "References"
            - [https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html ](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html)

    === "Other"

        Download and untgz archive from http://cassandra.apache.org/download/ in the folder of your choice.


### Configuration 

#### `/etc/elasticsearch/elasticsearch.yml`

!!! Example ""

    === "Elasticsearch"

        Use an existing Elasticsearch instance or install a new one. This instance should be reachable by all nodes of a cluster.

        !!! Warning
            Elasticsearch configuration should use the default value for `script.allowed_types`, or contain the following configuration line: 

            ```bash
            cat << EOF | sudo tee /etc/elasticsearch/elasticsearch.yml
            http.host: 127.0.0.1
            transport.host: 127.0.0.1
            cluster.name: hive
            thread_pool.search.queue_size: 100000
            path.logs: "/var/log/elasticsearch"
            path.data: "/var/lib/elasticsearch"
            xpack.security.enabled: false
            script.allowed_types: "inline,stored"
            EOF
            ```



!!! Note
    - Indexes will be created at the first start of TheHive. It can take a certain amount of time, depending the size of the database
    - Like data and files, indexes should be part of the backup policy
    - Indexes can removed and created again

#### `/etc/elasticsearch/jvm.options.d/jvm.options`

```bash
cat << EOF | sudo tee -a /etc/elasticsearch/jvm.options.d/jvm.options
-Dlog4j2.formatMsgNoLookups=true
-Xms4g
-Xmx4g
EOF
```

## File storage

Files uploaded in TheHive (in *task logs* or in *observables*) can be stores in localsystem, in a Hadoop filesystem (recommended) or in the graph database.

For standalone production and test servers , we recommends using local filesystem. If you think about building a cluster with TheHive, you have several possible solutions: using Hadoop or S3 services ; see the [related guide](../Architecture/3_nodes_cluster.md) for more details and an example with MinIO servers.  

!!! Example ""
    === "Local Filesystem"

        !!! Warning
            This option is perfect **for standalone servers**. If you intend to build a cluster for your instance of TheHive 4 we recommend:
            
            - using a NFS share, common to all nodes
            - having a look at storage solutions implementing S3 or HDFS.

        To store files on the local filesystem, start by choosing the dedicated folder:

        ```bash
        sudo mkdir -p /opt/thp/thehive/files
        ```

        This path will be used in the configuration of TheHive.

        Later, after having installed TheHive, ensure the user `thehive` owns the path chosen for storing files:

        ```
        chown -R thehive:thehive /opt/thp/thehive/files
        ```

    === "S3 with Min.io"

        An example of installing, configuring and use Min.IO is detailed in [this documentation](../Architecture/3_nodes_cluster.md).



## TheHive

This part contains instructions to install TheHive and then configure it.

!!! Warning
    TheHive4 can't be installed on the same server than older versions. We recommend installing it on a new server, especially if a migration is foreseen.

### Installation

All packages are published on our packages repository. We support Debian and RPM packages as well as binary packages (zip archive). All packages are signed using our GPG key [562CBC1C](https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY). Its fingerprint is `0CD5 AC59 DE5C 5A8E 0EE1  3849 3D99 BB18 562C BC1C`.

!!! Example ""

    === "Debian"
 
        ```bash
        wget -O- https://download.thehive-project.org/strangebee.gpg | sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
        
        ```
 
    === "RPM"

        ```bash
        sudo rpm --import https://download.thehive-project.org/strangebee.gpg 
        ```

We also release stable and beta version of the applications.

#### Stable versions

Install TheHive 4.x package of the stable version by using the following commands:

!!! Example ""

    === "Debian"

        ```bash
        echo 'deb [signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.staging.strangebee.com thehive-5.x main' | sudo tee -a /etc/apt/sources.list.d/strangebee.list
        sudo apt-get update
        sudo apt-get install -y thehive
        ```

    === "RPM"
        1. Setup your system to connect the RPM repository. Create and edit the file `/etc/yum.repos.d/thehive-project.repo`:

            ```bash
            cat <<EOF | sudo tee -a /etc/yum.repos.d/strangebee.repo
            [thehive]
            enabled=1
            priority=1
            name=StrangeBee RPM repository
            baseurl=https://rpm.staging.strangebee.com/thehive-5.x/noarch
            gpgkey=https://download.thehive-project.org/strangebee.gpg
            gpgcheck=1
            EOF
            ```

        2. Then install the package using `yum`:

            ```bash
            yum install -y thehive
            ```
    
    === "Other"

        1. Download and unzip the chosen binary package. TheHive files can be installed wherever you want on the filesystem. In this guide, we assume you have chosen to install them under `/opt`.

        ```bash
        cd /opt
        wget https://download.thehive-project.org/thehive4-latest.zip
        unzip thehive4-latest.zip
        ln -s thehive4-x.x.x thehive
        ```

        1. Prepare the system

            It is recommended to use a dedicated, non-privileged user account to start TheHive. If so, make sure that the chosen account can create log files in `/opt/thehive/logs`.

            If you'd rather start the application as a service, use the following commands:

            ```bash
            addgroup thehive
            adduser --system thehive
            chown -R thehive:thehive /opt/thehive
            mkdir /etc/thehive
            touch /etc/thehive/application.conf
            chown root:thehive /etc/thehive
            chgrp thehive /etc/thehive/application.conf
            chmod 640 /etc/thehive/application.conf
            ```

            Copy the systemd script in `/etc/systemd/system/thehive.service`.

            ```bash
            cd /tmp
            wget https://github.com/TheHive-Project/TheHive/blob/master/package/thehive.service
            cp thehive.service /etc/systemd/system/thehive.service
            ```


#### Beta versions

To install beta versions of TheHive4, use the following setup:

!!! Example ""

    === "Debian"

        ```bash
        echo 'deb https://deb.thehive-project.org beta main' | sudo tee -a /etc/apt/sources.list.d/thehive-project.list
        sudo apt-get update
        sudo apt-get install thehive4
        ```

    === "RPM"

        1. setup your system to connect the RPM repository. Create and edit the file `/etc/yum.repos.d/thehive-project.repo`:

            ```bash
            [thehive-project]
            enabled=1
            priority=1
            name=TheHive-Project RPM repository
            baseurl=https://rpm.thehive-project.org/beta/noarch
            gpgcheck=1
            ```

        2. Then install the package using `yum`:

            ```bash
            yum install thehive4
            ```

    === "Other"

        1. Download and unzip the chosen binary package. TheHive files can be installed wherever you want on the filesystem. In this guide, we assume you have chosen to install them under `/opt`.

            ```bash
            cd /opt
            wget https://download.thehive-project.org/thehive4-beta-latest.zip
            unzip thehive4-beta-latest.zip
            ln -s thehive4-x.x.x thehive
            ```
        
        2. Prepare the system

            It is recommended to use a dedicated, non-privileged user account to start TheHive. If so, make sure that the chosen account can create log files in `/opt/thehive/logs`.

            If you'd rather start the application as a service, use the following commands:

            ```bash
            addgroup thehive
            adduser --system thehive
            chown -R thehive:thehive /opt/thehive
            mkdir /etc/thehive
            touch /etc/thehive/application.conf
            chown root:thehive /etc/thehive
            chgrp thehive /etc/thehive/application.conf
            chmod 640 /etc/thehive/application.conf
            ```

            Copy the systemd script in `/etc/systemd/system/thehive.service`.

            ```bash
            cd /tmp
            wget https://github.com/TheHive-Project/TheHive/blob/master/package/thehive.service
            cp thehive.service /etc/systemd/system/thehive.service
            ```

!!! Warning

    We recommend using or playing with Beta version **for testing purpose only**.


### Configuration

Following configurations are required to start TheHive successfully:

- Secret key configuration
- Database configuration
- File storage configuration

#### Secret key configuration

!!! Example ""

    === "Debian"
        The secret key is automatically generated and stored in `/etc/thehive/secret.conf` by package installation script.

    === "RPM"
        The secret key is automatically generated and stored in `/etc/thehive/secret.conf` by package installation script.

    === "Other"
        Setup a secret key in the `/etc/thehive/secret.conf` file by running the following command:

        ```bash
        cat > /etc/thehive/secret.conf << _EOF_
        play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"
        _EOF_
        ```

#### Database

To use Cassandra database, TheHive configuration file (`/etc/thehive/application.conf`) has to be edited and updated with following lines:

```yaml
db {
  provider: janusgraph
  janusgraph {
    storage {
      backend: cql
      hostname: ["127.0.0.1"] # seed node ip addresses
      #username: "<cassandra_username>"       # login to connect to database (if configured in Cassandra)
      #password: "<cassandra_passowrd"
      cql {
        cluster-name: thp       # cluster name
        keyspace: thehive           # name of the keyspace
        local-datacenter: datacenter1   # name of the datacenter where TheHive runs (relevant only on multi datacenter setup)
        # replication-factor: 2 # number of replica
        read-consistency-level: ONE
        write-consistency-level: ONE
      }
    }
  }
}
```

#### Indexes

Update `db.storage` configuration part in `/etc/thehive/application.conf` accordingly to your setup. 

!!! Example "" 
    === "Lucene"

        If your setup is a standalone server or you are using a common NFS share, configure TheHive like this:  

        ```yaml
        db {
          provider: janusgraph
          janusgraph {
            storage {
              [..]
            }
            ## Index configuration
            index.search {
              backend : lucene
              directory:  /opt/thp/thehive/index
            }
          }
        }
        ```

    === "Elasticsearch" 

        If you decided to have access to a centralised index with Elasticsearch, configure TheHive like this:  

        ```yaml
        db {
          provider: janusgraph
          janusgraph {
            storage {
              [..]
            }
            ## Index configuration
            index.search {
              backend : elasticsearch
              hostname : ["10.1.2.20"]
              index-name : thehive
            }
          }
        }
        ```


#### Filesystem


!!! Example ""

    === "Local filesystem"

        If you chose to store files on the local filesystem:

        1. Ensure permission of the folder

            ```bash
            chown -R thehive:thehive /opt/thp/thehive/files
            ```

        2. add following lines to TheHive configuration file (`/etc/thehive/application.conf`)

            ```yml
            ## Storage configuration
            storage {
            provider = localfs
            localfs.location = /opt/thp/thehive/files
            }
            ```

    === "S3"
        If you chose MinIO and a S3 object storage system to store files in a  filesystem, add following lines to TheHive configuration file (`/etc/thehive/application.conf`)

        ```yaml
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
          }
        }
        ```

    === "HDFS"
        If you chose Apache Hadoop and a HDFS filesystem to store files in a distrubuted filesystem, add following lines to TheHive configuration file (`/etc/thehive/application.conf`)

        ```yaml
        ## Storage configuration
        storage {
          provider: hdfs
          hdfs {
            root: "hdfs://thehive1:10000" # namenode server
            location: "/thehive"
            username: thehive
          }
        }
        ```

### Run

Save configuration file and run the service:


```bash
service thehive start
```

Please note that the service may take some time to start. Once it is started, you may launch your browser and connect to `http://YOUR_SERVER_ADDRESS:9000/`.

The default admin user is `admin@thehive.local` with password `secret`. It is recommended to change the default password.


## Advanced configuration
For additional configuration options, please refer to the [Configuration Guides](../index.md#configuration-guides).


