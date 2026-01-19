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

# Check if MinIO is accessible
if ! mcli ls ${MINIO_ALIAS} > /dev/null 2>&1; then
    echo "Error: Cannot connect to MinIO server"
    exit 1
fi

# Look for the latest backup snapshot in MinIO
MINIO_BACKUP_LIST=(${MINIO_ARCHIVE_PATH}/minio_????????_??h??m??s.tar)
MINIO_LATEST_BACKUP_NAME=$(basename ${MINIO_BACKUP_LIST[-1]})

if [ -z "${LATEST_BACKUP}" ]; then
    echo "Error: No backup snapshots found in ${MINIO_ARCHIVE_PATH}"
    exit 1
fi

echo "Latest attachment files backup snapshot found is ${MINIO_ARCHIVE_PATH}/${MINIO_LATEST_BACKUP_NAME}"

tar xvf "${MINIO_ARCHIVE_PATH}/${MINIO_LATEST_BACKUP_NAME}" -C ${MINIO_ARCHIVE_PATH} > /dev/null
echo "Latest Minio backup archive extracted in ${MINIO_ARCHIVE_PATH}/${MINIO_LATEST_BACKUP_NAME}"

# Restore attachments from MinIO
echo "Restoring attachments from MinIO snapshot ${MINIO_LATEST_BACKUP_NAME}..."
mcli mirror ${MINIO_ARCHIVE_PATH}/${MINIO_LATEST_BACKUP_NAME%.tar} ${MINIO_ALIAS}/${MINIO_BUCKET}/

# Display completion message
echo ""
echo "Attachment files data restoration done!"
echo "Restored from: ${MINIO_ALIAS}/${MINIO_BUCKET}/${LATEST_BACKUP}"
```