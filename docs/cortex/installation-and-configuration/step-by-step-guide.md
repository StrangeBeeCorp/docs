# Step-by-Step guide

This page is a step by step installation and configuration guide to get a Cortex instance up and running. This guide is illustrated with examples for Debian and RPM packages based systems and for installation from binary packages.


## Required packages

!!! Example "" 

    === "Debian" 

        ```bash
        apt install wget gnupg apt-transport-https git ca-certificates ca-certificates-java curl  software-properties-common python3-pip lsb_release
        ``` 

    === "RPM"

        ```bash
        yum install pkg-install gnupg chkconfig python3-pip git 
        ```

## Java Virtual Machine

!!! warning "Manual installation required"
    As of Cortex 3.2, OpenJDK 11 is no longer installed automatically. You must manually install OpenJDK 11 or a later version before running Cortex.  
    This change allows you to uninstall or upgrade Java independently of Cortex.

!!! example "Install Java"

    === "Debian"

        ``` bash
        apt install -y openjdk-11-jre-headless
        echo JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment
        export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
        ```

    === "RPM"

        ``` bash
        sudo yum install -y java-11-openjdk-headless.x86_64
        echo JAVA_HOME="/usr/lib/jvm/java-11-openjdk" | sudo tee -a /etc/environment
        export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
        ```

    === "Other"

        The installation requires Java 11, so refer to your system documentation to install it.



## Elasticsearch

!!! Example ""

    === "Debian"

        ```bash
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" |  sudo tee /etc/apt/sources.list.d/elastic-7.x.list 
        sudo apt install elasticsearch   
        ```

    === "RPM"

        ```title="/etc/yum.repos.d/elasticsearch.repo"
        [elasticsearch]
        name=Elasticsearch repository for 7.x packages
        baseurl=https://artifacts.elastic.co/packages/7.x/yum
        gpgcheck=1
        gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
        enabled=0
        autorefresh=1
        type=rpm-md
        ```

        ```bash
        sudo yum install --enablerepo=elasticsearch elasticsearch
        ```

### Configuration 

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

    Adjust this file according to the amount of RAM available on your server: 

    ```title="/etc/elasticsearch/jvm.options.d/jvm.options"
    -Dlog4j2.formatMsgNoLookups=true
    -Xms4g
    -Xmx4g
    ```

## Docker

If using Docker images of Analyzers and Responders, Docker engine is required on the Operating System: 

!!! Example ""

    === "Debian"

        ```bash
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
        apt install docker-ce
        ```

    === "RPM"
        
        ```bash
        sudo yum remove -yq docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
        sudo dnf -yq install dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        sudo dnf install -yq docker-ce docker-ce-cli containerd.io docker-compose-plugin
        ```


# Cortex Installation and Configuration

This section provides step-by-step instructions to install Cortex and configure it properly.

## Installation

Cortex is available in Debian, RPM, and binary (zip archive) formats. All packages are signed using our GPG key [562CBC1C](https://raw.githubusercontent.com/TheHive-Project/Cortex/master/PGP-PUBLIC-KEY), with the following fingerprint:

```
0CD5 AC59 DE5C 5A8E 0EE1  3849 3D99 BB18 562C BC1C
```

### Debian-based Installation

Ensure your system is up to date before installing Cortex. Run the following commands:

```bash
wget -qO- https://raw.githubusercontent.com/TheHive-Project/Cortex/master/PGP-PUBLIC-KEY | sudo tee /usr/share/keyrings/thehive-project.gpg > /dev/null
```

Add the repository to your system:

```bash
echo "deb [arch=all signed-by=/usr/share/keyrings/thehive-project.gpg] https://deb.thehive-project.org release main" | sudo tee /etc/apt/sources.list.d/thehive-project.list
```

Update the package list and install Cortex:

```bash
sudo apt update
sudo apt install cortex
```

### RPM-based Installation

For RPM-based distributions (CentOS, RHEL, Fedora), create a new repository configuration file:

```bash
sudo tee /etc/yum.repos.d/thehive-project.repo <<EOL
[cortex]
enabled=1
priority=1
name=TheHive-Project RPM repository
baseurl=https://rpm.thehive-project.org/release/noarch
gpgkey=https://raw.githubusercontent.com/TheHive-Project/Cortex/master/PGP-PUBLIC-KEY
gpgcheck=1
EOL
```

Then, install Cortex:

```bash
sudo yum install cortex
```

### Binary Installation

For environments where package managers are not available, download and extract the Cortex binary package:

```bash
wget https://download.thehive-project.org/cortex-latest.zip
unzip cortex-latest.zip -d /opt/cortex
cd /opt/cortex
chmod +x cortex
```

## Post-Installation Configuration

### Running Analyzers & Responders with Docker

If you plan to use Cortex with _Analyzers & Responders_ running in Docker, ensure the `cortex` service account has appropriate permissions to interact with Docker:

```bash
sudo usermod -a -G docker cortex
```

### Verify Installation

After installation, you can check if Cortex is properly installed by running:

```bash
cortex --version
```

This should return the installed version of Cortex.

### Configuration

Following settings are required to start Cortex successfully:

- [Secret key](secret.md) configuration
- [Database configuration](database.md)
- [Authentication](authentication.md)
- [Analyzers & Responders configuration](analyzers-responders.md)

Advanced configuration settings might be added to run the application successfully: 

- [Specific Docker parameters](docker.md)
- [Proxy settings](proxy-settings.md)
- [SSL configuration](ssl.md)

### Start Cortex service

!!! Warning

    Before starting the service, ensure to have configured accordingly the application. Start by setting up the [secret key](secret.md).

Save configuration file and run the service:

!!! Example "" 

    ```bash
    systemctl start cortex
    ```

Please note that the service may take some time to start. Once it is started, you may launch your browser and connect to `http://YOUR_SERVER_ADDRESS:9001/`. 

## First start

Refer to the [First start](../user-guides/first-start.md) guide for the next steps.

