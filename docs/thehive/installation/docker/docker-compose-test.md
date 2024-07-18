
# TheHive Setup for Testing Environment

## Introduction

This guide will assist you in setting up TheHive, using Docker Compose on an Ubuntu system. By following the steps outlined in this documentation, you will be able to install and configure TheHive along with its dependencies, specifically for testing in your test environment.

---

## Prerequisites

Ensure you have the following installed on your Ubuntu system:

- **Docker**: A platform to develop, ship, and run applications in containers.

- **Docker Compose**: A tool for defining and running multi-container Docker applications.

---

## Setting Up TheHive with Docker Compose

### Installing Docker

1. **Update your package lists to ensure you have the latest information:**

    ```bash
    sudo apt update
    ```

2. **Install Docker from the default Ubuntu repositories:**

    ```bash
    sudo apt install docker.io
    ```

&nbsp;

### Installing Docker Compose

1. **Install Docker Compose from the default Ubuntu repositories:**

    ```bash
    sudo apt install docker-compose
    ```

&nbsp;

### Start and Enable Docker Service

1. **Start the Docker service:**

    ```bash
    sudo systemctl start docker
    ```

2. **Enable Docker to start on boot:**

    ```bash
    sudo systemctl enable docker
    ```

&nbsp;

### Add Your User to the Docker Group (Optional)

1. **Add your current user to the Docker group to run Docker commands without `sudo`:**

```bash
sudo usermod -aG docker $USER
# Log out and log back in for the group change to take effect
```

&nbsp;

### Start the Docker Compose

1. **Prepare Docker Compose File**: Create a Docker Compose file to orchestrate the deployment of TheHive. You can use the following example as a starting point:

    !!! Example ""

    ```yaml
    version: '3.8'
    services:
      cassandra:
        image: 'cassandra:4.1'  # This specifies the Docker image for Cassandra, version 4.1.
        container_name: cassandra  # This sets the name of the container to 'cassandra'.
        hostname: cassandra  # This sets the hostname of the container to 'cassandra'.
        restart: always  # This ensures the container always restarts if it stops.
        volumes:
          - cassandra-data:/var/lib/cassandra  # This mounts a volume for Cassandra data storage.
          - cassandra-logs:/var/log/cassandra  # This mounts a volume for Cassandra log files.
        environment:
          - CASSANDRA_CLUSTER_NAME=TheHive  # This sets the Cassandra cluster name to 'TheHive'.
          - CASSANDRA_AUTHENTICATOR=PasswordAuthenticator  # This sets the authenticator to use passwords.
          - CASSANDRA_USER=${CASSANDRA_USER}  # This sets the Cassandra user from an environment variable.
          - CASSANDRA_PASSWORD_SEEDER=yes  # This indicates that the seeder will set the password.
          - CASSANDRA_PASSWORD=${CASSANDRA_PASSWORD}  # This sets the Cassandra password from an environment variable.
          - HEAP_NEWSIZE=1280M  # This sets the initial size of the heap memory.
          - MAX_HEAP_SIZE=1280M  # This sets the maximum size of the heap memory.
        deploy:
          resources:
            limits:
              memory: 4G  # This limits the memory usage to 4GB.
        networks:
          - thehive-test-network  # This connects the container to the 'thehive-test-network'.
        healthcheck: 
          test: cqlsh -u cassandra -p ${CASSANDRA_PASSWORD} cassandra -e 'show host' > /dev/null 2&>1 || exit 1  # This sets the health check command for Cassandra.
          interval: 2s  # This sets the interval between health checks to 2 seconds.
          timeout: 1s  # This sets the timeout for each health check to 1 second.
          retries: 3  # This sets the number of retries for the health check.
          start_period: 60s  # This sets the initial delay before starting health checks.

      elasticsearch:
        image: 'elasticsearch:7.17.19'  # This specifies the Docker image for Elasticsearch, version 7.17.19.
        container_name: elasticsearch  # This sets the name of the container to 'elasticsearch'.
        hostname: elasticsearch  # This sets the hostname of the container to 'elasticsearch'.
        restart: always  # This ensures the container always restarts if it stops.
        environment:
          - http.host=0.0.0.0  # This sets the HTTP host to listen on all interfaces.
          - discovery.type=single-node  # This configures Elasticsearch to run as a single node.
          - cluster.name=hive  # This sets the Elasticsearch cluster name to 'hive'.
          - thread_pool.search.queue_size=100000  # This sets the search thread pool queue size.
          - thread_pool.write.queue_size=100000  # This sets the write thread pool queue size.
          - bootstrap.memory_lock=true  # This locks the memory to prevent swapping.
          - xpack.security.enabled=false  # This disables X-Pack security features.
          - ES_JAVA_OPTS=-Xms256m -Xmx256m  # This sets the Java heap size for Elasticsearch.
        ulimits:
          nofile:
            soft: 65536  # This sets the soft limit for the number of open files.
            hard: 65536  # This sets the hard limit for the number of open files.
        volumes:
          - elasticsearch-data:/usr/share/elasticsearch/data  # This mounts a volume for Elasticsearch data storage.
          - elasticsearch-logs:/usr/share/elasticsearch/logs  # This mounts a volume for Elasticsearch log files.
        networks:
          - thehive-test-network  # This connects the container to the 'thehive-test-network'.
        healthcheck:
          test: curl -s -f elasticsearch:9200/_cat/health > /dev/null  || exit 1  # This sets the health check command for Elasticsearch.
          interval: 2s  # This sets the interval between health checks to 2 seconds.
          timeout: 1s  # This sets the timeout for each health check to 1 second.
          retries: 3  # This sets the number of retries for the health check.
          start_period: 60s  # This sets the initial delay before starting health checks.

      thehive:
        image: 'strangebee/thehive:5.3'  # This specifies the Docker image for TheHive, version 5.3.
        container_name: thehive  # This sets the name of the container to 'thehive'.
        hostname: thehive  # This sets the hostname of the container to 'thehive'.
        mem_limit: 1664m  # This limits the memory usage to 1664MB.
        environment:
          - MAX_HEAP_SIZE=1280M  # This sets the maximum heap size for TheHive.
          - HEAP_NEWSIZE=1280M  # This sets the initial heap size for TheHive.
          - JVM_OPTS="-XX:MaxMetaspaceSize=256m"  # This sets the JVM options for TheHive.
        restart: always  # This ensures the container always restarts if it stops.
        ports:
          - '0.0.0.0:9000:9000'  # This maps port 9000 on the host to port 9000 in the container.
        volumes:
          - ./thehive/config:/etc/thehive  # This mounts a volume for TheHive configuration files.
          - ./thehive/log:/var/log/thehive  # This mounts a volume for TheHive log files.
          - ./thehive/data/files:/opt/thp/thehive/files  # This mounts a volume for TheHive data files.
        command: '--no-config --no-config-secret'  # This specifies additional commands to run with the TheHive container.
        networks:
          - thehive-test-network  # This connects the container to the 'thehive-test-network'.
        depends_on:
          elasticsearch:
            condition: service_healthy  # This ensures TheHive waits until Elasticsearch is healthy.
          cassandra:
            condition: service_healthy  # This ensures TheHive waits until Cassandra is healthy.

    volumes:
      cassandra-data:  # This defines a named volume for Cassandra data.
      cassandra-logs:  # This defines a named volume for Cassandra logs.
      elasticsearch-data:  # This defines a named volume for Elasticsearch data.
      elasticsearch-logs:  # This defines a named volume for Elasticsearch logs.

    networks:
      thehive-test-network:  # This defines a custom network for the services.
    ```

2. **Run Docker Compose**: Execute the following command in the directory containing your Docker Compose file to start TheHive:

    ```bash
    sudo docker-compose up -d
    ```

---

## Verifying the Setup

1. **Check the status of the containers:**

    List the status of the containers to ensure they are running:

    ```bash
    sudo docker-compose ps
    ```

2. **View logs for troubleshooting:**

    Display the logs of the running containers to troubleshoot any issues:

    ```bash
    sudo docker-compose logs
    ```

---

## Accessing TheHive Application

1. **Determine the IP Address of your Ubuntu machine:**

    Get the IP address of your machine:

    ```bash
    hostname -I
    ```

2. **Access TheHive in your web browser:**

    Once the containers are up and running, access TheHive web interface by navigating to ``http://<IP_ADDRESS>:<PORT>`` in your web browser. For example, if your machine's IP address is `192.168.1.100` and TheHive is configured to run on port `9000`, go to:

    ```
    http://192.168.1.100:9000
    ```

3. **Default Login Credentials:**

    Use the default credentials to log in:

    - **Username:** `admin`
    - **Password:** `secret`

---

## Optional: Stopping and Removing Containers

If you need to stop and remove the containers, you can use the following commands:

1. **Stop the containers:**

    Stop the running containers:

    ```bash
    sudo docker-compose down
    ```

2. **Remove all stopped containers, unused networks, and dangling images:**

    Clean up your Docker environment:

    ```bash
    sudo docker system prune -a
    ```

---

## Configuration Files

### `application.conf`

The `application.conf` file contains settings related to the web server, such as the HTTP port. Ensure it has the correct configuration:

```conf
play.server.http.port = 9000
```

&nbsp;

### `secret.conf`

Contains the secret key for the application:

```conf
play.http.secret.key="supersecretkeyhere"
```

&nbsp;

### `logback.xml`

Contains logging configuration settings for TheHive application.

&nbsp;