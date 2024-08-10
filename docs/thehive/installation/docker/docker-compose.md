# TheHive Docker Baseline Configuration

## Introduction

This guide provides a baseline configuration for setting up TheHive using Docker Compose on an Ubuntu system. It outlines the steps necessary to install and configure TheHive and its dependencies. This configuration serves as a starting point that users can customize and enhance based on their specific requirements.

---

## Prerequisites

Ensure the following are installed on your Ubuntu system:

- **Docker**: A platform to develop, ship, and run applications in containers.
- **Docker Compose**: A tool for defining and running multi-container Docker applications.

---

## Setting Up TheHive with Docker Compose

1. **Create a dedicated directory for TheHive setup:**

    ```bash
    mkdir -p ~/thehive
    cd ~/thehive
    ```

2. **Create a configuration directory for TheHive:**

    Create a directory inside ``~/thehive`` folder:

    ```bash
    mkdir -p ~/thehive/thehive/config
    ```

    This directory will be used to store TheHive configuration files, ensuring they are properly organized and easily accessible.

4. **Create the configuration files:**

    **`application.conf`**: Create this file in `~/thehive/thehive/config` with the following content:

    ```conf
    include "/etc/thehive/secret.conf"

    # DATABASE CONFIGURATION
    db.janusgraph {
      storage {
          backend = cql
          hostname = ["cassandra"]
          cql {
          cluster-name = thehive
          keyspace = thehive
          }
      }
      index.search {
          backend = elasticsearch
          hostname = ["elasticsearch"]
          index-name = thehive
      }
    }

    # ATTACHMENTS STORAGE CONFIGURATION
    storage {
      ## Local filesystem
      provider: localfs
      localfs {
        location: /opt/thp/thehive/files
      }
    }

    # SERVICE CONFIGURATION
    stream.longPolling.refresh: 45 seconds
    play.http.context : "/"
    play.http.parser.maxDiskBuffer: 1GB
    play.http.parser.maxMemoryBuffer: 256kB
    ### Stream configuration
    stream {
      get {
        maxAttempts = 5
        minBackoff = 100 milliseconds
        maxBackoff = 500 milliseconds
        randomFactor = 0.2
      }
    }


    # CONNECTORS
    # Enable Cortex connector
    scalligraph.modules += org.thp.thehive.connector.cortex.CortexModule
    # Enable MISP connector
    scalligraph.modules += org.thp.thehive.connector.misp.MispModule
    ```

    &nbsp;

    **`logback.xml`**: Create this file in `~/thehive/thehive/config` with the following content:

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <configuration debug="false">

        <conversionRule conversionWord="coloredLevel"
                        converterClass="play.api.libs.logback.ColoredLevel"/>

        <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
            <file>${application.home:-.}/logs/application.log</file>
            <rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
                <fileNamePattern>${application.home:-.}/logs/application.%i.log.zip</fileNamePattern>
                <minIndex>1</minIndex>
                <maxIndex>10</maxIndex>
            </rollingPolicy>
            <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
                <maxFileSize>10MB</maxFileSize>
            </triggeringPolicy>
            <encoder>
                <pattern>%date [%level] from %logger in %thread %replace(\(%X{userId}@%X{organisation}\) ){'\(@\)
                    ',''}[%X{kamonTraceId}] %message%n%xException
                </pattern>
            </encoder>
        </appender>

        <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%date %coloredLevel %logger{15} %replace(\(%X{userId}@%X{organisation}\) ){'\(@\)
                    ',''}[%X{kamonTraceId}] %message%n%xException{10}
                </pattern>
            </encoder>
        </appender>

        <appender name="ASYNCFILE" class="ch.qos.logback.classic.AsyncAppender">
            <appender-ref ref="FILE"/>
        </appender>

        <appender name="ASYNCSTDOUT" class="ch.qos.logback.classic.AsyncAppender">
            <appender-ref ref="STDOUT"/>
        </appender>

        <!-- do not set the following logger to TRACE -->
        <logger name="org.thp.scalligraph.traversal" level="INFO"/>
        <logger name="org.reflections.Reflections" level="ERROR"/>
        <logger name="org.janusgraph.graphdb.database.management.ManagementLogger" level="OFF"/>
        <logger name="org.janusgraph.graphdb.database.IndexSerializer" level="ERROR"/>
        <logger name="org.apache.kafka" level="WARN"/>
        <logger name="org.docx4j" level="WARN"/>
        <logger name="org.docx4j.model.PropertyResolver" level="OFF" />
        <!-- Log Elasticsearch requests -->
        <!--<logger name="org.janusgraph.diskstorage.es.rest.RestElasticSearchClient" level="TRACE"/>-->
        <logger name="org.thp.scalligraph.models" level="INFO"/>
        <logger name="org.thp" level="INFO"/>

        <root level="INFO">
            <appender-ref ref="ASYNCFILE"/>
            <appender-ref ref="ASYNCSTDOUT"/>
        </root>

    </configuration>
    ```

    &nbsp;

    **`secret.conf`**: Use the following commands to create the file:

    ```bash
    key=$(dd if=/dev/urandom bs=1024 count=1 | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
    echo "play.http.secret.key=\"$key\"" | sudo tee -a ~/thehive/thehive/config/secret.conf
    ```

&nbsp;

### Installing Docker and Docker Compose

To install Docker Engine (which includes Docker Compose), follow the steps outlined in the Docker documentation: [Docker Engine Installation on Ubuntu](https://docs.docker.com/engine/install/ubuntu/).

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

3. **Add your current user to the Docker group (optional):**

    This allows running Docker commands without `sudo`:

    ```bash
    sudo usermod -aG docker $USER
    # Log out and log back in for the group change to take effect
    ```

&nbsp;

### Docker Compose Setup

Create a `docker-compose.yml` file in `~/thehive` with the following content:

=== "For Testing Environment"

    ```yaml
    services:
      cassandra:
        image: 'cassandra:4.1'
        container_name: cassandra
        hostname: cassandra
        restart: always
        volumes:
          - cassandra-data:/var/lib/cassandra
          - cassandra-logs:/var/log/cassandra
        environment:
          - CASSANDRA_CLUSTER_NAME=thehive
          - CASSANDRA_AUTHENTICATOR=PasswordAuthenticator
          - CASSANDRA_PASSWORD_SEEDER=yes
          - HEAP_NEWSIZE=200M
          - MAX_HEAP_SIZE=200M
        deploy:
          resources:
            limits:
              memory: 2G
        memswap_limit: 2G
        networks:
          - thehive-test-network
        healthcheck: 
          test: cqlsh -u cassandra -p cassandra cassandra -e 'show host' > /dev/null 2>&1 || exit 1
          interval: 10s
          timeout: 5s
          retries: 5
          start_period: 60s
      
      elasticsearch:
        image: 'elasticsearch:7.17.19'
        container_name: elasticsearch
        hostname: elasticsearch
        restart: always
        environment:
          - http.host=0.0.0.0
          - discovery.type=single-node
          - cluster.name=thehive
          - thread_pool.search.queue_size=100000
          - thread_pool.write.queue_size=100000
          - bootstrap.memory_lock=true
          - xpack.security.enabled=false
          - ES_JAVA_OPTS=-Xms1G -Xmx1G
        ulimits:
          nofile:
            soft: 65536
            hard: 65536
        volumes:
          - elasticsearch-data:/usr/share/elasticsearch/data
          - elasticsearch-logs:/usr/share/elasticsearch/logs
        deploy:
          resources:
            limits:
              memory: 2G
        memswap_limit: 2G
        networks:
          - thehive-test-network
        healthcheck:
          test: curl -s -f http://elasticsearch:9200/_cat/health > /dev/null || exit 1
          interval: 10s
          timeout: 5s
          retries: 5
          start_period: 60s
      
      thehive:
        image: 'strangebee/thehive:5.3'
        container_name: thehive
        hostname: thehive
        restart: always
        environment:
          - |
            JAVA_OPTS=
              -Xms1000m
              -Xmx1000m
              -XX:MaxMetaspaceSize=450m
              -XX:ReservedCodeCacheSize=250m
        ports:
          - '0.0.0.0:9000:9000'
        volumes:
          - ./thehive/config:/etc/thehive
          - ./thehive/log:/var/log/thehive
          - ./thehive/data/files:/opt/thp/thehive/files
        command: '--no-config --no-config-secret'
        deploy:
          resources:
            limits:
              memory: 2G
        memswap_limit: 2G
        networks:
          - thehive-test-network
        depends_on:
          elasticsearch:
            condition: service_healthy
          cassandra:
            condition: service_healthy

    volumes:
      cassandra-data:
      cassandra-logs:
      elasticsearch-data:
      elasticsearch-logs:

    networks:
      thehive-test-network:
    ```

=== "For Production Environment"

    ```yaml
    services:
      cassandra:
        image: 'cassandra:4.1'
        container_name: cassandra
        hostname: cassandra
        restart: always
        volumes:
          - cassandra-data:/var/lib/cassandra
          - cassandra-logs:/var/log/cassandra
        environment:
          - CASSANDRA_CLUSTER_NAME=thehive
          - CASSANDRA_AUTHENTICATOR=PasswordAuthenticator
          - CASSANDRA_PASSWORD_SEEDER=yes
          - HEAP_NEWSIZE=1G
          - MAX_HEAP_SIZE=4G
        deploy:
          resources:
            limits:
              memory: 6G
        memswap_limit: 6G
        networks:
          - thehive-production-network
        healthcheck: 
          test: cqlsh -u cassandra -p cassandra cassandra -e 'show host' > /dev/null 2>&1 || exit 1
          interval: 10s
          timeout: 5s
          retries: 5
          start_period: 60s
      
      elasticsearch:
        image: 'elasticsearch:7.17.19'
        container_name: elasticsearch
        hostname: elasticsearch
        restart: always
        environment:
          - http.host=0.0.0.0
          - discovery.type=single-node
          - cluster.name=thehive
          - thread_pool.search.queue_size=100000
          - thread_pool.write.queue_size=100000
          - bootstrap.memory_lock=true
          - xpack.security.enabled=false
          - ES_JAVA_OPTS=-Xms1G -Xmx1G
        ulimits:
          nofile:
            soft: 65536
            hard: 65536
        volumes:
          - elasticsearch-data:/usr/share/elasticsearch/data
          - elasticsearch-logs:/usr/share/elasticsearch/logs
        deploy:
          resources:
            limits:
              memory: 6G
        memswap_limit: 6G
        networks:
          - thehive-production-network
        healthcheck:
          test: curl -s -f http://elasticsearch:9200/_cat/health > /dev/null || exit 1
          interval: 10s
          timeout: 5s
          retries: 5
          start_period: 60s
      
      thehive:
        image: 'strangebee/thehive:5.3'
        container_name: thehive
        hostname: thehive
        restart: always
        environment:
          - |
            JAVA_OPTS=
              -Xms1000m
              -Xmx1000m
              -XX:MaxMetaspaceSize=450m
              -XX:ReservedCodeCacheSize=250m
        ports:
          - '0.0.0.0:9000:9000'
        volumes:
          - ./thehive/config:/etc/thehive
          - ./thehive/log:/var/log/thehive
          - ./thehive/data/files:/opt/thp/thehive/files
        command: '--no-config --no-config-secret'
        deploy:
          resources:
            limits:
              memory: 3G
        memswap_limit: 3G
        networks:
          - thehive-production-network
        depends_on:
          elasticsearch:
            condition: service_healthy
          cassandra:
            condition: service_healthy

    volumes:
      cassandra-data:
      cassandra-logs:
      elasticsearch-data:
      elasticsearch-logs:

    networks:
      thehive-production-network:
    ```

&nbsp;

Execute the following command in the `~/thehive` directory to start TheHive:

```bash
sudo docker compose up -d
```

&nbsp;

!!! Danger "Important Note:"
    The provided `docker-compose.yml` for production environment is a baseline configuration designed for a system with 16GB of RAM. Depending on your infrastructure, such as available memory, CPU capacity, and workload requirements, you may need to adjust the memory allocations, heap sizes, and other resource settings. It is essential to monitor the performance of your services and fine-tune these settings to ensure optimal operation within your environment. This configuration is meant as a starting point and should be customized based on the specific needs of your deployment.

&nbsp;

### Verifying the Setup

1. **Check the status of the containers:**

    ```bash
    sudo docker compose ps
    ```

2. **View logs for troubleshooting:**

    ```bash
    sudo docker compose logs
    ```

&nbsp;

### Accessing TheHive Application

1. **Determine the IP address of your Ubuntu machine:**

    ```bash
    hostname -I
    ```

2. **Access TheHive in your web browser:**

    Navigate to `http://<IP_ADDRESS>:9000` in your web browser, replacing `<IP_ADDRESS>` with your machine's IP address.

3. **Default Login Credentials:**

    - **Username:** `admin`
    - **Password:** `secret`

---

## Optional: Stopping and Removing Containers

1. **Stop the containers:**

    ```bash
    sudo docker compose down
    ```

2. **Remove all stopped containers, unused networks, and dangling images:**

    ```bash
    sudo docker system prune -a
    ```

---

## Configuration Files

### `application.conf`

Ensure the following setting is present:

```conf
play.server.http.port = 9000
```

### `secret.conf`

Contains the secret key for the application:

```conf
play.http.secret.key="supersecretkeyhere"
```

### `logback.xml`

Contains logging configuration settings for TheHive application.

&nbsp;