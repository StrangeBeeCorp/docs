#!/bin/bash

# ElasticSearch variables
ELASTICSEARCH_API_URL='http://127.0.0.1:9200'
ELASTICSEARCH_SNAPSHOT_REPOSITORY=thehive_repository
ELASTICSEARCH_INDEX=thehive_global

# Look for the latest archived ElasticSearch snapshot
ELASTICSEARCH_BACKUP_LIST=(${GENERAL_ARCHIVE_PATH}/elasticsearch_????????_??h??m??s.tar)
ELASTICSEARCH_LATEST_BACKUP_NAME=$(basename ${ELASTICSEARCH_BACKUP_LIST[-1]})

echo "Latest ElasticSearch backup archive found is ${GENERAL_ARCHIVE_PATH}/${ELASTICSEARCH_LATEST_BACKUP_NAME}"

# Extract the latest archive
ELASTICSEARCH_SNAPSHOT_NAME=$(echo ${ELASTICSEARCH_LATEST_BACKUP_NAME} | cut -d '.' -f 1)
ELASTICSEARCH_SNAPSHOT_FOLDER="${GENERAL_ARCHIVE_PATH}/${ELASTICSEARCH_SNAPSHOT_NAME}"

tar xvf "${GENERAL_ARCHIVE_PATH}/${ELASTICSEARCH_LATEST_BACKUP_NAME}"
echo "Latest ElasticSearch backup archive extracted in ${ELASTICSEARCH_SNAPSHOT_FOLDER}"

# Delete an existing ElasticSearch index
echo "Trying to delete the existing ElasticSearch index"
delete_index=$(curl -s -L -X DELETE "${ELASTICSEARCH_API_URL}/${ELASTICSEARCH_INDEX}/")

ack_delete=$(jq '.acknowledged == true' <<< delete_index)
if [ delete_index != true ]; then
    echo "Couldn't delete ${ELASTICSEARCH_INDEX} index, maybe it was already deleted"
else
    echo "Existing ${ELASTICSEARCH_INDEX} index deleted"
fi

# Restoring the extracted snapshot
echo "Restoring ${ELASTICSEARCH_SNAPSHOT_NAME} snapshot"
restore_status=$(curl -s -L -X POST "${ELASTICSEARCH_API_URL}/_snapshot/${ELASTICSEARCH_SNAPSHOT_REPOSITORY}/${ELASTICSEARCH_SNAPSHOT_NAME}/_restore?wait_for_completion=true")

echo "ElasticSearch data restoration done!"
rm -rf ${ELASTICSEARCH_SNAPSHOT_FOLDER}
