# Run Cortex with Docker

This topic provides step-by-step instructions for running Cortex with Docker or Podman.

## Prerequisites and alternatives

To run the Docker image, you need [Docker](https://www.docker.com/)—no surprises there. Alternatively, you can also use [Podman](https://podman.io/) as a compatible option.

## Default configuration of the Cortex Docker image

By default, the Docker image generates a Cortex configuration file with the following settings:

* It sets the Elasticsearch URI by resolving the host name `elasticsearch`.
* It uses the official locations for [analyzers](https://download.thehive-project.org/analyzers.json) and [responders](https://download.thehive-project.org/responders.json).
* It includes a generated secret to secure user sessions.

## Customizing Cortex Docker image behavior

You can customize the behavior of the Cortex Docker image using environment variables or command-line parameters:

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

## Overriding configuration with a custom file

The generated configuration includes the file `/etc/cortex/application.conf` at the end. You can override any setting by mounting your own `application.conf` file to this path.

!!! Example ""
    ```
    docker run --volume /path/to/my/application.conf:/etc/cortex/application.conf thehiveproject/cortex:latest --es-uri http://<elasticsearch-host>:9200
    ```

Cortex uses Docker to run analyzers and responders. When running Cortex inside a Docker container, you can:

* Grant Cortex access to the Docker or Podman service (recommended approach)
* Start a Docker service inside the Cortex Docker container

If your environment requires Docker registry authentication, add the following section to your Cortex `application.conf` file:

!!! Example ""
    ```
    docker {
      host = "<docker-host-url>"
      tlsVerify = true 
      certPath = "/path/to/ca/certificates"
      registry {
        user = "<registry-username>"
        password = "<registry-password>"
        email = "<registry-email>"
        url = "https://index.docker.io/v1/"
      }
    }
    ```

Usually, only the `registry` section needs configuration unless you connect to a remote Docker daemon.

## Running Cortex with Docker

### Using the host Docker service

To allow Cortex to use the Docker service, you must bind the Docker socket into the Cortex container. Since Cortex shares job files with analyzers, you also need to bind a shared folder between Cortex and the analyzers.

!!! Example ""
    ```
    docker run --volume /var/run/docker.sock:/var/run/docker.sock --volume /var/run/cortex/jobs:/tmp/cortex-jobs thehiveproject/cortex:latest --job-directory /tmp/cortex-jobs --docker-job-directory /var/run/cortex/jobs
    ```

Cortex creates Docker containers via the Docker socket `/var/run/docker.sock`. The directory `/var/run/cortex/jobs` stores temporary job files on the host, and `/tmp/cortex-jobs` is the corresponding path inside the container. Cortex requires both paths via `--job-directory` (inside container) and `--docker-job-directory` (host path) so job files are available to analyzers. Usually, when host and container paths are the same, `--docker-job-directory` can be omitted.

On Windows, Docker service is accessible through the named pipe `\\.\pipe\docker_engine`. The command changes accordingly:

!!! Example ""
    ```
    docker run --volume //./pipe/docker_engine://./pipe/docker_engine --volume C:\\CORTEX\\JOBS:/tmp/cortex-jobs thehiveproject/cortex:latest --job-directory /tmp/cortex-jobs --docker-job-directory C:\\CORTEX\\JOBS
    ```

### Running Docker inside Cortex container (Docker-in-Docker)

You can also run a Docker service inside the Cortex container itself—essentially Docker within Docker—by using the `--start-docker` parameter. Note that you must start the container in privileged mode.

!!! Example ""
    ```
    docker run --privileged thehiveproject/cortex:latest --start-docker
    ```

In this mode, you don’t need to bind any job directories since the Docker daemon runs inside the container.

### Using Docker Compose to start Cortex and Elasticsearch

Cortex requires Elasticsearch to run. You can use [Docker Compose](https://github.com/StrangeBeeCorp/docker) to start both services together, or install and configure Elasticsearch manually.

Docker Compose enables you to launch multiple containers and link them.

The following [docker-compose.yml](https://raw.githubusercontent.com/TheHive-Project/Cortex/master/docker/cortex/docker-compose.yml) file starts Elasticsearch and Cortex:

!!! Example ""
    ```
    version: "2"
    services:
      elasticsearch:
        image: elasticsearch:7.9.1
        environment:
          - http.host=0.0.0.0
          - discovery.type=single-node
          - script.allowed_types=inline
          - thread_pool.search.queue_size=100000
          - thread_pool.write.queue_size=10000
        volumes:
          - /path/to/data:/usr/share/elasticsearch/data
      cortex:
        image: thehiveproject/cortex:3.1.1
        environment:
          - job_directory=${job_directory}
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
          - ${job_directory}:${job_directory}
        depends_on:
          - elasticsearch
        ports:
          - "0.0.0.0:9001:9001"
    ```

Place this [Docker Compose file](https://raw.githubusercontent.com/TheHive-Project/Cortex/master/docker/docker-compose.yaml) and the corresponding [.env file](https://raw.githubusercontent.com/TheHive-Project/Cortex/master/docker/cortex/.env) in an empty folder, then run `docker-compose up`. Cortex is available on port 9001/tcp by default, which you can customize in the compose file.

!!! Tip "Advanced configuration"
    For advanced configuration, visit [the StrangeBee Docker Templates repository](https://github.com/TheHive-Project/Docker-Templates).

## Running Cortex with Podman

Podman is an open-source container engine designed as a drop-in replacement for Docker. It allows you to run containers without requiring a daemon and can run in rootless mode for improved security.

Like Docker, Podman can run the Cortex container image as well as its analyzers. The examples below assume you run the containers in rootful mode.

For Cortex to interact with Podman, it requires access to the [Podman socket](https://docs.podman.io/en/latest/markdown/podman-system-service.1.html). On some systems, Podman automatically installs and enables this socket service.

You can check whether the Podman socket service is running on your system with this command:

!!! Example ""
    ```shell
    systemctl status podman.socket
    ```

By default, the Podman socket resides at `/run/podman/podman.sock`. This path may vary depending on your system configuration.

!!! Example "Configuring Cortex to run analyzers with Podman"

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
      --es-uri http://<elasticsearch-ip>:9200
    ```

    With this setup, Cortex will use Podman to run analyzers inside the container.

!!! Warning "Image not found"

    Podman may encounter issues pulling Cortex analyzer images from the default Docker registry. To fix this, add `docker.io` as an unqualified registry in your Podman configuration.

    Edit `/etc/containers/registries.conf` and add:

    ```
    unqualified-search-registries = ['docker.io']
    ```

    After making this change, restart the Podman socket service to apply the update.

!!! Example "Docker in Podman"

    You can run Docker inside a Podman container by using the `--privileged` flag:

    ```shell
    podman run \
      --privileged \
      --rm \
      --name cortex \
      -p 9001:9001 \
      docker.io/thehiveproject/cortex:3.1.7 \
      --es-uri http://<elasticsearch-ip>:9200 \
      --start-docker
    ```

<h2>Next steps</h2>

* [Parameters for Docker](parameters-docker.md)