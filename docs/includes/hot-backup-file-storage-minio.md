```bash
#!/bin/bash

# TheHive attachment variables
MINIO_ARCHIVE_PATH=/mnt/backup/minio/

# MinIO variables
MINIO_ENDPOINT="<minio_server_url>"
MINIO_ACCESS_KEY="<access_key>"
MINIO_SECRET_KEY="<secret_key>"
MINIO_BUCKET="thehive"
MINIO_ALIAS=th_minio
MINIO_SNAPSHOT_NAME="minio_$(date +%Y%m%d_%Hh%Mm%Ss)"

# Check if MinIO is accessible
if ! mcli ls ${MINIO_ALIAS} > /dev/null 2>&1; then
    echo "Error: Cannot connect to MinIO server"
    exit 1
fi

# Mirror MinIO bucket content to local backup folder
mcli mirror ${MINIO_ALIAS}/${MINIO_BUCKET} ${MINIO_ARCHIVE_PATH}/${MINIO_SNAPSHOT_NAME}

tar cvf ${MINIO_ARCHIVE_PATH}/${MINIO_SNAPSHOT_NAME}.tar -C "${MINIO_ARCHIVE_PATH}" ${MINIO_SNAPSHOT_NAME} 

# Display the location of the backup
echo ""
echo "TheHive attachment files backup done! Keep the following backup archive safe:"
echo "${MINIO_ARCHIVE_PATH}/${MINIO_SNAPSHOT_NAME}.tar"
```