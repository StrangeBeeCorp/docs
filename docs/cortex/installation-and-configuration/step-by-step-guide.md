# Install Cortex with Packages

Welcome to the step-by-step guide for installing and configuring Cortex with packages!

This guide is designed for users who are comfortable with Linux system administration, but you don't need to be an infrastructure expert to follow along.

By the end, you'll have a fully functional instance of Cortex up and running.

!!! note "Guide scope"
    This guide covers setting up a new instance of Cortex with packages, with all components hosted on the same server. This guide is illustrated with examples for Debian and RPM packages based systems and for installation from ZIP binary packages.

    It doesn't cover:

    * Docker deployments: For Docker-based setups, follow [Run Cortex with Docker](run-cortex-with-docker.md).
    * Cluster deployments: Refer to [Deploy Cortex on Kubernetes](deploy-cortex-on-kubernetes.md) for Kubernetes deployments.
    * Version upgrades: For upgrading an existing instance, see [Upgrade to Cortex 4.1](../operations/upgrade-cortex-4.md).

!!! warning "Before you begin"
    To ensure a smooth installation process, make sure you have:

    * A basic understanding of [the role and architecture of Cortex](../index.md)
    * [Hardware and operating system](system-requirements.md), and [software](software-requirements.md) requirements fully met and verified

## Step 1: Install required dependencies

Start by installing the necessary dependencies for Cortex.

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

Cortex requires Java to run its application server and to manage various processes.

!!! warning "Manual installation required"
    Starting with Cortex 3.2, the Java virtual machine (JVM) is no longer installed automatically. You must manually install it before running Cortex.

!!! note "Java support"

    * For security and long-term support, use [Amazon Corretto](https://aws.amazon.com/corretto/){target=_blank}, which provides OpenJDK builds maintained by Amazon.
    * Corretto 11 or higher is required to install Cortex.

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
        sudo yum install -y java-11-amazon-corretto-devel &> /dev/null
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

## :fontawesome-solid-list: Step 3: Install and configure Elasticsearch {#step-3-install-configure-elasticsearch}

[Elasticsearch](https://www.elastic.co/elasticsearch){target=_blank} is a data indexing and search engine that's used in Cortex to store and manage all its data.

!!! info "Single node configuration"
    In this guide, you will configure Elasticsearch as a single node on your server, which is fine for running Cortex.

!!! note "Elasticsearch supported versions"

    **Cortex**

    {% include-markdown "includes/elasticsearch-supported-versions-cortex.md" %}

    **TheHive**

    {% include-markdown "includes/elasticsearch-supported-versions-thehive.md" %}

    Sharing a single Elasticsearch instance between TheHive and Cortex isn't recommended. If you must do it, ensure the Elasticsearch version is compatible with both applications.

### Step 3.1: Install Elasticsearch

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

    Download the tar.gz archive from [Elasticsearch downloads](http://elastic.co/downloads/elasticsearch){target=_blank} and extract it into the folder of your choice. You can use utilities like [`wget`](https://www.gnu.org/software/wget/){target=_blank} to download the archive.

### Step 3.2: Configure Elasticsearch

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
        You can deactivate X-Pack security by setting `xpack.security.enabled: false`, but this is strongly discouraged—especially in production environments. Doing so leaves your Elasticsearch instance unprotected against unauthorized access and compromises the security of your entire Cortex deployment.

6. Optional: In the `elasticsearch.yml` file, set the `script.allowed_types` parameter. This controls what types of scripts Elasticsearch is allowed to run for calculations, aggregations, or custom logic on your data.

    By default, Elasticsearch allows both inline and stored scripts. For a standard single-node setup, you usually don't need to change this.

    You can restrict this if you want to allow only one type—or none by adding the following line (or edit it if it already exists):

    ```yaml
    script.allowed_types: <allowed_type>
    ```

    Replace `<allowed_type>` with the type you want to allow: `inline`, `stored`, or `none`.

7. Save your modifications in the `elasticsearch.yml` file.

!!! example "Example of a `elasticsearch.yml` file configuration"
    ```
    # content from /etc/elasticsearch/elasticsearch.yml
    [..]
    cluster.name: cortex
    thread_pool.search.queue_size: 100000
    path.logs: "/var/log/elasticsearch"
    path.data: "/var/lib/elasticsearch"
    xpack.security.enabled: true
    script.allowed_types: "inline,stored"
    [..]
    ```

#### Configure JVM options for Elasticsearch

The Java virtual machine (JVM) is what runs Elasticsearch. The JVM options control how much memory Elasticsearch can use, how it manages that memory, and other performance-related settings. By default, Java determines heap size automatically, which isn't recommended for production environments and may cause memory contention or out-of-memory errors.

1. Check if the `/etc/elasticsearch/jvm.options.d/jvm.options` exists. If it doesn't, create it.

2. Open the `/etc/elasticsearch/jvm.options.d/jvm.options` file using a text editor.

3. In the `jvm.options` file, set the JVM options.

    !!! tip "Heap size guidelines for Elasticsearch"
        Heap allocation [must not exceed 50% of the available RAM](https://www.elastic.co/search-labs/blog/elasticsearch-heap-size-jvm-garbage-collection){target=_blank}. Available RAM refers to the memory remaining after accounting for the operating system and other services running on the same host.

    ```yaml
    -Dlog4j2.formatMsgNoLookups=true
    -Xms<heap_size>
    -Xmx<heap_size>
    ```

    Replace `<heap_size>` with the desired heap size. `Xms` sets the initial heap size, and `Xmx` the maximum heap size.

    {% include-markdown "includes/jvm-options-xms-xmx-same-value.md" %}

    {% include-markdown "includes/disable-swap-elasticsearch.md" %}

4. Save your modifications in the `jvm.options` file.

### Step 3.3: Start the Elasticsearch service

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

### Step 3.4: Set a user with the right permissions {#set-a-user-with-the-right-permissions}

If you enabled X-Pack security in [Step 3.2](#step-32-configure-elasticsearch), and Elasticsearch is running, set up a user with the right permissions for Cortex.

1. Create a `cortex` user.

    ```bash
    sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd cortex -p <cortex_user_password> -r superuser
    ```

    Replace `<cortex_user_password>` with a secure password you choose for your Cortex user.

    !!! tip "Note this password"
        Keep this password secure. You will need to enter it later in the Cortex configuration file so the application can connect to Elasticsearch.

2. Optional: Set a password for the `elastic` user.

    * [For Elasticsearch 7.x](https://www.elastic.co/docs/reference/elasticsearch/command-line-tools/setup-passwords){target=_blank}:

    ```bash
    sudo /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
    ```

    * [For Elasticsearch 8.0](https://www.elastic.co/docs/reference/elasticsearch/command-line-tools/reset-password){target=_blank}:

    ```bash
    sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password
    ```

    Skip this step if the password is already set.

3. Create or update a role with the privileges needed for Cortex.

    !!! warning "Elasticsearch permission requirements"

        The `cortex_role` role needs the `create_index`, `write`, and `read` indices privileges on `cortex_*` indices:

        * Creating an index and its mapping at initialization requires the `create_index` privilege.
        * Creating and deleting documents in the index requires the `write` privilege.
        * Searching documents in the index requires the `read` privilege.

        If you're using an existing Elasticsearch instance, confirm it can grant these privileges before connecting it to Cortex.

    * Create a role:

    ```bash
    curl -u elastic:<elastic_user_password> -X POST "http://localhost:9200/_security/role/cortex_role" -H "Content-Type: application/json" -d '
    {
      "indices": [
        {
          "names": ["cortex_*"],
          "privileges": ["create_index", "write", "read"]
        }
      ]
    }'
    ```

    Replace `<elastic_user_password>` with the password you set for the `elastic` user.

    If successful, the command should return: `{"role":{"created":true}}`.

    For more details, refer to [the official Elasticsearch API documentation for role creation](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-put-role){target=_blank}.

    * Update a role:

    ```bash
    curl -u elastic:<elastic_user_password> -X PUT "http://localhost:9200/_security/role/<role>" -H "Content-Type: application/json" -d '
    {
      "indices": [
        {
          "names": ["cortex_*"],
          "privileges": ["create_index", "write", "read"]
        }
      ]
    }'
    ```

    Replace `<role>` with the actual role name you want to update.

    Replace `<elastic_user_password>` with the password you set for the `elastic` user.

    For more details, refer to [the official Elasticsearch API documentation for updating roles](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-put-role){target=_blank}.

4. Assign the role to the user you'll use for Cortex.

    ```bash
    curl -u elastic:<elastic_user_password> -X PUT "http://localhost:9200/_security/user/cortex" \
    -H "Content-Type: application/json" \
    -d '{
        "password" : "<cortex_user_password>",
        "roles" : ["cortex_role"]
    }'
    ```

    Replace `<cortex_user_password>` with the password you set for the `cortex` user.

    Replace `<elastic_user_password>` with the password you set for the `elastic` user.

    Replace `cortex_role` with actual role name if different.

    If successful, the command should return: `{"created":true}`.

    For more details, refer to [the official Elasticsearch API documentation for updating users](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-put-user){target=_blank}.

---

## (Optional) Step 4: Install Docker

If you plan to run [analyzers and responders as Docker images](analyzers-responders.md#run-with-docker)—the recommended option—install the Docker engine on the operating system running Cortex.

=== "DEB (Debian/Ubuntu)"

    ```bash
    . /etc/os-release
    curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${ID} ${VERSION_CODENAME:-$UBUNTU_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt update
    sudo apt install docker-ce
    ```

=== "RPM (RHEL/Fedora)"

    ```bash
    . /etc/os-release
    sudo yum remove -yq docker \
              docker-client \
              docker-client-latest \
              docker-common \
              docker-latest \
              docker-latest-logrotate \
              docker-logrotate \
              docker-engine
    sudo dnf -yq install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/${ID}/docker-ce.repo
    sudo dnf install -yq docker-ce docker-ce-cli containerd.io docker-compose-plugin
    ```

If you'd rather store and run analyzers and responders directly on the host instead of using Docker, see [Store & run programs on the host](analyzers-responders.md#store-run-programs-on-the-host).

---

## Step 5: Install and configure Cortex {#cortex-installation-and-configuration}

### Step 5.1: Install Cortex

Cortex packages are distributed as RPM and DEB files, as well as ZIP binary packages, all available for direct download via tools like `wget` or `curl`, with installation performed manually.

All packages are hosted on an HTTPS-secured website and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum){target=_blank} and a [GPG](https://www.gnupg.org/){target=_blank} signature for verification.

{% include-markdown "includes/manual-download-installation-cortex.md" %}

{% include-markdown "includes/zip-binaries-installation-cortex.md" %}

### Step 5.2: Configure Cortex

#### Configure the secret key

Cortex uses a secret key to sign session cookies and ensure secure user authentication.

1. Generate and configure a secret key.

    ```bash
    cat > /etc/cortex/secret.conf << _EOF_
    play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"
    _EOF_
    ```

2. In the `/etc/cortex/application.conf` file, replace the line including `play.http.secret.key=` with:

    ```yaml title="/etc/cortex/application.conf"
    [..]
    include "/etc/cortex/secret.conf"
    [..]
    ```

    !!! danger "Security requirements"
        Never share or commit your secret key to version control. Use different keys for each environment (development, staging, production).

For more details, see [Secret key configuration](secret.md).

#### Configure the database and index

In the `application.conf` file, configure Cortex to connect to Elasticsearch.

!!! example "Example of database and index configuration with authentication"
    ```yaml title="/etc/cortex/application.conf"
    [..]
    search {
      index = cortex
      uri = "http://127.0.0.1:9200"
      user = "cortex"
      password = "<cortex_user_password>"
    }
    [..]
    ```

Replace `<cortex_user_password>` with the password set in [Step 3.4](#set-a-user-with-the-right-permissions).

You can remove the `user` and `password` lines if you didn't enable X-Pack security for Elasticsearch.

For all available options, see [Database configuration](database.md).

#### Configure analyzers and responders

Tell Cortex where to find analyzers and responders, and whether they run as Docker images or directly on the host.

For detailed instructions and configuration examples, see [Analyzers & Responders](analyzers-responders.md).

If you plan to run analyzers and responders as Docker images, ensure the `cortex` service account has appropriate permissions to interact with Docker:

```bash
sudo usermod -a -G docker cortex
```

### Step 5.3: Verify installation

After installation, you can check if Cortex is properly installed by running:

```bash
cortex --version
```

This should return the installed version of Cortex.

### Step 5.4: Start Cortex service

!!! warning
    Before starting the service, ensure you have configured the application accordingly. At minimum, set up the [secret key](#configure-the-secret-key) and the [database and index configuration](#configure-the-database-and-index).

1. Start Cortex service and enable it at boot.

    ```bash
    sudo systemctl start cortex
    sudo systemctl enable cortex
    ```

2. Verify that Cortex is running.

    ```bash
    sudo systemctl status cortex
    ```

    If Cortex is running, you should see an active status in green.

    !!! info "Service startup delay"
        Be aware that the service may take some time to start initially.

    !!! bug "Troubleshooting Cortex"
        Check the Cortex logs in `/var/log/cortex/application.log` for configuration or startup errors.

3. Open your web browser and navigate to `http://<server_address>:9001/`.

### Step 5.5: Perform the initial setup

Follow the instructions in the [First start](../user-guides/first-start.md) guide to complete the initial setup of Cortex.

---

## Advanced configuration

For additional customization, see:

* [Proxy Settings](proxy-settings.md)
* [SSL Configuration](ssl.md)
* [Advanced Configuration](advanced-configuration.md)
* [Parameters for Docker](parameters-docker.md)

---

## Backup

All persistent data is stored in Elasticsearch. See [Backup and Restore Data](../operations/backup-restore.md) for detailed steps.

<h2>Next steps</h2>

* [First start](../user-guides/first-start.md)
* [Authentication](authentication.md)
* [Analyzers & Responders](analyzers-responders.md)
* [Proxy Settings](proxy-settings.md)
* [SSL Configuration](ssl.md)
* [Advanced Configuration](advanced-configuration.md)
* [Backup and Restore Data](../operations/backup-restore.md)
* [Cortex Package Repository](cortex-packages.md)
* [Run Cortex with Docker](run-cortex-with-docker.md)
