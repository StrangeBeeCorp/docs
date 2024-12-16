# Backup and Restore Guides

!!! Warning
    Regardless of the situation, we **strongly** recommend performing **cold backups**. TheHive utilizes Cassandra as its database and Elasticsearch as its indexing engine. Files are typically stored in a folder, although some users opt for Minio S3 object storage. For every backup, the data, index, and files **must** remain intact and consistent. **Any inconsistency could result in data restoration failure**.

    This documentation provides detailed instructions for performing cold backups. Alternatively, you may opt for a hot backup and restore strategy. To assist with this, we provide sample scripts that you can tailor to your specific requirements. However, it is important to note that the final responsibility for implementing and testing the backup and restore processes lies with you.

    We strongly recommend thoroughly validating your backup and restoration procedures in a controlled environment before relying on them in production. While we strive to provide accurate and helpful guidance, we cannot assume liability for any data loss, downtime, or system failures resulting from incorrect configurations, inconsistencies in your data, or issues during the restoration process. It is essential to ensure that your chosen approach aligns with your infrastructure and operational needs.

---
# Cold backup & restore

Your backup and restore strategy heavily depends on your infrastructure and orchestration approach, whether you are using physical servers, virtual servers, Docker, Kubernetes, or cloud solutions like AWS EC2 instances.

For example, with AWS Amazon EC2 servers where all data, indexes, and files are stored on dedicated volumes, performing a daily backup of the volumes takes less than 3 minutes. This includes housekeeping tasks such as stopping and restarting services.


