```bash
#!/bin/bash

# TheHive attachment variables
SEAWEEDFS_ARCHIVE_PATH=/mnt/backup/seaweedfs/

# SeaweedFS variables
SEAWEEDFS_BUCKET="thehive"
SEAWEEDFS_ALIAS=th_seaweedfs
SEAWEEDFS_SNAPSHOT_NAME="seaweedfs_$(date +%Y%m%d_%Hh%Mm%Ss)"

# Check if SeaweedFS is accessible
if ! mcli ls ${SEAWEEDFS_ALIAS} > /dev/null 2>&1; then
    echo "Error: Cannot connect to SeaweedFS server"
    exit 1
fi

# Mirror SeaweedFS bucket content to local backup folder
mcli mirror ${SEAWEEDFS_ALIAS}/${SEAWEEDFS_BUCKET} ${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_SNAPSHOT_NAME}

tar cvf ${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_SNAPSHOT_NAME}.tar -C "${SEAWEEDFS_ARCHIVE_PATH}" ${SEAWEEDFS_SNAPSHOT_NAME} 

# Display the location of the backup
echo ""
echo "TheHive attachment files backup done! Keep the following backup archive safe:"
echo "${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_SNAPSHOT_NAME}.tar"

rm -rf ${SEAWEEDFS_ARCHIVE_PATH}/${SEAWEEDFS_SNAPSHOT_NAME}
```