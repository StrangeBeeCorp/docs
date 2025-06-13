!!! warning "Script restrictions"
    This script works only when file storage is managed directly on a machine. It doesn't support deployments using Docker or Kubernetes.

```bash
#!/bin/bash

# TheHive attachment variables
ATTACHMENT_FOLDER=/opt/thp/thehive/files

# Backup variables
GENERAL_ARCHIVE_PATH=/mnt/backup
SNAPSHOT_NAME="files_$(date +%Y%m%d_%Hh%Mm%Ss)"
ATTACHMENT_ARCHIVE_PATH="${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}"

# Copy all TheHive attachment
cp -r ${ATTACHMENT_FOLDER}/* ${ATTACHMENT_ARCHIVE_PATH}/

# Create a ".tar" archive with the folder containing the backed up attachment files
cd ${GENERAL_ARCHIVE_PATH}
tar cf ${SNAPSHOT_NAME}.tar ${SNAPSHOT_NAME}

# Remove the folder once the archive is created
rm -rf ${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}

# Display the location of the attachment archive
echo ""
echo "TheHive attachment files backup done! Keep the following backup archive safe:"
echo "${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}.tar"
```

!!! info "Where to find the backup archive?"
    After running the script, the backup archive is available at `/mnt/backup` with a `files_` prefix. Be sure to copy this archive to a separate server or storage location to safeguard against data loss if the TheHive server fails.