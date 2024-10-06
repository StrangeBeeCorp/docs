# :material-docker: Running TheHive with Docker

Docker provides a convenient way to package, distribute, and run applications in lightweight containers, enabling seamless deployment across various environments. TheHive leverages Docker to offer users a straightforward method for deploying its platform for incident response and case management.

TheHive fully supports Docker, allowing users to quickly deploy and manage their instance of the platform using Docker containers. By utilizing Docker images provided by TheHive project, users can streamline the setup process and focus on leveraging TheHive's powerful features for incident response and collaboration.

---

## Quick Start

To deploy TheHive (and Cortex) using Docker, follow these steps:

1. **Prepare Docker Compose File**: Create a Docker Compose file to orchestrate the deployment of TheHive and Cortex. You can use the following example as a starting point:

    !!! Example ""

        ```yaml
        version: "3"
        services:
          thehive:
            image: strangebee/thehive:5.4
            depends_on:
              - cassandra
              - elasticsearch
              - minio
              - cortex
            mem_limit: 1500m
            ports:
              - "9000:9000"
            environment:
              - JVM_OPTS="-Xms1024M -Xmx1024M"
            command:
              - --secret
              - "2YK9Dt4qYWM0vLb95Bc7H9XUGzrQTfTF"
              - "--cql-hostnames"
              - "cassandra"
              - "--index-backend"
              - "elasticsearch"
              - "--es-hostnames"
              - "elasticsearch"
              - "--s3-endpoint"
              - "http://minio:9000"
              - "--s3-access-key"
              - "minioadmin"
              - "--s3-secret-key"
              - "minioadmin"
              - "--s3-bucket"
              - "thehive"
              - "--s3-use-path-access-style"
              - "--cortex-hostnames"
              - "cortex"
              - "--cortex-keys"
              # put cortex api key once cortex is bootstraped
              - "<cortex_api_key>"

          cassandra:
            image: 'cassandra:4'
            mem_limit: 1600m
            ports:
              - "9042:9042"
            environment:
              - MAX_HEAP_SIZE=1024M
              - HEAP_NEWSIZE=1024M
              - CASSANDRA_CLUSTER_NAME=TheHive
            volumes:
              - cassandradata:/var/lib/cassandra
            restart: on-failure

          elasticsearch:
            image: docker.elastic.co/elasticsearch/elasticsearch:7.17.12
            mem_limit: 1500m
            ports:
              - "9200:9200"
            environment:
              - discovery.type=single-node
              - xpack.security.enabled=false
            volumes:
              - elasticsearchdata:/usr/share/elasticsearch/data

          minio:
            image: quay.io/minio/minio
            mem_limit: 512m
            command: ["minio", "server", "/data", "--console-address", ":9090"]
            environment:
              - MINIO_ROOT_USER=minioadmin
              - MINIO_ROOT_PASSWORD=minioadmin
            ports:
              - "9090:9090"
            volumes:
              - "miniodata:/data"

          cortex:
            image: thehiveproject/cortex:3.1.7
            depends_on:
              - elasticsearch
            environment:
              - job_directory=/tmp/cortex-jobs
            volumes:
              - /var/run/docker.sock:/var/run/docker.sock
              - /tmp/cortex-jobs:/tmp/cortex-jobs
            ports:
              - "9001:9001"

        volumes:
          miniodata:
          cassandradata:
          elasticsearchdata:
        ```

2. **Run Docker Compose**: Execute the following command in the directory containing your Docker Compose file to start TheHive and Cortex:

    !!! Example ""

        ```yaml
        docker-compose up -d
        ```

3. **Access TheHive Web Interface**: Once the containers are up and running, access TheHive web interface by navigating to ``http://localhost:9000`` in your web browser. You can now proceed with configuring and using TheHive for your incident response and case management needs.

4. **(Optional) Access Cortex Web Interface**: Cortex web interface can be accessed by visiting ``http://localhost:9001`` in your browser. Cortex serves as an analysis engine for observables and can be integrated seamlessly with TheHive.

---

## Default Credentials

The default administrative credentials for TheHive are as follows:

- Username: `admin@thehive.local`
- Password: `secret`

---

## Using Your Own Configuration File

You have the option to use your own configuration file when deploying TheHive. Below are the steps to do so:

1. Ensure you have a custom configuration file ready.

2. Update your Docker Compose file or Docker run command to include the custom configuration file:

    ```yaml
      thehive:
        image: strangebee/thehive:<version>
        depends_on:
          - cassandra
          - elasticsearch
          - minio
          - cortex
        mem_limit: 1500m
        ports:
          - "9000:9000"
        environment:
          - JVM_OPTS="-Xms1024M -Xmx1024M"
        volumes:
          - <host_conf_folder>:/data/conf
        command:
          - --no-config
          - --config-file
          - /data/conf/application.conf
    ```

    ```bash
    docker run --rm -p 9000:9000 -v <host_conf_folder>:/data/conf strangebee/thehive:<version> --no-config --config-file /data/conf/application.conf 
    ```

3. Ensure that the ``<host_conf_folder>`` directory contains the ``application.conf`` file.

    !!! Note
        To prevent conflict with your custom file, make sure to use the --no-config flag to instruct the entrypoint not to generate any configuration. Otherwise, the entry point will generate a default configuration that may conflict with your settings.

---

## Using Command Line Arguments

When deploying TheHive, it's recommended to utilize Cassandra and Elasticsearch for data storage, along with MinIO for file storage. You can pass the hostnames of your instances as arguments when running the Docker container:

```bash
docker run --rm -p 9000:9000 strangebee/thehive:<version> \
    --secret <secret>
    --cql-hostnames <cqlhost1>,<cqlhost2>,...
    --cql-username <cqlusername>
    --cql-password <cqlusername>
    --index-backend elasticsearch
    --es-hostnames <eshost1>,<eshost2>,...
    --s3-endpoint <minio_endpoint>
    --s3-access-key <minio_access_key>
    --s3-secret-key <minio_secret_key>
```

This command connects your Docker container to external Cassandra and Elasticsearch nodes while storing data files on MinIO. The container exposes TheHive on port 9000.

---

## All Options

To view a list of all supported options for the Docker entry point, use the -h flag:

```bash
docker run --rm strangebee/thehive:<version> -h
```

The output will display available options, allowing you to configure TheHive according to your requirements.

Available Options:

- `--config-file <file>`: Specifies the path to the configuration file.
- `--no-config`: Prevents TheHive from attempting to configure itself, including adding secrets and Elasticsearch settings.
- `--no-config-secret`: Excludes the addition of a randomly generated secret from the configuration.
- `--secret <secret>`: Sets the secret used to secure sessions.
- `--show-secret`: Displays the generated secret.
- `--no-config-db`: Disables automatic configuration of the database.
- `--cql-hostnames <host>,<host>,...`: Resolves these hostnames to locate Cassandra instances.
- `--cql-username <username>`: Specifies the username for the Cassandra database.
- `--cql-password <password>`: Specifies the password for the Cassandra database.
- `--no-cql-wait`: Skips waiting for Cassandra to become available.
- `--bdb-directory <path>`: Defines the location of the local database if Cassandra is not used (default: /data/db).
- `--index-backend`: Specifies the backend to use for index (default: elasticsearch).
- `--es-hostnames`: Specifies the Elasticsearch instances used for index.
- `--es-index`: Specifies the Elasticsearch index name to be used (default: thehive).
- `--no-config-storage`: Disables automatic configuration of storage.
- `--storage-directory <path>`: Specifies the location of local storage if S3 is not used (default: /data/files).
- `--s3-endpoint <endpoint>`: Specifies the endpoint of S3 or other object storage if used, with 's3.amazonaws.com' for AWS S3.
- `--s3-region <region>`: Specifies the S3 region, optional for MinIO.
- `--s3-bucket <bucket>`: Specifies the name of the bucket to use (default: thehive), which must already exist.
- `--s3-access-key <key>`: Specifies the S3 access key (required for S3).
- `--s3-secret-key <key>`: Specifies the S3 secret key (required for S3).
- `--s3-use-path-access-style`: Sets this flag if using MinIO or another non-AWS S3 provider, defaulting to virtual host style.
- `--no-config-cortex`: Excludes Cortex configuration.
- `--cortex-proto <proto>`: Defines the protocol to connect to Cortex (default: http).
- `--cortex-port <port>`: Defines the port to connect to Cortex (default: 9001).
- `--cortex-hostnames <host>,<host>,...`: Resolves these hostnames to locate Cortex instances.
- `--cortex-keys <key>,<key>,...`: Defines Cortex keys.
- `--kubernetes`: Utilizes the Kubernetes API to join other nodes.
- `--kubernetes-pod-label-selector <selector>`: Specifies the selector to use to select other pods running the app (default app=thehive).
- `--cluster-min-nodes-count <count>`: Specifies the minimum number of nodes to form a cluster (default to 1).
- `migrate <param> <param> ...`: Runs the migration tool.
- `cloner <param> <param> ...`: Runs the cloner tool. 

---

## Usage in Kubernetes

For instructions on how to deploy TheHive on Kubernetes, please refer to the [**dedicated page**](kubernetes.md).

---

## Additional Recommendations

When deploying TheHive using Docker, consider the following recommendations:

- Always create the bucket named "thehive" in MinIO.
- Change the default credentials and secrets to enhance security.
- It's highly recommended to set a specific version for your Docker image in production scenarios instead of relying on the `latest` tag. The `latest` tag refers to the latest 5.0.x version of TheHive.

!!! Warning "Lucene Index Deprecation"
    Starting from version 5.1, TheHive no longer supports the Lucene index. Usage of the Lucene index may result in issues, especially when querying custom fields. Therefore, it's strongly advised to use Elasticsearch instead.

    Refer to [**this page**](../operations/change-index.md) for instructions on how to perform the update.

---

## Troubleshooting

Below are some common issues that may arise when running TheHive with Docker:

- **Example 1**: Container Exited with Code 137

    If one of your containers exits with code 137, it indicates that it's using more memory than allowed by Docker. 

    Adjust the values 1024M according to your specific memory requirements. This will help optimize memory usage and prevent the container from exiting with code 137.

    **Resolution**:

    To resolve this issue, you can increase the ``mem_limit`` parameter to allocate more memory for the container.

    For JVM-based applications such as TheHive, Cassandra, and Elasticsearch, you can further optimize memory usage by tuning the JVM parameters. Specifically for TheHive, you can utilize the JVM_OPTS environment variable to set the maximum heap size.

    Here's an example of setting JVM options for TheHive:
    
    !!! Example "" 

        ```text
        JVM_OPTS="-Xms1024M -Xmx1024M"
        ```

&nbsp;