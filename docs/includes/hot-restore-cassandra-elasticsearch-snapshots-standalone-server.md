```bash
#!/bin/bash

set -e

# Configuration
# Cassandra variables
CASSANDRA_KEYSPACE=thehive
CASSANDRA_GENERAL_ARCHIVE_PATH=/mnt/backup/cassandra
CASSANDRA_CONNECTION="<ip_node_cassandra>"
CASSANDRA_THEHIVE_USER="thehive"
CASSANDRA_BACKUP_LIST=(${CASSANDRA_GENERAL_ARCHIVE_PATH}/cassandra_????????_??h??m??s.tar)
CASSANDRA_LATEST_BACKUP_NAME=$(basename ${CASSANDRA_BACKUP_LIST[-1]})
CASSANDRA_SNAPSHOT_NAME=$(echo ${CASSANDRA_LATEST_BACKUP_NAME} | cut -d '.' -f 1)
CASSANDRA_SNAPSHOT_FOLDER="${CASSANDRA_GENERAL_ARCHIVE_PATH}/${CASSANDRA_SNAPSHOT_NAME}"

# Elasticsearch variables
ELASTICSEARCH_API_URL='http://127.0.0.1:9200'
ELASTICSEARCH_SNAPSHOT_REPOSITORY=thehive_repository
ELASTICSEARCH_GENERAL_ARCHIVE_PATH=/mnt/backup/elasticsearch
ELASTICSEARCH_BACKUP_LIST=(${ELASTICSEARCH_GENERAL_ARCHIVE_PATH}/elasticsearch_????????_??h??m??s.info)
ELASTICSEARCH_LATEST_BACKUP_NAME=$(basename ${ELASTICSEARCH_BACKUP_LIST[-1]})
ELASTICSEARCH_SNAPSHOT_NAME=$(echo ${ELASTICSEARCH_LATEST_BACKUP_NAME} | cut -d '.' -f 1)

echo "Latest Elasticsearch backup archive found is ${ELASTICSEARCH_GENERAL_ARCHIVE_PATH}/${ELASTICSEARCH_LATEST_BACKUP_NAME}"
echo "Latest Cassandra backup archive found is ${CASSANDRA_GENERAL_ARCHIVE_PATH}/${CASSANDRA_LATEST_BACKUP_NAME}"

{
    set -e

    echo "Latest Elasticsearch snapshot to be restore: ELASTICSEARCH_SNAPSHOT_NAME"

    # Delete an existing Elasticsearch index
    echo "Trying to delete the existing Elasticsearch index"
    delete_index=$(curl -s -L -X DELETE "${ELASTICSEARCH_API_URL}/thehive_global/")

    ack_delete=$(jq '.acknowledged == true' <<< $delete_index)
    if [ $ack_delete != true ]; then
        echo "Couldn't delete thehive_global index, maybe it was already deleted"
    else
        echo "Existing thehive_global index deleted"
    fi

    # Restoring the extracted snapshot
    echo "Restoring ${ELASTICSEARCH_SNAPSHOT_NAME} snapshot"
    restore_status=$(curl -s -L -X POST "${ELASTICSEARCH_API_URL}/_snapshot/${ELASTICSEARCH_SNAPSHOT_REPOSITORY}/${ELASTICSEARCH_SNAPSHOT_NAME}/_restore?wait_for_completion=true")

    echo "Elasticsearch data restoration done!"

} &
PID_ES=$!

{

    set -e

    tar xvf "${CASSANDRA_GENERAL_ARCHIVE_PATH}/${CASSANDRA_LATEST_BACKUP_NAME}" -C ${CASSANDRA_GENERAL_ARCHIVE_PATH} > /dev/null
    echo "Latest Cassandra backup archive extracted in ${CASSANDRA_SNAPSHOT_FOLDER}"

    # Check if Cassandra already has an existing keyspace
    cqlsh ${CASSANDRA_CONNECTION}  -e "DESCRIBE KEYSPACE ${CASSANDRA_KEYSPACE}" || true > "${CASSANDRA_SNAPSHOT_FOLDER}/target_keyspace_${CASSANDRA_KEYSPACE}.cql"

    if cmp --silent -- "${CASSANDRA_SNAPSHOT_FOLDER}/create_keyspace_${CASSANDRA_KEYSPACE}.cql" "${CASSANDRA_SNAPSHOT_FOLDER}/target_keyspace_${CASSANDRA_KEYSPACE}.cql"; then
        echo "Existing ${CASSANDRA_KEYSPACE} keyspace definition is identical to the one in the backup, no need to drop and recreate it"
    else
        echo "Existing ${CASSANDRA_KEYSPACE} keyspace definition does not match the one in the backup, dropping it"
        cqlsh ${CASSANDRA_CONNECTION} --request-timeout=120 -e "DROP KEYSPACE IF EXISTS ${CASSANDRA_KEYSPACE};"
        sleep 5s
        echo "Creating ${CASSANDRA_KEYSPACE} keyspace using the definition from the backup"
        cqlsh ${CASSANDRA_CONNECTION} --request-timeout=120 -f ${CASSANDRA_SNAPSHOT_FOLDER}/create_keyspace_${CASSANDRA_KEYSPACE}.cql
        #cqlsh ${CASSANDRA_CONNECTION} --request-timeout=120 -e "GRANT ALL PERMISSIONS ON KEYSPACE ${CASSANDRA_THEHIVE_USER} TO thehive;"
    fi

    # Create the tables and load related data
    for TABLE in $(ls "${CASSANDRA_SNAPSHOT_FOLDER}/${CASSANDRA_KEYSPACE}"); do
        TABLE_BASENAME=$(basename ${TABLE})
        TABLE_NAME=${TABLE_BASENAME%%-*}
        echo "Importing ${TABLE_NAME} table and related data"
        nodetool import ${CASSANDRA_KEYSPACE} ${TABLE_NAME} ${CASSANDRA_SNAPSHOT_FOLDER}/${CASSANDRA_KEYSPACE}/${TABLE}
        echo ""
    done

    echo "Cassandra data restoration done!"
    rm -rf "${CASSANDRA_SNAPSHOT_FOLDER}"
} &
PID_CASS=$!

ES_EXIT=0
CASS_EXIT=0

# Wait for the two snapshots to finish
wait $PID_ES || ES_EXIT=$?
wait $PID_CASS || CASS_EXIT=$?

# Final check
if [ $ES_EXIT -eq 0 ] && [ $CASS_EXIT -eq 0 ]; then
    echo "=== ✓ Successful full restore ==="
    exit 0
else
    echo "=== ✗ ERREUR - ES: exit $ES_EXIT, Cassandra: exit $CASS_EXIT ==="
    exit 1
fi
```