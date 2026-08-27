# Run Cortex with Docker

Cortex runs on Docker using official container images.

You can run Cortex with Docker in several ways:

* Deploy Cortex and Elasticsearch as a production-ready stack using Docker Compose—the recommended approach, covered below.
* Run [a standalone Cortex container](#running-cortex-with-a-standalone-container) directly with `docker run`, with or without Docker-in-Docker.
* Run Cortex with [Podman](#running-cortex-with-podman) instead of Docker.

In every method, Cortex also uses Docker to run analyzers and responders, so it needs access to a Docker or Podman socket.

Regardless of the method you choose, you can [customize how the Cortex image behaves at startup](#customizing-cortex-docker-image-behavior) using environment variables or command-line parameters.

## Deploy Cortex with Docker Compose

Two deployment profiles for production environments are available on [a dedicated GitHub repository](https://github.com/StrangeBeeCorp/docker/tree/main){target=_blank}, with all services configured automatically.

If you want to use only the Cortex Docker image, get it from [Docker Hub](https://hub.docker.com/r/thehiveproject/cortex){target=_blank}. You'll need to install Elasticsearch separately.

!!! tip "Trying out Cortex?"
    This section covers production deployments only. To trial Cortex with TheHive and sample data, see [Deploy a Demo Docker Environment](../../resources/docker-demo.md).

!!! note "Guide scope"
    This section covers deploying a new instance of Cortex using Docker Compose, with all components hosted on the same server.

    It doesn't cover:

    * Package installations: For package installations, follow the [step-by-step guide](step-by-step-guide.md).
    * Cluster deployments: Refer to [Deploy Cortex on Kubernetes](deploy-cortex-on-kubernetes.md) for Kubernetes deployments.

!!! warning "Before you begin"
    To ensure a smooth deployment process, make sure you have:

    * A basic understanding of [the role and architecture of Cortex](../index.md)
    * At least `sudo` permissions

### Step 1: Install required dependencies

Start by installing the necessary dependencies for deploying Cortex with Docker Compose.

* [Docker Engine](https://docs.docker.com/engine/install/){target=_blank}: version `v23.0.15` or later
* [Docker Compose plugin](https://docs.docker.com/compose/install/){target=_blank}: version `v2.20.2` or later
* [jq](https://jqlang.github.io/jq/){target=_blank}

#### Verify dependencies installation

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

### Step 2: Clone the GitHub repository

Next, clone the [StrangeBee Docker repository](https://github.com/StrangeBeeCorp/docker.git){target=_blank} to your local machine:

```bash
git clone https://github.com/StrangeBeeCorp/docker.git
```

### Step 3: Choose your deployment profile

Before proceeding with any commands, take a moment to choose the deployment profile that best fits your needs. Two prebuilt profiles are available for production environments, each designed for different use cases and performance requirements.

#### Profile n°1: *Production environment #1* (Cortex)

Single server deployment of Cortex for standard production workloads.

Check the hardware requirements in the [System Requirements](system-requirements.md#hardware-requirements).

#### Profile n°2: *Production environment #2* (Cortex)

Single server deployment of Cortex for high-performance or resource-intensive workloads.

Check the hardware requirements in the [System Requirements](system-requirements.md#hardware-requirements).

!!! info "TheHive deployment"
    Similar production deployment profiles are available for TheHive. See [Deploy TheHive with Docker Compose](../../thehive/installation/docker.md) for details.

### Step 4: Review the application stack

The Docker Compose file deploys the following components:

* Elasticsearch: Database used by Cortex
* Cortex: Main application
* Nginx: HTTPS reverse proxy

#### Configuration and data files

Each container has a dedicated folder for configuration, data, and log files.

```bash
├── certificates
├── cortex
├── docker-compose.yml
├── dot.env.template
├── elasticsearch
├── nginx
├── README.md
└── scripts
```

#### Files and folders overview

##### Elasticsearch

```bash
elasticsearch
├── data
└── logs
```

* `./elasticsearch/data`: Database files.
* `./elasticsearch/logs`: Log files.

{% include-markdown "includes/docker-not-modify-files-manually.md" %}

##### Cortex

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

##### Nginx

```bash
nginx
├── certs
└── templates
    └── default.conf.template
```

* `./nginx/templates/default.conf.template`: File used to initialize Nginx configuration when the container starts.

{% include-markdown "includes/docker-not-modify-files-manually.md" %}

##### Certificates

This folder is empty by default. The application stack initializes with self-signed certificates.

To use your own certificates, such as certificates signed by an internal authority, create the following files with these exact filenames:

```bash
certificates
├── server.crt         ## Server certificate
├── server.key         ## Server private key
└── ca.pem             ## Certificate Authority
```

##### Scripts

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
* `reset.sh`: Resets the environment. Running this script deletes all data and containers.
* `backup.sh`: Performs a cold backup of the current environment.
* `restore.sh`: Restores the environment from a previously taken backup.

### Step 5: Go to the selected profile

Navigate to the directory of your chosen profile.

For example, to select the *Production environment #1* profile:

```bash
cd docker/prod1-cortex
```

### Step 6: Initialize Cortex

Before starting Cortex, initialize the environment using the provided `init.sh` script.

```bash
bash ./scripts/init.sh
```

This script automates several critical setup tasks:

* Prompts for a server name to include in the Nginx server certificate.
* Initializes the `secret.conf` and `index.conf` configuration files for Cortex.
* Generates a self-signed certificate if none exists in the `./certificates` directory.
* Creates a `.env` file with user/group information and application settings.
* Generates a random password for Elasticsearch authentication.
* Verifies file and folder permissions to ensure proper access rights.

!!! tip "Elasticsearch password"
    If you need to retrieve the Elasticsearch password, check the `.env` file.

!!! note "User permissions"
    Cortex will run under the user account and group that execute the initialization script. That user must have read/write access to the mounted host directories created during initialization.

### Step 7: Start Cortex

Once initialization is complete, start all services using Docker Compose.

```bash
docker compose up -d
```

Check that all containers are running.

```bash
docker compose ps
```

All services should show a running status. If Cortex fails to start or you encounter errors, stop the running containers and restart without the `-d` flag to display real-time logs in your terminal:

```bash
docker compose down
docker compose up
```

### Step 8: Access Cortex

Open your browser and navigate to the IP address or hostname of the server running Docker Compose.

For additional Docker entrypoint options, see [Customizing Cortex Docker image behavior](#customizing-cortex-docker-image-behavior) below.

## Running Cortex with a standalone container

Cortex uses Docker to run analyzers and responders. When running Cortex inside a Docker container, you can:

* Grant Cortex access to the Docker or Podman service (recommended approach)
* Start a Docker service inside the Cortex Docker container

### Using the host Docker service

To allow Cortex to use the Docker service, you must bind the Docker socket into the Cortex container. Since Cortex shares job files with analyzers, you also need to bind a shared folder between Cortex and the analyzers.

!!! example ""
    ```
    docker run --volume /var/run/docker.sock:/var/run/docker.sock --volume /var/run/cortex/jobs:/tmp/cortex-jobs thehiveproject/cortex:latest --job-directory /tmp/cortex-jobs --docker-job-directory /var/run/cortex/jobs
    ```

Cortex creates Docker containers via the Docker socket `/var/run/docker.sock`. The directory `/var/run/cortex/jobs` stores temporary job files on the host, and `/tmp/cortex-jobs` is the corresponding path inside the container. Cortex requires both paths via `--job-directory` (inside container) and `--docker-job-directory` (host path) so job files are available to analyzers. Usually, when host and container paths are the same, `--docker-job-directory` can be omitted.

On Windows, Docker service is accessible through the named pipe `\\.\pipe\docker_engine`. The command changes accordingly:

!!! example ""
    ```
    docker run --volume //./pipe/docker_engine://./pipe/docker_engine --volume C:\\CORTEX\\JOBS:/tmp/cortex-jobs thehiveproject/cortex:latest --job-directory /tmp/cortex-jobs --docker-job-directory C:\\CORTEX\\JOBS
    ```

### Running Docker inside Cortex container (Docker-in-Docker)

You can also run a Docker service inside the Cortex container itself by using the `--start-docker` parameter. You must start the container in privileged mode.

!!! example ""
    ```
    docker run --privileged thehiveproject/cortex:latest --start-docker
    ```

In this mode, you don't need to bind any job directories since the Docker daemon runs inside the container.

## Running Cortex with Podman

Podman is an open-source container engine designed as a drop-in replacement for Docker. It allows you to run containers without requiring a daemon and can run in rootless mode for improved security.

Like Docker, Podman can run the Cortex container image as well as its analyzers. The examples below assume you run the containers in rootful mode.

For Cortex to interact with Podman, it requires access to the [Podman socket](https://docs.podman.io/en/latest/markdown/podman-system-service.1.html){target=_blank}. On some systems, Podman automatically installs and enables this socket service.

You can check whether the Podman socket service is running on your system with this command:

!!! example ""
    ```shell
    sudo systemctl status podman.socket
    ```

By default, the Podman socket resides at `/run/podman/podman.sock`. This path may vary depending on your system configuration.

!!! example "Configuring Cortex to run analyzers with Podman"

    To allow Cortex to run analyzers with Podman, mount the Podman socket inside the container at `/var/run/docker.sock`:

    ```shell
    podman run \
      --rm \
      --name cortex \
      -p 9001:9001 \
      -v /var/run/cortex/jobs:/tmp/cortex-jobs \
      -v /run/podman/podman.sock:/var/run/docker.sock \
      docker.io/thehiveproject/cortex:3.1.7 \
      --job-directory /tmp/cortex-jobs \
      --docker-job-directory /var/run/cortex/jobs \
      --es-uri http://<elasticsearch_ip>:9200
    ```

    With this setup, Cortex will use Podman to run analyzers inside the container.

!!! warning "Image not found"

    Podman may encounter issues pulling Cortex analyzer images from the default Docker registry. To fix this, add `docker.io` as an unqualified registry in your Podman configuration.

    Edit `/etc/containers/registries.conf` and add:

    ```
    unqualified-search-registries = ['docker.io']
    ```

    After making this change, restart the Podman socket service to apply the update.

!!! example "Docker in Podman"

    You can run Docker inside a Podman container by using the `--privileged` flag:

    ```shell
    podman run \
      --privileged \
      --rm \
      --name cortex \
      -p 9001:9001 \
      docker.io/thehiveproject/cortex:3.1.7 \
      --es-uri http://<elasticsearch_ip>:9200 \
      --start-docker
    ```

## Customizing Cortex Docker image behavior

By default, the Docker image generates a Cortex configuration file with the following settings:

* It sets the Elasticsearch URI by resolving the host name `elasticsearch`.
* It uses the official locations for [analyzers](https://catalogs.download.strangebee.com/latest/json/analyzers.json){target=_blank} and [responders](https://catalogs.download.strangebee.com/latest/json/responders.json){target=_blank}.
* It includes a generated secret to secure user sessions.

You can further customize this behavior using environment variables or command-line parameters:

| Parameter            | Environment variable         | Description                                       |
|----------------------|----------------------|---------------------------------------------------|
| `--no-config`        | `no_config=1`        | Don't configure Cortex                           |
| `--no-config-secret` | `no_config_secret=1` | Don't add the random secret to the configuration |
| `--no-config-es` | `no_config_es=1` | Don't add Elasticsearch hosts to the configuration
| `--es-uri <uri>` | `es_uri=<uri>` | Configure Elasticsearch hosts with this string (format: http(s)://host:port,host:port(/prefix)?querystring)
| `--es-hostname <host>` | `es_hostname=host` | Resolve this host name to locate Elasticsearch instances
| `--secret <secret>` | `secret=<secret>` | Secret used to secure sessions
| `--show-secret` | `show_secret=1` | Display the generated secret
| `--job-directory <dir>` | `job_directory=<dir>` | Directory to store job files
| `--docker-job-directory <dir>` | `docker_job_directory=<dir>` | Host directory corresponding to the job directory (outside the container)
| `--analyzer-url <url>` | `analyzer_urls=<url>,<url>,...` | URLs or paths where analyzers are located
| `--responder-url <url>` | `responder_urls=<url>,<url>,...` | URLs or paths where responders are located
| `--start-docker` | `start_docker=1` | Start an internal Docker daemon inside the container to run analyzers/responders
| `--daemon-user <user>` | `daemon_user=<user>` | Run Cortex using this user

The command-line parameters and environment variables documented here are used to customize Cortex when the container starts. These are converted into settings inside the `application.conf` configuration file, whose available options and structure are documented separately in [Parameters for Docker](parameters-docker.md).

### Overriding configuration with a custom file

The generated configuration includes the file `/etc/cortex/application.conf` at the end. You can override any setting by mounting your own `application.conf` file to this path.

!!! example ""
    ```
    docker run --volume /path/to/my/application.conf:/etc/cortex/application.conf thehiveproject/cortex:latest --es-uri http://<elasticsearch_host>:9200
    ```

If your environment requires Docker registry authentication, add the following block to your Cortex `application.conf` file:

!!! example ""
    ```
    docker {
      host = "<docker_host_url>"
      tlsVerify = true 
      certPath = "/path/to/ca/certificates"
      registry {
        user = "<registry_username>"
        password = "<registry_password>"
      }
    }
    ```

Only configure the `host`, `tlsVerify`, and `certPath` parameters if you're connecting to a remote Docker daemon. You don't need to set them for local Docker setups.

Use the `registry` section only when you pull images from a private Docker registry that requires authentication.

!!! warning "Registry behavior"

    * Public registries like Docker Hub typically don't need credentials. Adding authentication to public pulls may cause failures.
    * Cortex supports only one registry credentials set for all image pulls. It can't handle different credentials for different registries.
    * The target registry is determined by the FQDN, such as `harbor.example.com/project/image:tag`.

<h2>Next steps</h2>

* [Parameters for Docker](parameters-docker.md)
* [Deploy TheHive with Docker Compose](../../thehive/installation/docker.md)
* [Deploy a Demo Docker Environment](../../resources/docker-demo.md)
