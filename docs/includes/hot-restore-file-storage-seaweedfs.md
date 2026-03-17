```bash
#!/bin/bash

# TheHive attachment variables
SEAWEEDFS_ARCHIVE_PATH=/mnt/backup/seaweedfs/

# SeaweedFS variables
SEAWEEDFS_BUCKET="thehive"
SEAWEEDFS_ALIAS=th_seaweedfs

# Check if SeaweedFS is accessible
if ! mcli ls ${SEAWEEDFS_ALIAS} > /dev/null 2>&1; then
    echo "Error: Cannot connect to SeaweedFS server"
    exit 1
fi

# Look for the latest backup snapshot in SeaweedFS
SEAWEEDFS_BACKUP_LIST=(${SEAWEEDFS_ARCHIVE_PATH}/seaweedfs_????????_??h??m??s.tar)
SEAWEEDFS_LATEST_BACKUP_NAME=$(basename ${SEAWEEDFS_BACKUP_LIST[-1]})
if [ -z "${SEAWEEDFS_LATEST_BACKUP_NAME}" ]; then
    echo "Error: No backup snapshots found in ${SEAWEEDFS_ARCHIVE_PATH}"
    exit 1
fi

echo "Latest attachment files backup snapshot found is ${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_LATEST_BACKUP_NAME}"

tar xvf "${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_LATEST_BACKUP_NAME}" -C ${SEAWEEDFS_ARCHIVE_PATH} > /dev/null

if [ ! -d "${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_LATEST_BACKUP_NAME%.tar}" ]; then
    echo "Error: Extracted folder not found"
    exit 1
fi

echo "Latest SeaweedFS backup archive extracted in ${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_LATEST_BACKUP_NAME%.tar}"

# Restore attachments from SeaweedFS
echo "Restoring attachments from SeaweedFS snapshot ${SEAWEEDFS_LATEST_BACKUP_NAME}..."
mcli mirror ${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_LATEST_BACKUP_NAME%.tar} ${SEAWEEDFS_ALIAS}/${SEAWEEDFS_BUCKET}/

# Clean up extracted folder
rm -rf "${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_LATEST_BACKUP_NAME%.tar}"

# Display completion message
echo ""
echo "Attachment files data restoration done!"
echo "Restored from: ${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_LATEST_BACKUP_NAME}"
```