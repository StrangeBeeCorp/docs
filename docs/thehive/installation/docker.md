# Deploy TheHive with Docker Compose

In this guide, we're going to deploy and configure TheHive On-prem using Docker Compose.

By the end, you'll have a fully functional TheHive instance running in Docker containers.

We provide several deployment profiles depending on your performance requirements on [a dedicated GitHub repository](https://github.com/StrangeBeeCorp/docker/tree/main){target=_blank}, with [all services](../overview/index.md#architecture) configured automatically.

If you want to use only the TheHive Docker image, get it from [Docker Hub](https://hub.docker.com/r/strangebee/TheHive){target=_blank}. You'll need to install [other required services](../overview/index.md#architecture) separately.

!!! note "Guide scope"
    This guide covers deploying a new instance of TheHive using Docker Compose, with all components hosted on the same server.

    It doesn't cover:

    * Linux installations: For Linux installations, follow [Install TheHive on Linux Systems](installation-guide-linux-standalone-server.md).
    * Cluster deployments: Refer to [Setting up a Cluster with TheHive](deploying-a-cluster.md) for Linux, or [Deploy TheHive on Kubernetes](kubernetes.md) for Kubernetes deployments.
    * Version upgrades: For upgrading an existing instance, see [Upgrade from TheHive 5.x](upgrade-from-5.x.md) or [Upgrade from TheHive 4.x](upgrade-from-4.x.md).

!!! warning "Before you begin"
    To ensure a smooth deployment process, make sure you have:

    * A basic understanding of [TheHive architecture](../overview/index.md#architecture)
    * [System requirements fully met and verified](system-requirements.md) for Docker Compose deployment
    * At least `sudo` permissions

{% include-markdown "includes/data-protection-link.md" %}

## Step 1: Install required dependencies

Start by installing the necessary dependencies for deploying TheHive with Docker Compose.

* [Docker Engine](https://docs.docker.com/engine/install/){target=_blank}: version `v23.0.15` or later
* [Docker Compose plugin](https://docs.docker.com/compose/install/){target=_blank}: version `v2.20.2` or later
* [jq](https://jqlang.github.io/jq/){target=_blank}

### Verify dependencies installation

Run the following commands to ensure the dependencies are correctly installed:

* Check the Docker engine version:

```bash
docker version
```

* Confirm the current user can run Docker commands:

```bash
docker run hello-world
```

For details on post-installation steps and user permissions, see the [Docker post-installation guide](https://docs.docker.com/engine/install/linux-postinstall/){target=_blank}.

* Check the Docker Compose plugin version:

```bash
docker compose version
```

## Step 2: Clone the GitHub repository

Next, clone the [StrangeBee Docker repository](https://github.com/StrangeBeeCorp/docker.git){target=_blank} to your local machine:

```bash
git clone https://github.com/StrangeBeeCorp/docker.git
```

## Step 3: Choose your deployment profile

Before proceeding with any commands, take a moment to choose the deployment profile that best fits your needs. We provide three prebuilt profiles, each designed for different use cases and performance requirements.

### Profile n°1: *Testing environment* (TheHive and Cortex)

!!! danger "Testing only"
    This profile is for testing purposes only and must never be used in production

Single server deployment of both TheHive and [Cortex](../administration/cortex/about-cortex.md) for testing purposes.

Check the hardware requirements in the [Docker Compose deployment section](system-requirements.md#hardware-requirements).

### Profile n°2: *Production environment #1* (TheHive)

Single server deployment of TheHive for intensive use.

Check the hardware requirements in the [Docker Compose deployment section](system-requirements.md#hardware-requirements).

### Profile n°3: *Production environment #2* (TheHive)

Single server deployment of TheHive for high-performance requirements.

Check the hardware requirements in the [Docker Compose deployment section](system-requirements.md#hardware-requirements).

!!! info "Cortex deployment"
    Similar production deployment profiles are available for Cortex. See [Run Cortex with Docker](../../cortex/installation-and-configuration/run-cortex-with-docker.md) for details.

## Step 4: Understand the application stack content

=== "Testing environment profile"

    The Docker Compose file deploys the following components:

    * Cassandra: Database used by TheHive
    * Elasticsearch: Database for Cortex and indexing engine for TheHive
    * TheHive: Main application
    * Cortex: Analyzers and responders engine
    * Nginx: HTTPS reverse proxy

    ### Configuration and data files

    Each container has a dedicated folder for configuration, data, and log files.

    ```bash
    ├── cassandra
    ├── certificates
    ├── cortex
    ├── docker-compose.yml
    ├── dot.env.template
    ├── elasticsearch
    ├── nginx
    ├── README.md
    ├── scripts
    └── thehive
    ```

    ### Files and folders overview

    #### Cassandra

    ```bash
    cassandra
    ├── data
    └── logs
    ```

    * `./cassandra/data`: Database files.
    * `./cassandra/logs`: Log files.

    {% include-markdown "includes/docker-not-modify-files-manually.md" %}

    #### Elasticsearch

    ```bash
    elasticsearch
    ├── data
    └── logs
    ```

    * `./elasticsearch/data`: Database files.
    * `./elasticsearch/logs`: Log files.

    {% include-markdown "includes/docker-not-modify-files-manually.md" %}

    #### TheHive

    ```bash
    thehive
    ├── config
    │   ├── application.conf
    │   ├── index.conf.template
    │   ├── logback.xml
    │   └── secret.conf.template
    ├── data
    │   └── files
    └── logs
    ```

    * `./thehive/config`: Configuration files. `index.conf` and `secret.conf` are generated automatically when you use the `init.sh` script.
    * `./thehive/data/files`: File storage for TheHive.
    * `./thehive/logs`: Log files.

    {% include-markdown "includes/docker-not-modify-files-manually-except-config.md" %}

    #### Cortex

    ```bash
    cortex
    ├── config
    │   ├── application.conf
    │   ├── index.conf.template
    │   ├── logback.xml
    │   └── secret.conf.template
    ├── cortex-jobs
    ├── logs
    └── neurons
    ```

    * `./cortex/config`: Configuration files. `index.conf` and `secret.conf` are generated automatically when you use the `init.sh` script.
    * `./cortex/cortex-jobs`: Temporary data storage for analyzers and responders.
    * `./cortex/logs`: Log files.
    * `./cortex/neurons`: Folder for custom analyzers and responders.

    {% include-markdown "includes/docker-not-modify-files-manually-except-config.md" %}

    #### Nginx

    ```bash
    nginx
    ├── certs
    └── templates
        └── default.conf.template
    ```

    * `./nginx/templates/default.conf.template`: File used to initialize Nginx configuration when the container starts.

    {% include-markdown "includes/docker-not-modify-files-manually.md" %}

    #### Certificates

    This folder is empty by default. The application stack initializes with self-signed certificates.

    To use your own certificates, such as certificates signed by an internal authority, create the following files with these exact filenames:

    ```bash
    certificates
    ├── server.crt         ## Server certificate
    ├── server.key         ## Server private key
    └── ca.pem             ## Certificate Authority
    ```

    #### Scripts

    ```bash
    scripts
    ├── check_permissions.sh
    ├── generate_certs.sh
    ├── init.sh
    ├── output.sh
    ├── reset.sh
    ├── test_init_applications.sh
    ├── test_init_cortex.sh
    ├── test_init_thehive.sh
    ├── backup.sh
    └── restore.sh
    ```

    The application stack includes several utility scripts:

    * `check_permissions.sh`: Ensures proper permissions are set on files and folders.
    * `generate_certs.sh`: Generates a self-signed certificate for Nginx.
    * `init.sh`: Initializes the application stack.
    * `output.sh`: Displays output messages called by other scripts.
    * `reset.sh`: Resets the testing environment. Running this script deletes all data and containers.
    * `test_init_applications.sh`: Configures TheHive and Cortex by enabling analyzers, integrating Cortex with TheHive, and creating sample data like alerts, observables, and custom fields in TheHive.
    * `test_init_cortex.sh`: Helper script called by `test_init_applications.sh` to set up Cortex.
    * `test_init_thehive.sh`: Helper script called by `test_init_applications.sh` to set up TheHive.
    * `backup.sh`: Performs a cold backup of the current environment.
    * `restore.sh`: Restores the environment from a previously taken backup.

=== "Production environment #1 & #2 profiles"

    The Docker Compose file deploys the following components:

    * Cassandra: Database used by TheHive
    * Elasticsearch: Indexing engine for TheHive
    * TheHive: Main application
    * Nginx: HTTPS reverse proxy

    ### Configuration and data files

    Each container has a dedicated folder for configuration, data, and log files.

    ```bash
    ├── cassandra
    ├── certificates
    ├── docker-compose.yml
    ├── dot.env.template
    ├── elasticsearch
    ├── nginx
    ├── README.md
    ├── scripts
    └── thehive
    ```

    ### Files and folders overview

    #### Cassandra

    ```bash
    cassandra
    ├── data
    └── logs
    ```

    * `./cassandra/data`: Database files.
    * `./cassandra/logs`: Log files.

    {% include-markdown "includes/docker-not-modify-files-manually.md" %}

    #### Elasticsearch

    ```bash
    elasticsearch
    ├── data
    └── logs
    ```

    * `./elasticsearch/data`: Database files.
    * `./elasticsearch/logs`: Log files.

    {% include-markdown "includes/docker-not-modify-files-manually.md" %}

    #### TheHive

    ```bash
    thehive
    ├── config
    │   ├── application.conf
    │   ├── index.conf.template
    │   ├── logback.xml
    │   └── secret.conf.template
    ├── data
    │   └── files
    └── logs
    ```

    * `./thehive/config`: Configuration files. `index.conf` and `secret.conf` are generated automatically when you use the `init.sh` script.
    * `./thehive/data/files`: File storage for TheHive.
    * `./thehive/logs`: Log files.

    {% include-markdown "includes/docker-not-modify-files-manually-except-config.md" %}

    #### Nginx

    ```bash
    nginx
    ├── certs
    └── templates
        └── default.conf.template
    ```

    * `./nginx/templates/default.conf.template`: File used to initialize Nginx configuration when the container starts.

    {% include-markdown "includes/docker-not-modify-files-manually.md" %}

    #### Certificates

    This folder is empty by default. The application stack initializes with self-signed certificates.

    To use your own certificates, such as certificates signed by an internal authority, create the following files with these exact filenames:

    ```bash
    certificates
    ├── server.crt         ## Server certificate
    ├── server.key         ## Server private key
    └── ca.pem             ## Certificate Authority
    ```

    #### Scripts

    ```bash
    scripts
    ├── check_permissions.sh
    ├── generate_certs.sh
    ├── init.sh
    ├── output.sh
    ├── reset.sh
    ├── backup.sh
    └── restore.sh
    ```

    The application stack includes several utility scripts:

    * `check_permissions.sh`: Ensures proper permissions are set on files and folders.
    * `generate_certs.sh`: Generates a self-signed certificate for Nginx.
    * `init.sh`: Initializes the application stack.
    * `output.sh`: Displays output messages called by other scripts.
    * `reset.sh`: Resets the testing environment. Running this script deletes all data and containers.
    * `backup.sh`: Performs a cold backup of the current environment. See [# Perform a Cold Backup for a Stack Running with Docker Compose](../operations/backup-restore/backup/cold-backup/docker-compose.md) for more details.
    * `restore.sh`: Restores the environment from a previously taken backup. See [Restore a Cold Backup for a Stack Running with Docker Compose](../operations/backup-restore/restore/cold-restore/docker-compose.md) for more details.

## Step 5: Go to the selected profile

Navigate to the directory of your chosen profile.

For example, to select the *Production environment #1* profile:

```bash
cd docker/prod1-thehive
```

## Step 6: Initialize TheHive

Before starting TheHive, we need to initialize the environment using the provided `init.sh` script.

This script automates several critical setup tasks:

* Prompts for a server name to include in the Nginx server certificate.
* Initializes the `secret.conf` configuration files for TheHive and Cortex.
* Generates a self-signed certificate if none exists in the `./certificates` directory.
* Creates a `.env` file with user/group information and application settings.
* Generates a random password for Elasticsearch authentication.
* Verifies file and folder permissions to ensure proper access rights.

!!! tip "Elasticsearch password"
    If you need to retrieve the Elasticsearch password, check the `.env` file.

!!! note "User permissions"
    TheHive will run under the user account and group that execute the initialization script. Ensure you're using an appropriate user with the necessary permissions.

Execute the initialization script to set up the necessary configurations:

```bash
bash ./scripts/init.sh
```

## Step 7: Start TheHive

Once initialization is complete, start all services using Docker Compose.

```bash
docker compose up -d
```

If TheHive fails to start or you encounter errors, stop the running containers and restart without the `-d` flag to display real-time logs in your terminal:

```bash
docker compose down
docker compose up
```

## Step 8: Access TheHive

=== "Testing environment profile"

    Open your browser and navigate to [`http://localhost/thehive`](http://localhost/thehive){target=_blank} or use the IP address of the server running Docker Compose.

=== "Production environment #1 & #2 profiles"

    * Without DNS: Open your browser and navigate to [`http://localhost`](http://localhost){target=_blank} or use the IP address of the server running Docker Compose.

    * With DNS and a valid certificate: Use the public URL defined in `application.baseUrl`. See [Configure HTTPS for TheHive With a Reverse Proxy](../configuration/ssl/configure-https-reverse-proxy.md).

For additional Docker entrypoint options, see [TheHive Docker Entrypoint Settings](../configuration/thehive-docker-entrypoint-settings.md).

<h2>Next steps</h2>

* [Turn Off The Cortex Integration](../configuration/turn-off-cortex-connector.md)
* [Turn Off The MISP Integration](../configuration/turn-off-misp-connector.md)
* [Update TheHive Service Configuration](../configuration/update-service-configuration.md)
* [Update Log Configuration](../configuration/update-log-configuration.md)
* [Enable the GDPR Compliance Feature](../configuration/enable-gdpr.md)
* [Configure HTTPS for TheHive With a Reverse Proxy](../configuration/ssl/configure-https-reverse-proxy.md)
* [Configure JVM Trust for SSL/TLS Certificates](../configuration/ssl/configure-ssl-jvm.md)
* [Perform a Cold Backup for a Stack Running with Docker Compose](../operations/backup-restore/backup/cold-backup/docker-compose.md)
* [Set Up Monitoring for TheHive with Prometheus and Grafana](../operations/monitoring.md)