# Backup and Restore Guides

!!! Warning
    Regardless of the situation, we **strongly** recommend performing **cold backups**. TheHive utilizes Cassandra as its database and Elasticsearch as its indexing engine. Files are typically stored in a folder, although some users opt for Minio S3 object storage. For every backup, the data, index, and files **must** remain intact and consistent. **Any inconsistency could result in data restoration failure**.

    This documentation provides detailed instructions for performing cold backups. Alternatively, you may opt for a hot backup and restore strategy. To assist with this, we provide sample scripts that you can tailor to your specific requirements. However, it is important to note that the final responsibility for implementing and testing the backup and restore processes lies with you.

    We strongly recommend thoroughly validating your backup and restoration procedures in a controlled environment before relying on them in production. While we strive to provide accurate and helpful guidance, we cannot assume liability for any data loss, downtime, or system failures resulting from incorrect configurations, inconsistencies in your data, or issues during the restoration process. It is essential to ensure that your chosen approach aligns with your infrastructure and operational needs.

---
## Cold backup & restore

Your backup and restore strategy heavily depends on your infrastructure and orchestration approach, whether you are using physical servers, virtual servers, Docker, Kubernetes, or cloud solutions like AWS EC2 instances.

For example, with AWS Amazon EC2 servers where all data, indexes, and files are stored on dedicated volumes, performing a daily backup of the volumes takes less than 3 minutes. This includes housekeeping tasks such as stopping and restarting services.


### Backup and Restore Procedures

For: 

* **Physical servers**: [backup](./backup/physical-server.md) and [restore](./restore/physical-server.md) procedures
* **Virtual servers**: [backup](./backup/virtual-server.md) and [restore](./restore/virtual-server.md) procedures
* **Containerized Environments (Docker Compose)**: [backup](./backup/docker-compose.md) and [restore](./restore/docker-compose.md) procedures
 

Use the links above or navigate through the documentation to find the specific procedure suited for your environment.


---
## Introduction to Hot Backup and Restore

While **cold backups** are highly recommended due to their simplicity and consistency, you may want to consider **hot backups**.  

Hot backup procedures can minimize downtime, making them more suitable for production environments where service availability is critical. However, hot backups introduce additional complexity and risks, such as data inconsistencies, particularly in distributed systems like Cassandra and Elasticsearch.

### Considerations for Hot Backups

- **Data Consistency:** Ensure that the backup process handles the synchronization of data across services like Cassandra and Elasticsearch. Use tools such as `nodetool snapshot` for Cassandra and Elasticsearch APIs for snapshots.  
- **Service-Specific Tools:** Hot backups often require the use of specialized commands or APIs to ensure that the data state remains consistent during the process.  
- **Validation:** Always test your hot backup and restore process thoroughly in a non-production environment before relying on it in production.  

Sample scripts and guidelines for hot backups are provided in this documentation. However, these are intended as a starting point and must be adapted to your infrastructure and operational requirements.
