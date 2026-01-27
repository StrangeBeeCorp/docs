# TheHive Docker Entrypoint Settings

TheHive Docker entrypoint provides command-line options to configure the application at startup.

## Viewing available options

To display all supported entrypoint options:

```bash
docker run --rm strangebee/thehive:<thehive_version> -h
```

Replace `<thehive_version>` with the TheHive version.

## Configuration options

### General configuration

| Parameter | Type | Description |
|-----------|------|-------------|
| `--config-file <file>` | string | Specifies the path to the configuration file. |
| `--no-config` | flag | Prevents TheHive from automatic configuration, including secrets and Elasticsearch settings. |
| `--no-config-secret` | flag | Excludes automatic generation of a random secret. |
| `--secret <secret>` | string | Sets the secret used to secure sessions. |
| `--show-secret` | flag | Displays the generated secret. |

### Database configuration

| Parameter | Type | Description |
|-----------|------|-------------|
| `--no-config-db` | flag | Turns off automatic database configuration. |
| `--cql-hostnames <host>,<host>,...` | string | Resolves host names to locate Cassandra instances. |
| `--cql-username <username>` | string | Specifies the Cassandra database username. |
| `--cql-password <password>` | string | Specifies the Cassandra database password. |
| `--cql-datacenter <datacenter>` | string | <!-- md:version 5.4.7 --> Specifies the Cassandra datacenter name. It supports different values per node in cluster mode. |
| `--cql-keyspace <keyspace>` | string | <!-- md:version 5.4.7 --> Specifies the name of the Cassandra keyspace. Default: `thehive`. |
| `--no-cql-wait` | flag | Skips waiting for Cassandra availability. |

### Index configuration

| Parameter | Type | Description |
|-----------|------|-------------|
| `--es-hostnames <host>,<host>,...` | string | Specifies Elasticsearch instances for indexing. |
| `--es-index` | string | Specifies the Elasticsearch index name. Default: `thehive`. |
| `--es-username <username>` | string | Specifies the Elasticsearch username. |
| `--es-password <password>` | string | Specifies the Elasticsearch password. |

### Storage configuration

| Parameter | Type | Description |
|-----------|------|-------------|
| `--no-config-storage` | flag | Turns off automatic storage configuration. |
| `--storage-directory <path>` | string | Specifies local storage location when not using S3. Default: `/data/files`. |
| `--s3-endpoint <endpoint>` | string | Specifies S3 or object storage endpoint. Use `s3.amazonaws.com` for AWS S3. |
| `--s3-region <region>` | string | Specifies the S3 region. |
| `--s3-bucket <bucket>` | string | Specifies the S3 bucket name. Default: `thehive`, which must already exist. |
| `--s3-access-key <key>` | string | Specifies the S3 access key. Required for S3. |
| `--s3-secret-key <key>` | string | Specifies the S3 secret key. Required for S3. |
| `--s3-use-path-access-style` | flag | Enables path-style access for non-AWS S3 providers (defaults to virtual host style). |

### Cortex integration

| Parameter | Type | Description |
|-----------|------|-------------|
| `--no-config-cortex` | flag | Excludes Cortex configuration. |
| `--cortex-proto <proto>` | string | Defines the protocol to connect to Cortex. Default: `http`. |
| `--cortex-port <port>` | integer | Defines the port to connect to Cortex. Default: `9001`. |
| `--cortex-hostnames <host>,<host>,...` | string | Resolves host names to locate Cortex instances. |
| `--cortex-keys <key>,<key>,...` | string | Defines Cortex API keys. |

### Clustering configuration

| Parameter | Type | Description |
|-----------|------|-------------|
| `--kubernetes` | flag | Utilizes the Kubernetes API to join other nodes. |
| `--kubernetes-pod-label-selector <selector>` | string | Specifies the label selector for pods running TheHive. Default: `app=thehive`. |
| `--cluster-min-nodes-count <count>` | integer | Specifies the minimum number of nodes to form a cluster. Default: `1`. |

### Utility commands

| Parameter | Type | Description |
|-----------|------|-------------|
| `migrate <param> <param> ...` | command | Runs the migration tool. |
| `cloner <param> <param> ...` | command | Runs the cloner tool. |

<h2>Next steps</h2>

* [Perform a Cold Backup for a Stack Running with Docker Compose](../operations/backup-restore/backup/cold-backup/docker-compose.md)
* [Set Up Monitoring for TheHive with Prometheus and Grafana](../operations/monitoring.md)