# :material-docker: Running with docker

This page will guide you on how to use the docker image of TheHive

## Quick start

Run TheHive and Cortex using this docker compose file:

```yaml
version: "3"
services:
  thehive:
    image: strangebee/thehive:5.2
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
      - "mySecretForTheHive"
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
    mem_limit: 1000m
    ports:
      - "9042:9042"
    environment:
      - CASSANDRA_CLUSTER_NAME=TheHive
    volumes:
      - cassandradata:/var/lib/cassandra

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.9
    mem_limit: 512m
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
    environment:
      - job_directory=/tmp/cortex-jobs
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /tmp/cortex-jobs:/tmp/cortex-jobs
    depends_on:
      - elasticsearch
    ports:
      - "9001:9001"

volumes:
  miniodata:
  cassandradata:
  elasticsearchdata:

```

Connect on [http://localhost:9000] to see the login page. 

!!! Info "Default credentials"
    Default admin credentials are `admin@thehive.local` / `secret`

We recommend to always set the version of your docker image in production scenario. `latest` tag will refer to the latest 5.0.x version.

!!! Info
    * Do not forget to create the bucket "thehive" in MinIO
    * It's highly recommended to change the default credentials and secrets.

!!! Warning "Lucene index"
    Since version 5.1, the lucene index is no longer supported and will cause issues when using queries on custom fields. That's why we strongly recommend you to use Elasticsearch instead.

    Please refer to [this page](../operations/change-index.md) on how to update.

### Using your own configuration file

The entry point arguments are used to create a `application.conf` file in the container. A custom configuration file can also be provided:

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

  ...
```

```bash
docker run --rm -p 9000:9000 -v <host_conf_folder>:/data/conf strangebee/thehive:<version> --no-config --config-file /data/conf/application.conf 
```

The folder `<host_conf_folder>` needs to contain a `application.conf` file.

`--no-config` is used to tell the entrypoint to not generate any configuration. Otherwise the entry point will generate a default configuration that will be merged with your file. 

### Using command line arguments

We recommend running TheHive with Cassandra and Elasticsearch for data storage and minio for file storage. You can pass the hostnames of your instances via the arguments:

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

This will connect your docker container to external cassandra and elasticsearch nodes. The data files will be stored on minio.
The container exposes TheHive on the port `9000`.


### All options

You can get a list of all options supported by the docker entry point with `-h`:
```bash
docker run --rm strangebee/thehive:<version> -h
```

```
Available options:
    --config-file <file>                        | configuration file path
    --no-config                                 | do not try to configure TheHive (add secret and elasticsearch)
    --no-config-secret                          | do not add random secret to configuration
    --secret <secret>                           | secret to secure sessions
    --show-secret                               | show the generated secret
    --no-config-db                              | do not configure database automatically
    --cql-hostnames <host>,<host>,...           | resolve these hostnames to find cassandra instances
    --cql-username <username>                   | username of cassandra database
    --cql-password <password>                   | password of cassandra database
    --no-cql-wait                               | don't wait for cassandra
    --bdb-directory <path>                      | location of local database, if cassandra is not used (default: /data/db)
    --index-backend                             | backend to use for index. One of 'lucene' or 'elasticsearch' (default: lucene)
    --es-hostnames                              | elasticsearch instances used for index
    --es-index                                  | elasticsearch index name to used (default: thehive)
    --no-config-storage                         | do not configure storage automatically
    --storage-directory <path>                  | location of local storage, if s3 is not used (default: /data/files)
    --s3-endpoint <endpoint>                    | endpoint of s3 (or other object storage) if used, use 's3.amazonaws.com' for aws s3
    --s3-region <region>                        | s3 region, optional for minio
    --s3-bucket <bucket>                        | name of the bucket to use (default: thehive), the bucket must already exists
    --s3-access-key <key>                       | s3 access key (required for s3)
    --s3-secret-key <key>                       | s3 secret key (required for s3)
    --s3-use-path-access-style                  | set this flag if you use minio or other non aws s3 provider, default to virtual host style
    --no-config-cortex                          | do not add Cortex configuration
    --cortex-proto <proto>                      | define protocol to connect to Cortex (default: http)
    --cortex-port <port>                        | define port to connect to Cortex (default: 9001)
    --cortex-hostnames <host>,<host>,...        | resolve this hostname to find Cortex instances
    --cortex-keys <key>,<key>,...               | define Cortex key
    --kubernetes                                | will use kubernetes api to join other nodes
    --kubernetes-pod-label-selector <selector>  | selector to use to select other pods running the app (default app=thehive)
    --cluster-min-nodes-count <count>           | minimum number of nodes to form a cluster (default to 1)
    migrate <param> <param> ...                 | run migration tool
    cloner <param> <param> ...                  | run cloner tool
```

## Usage in kubernetes

Refer to the [dedicated page](kubernetes.md) for instuctions on how to deploy on kubernetes.
