!!! info "Backup storage"
    Elasticsearch offers several options for storing backups. In this procedure and in the provided scripts, a dedicated folder with a predefined folder structure is used. 
    
    For example:
    ```
     /opt/thehive-backups
    └── thehive-backup-20250421-1530-node01
        ├── cassandra
        ├── elasticsearch
        └── files
    ```
    **Backup folder configuration:**

    ``` bash
    BACKUP_ROOT_FOLDER="/opt/thehive-backups"
    DATE=$(date +"%Y%m%d-%H%M")
    HOST=$(hostname)
    BACKUP_FOLDER="${BACKUP_ROOT_FOLDER}/thehive-backup-${DATE}-${HOST}"
    BACKUP_FILENAME="${BACKUP_FOLDER}/thehive-backup-${DATE}-${HOST}.tar.bz2"
    ```
    After creating the backup archive `${BACKUP_FILENAME}`, store the archive in external storage solutions, such as a Network File System (NFS), AWS S3, Azure Blob Storage, or Google Cloud Storage.