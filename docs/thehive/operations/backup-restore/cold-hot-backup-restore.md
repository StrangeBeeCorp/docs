# Cold vs. Hot Backup and Restore

TheHive supports two backup and restore approaches: cold backups, which require stopping services to ensure data consistency, and hot backups, which allow backups while services remain running.

## Definitions

* A cold backup involves shutting down TheHive and its architecture components to back up all data. This method ensures that the data is consistent and intact, but requires downtime. This option is available for standalone servers only, not for clusters.

* A hot backup keeps TheHive running while it takes the backup. This reduces downtime but may not guarantee data integrity across all architecture components. This option is available for both standalone servers and clusters.

* Both cold restore and hot restore require shutting down TheHive to complete the restoration process.

## TheHive infrastructure challenges

{% include-markdown "includes/backup-requirement.md" %}

TheHive is built on an architecture that includes [Apache Cassandra as the database](../../installation/installation-guide-linux-standalone-server.md#step-3-install-configure-cassandra), [Elasticsearch as the indexing engine](../../installation/installation-guide-linux-standalone-server.md#step-4-install-configure-elasticsearch), and file storage managed either [locally](../../installation/installation-guide-linux-standalone-server.md#step-54-create-the-file-storage-directory), [via a NFS, or using S3-compatible object storage](../../installation/deploying-a-cluster.md#configure-file-storage). This architecture requires careful coordination to maintain consistency across the database, index, and file storage during backups. Any mismatch between these components can lead to restoration failures.

## Cold vs. hot backup and restore comparison

| Type | Complexity | TheHive backup state  | TheHive restore state | Data integrity | Tools                  | Supported environment | Use case |
| -----| ---------- | --------------------| ---------------| ---------------| -----------------------| --------| --------|
| **Cold** | Medium     | Application stopped | Application stopped | Guaranteed      | Usual tools            | Standalone servers only| Want to ensure data integrity |
| **Hot** | High       | Application running | Application stopped | Not guaranteed  | Service-specific tools | Standalone servers and clusters | Can't afford any downtime |

## Available backup and restore procedures

!!! warning "Testing responsibilities"
    TheHive doesn't assume responsibility for data loss, downtime, or operational issues resulting from misconfiguration or restoration errors. It's the organization's responsibility to implement and test backup and restore procedures in a controlled environment before applying them in production.

!!! note "Full backups only"
    These procedures focus exclusively on methods for creating full backups and don't cover incremental backup strategies.

!!! danger "System admin expertise required"
    Backup and restore operations for TheHive involve low-level actions on databases, indexes, and file storage. These procedures must be performed by experienced system administrators who fully understand the underlying infrastructure. Incorrect execution may result in data corruption and data loss.

### Cold backup and restore procedures

How cold backup and restore is implemented depends on the infrastructure and orchestration environment in use. This may include physical or virtual servers, containerized deployments using Docker or Kubernetes, or cloud-based instances such as AWS EC2.

For example, with AWS EC2, data, indexes, and files can be stored on dedicated volumes. In such cases, taking daily snapshots of these volumes can be a simple and efficient backup strategy, typically completed within minutes—including the necessary service stop and restart operations.

* Physical servers: [Back up](../backup-restore/backup/cold-backup/physical-server.md) / [Restore](../backup-restore/restore/cold-restore/physical-server.md)
* Virtual servers: [Back up](../backup-restore/backup/cold-backup/virtual-server.md) / [Restore](../backup-restore/restore/cold-restore/virtual-server.md)
* Containerized environments (Docker Compose): [Back up](../backup-restore/backup/cold-backup/docker-compose.md) / [Restore](../backup-restore/restore/cold-restore/docker-compose.md)

### Hot backup and restore procedures

The approach to hot backup and restore varies depending on the deployment type, whether TheHive is running on a standalone server or in a clustered environment.

* Standalone server: [Back up](../backup-restore/backup/hot-backup/hot-backup-standalone-server.md) / [Restore](../backup-restore/restore/hot-restore/restore-hot-backup-standalone-server.md)
* Cluster: [Back up](../backup-restore/backup/hot-backup/hot-backup-cluster.md) / [Restore](../backup-restore/restore/hot-restore/restore-hot-backup-cluster.md)

<h2>Next steps</h2>

* [Cassandra Cluster Operations](../cassandra-cluster.md)
* [Security in Apache Cassandra](../cassandra-security.md)
* [Set Up Monitoring for TheHive with Prometheus and Grafana](../monitoring.md)
* [Troubleshooting](../troubleshooting.md)