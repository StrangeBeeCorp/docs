# Deploy a Demo Docker Environment

Deploy a demo environment to trial TheHive and Cortex with sample data using Docker Compose.

For a simpler setup using a pre-packaged VM image, see [Set Up a Demo Virtual Machine Environment](vm-demo.md).

!!! danger "Testing only"
    This environment is for testing purposes only and must never be used in production.

!!! tip "Platinum trial"
    The Docker installation of TheHive with Cortex includes a 14-day Platinum trial license. After the trial ends, TheHive switches to read-only mode.

!!! warning "Before you begin"
    To ensure a smooth deployment process, make sure you have:

    * A basic understanding of [TheHive architecture](../thehive/overview/index.md#architecture)
    * [System requirements](../thehive/installation/system-requirements.md) fully met and verified for a Docker Compose *Testing* environment
    * At least `sudo` permissions

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

## Step 3: Go to the *Testing* profile

Navigate to the testing environment directory:

```bash
cd docker/testing
```

## Step 4: Initialize the environment

Before starting TheHive and Cortex, initialize the environment using the provided `init.sh` script.

```bash
bash ./scripts/init.sh
```

This script automates several critical setup tasks:

* Prompts for a server name to include in the Nginx server certificate.
* Initializes the `secret.conf` and `index.conf` configuration files for TheHive and Cortex.
* Generates a self-signed certificate if none exists in the `./certificates` directory.
* Creates a `.env` file with user/group information and application settings.
* Generates a random password for Elasticsearch authentication.
* Verifies file and folder permissions to ensure proper access rights.

!!! tip "Elasticsearch password"
    If you need to retrieve the Elasticsearch password, check the `.env` file.

!!! note "User permissions"
    TheHive and Cortex will run under the user account and group that execute the initialization script. That user must have read/write access to the mounted host directories created during initialization.

## Step 5: Start the environment

Start all services using Docker Compose:

```bash
docker compose up -d
```

Check that all containers are running.

```bash
docker compose ps
```

All services should show a running status. If any service fails to start, stop the containers and restart without the `-d` flag to display real-time logs:

```bash
docker compose down
docker compose up
```

## Step 6: Load demo data

Run the following script to configure TheHive and Cortex with sample data:

```bash
bash ./scripts/test_init_applications.sh
```

This script:

* Initializes Cortex and TheHive with a `Demo` organization and `thehive` user account
* Integrates TheHive with Cortex
* Enables some free analyzers
* Adds sample data including an alert, a case template, custom fields, MISP taxonomies, and MITRE ATT&CK data

## Step 7: Access TheHive and Cortex

* TheHive: Open your browser and navigate to [`http://localhost/thehive`](http://localhost/thehive){target=_blank} or use the IP address of the server running Docker Compose.

* Cortex: Open your browser and navigate to [`http://localhost/cortex`](http://localhost/cortex){target=_blank} or use the IP address of the server running Docker Compose.

Then use the following default users and passwords to access TheHive and Cortex:

| Application | User type | Username | Password |
| ----------- | --------- | -------- | -------- |
| TheHive | Admin | `admin@thehive.local` | `secret` |
| TheHive | Org Admin | `thehive@thehive.local` | `thehive1234` |
| Cortex | Admin | `admin` | `thehive1234` |
| Cortex | Org Admin | `thehive` | `thehive1234` |

## Reset your environment

!!! danger "Irreversible action"
    This script deletes all data and containers.

Run the following script to delete all data in the testing environment:

```bash
bash ./scripts/reset.sh
```

## Application stack

This section describes the components and file structure deployed by the Docker Compose file. Use it as a reference when troubleshooting or customizing your environment.

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

## Operations

All commands must be run from the `docker/testing` directory where the `docker-compose.yml` file is located.

### Configure TheHive

{% include-markdown "includes/maintenance-window-required.md" %}

After modifying TheHive configuration, restart the service.

* Configuration file: `./thehive/config/application.conf`

* Restart command:

```bash
docker compose restart thehive
```

The following documentation pages explain how to configure specific settings in `application.conf`:

* [Update TheHive Service Configuration](../thehive/configuration/update-service-configuration.md)
* [Configure Database and Index Authentication](../thehive/configuration/configure-authentication-cassandra-elasticsearch.md)
* [TheHive Database and Index Connection Settings](../thehive/configuration/cassandra-elasticsearch-connection-settings.md)
* [Turn Off the Cortex Integration](../thehive/configuration/turn-off-cortex-connector.md)
* [Turn Off the MISP Integration](../thehive/configuration/turn-off-misp-connector.md)

### Configure Cortex

{% include-markdown "includes/maintenance-window-required.md" %}

After modifying Cortex configuration, restart the service.

* Configuration file: `./cortex/config/application.conf`

* Restart command:

```bash
docker compose restart cortex
```

The following documentation pages explain how to configure specific settings in `application.conf`:

* [Database Configuration](../cortex/installation-and-configuration/database.md)
* [Authentication](../cortex/installation-and-configuration/authentication.md)
* [Proxy Settings](../cortex/installation-and-configuration/proxy-settings.md)
* [Analyzers and Responders](../cortex/installation-and-configuration/analyzers-responders.md)
* [Advanced Configuration](../cortex/installation-and-configuration/advanced-configuration.md)

## Troubleshooting

* TheHive service logs: `./thehive/log/application.log`
* Cortex service logs: `./cortex/log/application.log`

<h2>Next steps</h2>

* [TheHive Troubleshooting](../thehive/operations/troubleshooting.md)
* [Deploy TheHive with Docker Compose](../thehive/installation/docker.md)
* [Run Cortex with Docker](../cortex/installation-and-configuration/run-cortex-with-docker.md)