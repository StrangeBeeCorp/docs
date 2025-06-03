# Cold vs. Hot Backup and Restore

This topic compares cold and hot backup and restore options in TheHive, helping you make the best decision based on your organization's needs and requirements.

## Definitions

A cold backup involves shutting down TheHive and its architecture components to back up all data. This method ensures that the data is consistent and intact, but requires downtime. This option is available for standalone servers only, not for clusters.

A hot backup keeps TheHive running while it takes the backup. This reduces downtime but may not guarantee data integrity across all architecture components. This option is available for both standalone servers and clusters.

Both cold restore and hot restore require shutting down TheHive to complete the restoration process.

## TheHive infrastructure challenges

{!includes/backup-requirement.md!}

TheHive is built on an architecture that includes [Apache Cassandra as the database](../../installation/step-by-step-installation-guide.md#apache-cassandra), [Elasticsearch as the indexing engine, and optionally as audit log storage (since version 5.5)](../../installation/step-by-step-installation-guide.md#elasticsearch), and [files stored either locally, using an Network File System (NFS), or in MinIO S3 object storage](../../installation/step-by-step-installation-guide.md#file-storage). This setup requires careful attention to ensure consistency across the data, index, and files for successful backups. Any inconsistency between them could result in restoration failures.

## Cold vs. hot backup and restore comparison

| Type | Complexity | TheHive backup state  | TheHive restore state | Data integrity | Tools                  | Supported environment | Use case |
| -----| ---------- | --------------------| ---------------| ---------------| -----------------------| --------| --------|
| **Cold** | Medium     | Application stopped | Application stopped | Guaranteed      | Usual tools            | Standalone servers only| Want to ensure data integrity |
| **Hot** | High       | Application running | Application stopped | Not guaranteed  | Service-specific tools | Standalone servers and clusters | Can't afford any downtime |

## Available backup and restore procedures

!!! warning "Testing responsibilities"
    TheHive isn't liable for data loss, downtime, or failures due to incorrect configurations or restoration issues. The responsibility for implementing and testing these processes lies with you. Validate them in a controlled environment before using them in production.

!!! note "Full backups only"
    These procedures focus exclusively on methods for creating full backups and don't cover incremental backup strategies.

### Cold backup and restore procedures

How you proceed with cold backup and restore depends on your infrastructure and orchestration setup. This could involve physical servers, virtual servers, Docker, Kubernetes, or cloud solutions like AWS EC2.

For example, with AWS EC2, data, indexes, and files can be stored on dedicated volumes. In such cases, taking daily snapshots of these volumes can be a simple and efficient backup strategy, typically completed within minutes—including the necessary service stop and restart operations.

* Physical servers: [Back up](../backup-restore/backup/cold-backup/physical-server.md) / [Restore](../backup-restore/restore/cold-restore/physical-server.md)
* Virtual servers: [Back up](../backup-restore/backup/cold-backup/virtual-server.md) / [Restore](../backup-restore/restore/cold-restore/virtual-server.md)
* Containerized environments (Docker Compose): [Back up](../backup-restore/backup/cold-backup/docker-compose.md) / [Restore](../backup-restore/restore/cold-restore/docker-compose.md)

### Hot backup and restore procedures

The approach to hot backup and restore depends on whether you have a standalone server or a cluster.

* Standalone server: [Back up](../backup-restore/backup/hot-backup/hot-backup-standalone-server.md) / [Restore](../backup-restore/restore/hot-restore/restore-hot-backup-standalone-server.md)
* Cluster: [Back up](../backup-restore/backup/hot-backup/hot-backup-cluster.md) / [Restore](../backup-restore/restore/hot-restore/restore-hot-backup-cluster.md)

<h2>Next steps</h2>

* [Cassandra Cluster Operations](../cassandra-cluster.md)
* [Security in Apache Cassandra](../cassandra-security.md)
* [MinIO Cluster Operations](../minio-cluster.md)
* [Monitoring TheHive](../monitoring.md)
* [Troubleshooting](../troubleshooting.md)