# TheHive Setup for Testing Environment

## Introduction

This guide will assist you in setting up TheHive using Docker Compose on an Ubuntu system. By following the steps outlined in this documentation, you will be able to install and configure TheHive along with its dependencies, specifically for testing purposes in your test environment.

---

## Prerequisites

Ensure the following are installed on your Ubuntu system:

- **Docker**: A platform to develop, ship, and run applications in containers.
- **Docker Compose**: A tool for defining and running multi-container Docker applications.

---

## Setting Up TheHive with Docker Compose

1. **Create a dedicated directory for TheHive setup:**

    ```bash
    mkdir -p /opt/thehive
    cd /opt/thehive
    ```

2. **Create a `.env` file to define environment variables:**

    In the `/opt/thehive` directory, create a `.env` file with the following content:

    ```env
    CASSANDRA_USER=cassandra
    CASSANDRA_PASSWORD=YourCassandraPassword
    ```

    Replace `YourCassandraPassword` with a strong password for the Cassandra database.

3. **Create a configuration directory for TheHive:**

    Create a directory to hold TheHive configuration files:

    ```bash
    mkdir -p /opt/thehive/thehive/config
    ```

    This directory will be used to store TheHive configuration files, ensuring they are properly organized and easily accessible.

4. **Create the configuration files:**

    **`application.conf`**: Create this file in `/opt/thehive/thehive/config` with the following content:

    ```conf
    include "/etc/thehive/secret.conf"

    # DATABASE CONFIGURATION
    db.janusgraph {
      storage {
          backend = cql
          hostname = ["cassandra"]
          cql {
          cluster-name = thp
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

    **`logback.xml`**: Create this file in `/opt/thehive/thehive/config` with the following content:

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
        <logger name="org.reflections8.Reflections" level="ERROR"/>
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

    **`secret.conf`**: Create this file in `/opt/thehive/thehive/config` with the following content:

    ```conf
    play.http.secret.key="supersecretkeyhere"
    ```

### Installing Docker and Docker Compose

1. **Update your package lists:**

    ```bash
    sudo apt update
    ```

2. **Install Docker:**

    ```bash
    sudo apt install docker.io
    ```

3. **Install Docker Compose:**

    ```bash
    sudo apt install docker-compose
    ```

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

### Docker Compose Setup

1. **Create a Docker Compose file:**

    Create a `docker-compose.yml` file in `/opt/thehive` with the following content:

    ```yaml
    version: '3.8'
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
          - CASSANDRA_CLUSTER_NAME=TheHive
          - CASSANDRA_AUTHENTICATOR=PasswordAuthenticator
          - CASSANDRA_USER=${CASSANDRA_USER}
          - CASSANDRA_PASSWORD_SEEDER=yes
          - CASSANDRA_PASSWORD=${CASSANDRA_PASSWORD}
          - HEAP_NEWSIZE=1280M
          - MAX_HEAP_SIZE=1280M
        deploy:
          resources:
            limits:
              memory: 4G
        networks:
          - thehive-test-network
        healthcheck:
          test: cqlsh -u ${CASSANDRA_USER} -p ${CASSANDRA_PASSWORD} cassandra -e 'show host' > /dev/null 2>&1 || exit 1
          interval: 2s
          timeout: 1s
          retries: 3
          start_period: 60s

      elasticsearch:
        image: 'elasticsearch:7.17.19'
        container_name: elasticsearch
        hostname: elasticsearch
        restart: always
        environment:
          - http.host=0.0.0.0
          - discovery.type=single-node
          - cluster.name=hive
          - thread_pool.search.queue_size=100000
          - thread_pool.write.queue_size=100000
          - bootstrap.memory_lock=true
          - xpack.security.enabled=false
          - ES_JAVA_OPTS=-Xms256m -Xmx256m
        ulimits:
          nofile:
            soft: 65536
            hard: 65536
        volumes:
          - elasticsearch-data:/usr/share/elasticsearch/data
          - elasticsearch-logs:/usr/share/elasticsearch/logs
        networks:
          - thehive-test-network
        healthcheck:
          test: curl -s -f elasticsearch:9200/_cat/health > /dev/null || exit 1
          interval: 2s
          timeout: 1s
          retries: 3
          start_period: 60s

      thehive:
        image: 'strangebee/thehive:5.3'
        container_name: thehive
        hostname: thehive
        mem_limit: 1664m
        environment:
          - MAX_HEAP_SIZE=1280M
          - HEAP_NEWSIZE=1280M
          - JVM_OPTS="-XX:MaxMetaspaceSize=256m"
        restart: always
        ports:
          - '0.0.0.0:9000:9000'
        volumes:
          - ./thehive/config:/etc/thehive
          - ./thehive/log:/var/log/thehive
          - ./thehive/data/files:/opt/thp/thehive/files
        command: '--no-config --no-config-secret'
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

2. **Run Docker Compose:**

    Execute the following command in the `/opt/thehive` directory to start TheHive:

    ```bash
    sudo docker-compose up -d
    ```

### Verifying the Setup

1. **Check the status of the containers:**

    ```bash
    sudo docker-compose ps
    ```

2. **View logs for troubleshooting:**

    ```bash
    sudo docker-compose logs
    ```

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
    sudo docker-compose down
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