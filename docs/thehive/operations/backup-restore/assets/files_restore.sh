#!/bin/bash

# TheHive attachment variables
ATTACHMENT_FOLDER=/opt/thp/thehive/files

# Backup variables
GENERAL_ARCHIVE_PATH=/mnt/backup

# Look for the latest archived attachment files snapshot
ATTACHMENT_BACKUP_LIST=(${GENERAL_ARCHIVE_PATH}/files_????????_??h??m??s.tar)
ATTACHMENT_LATEST_BACKUP_NAME=$(basename ${ATTACHMENT_BACKUP_LIST[-1]})

echo "Latest attachment files backup archive found is ${GENERAL_ARCHIVE_PATH}/${ATTACHMENT_LATEST_BACKUP_NAME}"

# Extract the latest archive
ATTACHMENT_SNAPSHOT_NAME=$(echo ${ATTACHMENT_LATEST_BACKUP_NAME} | cut -d '.' -f 1)
ATTACHMENT_SNAPSHOT_FOLDER="${GENERAL_ARCHIVE_PATH}/${ATTACHMENT_SNAPSHOT_NAME}"

tar xvf "${GENERAL_ARCHIVE_PATH}/${ATTACHMENT_LATEST_BACKUP_NAME}"
echo "Latest attachment files backup archive extracted in ${ATTACHMENT_SNAPSHOT_FOLDER}"

# Clean existing TheHive attachment files
rm -rf ${ATTACHMENT_FOLDER}/*

# Copy the attachment files from the backup
cp -r ${ATTACHMENT_SNAPSHOT_FOLDER}/* ${ATTACHMENT_FOLDER}/

echo "attachment files data restoration done!"
rm -rf ${ATTACHMENT_SNAPSHOT_FOLDER}
