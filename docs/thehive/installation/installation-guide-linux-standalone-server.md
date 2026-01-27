# Install TheHive on Linux Systems

Welcome to the step-by-step guide for installing and configuring TheHive On-prem on Linux systems!

This guide is designed for users who are comfortable with Linux system administration, but you don’t need to be an infrastructure expert to follow along.

By the end, you'll have a fully functional instance of TheHive up and running.

If you prefer a faster setup on Linux, you can run an [automated installation script](automated-installation-script-linux.md) to install TheHive along with its required services and dependencies using predefined settings.

!!! note "Guide scope"
    This guide covers setting up a new instance of TheHive on Linux systems, with all components hosted on the same server.

    It doesn't cover:

    * Docker deployments: For Docker-based setups, follow [Deploy TheHive with Docker Compose](docker.md).
    * Cluster deployments: Refer to [Set Up a Cluster on Linux Systems](deploying-a-cluster.md) for Linux, or [Deploy TheHive on Kubernetes](kubernetes.md) for Kubernetes deployments.
    * Version upgrades: For upgrading an existing instance, see [Upgrade from TheHive 5.x](upgrade-from-5.x.md) or [Upgrade from TheHive 4.x](upgrade-from-4.x.md).

!!! warning "Before you begin"
    To ensure a smooth installation process, make sure you have:

    * A basic understanding of [TheHive architecture](../overview/index.md#architecture)
    * [System requirements fully met and verified](system-requirements.md) for Linux installation

{% include-markdown "includes/data-protection-link.md" %}

## Step 1: Install required dependencies

Start by installing the necessary dependencies for TheHive.

=== "DEB (Debian/Ubuntu)"

    Run the following commands:

    ```bash
    sudo apt update
    sudo apt install wget curl gnupg coreutils apt-transport-https git ca-certificates ca-certificates-java software-properties-common python3-pip lsb-release unzip
    ```

=== "RPM (RHEL/Fedora)"

    Run the following commands:

    ```bash
    sudo yum update
    sudo yum install wget curl gnupg2 coreutils chkconfig python3-pip git unzip
    ```

---

## Step 2: Set up the Java virtual machine (JVM)

TheHive requires Java to run its application server and to manage various processes.

!!! note "Java support"

    * For security and long-term support, we recommend using [Amazon Corretto](https://aws.amazon.com/corretto/){target=_blank}, which provides OpenJDK builds maintained by Amazon.
    * Only Java 11 is supported. Java 8 is no longer supported.

=== "DEB"

    1. Run the following commands:

        ```bash
        wget -qO- https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto.gpg
        echo "deb [signed-by=/usr/share/keyrings/corretto.gpg] https://apt.corretto.aws stable main" | sudo tee -a /etc/apt/sources.list.d/corretto.sources.list
        sudo apt update
        sudo apt install java-common java-11-amazon-corretto-jdk
        echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment
        export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
        ```

    2. Verify the installation.

        ```bash
        java -version
        ```
        
        You should see output similar to the following:

        ```bash
        openjdk version "11.0.28" 2025-07-15
        OpenJDK Runtime Environment Corretto-11.0.28.6.1 (build 11.0.28+6-LTS)
        OpenJDK 64-Bit Server VM Corretto-11.0.28.6.1 (build 11.0.28+6-LTS, mixed mode)
        ```
        
        If a different Java version appears, set Java 11 as the default using [`sudo update-alternatives --config java`](https://www.man7.org/linux/man-pages/man1/update-alternatives.1.html#COMMANDS){target=_blank}.

=== "RPM"

    1. Run the following commands:

        ```bash
        sudo rpm --import https://yum.corretto.aws/corretto.key &> /dev/null
        wget -qO- https://yum.corretto.aws/corretto.repo | sudo tee -a /etc/yum.repos.d/corretto.repo
        sudo yum install -y java-11-amazon-corretto-devel > /dev/null
        echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment
        export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
        ```

        !!! note "Adjusting for your distribution"
            The exact commands may vary depending on your Linux distribution. Refer to your distribution documentation for the recommended way to install Java and adjust the steps accordingly.

    2. Verify the installation.

        ```bash
        java -version
        ```

        You should see output similar to the following:

        ```bash
        openjdk version "11.0.28" 2025-07-15
        OpenJDK Runtime Environment Corretto-11.0.28.6.1 (build 11.0.28+6-LTS)
        OpenJDK 64-Bit Server VM Corretto-11.0.28.6.1 (build 11.0.28+6-LTS, mixed mode)
        ```

        If a different Java version appears, set Java 11 as the default using [`sudo alternatives --config java`](https://linux.die.net/man/8/alternatives){target=_blank}.

=== "Other installation methods"
    If you're using a system other than DEB or RPM, refer to your system documentation for instructions on installing Java 11.

---

## :fontawesome-solid-database: Step 3: Install and configure Apache Cassandra {#step-3-install-configure-cassandra}

[Apache Cassandra](https://cassandra.apache.org){target=_blank} is a database system that's used in TheHive as the back-end database for storing and managing incident response data.

!!! info "Single node configuration"
    In this guide, we will configure Cassandra as a single node on your server, which is fine for running TheHive. If you ever need multiple nodes later for higher performance, redundancy, or failover, refer to [Set Up a Cluster on Linux Systems](deploying-a-cluster.md#step-1-install-and-configure-apache-cassandra) for detailed instructions.

!!! note "Cassandra supported versions"
    TheHive is fully compatible with Cassandra version 4.1.x.

### Step 3.1: Install Cassandra

=== "DEB"

    1. Add Cassandra repository references.

        a. Download Cassandra repository keys.
        
        ```bash
        wget -qO -  https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor  -o /usr/share/keyrings/cassandra-archive.gpg
        ```
        
        b. Check if the `/etc/apt/sources.list.d/cassandra.sources.list` file exists. If it doesn't, create it.

        c. Add the repository to your system by appending the following line to the `/etc/apt/sources.list.d/cassandra.sources.list` file.
        
        ```bash
        echo "deb [signed-by=/usr/share/keyrings/cassandra-archive.gpg] https://debian.cassandra.apache.org 41x main" |  sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
        ```

    2. Update your package index and install Cassandra using the following commands:

        ```bash
        sudo apt update
        sudo apt install cassandra
        ```

    3. Verify that Cassandra is installed.

        ```bash
        sudo systemctl status cassandra
        ```

        This will show you the status of the Cassandra service. If Cassandra is installed you should see details about the service. If it's not installed, you will receive an error indicating that the service isn't found.

    4. By default, data is stored in `/var/lib/cassandra`. Set appropriate permissions for this directory to avoid any issues with data storage and access.

        ```bash
        sudo chown -R cassandra:cassandra /var/lib/cassandra
        ```

    Refer to the official Cassandra documentation website for [the most up-to-date instructions](https://cassandra.apache.org/doc/latest/cassandra/installing/installing.html#install-as-debian-package){target=_blank}.

=== "RPM"

    1. Add Cassandra repository references.

        a. Download Cassandra repository keys.
        
        ```bash
        sudo rpm --import https://downloads.apache.org/cassandra/KEYS
        ```

        !!! note
            When importing the `KEYS` file, you may see warnings such as:

            ```
            error: https://downloads.apache.org/cassandra/KEYS: key 1 not an armored public key.
            ```

            These messages are expected because the file contains multiple keys in different formats. The valid keys are still imported successfully, and you can safely continue with the installation.

        b. Check if the `/etc/yum.repos.d/cassandra.repo` file exists. If it doesn't, create it.

        c. Add the repository to your system by appending the following lines to the `/etc/yum.repos.d/cassandra.repo` file.

        ```bash
        echo "[cassandra]
        name=Apache Cassandra
        baseurl=https://redhat.cassandra.apache.org/41x/
        gpgcheck=1
        repo_gpgcheck=1
        gpgkey=https://downloads.apache.org/cassandra/KEYS" | sudo tee /etc/yum.repos.d/cassandra.repo
        ```

    2. Update your package index and install Cassandra using the following commands:
        
        ```bash
        sudo yum update
        sudo yum install cassandra
        ```

    3. By default, data is stored in `/var/lib/cassandra`. Set appropriate permissions for this directory to avoid any issues with data storage and access.

        ```bash
        sudo chown -R cassandra:cassandra /var/lib/cassandra
        ```

    Refer to the official Cassandra documentation website for [the most up-to-date instructions](https://cassandra.apache.org/doc/latest/cassandra/installing/installing.html#install-as-rpm-package){target=_blank}.

=== "Other installation methods"

    Download the `tar.gz` archive from [Apache Cassandra downloads](http://cassandra.apache.org/download/){target=_blank} and extract it into the folder of your choice. You can use utilities like [Wget](https://www.gnu.org/software/wget/){target=_blank} to download the archive.

### Step 3.2: Configure Cassandra

Configure Cassandra by modifying settings within the `cassandra.yaml` file.

1. Locate the `cassandra.yaml` file.

2. Open the `cassandra.yaml` file using a text editor.

3. In the `cassandra.yaml` file, set the `cluster_name` parameter to the desired name. This name will help identify your Cassandra cluster.

    Replace `Test Cluster` with your new cluster name.

4. Optional: In the `cassandra.yaml` file, change the default directory path values for the `data_file_directories`, `commitlog_directory`, `saved_caches_directory`, and `hints_directory` parameters. These tell Cassandra where to store its data, commit logs, cached files, and hint files.

    | Parameter    | Default directory path value |
    | -------- | ------- |
    | `data_file_directories`  | /var/lib/cassandra/data   |
    | `commitlog_directory` | /var/lib/cassandra/commitlog     |
    | `saved_caches_directory`    | /var/lib/cassandra/saved_caches    |
    | `hints_directory`    | var/lib/cassandra/hints    |

5. Set the appropriate permissions on each directory path to ensure Cassandra can read and write data properly.

    ```bash
    sudo chown -R cassandra:cassandra <directory_path>
    ```

    Replace `<directory_path>` with the actual directory path. Do this for each directory listed in the previous step.

6. Recommended: In the `cassandra.yaml` file, enable authentication.

    Set the following parameters with these exact values:

    ```yaml
    authenticator: PasswordAuthenticator
    authorizer: CassandraAuthorizer 
    ```

    {% include-markdown "includes/no-authentication-cassandra.md" %}

7. Save your modifications in the `cassandra.yaml` file.

!!! Example "Example of a `cassandra.yaml` file configuration"
    ```
    # content from cassandra.yaml
    [..]
    cluster_name: 'thp'
    data_file_directories:
    - '/var/lib/cassandra/data'
    commitlog_directory: '/var/lib/cassandra/commitlog'
    saved_caches_directory: '/var/lib/cassandra/saved_caches'
    hints_directory: '/var/lib/cassandra/hints'
    authenticator: PasswordAuthenticator
    authorizer: CassandraAuthorizer
    [..]
    ```

### Step 3.3: Start the Cassandra service

=== "DEB"

    1. Check whether the Cassandra service started automatically before configuring it.

        ```bash
        sudo systemctl status cassandra
        ```

        If it's running, stop it and remove existing data.

        ```bash
        sudo systemctl stop cassandra
        sudo rm -rf /var/lib/cassandra/*
        ```
    
    2. Start the Cassandra service.
        
        ```bash
        sudo systemctl start cassandra
        ```

    3. Enable the Cassandra service to restart automatically after a system reboot.

        ```bash
        sudo systemctl enable cassandra
        ```

    4. Verify that Cassandra is running.

        ```bash
        sudo systemctl status cassandra
        ```

        If Cassandra is running, you should see an active status in green.

=== "RPM"

    1. Start the Cassandra service by running the following commands:
        
        ```bash
        sudo systemctl daemon-reload
        sudo service cassandra start
        ```

        !!! note "Possible warnings"
            When starting Cassandra, you may see warnings. The script will usually end with `Starting Cassandra: OK`. This only means the process was launched. 

    2. Enable the Cassandra service to restart automatically after a system reboot.

        ```bash
        sudo systemctl enable cassandra
        ```

    3. Verify that Cassandra is running.

        ```bash
        sudo tail -n 50 /var/log/cassandra/system.log
        ```

        If Cassandra is running, you should see a line similar to:

        ```bash
        INFO  [main] ... Startup complete
        ```

!!! info "Default port for Cassandra communication"
    Cassandra defaults to listening on port `9042/tcp` for client communication.

!!! bug "Troubleshooting Cassandra"

    * Service won’t start → Check logs in `/var/log/cassandra/`. Look for binding or configuration errors in `cassandra.yaml`.
    * Port 9042 not reachable → Verify firewall rules and confirm Cassandra is listening with `ss -tlnp | grep 9042`.

### Step 3.4: Set a secure password for authentication (if you enabled authentication in [Step 3.2](#step-32-configure-cassandra))

{% include-markdown "includes/set-password-authentication-cassandra.md" %}

### Step 3.5: Create a new administrator role (if you enabled authentication in [Step 3.2](#step-32-configure-cassandra))

{% include-markdown "includes/create-administrator-role-cassandra.md" %}

### Step 3.6: Create the keyspace and a role for TheHive (if you enabled authentication in [Step 3.2](#step-32-configure-cassandra))

1. Create the `thehive` keyspace with basic replication.

    A keyspace is the Cassandra equivalent of a database. The replication factor defines how many copies of the data are stored across the cluster.

    ```bash
    CREATE KEYSPACE thehive
    WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
    };
    ```

2. Verify that the keyspace exists.

    ```bash
    DESCRIBE KEYSPACES;
    ```

3. Create a dedicated role for TheHive.

    ```bash
    CREATE ROLE thehive WITH LOGIN = true AND PASSWORD = '<thehive_role_password>';
    ```

    Replace `<thehive_role_password>` with the password you intend to use for the `thehive` role.

    !!! tip "Note this password"
        Keep this password secure. You will need to enter it later in TheHive configuration file so the application can connect to the Cassandra database.

4. Grant access to the keyspace.

    ```bash
    GRANT ALL PERMISSIONS ON KEYSPACE thehive TO 'thehive';
    ```

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

## :fontawesome-solid-list: Step 4: Install and configure Elasticsearch {#step-4-install-configure-elasticsearch}

[Elasticsearch](https://www.elastic.co/elasticsearch){target=_blank} is a data indexing and search engine that's used in TheHive to manage data indices. Starting with version 5.5, it can also replace Apache Cassandra (JanusGraph) for storing [audit logs](../user-guides/organization/about-audit-logs.md).

!!! info "Single node configuration"
    In this guide, we will configure Elasticsearch as a single node on your server, which is fine for running TheHive. If you ever need multiple nodes later for higher performance, redundancy, or failover, refer to [Set Up a Cluster on Linux Systems](deploying-a-cluster.md#step-2-install-and-configure-elasticsearch) for detailed instructions.

!!! note "Elasticsearch supported versions"

    **TheHive**

    {% include-markdown "includes/elasticsearch-supported-versions-thehive.md" %}
    
    If using Elasticsearch for [audit log storage](#step-53-audit-log-storage), you must use Elasticsearch 7.17 or later.

    **Cortex**

    {% include-markdown "includes/elasticsearch-supported-versions-cortex.md" %}
    
    Sharing a single Elasticsearch instance between TheHive and Cortex isn't recommended. If you must do it, ensure the Elasticsearch version is compatible with both applications.

!!! note "OpenSearch support"
    Starting with version 5.3, TheHive supports [OpenSearch](https://opensearch.org/){target=_blank} for advanced use cases, except for audit log storage.

### Step 4.1: Install Elasticsearch

=== "DEB"
    
    1. Add Elasticsearch repository references.

        a. Download Elasticsearch repository keys.

        ```bash
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
        sudo apt-get install apt-transport-https
        ```

        b. Check if the `/etc/apt/sources.list.d/elastic-8.x.list` file exists. If it doesn't, create it.

        c. Add the repository to your system by appending the following line to the `/etc/apt/sources.list.d/elastic-8.x.list` file.

        ```bash
        echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" |  sudo tee /etc/apt/sources.list.d/elastic-8.x.list 
        ```

    2. Update your package index and install Elasticsearch using the following commands:

        ```bash
        sudo apt update
        sudo apt install elasticsearch
        ```
    
    Refer to the official Elasticsearch documentation website for [the most up-to-date instructions](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-with-debian-package){target=_blank}.

=== "RPM"

    1. Add Elasticsearch repository references.

        a. Download Elasticsearch repository keys.

        ```bash
        sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
        ```
        
        b. Check if the `/etc/yum.repos.d/elasticsearch.repo` file exists. If it doesn't, create it.

        c. Add the repository to your system by appending the following line to the `/etc/yum.repos.d/elasticsearch.repo` file.

        ```bash
        echo "[elasticsearch]
        name=Elasticsearch repository for 8.x packages
        baseurl=https://artifacts.elastic.co/packages/8.x/yum
        gpgcheck=1
        gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
        enabled=0" | sudo tee /etc/yum.repos.d/elasticsearch.repo
        ```

    2. Update your package index and install Elasticsearch using the following commands:

        ```bash
        sudo yum -y update
        sudo yum install --enablerepo=elasticsearch elasticsearch
        ```
    
    Refer to the official Elasticsearch documentation website for [the most up-to-date instructions](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-with-rpm){target=_blank}.

=== "Other installation methods"

    Download the tar.gz archive from [Elasticsearch downloads](http://elastic.co/downloads/elasticsearch){target=_blank} and extract it into the folder of your choice. You can use utilities like [Wget](https://www.gnu.org/software/wget/){target=_blank} to download the archive.

### Step 4.2: Configure Elasticsearch

#### Configure the `/etc/elasticsearch/elasticsearch.yml` file

1. Open the `/etc/elasticsearch/elasticsearch.yml` file using a text editor.

2. In the `elasticsearch.yml` file, set the `cluster.name` parameter to the desired name. This name will help identify your Elasticsearch cluster.

    Replace `my-application` with your new cluster name.

    !!! tip "Default commented line"
        This line is commented out by default. Uncomment it to ensure your new value is applied.

3. In the `elasticsearch.yml` file, set the `thread_pool.search.queue_size` to the desired number. This parameter controls how many search requests Elasticsearch can queue at the same time. If the queue is full, new requests will wait or be rejected.

    Add the following line (or edit it if it already exists):

    ```yaml
    thread_pool.search.queue_size: <requests_limit>
    ```

    Replace `<requests_limit>` with the number of requests you want to allow in the queue. For example, you can use `100000` for a single-node setup.

4. Optional: In the `elasticsearch.yml` file, change the default directory path values for the `path.data` and `path.logs` parameters. That tells Elasticsearch where to store its data and logs.

    | Parameter    | Default directory path value |
    | -------- | ------- |
    | `path.data`  | /var/lib/elasticsearch |
    | `path.logs` | /var/log/elasticsearch     |

5. Recommended: Activate X-Pack security. It controls authentication, encryption, and other security features in Elasticsearch.

    In the `elasticsearch.yml` file, add the desired security parameters from [the official Elasticsearch security settings documentation](https://www.elastic.co/docs/reference/elasticsearch/configuration-reference/security-settings){target=_blank}. 
    
    At minimum add the following line (or edit it if it already exists):

    ```yaml
    xpack.security.enabled: true
    ```

    !!! danger "Deactivating X-Pack security"
        You can deactivate X-Pack security by setting `xpack.security.enabled: false`, but this is strongly discouraged—especially in production environments. Doing so leaves your Elasticsearch instance unprotected against unauthorized access and compromises the security of your entire TheHive deployment.

6. Optional: In the `elasticsearch.yml` file, set the `script.allowed_types` parameter. This controls what types of scripts Elasticsearch is allowed to run for calculations, aggregations, or custom logic on your data.
   
    By default, Elasticsearch allows both inline and stored scripts. For a standard single-node setup, you usually don’t need to change this.
    
    You can restrict this if you want to allow only one type—or none by adding the following line (or edit it if it already exists):

    ```yaml
    script.allowed_types: <allowed_type>
    ```

    Replace `<allowed_type>` with the type you want to allow: `inline`, `stored`, or `none`.

7. Save your modifications in the `elasticsearch.yml` file.

!!! Example "Example of a `elasticsearch.yml` file configuration"
    ```
    # content from /etc/elasticsearch/elasticsearch.yml
    [..]
    cluster.name: hive
    thread_pool.search.queue_size: 100000
    path.logs: "/var/log/elasticsearch"
    path.data: "/var/lib/elasticsearch"
    xpack.security.enabled: true
    [..]
    ```

#### Configure the `/etc/elasticsearch/jvm.options.d/jvm.options` file

1. Check if the `/etc/elasticsearch/jvm.options.d/jvm.options` exists. If it doesn't, create it.

2. Open the `/etc/elasticsearch/jvm.options.d/jvm.options` file using a text editor.

3. In the `jvm.options` file, set the Java virtual machine (JVM) options.

    The JVM is what runs Elasticsearch. The JVM options control how much memory Elasticsearch can use, how it manages that memory, and other performance-related settings.

    !!! warning "Heap size configuration"
        Heap allocation [must not exceed 50% of the total system RAM](https://www.elastic.co/search-labs/blog/elasticsearch-heap-size-jvm-garbage-collection){target=_blank}.

        Undefined heap settings may cause memory contention or out-of-memory errors.

    On a 12 GB RAM system, for example:

    ```yaml
    -Dlog4j2.formatMsgNoLookups=true
    -Xms6g
    -Xmx6g
    ```

    `Xms` defines the initial heap size allocated to the JVM, and `Xmx` sets the maximum heap size. Setting them to the same value is recommended for stable performance and predictable garbage collection.

4. Save your modifications in the `jvm.options` file.

!!! info "Index creation and management in TheHive"

    * Index creation occurs during TheHive initial startup, which may take some time to complete.
    * Similar to data and files, include indexes in the backup policy to ensure their preservation.
    * Remove and re-create indexes as needed.

### Step 4.3: Start the Elasticsearch service

=== "DEB"

    1. Check whether the Elasticsearch service started automatically before configuring it.

        ```bash
        sudo systemctl status elasticsearch
        ```

        If it's running, stop it and remove existing data.

        ```bash
        sudo systemctl stop elasticsearch
        sudo rm -rf /var/lib/elasticsearch/*
        ```
    
    2. Start the Elasticsearch service.
        
        ```bash
        sudo systemctl start elasticsearch
        ```

    3. Enable the Elasticsearch service to restart automatically after a system reboot.


        ```bash
        sudo systemctl enable elasticsearch
        ```
    
    4. Verify that Elasticsearch is running.

        ```bash
        sudo systemctl status elasticsearch
        ```

        If Elasticsearch is running, you should see an active status in green.

=== "RPM"

    1. Check whether the Elasticsearch service started automatically before configuring it.

        ```bash
        sudo systemctl status elasticsearch
        ```

        If it's running, stop it and remove existing data.

        ```bash
        sudo systemctl stop elasticsearch
        sudo rm -rf /var/lib/elasticsearch/*
        ```

    2. Start the Elasticsearch service by running the following commands:
        
        ```bash
        sudo systemctl daemon-reload
        sudo systemctl start elasticsearch
        ```

    3. Enable the Elasticsearch service to restart automatically after a system reboot.

        ```bash
        sudo systemctl enable elasticsearch
        ```

    4. Verify that Elasticsearch is running.

        ```bash
        sudo systemctl status elasticsearch
        ```

        If Elasticsearch is running, you should see an active status in green.

!!! bug "Troubleshooting Elasticsearch"

    * Service not starting → Check `/var/log/elasticsearch/` for JVM errors or heap misconfiguration.
    * Memory issues → Ensure heap (`Xms`/`Xmx`) is no more than 50% of system RAM.

### Step 4.4: Set a user with the right permissions for TheHive (if you enabled X-Pack security in [Step 4.2](#step-42-configure-elasticsearch)) {#step-44-permissions}

{% include-markdown "includes/set-user-thehive-elasticsearch.md" %}

---

## :material-beehive-outline: Step 5: Install and configure TheHive

### Step 5.1: Install TheHive

TheHive packages are distributed as RPM and DEB files, as well as ZIP binary packages, all available for direct download via tools like Wget or cURL, with installation performed manually.

All packages are hosted on an HTTPS-secured website and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum){target=_blank} and a [GPG](https://www.gnupg.org/){target=_blank} signature for verification.

{% include-markdown "includes/manual-download-installation-thehive.md" %}

=== "ZIP binary packages"

    If you prefer more control over where TheHive is installed, need to use it in environments without package managers, or want to avoid dependency issues, you can install TheHive by downloading a ZIP binary package.

    !!! tip "Destination path"
        The commands below use `/opt/` as the download path. Replace it with the full local directory path where you want to save the files.

    1. Download the binary package along with its SHA256 checksum and signature files. You can install TheHive anywhere on your filesystem.
   
        * Using Wget

            ```bash
            wget -O /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/zip/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip
            wget -O /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.sha256 https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/sha256/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.sha256
            wget -O /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.asc https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/asc/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            wget -O /opt/<file_name>.zip thehive.download.strangebee.com/<major.minor_version>/zip/<file_name>.zip
            wget -O /opt/<file_name>.zip.sha256 thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.zip.sha256
            wget -O /opt/<file_name>.zip.asc thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.zip.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `thehive-5.4.11-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `5.4`.

        * Using cURL

            ```bash
            curl -o /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/zip/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip
            curl -o /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.sha256 https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/sha256/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.sha256
            curl -o /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.asc https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/asc/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            curl -o /opt/<file_name>.zip thehive.download.strangebee.com/<major.minor_version>/zip/<file_name>.zip
            curl -o /opt/<file_name>.zip.sha256 thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.zip.sha256
            curl -o /opt/<file_name>.zip.asc thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.zip.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `thehive-5.4.11-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `5.4`.

    2. Verify the integrity of the downloaded package.

        * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            ```bash
            cat /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.sha256
            ```

            c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with unzipping or installation, and contact the [StrangeBee Security Team](mailto:security@strangebee.com).

          * Verify the GPG signature using the public key.
     
            a. Download the public key at [keys.download.strangebee.com](https://keys.download.strangebee.com){target=_blank} using Wget or cURL.

            ```bash
            wget -O /opt/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```
            
            ```bash
            curl -o /opt/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```

            b. Import the key into your GPG keyring.

            ```bash
            gpg --import /opt/strangebee.gpg
            ```

            c. Verify the downloaded package signature.

            ```bash
            gpg --verify /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip.asc /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip
            ```

            d. Expected result.

            You should see output similar to:

            ```
            gpg: Good signature from "TheHive Project (TheHive release key) <support@thehive-project.org>"
            ```

            The key fingerprint must match: `0CD5 AC59 DE5C 5A8E 0EE1  3849 3D99 BB18 562C BC1C`

            !!! info "Expected GPG warning"
                ```
                gpg: WARNING: This key is not certified with a trusted signature!
                gpg:          There is no indication that the signature belongs to the owner.
                ```
                This warning is expected. It means the package is signed with the official TheHive release key, but you haven't marked this key as `trusted` in your local GPG setup. As long as you see `Good signature` and the fingerprint matches, the verification is successful. Don't mark our key as globally trusted—the warning is a normal safety reminder and should remain visible.

            If you don't see `Good signature`, if the fingerprint differs, or if the signature is reported as `BAD`, don't install the package. This indicates the integrity or authenticity of the file can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).


    3. Unzip the package.

        !!! info "Unzip paths"
            
            * Replace `/opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip` with the full path to the ZIP file you downloaded.
            * Replace `/opt/` after `-d` with the directory where you want to extract the contents of the archive.

        ```bash
        unzip /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2.zip -d /opt/
        sudo ln -s /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-2 /opt/thehive
        ```

    4. Prepare the system by creating a dedicated, non-privileged user account to run TheHive. Ensure this user has permission to create log files in `/opt/thehive/logs`.

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

    5. Copy the systemd script into `/etc/systemd/system/thehive.service`.

        ```bash
        cd /tmp
        wget https://raw.githubusercontent.com/TheHive-Project/TheHive/master/package/thehive.service
        sudo cp thehive.service /etc/systemd/system/thehive.service
        ```

### Step 5.2: Configure TheHive

!!! info "Standalone server configuration"
    In this guide, we will configure TheHive for a standalone server, with all components hosted on a single server. This setup is suitable for testing and production environments. For cluster deployments, refer to [Set Up a Cluster on Linux Systems](deploying-a-cluster.md#step-4-install-and-configure-thehive).

1. Open the `/etc/thehive/application.conf` file using a text editor.

2. In the `application.conf` file, configure the service.

    To ensure TheHive works correctly—especially with authentication mechanisms such as SSO—configure the `application.baseUrl` and `play.http.context` parameters. If required, you can also adjust `http.address` and `http.port`.

    Default configuration:

    ```yaml
    [..]
    # Service configuration
    application.baseUrl = "http://localhost:9000"
    play.http.context = "/"
    [..]
    ```

    #### application.baseUrl

    Replace `http://localhost:9000` with the actual public URL that users will use to access TheHive.

    ##### Mandatory elements

    * Protocol: Either `http` or `https`, depending on whether you [configured HTTPS with a reverse proxy](../configuration/ssl/configure-https-reverse-proxy.md).
    * Host name: The DNS name or IP address that users enter in their browser.

    ##### Optional elements

    * Port: The network port where TheHive is exposed. Include a port only when the public URL uses a non-standard port. Standard ports are `80` for HTTP and `443` for HTTPS.
    * Path segments: Needed if TheHive runs behind a reverse proxy under a subpath.

    !!! note "Listen address and port"
        By default, TheHive listens on all network interfaces (`0.0.0.0`) at port `9000`.  
        These settings control how TheHive listens internally on the host and are independent of the public URL defined in `application.baseUrl`.

        * Use `http.address` and `http.port` to control how the service listens on the host.
        * Use `application.baseUrl` to define the public URL that TheHive communicates to clients.

        To customize the listen address and port, see [Update TheHive Service Configuration](../configuration/update-service-configuration.md#update-the-listen-address-and-port).

    #### play.http.context

    If TheHive is served under a subpath when running behind a reverse proxy, set `play.http.context` to the matching path segment.
    
    For configuration details, see [Update TheHive Service Configuration](../configuration/update-service-configuration.md#set-a-context-path).

    For additional guidance on proxy usage, see [Configure HTTPS for TheHive With a Reverse Proxy](../configuration/ssl/configure-https-reverse-proxy.md).

    {% include-markdown "includes/example-configuration-service.md" %}

3. Optional: Configure the secret key for the Play Framework.

    TheHive uses a secret key to sign session cookies and ensure secure user authentication.
    
    Skip this step if you installed TheHive using DEB or RPM packages—they generate the key automatically.

    a. For other installation methods, generate and configure a secret key.

    ```bash
    cat > /etc/thehive/secret.conf << _EOF_
    play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"
    _EOF_
    ```

    {% include-markdown "includes/minimum-key-length.md" %}

    b. Set appropriate file permissions.
    
    ```bash
    sudo chmod 400 /etc/thehive/secret.conf
    sudo chown thehive:thehive /etc/thehive/secret.conf
    ```

    !!! danger "Security requirements"
        Never share or commit your secret key to version control. Use different keys for each environment (development, staging, production).

4. In the `application.conf` file, configure the database and index.

    !!! example "Example of database and index configuration with authentication"
        ```yaml
        # Content from /etc/thehive/application.conf
        [..]
        # Database and index configuration
        db.janusgraph {
            storage {
                backend = cql
                hostname = ["127.0.0.1"]
                # Cassandra authentication (recommended)
                username = "thehive"
                password = "<thehive_role_password>"
                cql {
                    keyspace = thehive
                }
            }
            index.search {
                backend = elasticsearch
                hostname = ["127.0.0.1"]
                index-name = thehive
                # Elasticsearch authentication (recommended)
                elasticsearch {
                    http {
                        auth {
                            type = basic
                            basic {
                                username = "thehive"
                                password = "<thehive_user_password>"
                            }
                        }
                    }
                }
            }
        }
        [..]
        ```

    Replace `<thehive_role_password>` with the password set in [Step 3.6](#step-36-create-the-keyspace-and-a-role-for-thehive-if-you-enabled-authentication-in-step-32).

    Replace `<thehive_user_password>` with the password set in [Step 4.4](#step-44-permissions).

    You can remove the lines under `# Cassandra authentication (recommended)` and `# Elasticsearch authentication (recommended)` if you didn’t enable authentication for Cassandra or Elasticsearch.

    To set up SSL for Cassandra and Elasticsearch connections, see [Configure Database and Index SSL](../configuration/configure-ssl-cassandra-elasticsearch.md).

5. Save your modifications in the `application.conf` file.

### (Optional) Step 5.3: <!-- md:version 5.5 --> Configure audit log storage {#step-53-audit-log-storage}

By default, TheHive stores audit logs in Apache Cassandra via JanusGraph. However, if your organization generates a large volume of audit logs, you can switch to Elasticsearch.

Elasticsearch offers better performance, reduced latency, and advanced search capabilities.

!!! warning "Audit logs visibility"

    * With Elasticsearch, audit logs retain the visibility they had at the time of creation, regardless of the current visibility of the case. This means that even if [you set restricted visibility for a case](../user-guides/analyst-corner/cases/case-visibility/restrict-visibility-case.md), audit logs remain visible to all users who originally had access.
    * With the default configuration using Apache Cassandra (JanusGraph), audit logs immediately become private if the visibility of the associated case is restricted. This means that even if audit logs were originally public, they will be hidden from all users [once the case visibility is restricted](../user-guides/analyst-corner/cases/case-visibility/restrict-visibility-case.md).

!!! danger "Backups required"
    Regularly [back up your Elasticsearch indices](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore){target=_blank} to ensure you can recover audit logs in the event of an incident. This is critical for maintaining the integrity and availability of your data.

#### Activate audit log storage

{% include-markdown "includes/activate-audit-log-storage-elasticsearch.md" %}

#### Optional: Configure index template and Index Lifecycle Management (ILM)

{% include-markdown "includes/configure-index-ilm-elasticsearch.md" %}

### Step 5.4: Create the file storage directory

!!! info "Standalone server configuration"
    In this guide, we will configure local file storage for TheHive running on a standalone server, with all components hosted on the same server. This setup is suitable for testing and production environments. For cluster deployments, refer to [Set Up a Cluster on Linux Systems](deploying-a-cluster.md#step-3-set-up-a-shared-file-storage).

File storage contains [attachments](../user-guides/analyst-corner/cases/attachments/about-attachments.md) from cases, alerts, and organizations, as well as [observables](../user-guides/analyst-corner/cases/observables/about-observables.md) of type *file*. [All files are stored in their original form as plaintext](../../resources/security.md#database-and-storage).

On a standalone server, these files are stored on the local filesystem. By default, TheHive uses `/opt/thp/thehive/files` as the storage path.

1. Create the storage directory.

    ```bash
    sudo mkdir -p /opt/thp/thehive/files
    ```

2. Set ownership and permissions so that only the `thehive` user can read and write files.
   
    ```bash
    sudo chown -R thehive:thehive /opt/thp/thehive/files
    sudo chmod 700 /opt/thp/thehive/files
    ```

!!! info "Storage location"
    You can change this default location by updating the `localfs.location` parameter in the `application.conf` file.

### Step 5.5: Configure Cortex and MISP integration

!!! info "Cortex support"
    <!-- md:version 5.5 --> Cortex 3.1.5 and earlier are no longer supported since version 5.5.

By default, TheHive enables both the [Cortex](../administration/cortex/about-cortex.md) and the Malware Information Sharing Platform [MISP](../administration/misp-integration/about-misp-integration.md) integration modules.

When you connect TheHive to Cortex, you can use analyzers to look up extra information about observables and get clear reports with the results. You can also use responders to take automatic actions on cases, alerts, or tasks to help with investigations and incident response.

When you connect TheHive to MISP, you can bring in threat intelligence by importing MISP events as alerts or cases to support your investigations. You can also share your findings back to MISP by exporting observables marked as indicators of compromise (IOCs) so other teams and communities can benefit.

If you don't plan to use either of these services, you can deactivate the corresponding module by uncommenting the related configuration line in the `application.conf` file.

* To deactivate the Cortex module:

```yaml
scalligraph.disabledModules += org.thp.thehive.connector.cortex.CortexModule
```

* To deactivate the MISP module:

```yaml
scalligraph.disabledModules += org.thp.thehive.connector.misp.MispModule
```

### Step 5.6: Start TheHive service

1. Start TheHive service and enable it at boot.

    ```bash
    sudo systemctl start thehive
    sudo systemctl enable thehive
    ```

2. Verify that TheHive is running.

    ```bash
    sudo systemctl status thehive
    ```

    If TheHive is running, you should see an active status in green.

    !!! info "Service startup delay"
        Be aware that the service may take some time to start initially.

    !!! bug "Troubleshooting TheHive"
        If you run into issues, see the [Troubleshooting](../operations/troubleshooting.md) page for guidance.

3. Open your web browser and go to the URL you configured in the `application.baseUrl` setting inside the `/etc/thehive/application.conf` file.

    !!! tip "Port and path segment"
        If you configured `application.baseUrl` with an explicit port or a path segment, be sure to include them in the URL.

4. Perform the initial setup of the application by following the instructions in [Perform Initial Login and Setup as an Admin](../administration/perform-initial-setup-as-admin.md).

---

## Advanced configuration

For additional customization, see the Configuration and Operations sections of this documentation.

To enable HTTPS, follow the instructions in [Configure HTTPS for TheHive With a Reverse Proxy](../configuration/ssl/configure-https-reverse-proxy.md).

To enable GDPR compliance, follow the instructions in [Enable the GDPR Compliance Feature](../configuration/enable-gdpr.md).

---

## Backup

Choose between cold backups or hot backups depending on your operational requirements.  

See detailed steps in the Backup & Restore Operations section.

---

## Monitoring

We recommend setting up monitoring to track key performance metrics such as request latency, CPU usage, and memory consumption.  

See the [Set Up Monitoring for TheHive with Prometheus and Grafana](../operations/monitoring.md) page for detailed instructions.

<h2>Next steps</h2>

* [Turn Off The Cortex Integration](../configuration/turn-off-cortex-connector.md)
* [Turn Off The MISP Integration](../configuration/turn-off-misp-connector.md)
* [Update TheHive Service Configuration](../configuration/update-service-configuration.md)
* [Update Log Configuration](../configuration/update-log-configuration.md)
* [Enable the GDPR Compliance Feature](../configuration/enable-gdpr.md)
* [Configure HTTPS for TheHive With a Reverse Proxy](../configuration/ssl/configure-https-reverse-proxy.md)
* [Configure JVM Trust for SSL/TLS Certificates](../configuration/ssl/configure-ssl-jvm.md)
* [Perform a Hot Backup on a Standalone Server](../operations/backup-restore/backup/hot-backup/hot-backup-standalone-server.md)
* [Perform a Cold Backup on a Physical Server](../operations/backup-restore/backup/cold-backup/physical-server.md)
* [Perform a Cold Backup on a Virtual Server](../operations/backup-restore/backup/cold-backup/virtual-server.md)
* [Set Up Monitoring for TheHive with Prometheus and Grafana](../operations/monitoring.md)
* [Troubleshooting](../operations/troubleshooting.md)