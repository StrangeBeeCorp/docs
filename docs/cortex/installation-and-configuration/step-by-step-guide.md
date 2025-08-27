# Step-by-Step Guide

This page is a step by step installation and configuration guide to get a Cortex instance up and running. This guide is illustrated with examples for Debian and RPM packages based systems and for installation from ZIP binary packages.

## Required packages

!!! Example "" 

    === "DEB" 

        ```bash
        apt install wget gnupg apt-transport-https git ca-certificates ca-certificates-java curl  software-properties-common python3-pip lsb_release
        ``` 

    === "RPM"

        ```bash
        yum install gnupg chkconfig python3-pip git
        ```

## Java Virtual Machine

!!! warning "Manual installation required"
    Starting with Cortex 3.2, the Java Virtual Machine is no longer installed automatically. You must manually install it before running Cortex.

!!! example "Install Java"

    For enhanced security and long-term support, use [Amazon Corretto](https://aws.amazon.com/corretto/), an OpenJDK build provided and maintained by Amazon. Corretto 11 or higher is required to install Cortex.

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
                yum install java-11-amazon-corretto-devel &> /dev/null
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

        The installation requires Java 11, so refer to your system documentation to install it.

## Elasticsearch

!!! Example ""

    === "DEB"

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

If using Docker images of analyzers and responders, Docker engine is required on the operating system:

!!! Example ""

    === "DEB"

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

## Cortex installation and configuration

This section provides step-by-step instructions to install Cortex and configure it properly.

### Installation

Cortex packages are distributed as RPM and DEB files available for direct download via tools like Wget or cURL, with installation performed manually.

All packages are hosted on an HTTPS-secured website and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum) and a [GPG](https://www.gnupg.org/) signature for verification.

!!! warning "Prerequisites"
    Before starting this procedure, check that you have installed the following tools:

    * [Wget](https://www.gnu.org/software/wget/) or [cURL](https://curl.se/download.html) to download package files
    * [GPG](https://www.gnupg.org/) to verify the package’s GPG signature
    * [sha256sum](https://linux.die.net/man/1/sha256sum) to check the SHA256 checksum of the downloaded package

{!includes/manual-download-installation-cortex.md!}

=== "ZIP binary packages"

    If you prefer more control over where Cortex is installed, need to use it in environments without package managers, or want to avoid dependency issues, you can install Cortex by downloading a ZIP binary package.

    !!! tip "Destination path"
        The commands below use `/opt/` as the download path. Replace it with the full local directory path where you want to save the files.

    1. Download the binary package along with its SHA256 checksum and signature files. You can install Cortex anywhere on your filesystem.
   
        * Using Wget

            ```bash
            wget -O /opt/cortex/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/zip/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip
            wget -O /opt/cortex/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip.sha256 https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/sha256/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip.sha256
            wget -O /opt/cortex/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip.asc https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/asc/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            wget -O /opt/<file_name>.zip cortex.download.strangebee.com/<major.minor_version>/zip/<file_name>.zip
            wget -O /opt/<file_name>.zip.sha256 cortex.download.strangebee.com/<major.minor_version>/sha256/<file_name>.zip.sha256
            wget -O /opt/<file_name>.zip.asc cortex.download.strangebee.com/<major.minor_version>/asc/<file_name>.zip.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `cortex-3.1.8-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `3.1`.

        * Using cURL

            ```bash
            curl -o /opt/cortex/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/zip/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip
            curl -o /opt/cortex/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip.sha256 https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/sha256/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip.sha256
            curl -o /opt/cortex/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip.asc https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/asc/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            curl -o /opt/<file_name>.zip cortex.download.strangebee.com/<major.minor_version>/zip/<file_name>.zip
            curl -o /opt/<file_name>.zip.sha256 cortex.download.strangebee.com/<major.minor_version>/sha256/<file_name>.zip.sha256
            curl -o /opt/<file_name>.zip.asc cortex.download.strangebee.com/<major.minor_version>/asc/<file_name>.zip.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `cortex-3.1.8-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `3.1`.

    2. Verify the integrity of the downloaded package.

        * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /opt/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with unzipping or installation, and contact the [StrangeBee Security Team](mailto:security@strangebee.com).

          * Verify the GPG signature using the public key.
     
            a. Download the public key at [keys.download.strangebee.com](https://keys.download.strangebee.com) using Wget or cURL.

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
            gpg --verify /opt/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip.asc /opt/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip
            ```

            d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors, don't unzip or install the package as its integrity or authenticity can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).


    3. Unzip the package.

        !!! info "Unzip paths"
            
            * Replace `/opt/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip` with the full path to the ZIP file you downloaded.
            * Replace `/opt/` after `-d` with the directory where you want to extract the contents of the archive.

        ```bash
        unzip /opt/cortex-{!includes/cortex-latest-version.md!lines=2}-2.zip -d /opt/
        sudo ln -s /opt/cortex-{!includes/cortex-latest-version.md!lines=2}-2 /opt/cortex
        ```

    4. Make the Cortex binary executable.

        ```bash
        cd /opt/
        chmod +x cortex
        ```

### Post-installation configuration

#### Running analyzers & responders with Docker

If you plan to use Cortex with _Analyzers & Responders_ running in Docker, ensure the `cortex` service account has appropriate permissions to interact with Docker:

```bash
sudo usermod -a -G docker cortex
```

#### Verify installation

After installation, you can check if Cortex is properly installed by running:

```bash
cortex --version
```

This should return the installed version of Cortex.

#### Configuration

Following settings are required to start Cortex successfully:

- [Secret key](secret.md) configuration
- [Database configuration](database.md)
- [Authentication](authentication.md)
- [Analyzers & Responders configuration](analyzers-responders.md)

Advanced configuration settings might be added to run the application successfully: 

- [Specific Docker parameters](parameters-docker.md)
- [Proxy settings](proxy-settings.md)
- [SSL configuration](ssl.md)

#### Start Cortex service

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

