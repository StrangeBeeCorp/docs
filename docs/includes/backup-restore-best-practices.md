!!! tip "Best practices for safe backup and restore"

    * Coordinate your Apache Cassandra, Elasticsearch, and file storage backups to run at the same time. Using automation like a cron job helps minimize the chance of inconsistencies between components.
    * Before relying on these backups in a real incident, test the full backup and restore flow in a staging environment. It’s the only way to make sure everything works as expected.
    * Ensure you have an up-to-date backup before starting the restore operation, as errors during the restoration could lead to data loss.