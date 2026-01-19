```bash
#!/bin/bash

set -e

# Configuration
# Cassandra variables
CASSANDRA_KEYSPACE=thehive
CASSANDRA_CONNECTION="<ip_node_cassandra>"
CASSANDRA_GENERAL_ARCHIVE_PATH=/mnt/backup/cassandra
CASSANDRA_DATA_FOLDER=/var/lib/cassandra
CASSANDRA_SNAPSHOT_NAME="cassandra_$(date +%Y%m%d_%Hh%Mm%Ss)"
CASSANDRA_ARCHIVE_PATH="${CASSANDRA_GENERAL_ARCHIVE_PATH}/${CASSANDRA_SNAPSHOT_NAME}/${CASSANDRA_KEYSPACE}"

# Elasticsearch variables
ELASTICSEARCH_API_URL='http://127.0.0.1:9200'
ELASTICSEARCH_SNAPSHOT_REPOSITORY=thehive_repository
ELASTICSEARCH_GENERAL_ARCHIVE_PATH=/mnt/backup/elasticsearch
ELASTICSEARCH_SNAPSHOT_NAME="elasticsearch_$(date +%Y%m%d_%Hh%Mm%Ss)"


# Check if the snapshot repository is correctly registered
repository_config=$(curl -s -L "${ELASTICSEARCH_API_URL}/_snapshot")
repository_ok=$(jq 'has("'${ELASTICSEARCH_SNAPSHOT_REPOSITORY}'")' <<< ${repository_config})
if ! ${repository_ok}; then
  echo "Abort, no snapshot repository registered in Elasticsearch"
  echo "Set the repository folder 'path.repo'"
  echo "in an environment variable"
  echo "or in elasticsearch.yml"
  exit 1
fi

# Make sure the snapshot folder exists and its subcontent permissions are correct
mkdir -p ${CASSANDRA_ARCHIVE_PATH}
chown -R cassandra:cassandra ${CASSANDRA_ARCHIVE_PATH}
echo "Snapshot of all ${CASSANDRA_KEYSPACE} tables will be stored inside ${CASSANDRA_ARCHIVE_PATH}"

# Run both backups in parallel
{
    set -e

    # Creating snapshot name information file
    touch ${ELASTICSEARCH_GENERAL_ARCHIVE_PATH}/${ELASTICSEARCH_SNAPSHOT_NAME}.info

    echo "[ES] Starting the Elasticsearch snapshot..."
    RESPONSE=$(curl -s -L -X PUT "${ELASTICSEARCH_API_URL}/_snapshot/${ELASTICSEARCH_SNAPSHOT_REPOSITORY}/${ELASTICSEARCH_SNAPSHOT_NAME}" \
        -H 'Content-Type: application/json' \
        -d '{"indices":"thehive_global", "ignore_unavailable":true, "include_global_state":false}')
    if echo "$RESPONSE" | grep -q '"accepted":true'; then
        echo "[ES] ✓ Elasticsearch snapshot started successfully"
        exit 0
    else
        echo "[ES] ✗ Elasticsearch ERROR: $RESPONSE"
        exit 1
    fi

    # Verify that the snapshot is finished
    state="NONE"
    while [ "${state}" != "\"SUCCESS\"" ]; do
        echo "Snapshot in progress, waiting 5 seconds before checking status again..."
        sleep 5
        snapshot_list=$(curl -s -L "${ELASTICSEARCH_API_URL}/_snapshot/${ELASTICSEARCH_SNAPSHOT_REPOSITORY}/*?verbose=false")
        state=$(jq '.snapshots[] | select(.snapshot == "'${ELASTICSEARCH_SNAPSHOT_NAME}'").state' <<< ${snapshot_list})
    done
    echo "Snapshot finished"    

} &
PID_ES=$!

{
    set -e

    echo "[CASS] Starting snapshot ${CASSANDRA_SNAPSHOT_NAME} for keyspace ${CASSANDRA_KEYSPACE}"
    if nodetool snapshot -t "${CASSANDRA_SNAPSHOT_NAME}" "${CASSANDRA_KEYSPACE}"; then
        echo "[CASS] ✓ Snapshot Cassandra created successfully"

        # Save the cql schema of the keyspace
        cqlsh ${CASSANDRA_CONNECTION}  -e "DESCRIBE KEYSPACE ${CASSANDRA_KEYSPACE}" | grep -v "^WARNING" > "${CASSANDRA_GENERAL_ARCHIVE_PATH}/${CASSANDRA_SNAPSHOT_NAME}/create_keyspace_${CASSANDRA_KEYSPACE}.cql"
        echo "The keyspace cql definition for ${CASSANDRA_KEYSPACE} is stored in this file: ${CASSANDRA_GENERAL_ARCHIVE_PATH}/${CASSANDRA_SNAPSHOT_NAME}/create_keyspace_${CASSANDRA_KEYSPACE}.cql"

        # For each table folder in the keyspace folder of the snapshot
        for TABLE in $(ls ${CASSANDRA_DATA_FOLDER}/data/${CASSANDRA_KEYSPACE}); do
            # Folder where the snapshot files are stored
            TABLE_SNAPSHOT_FOLDER=${CASSANDRA_DATA_FOLDER}/data/${CASSANDRA_KEYSPACE}/${TABLE}/snapshots/${CASSANDRA_SNAPSHOT_NAME}
            if [ -d ${TABLE_SNAPSHOT_FOLDER} ]; then 
                # Create a folder for each table
                mkdir "${CASSANDRA_ARCHIVE_PATH}/${TABLE}"
                chown -R cassandra:cassandra ${CASSANDRA_ARCHIVE_PATH}/${TABLE}

                # Copy the snapshot files to the proper table folder
                # Snapshots files are hardlinks,
                # so we use --remove-destination to make sure the files are actually copied and not just linked
                cp -p --remove-destination ${TABLE_SNAPSHOT_FOLDER}/* ${CASSANDRA_ARCHIVE_PATH}/${TABLE}
            fi
        done

        # Delete Cassandra snapshot once it's backed up
        nodetool clearsnapshot -t ${CASSANDRA_SNAPSHOT_NAME} > /dev/null

        # Create a .tar archive with the folder containing the backed up Cassandra data
        tar cf ${CASSANDRA_GENERAL_ARCHIVE_PATH}/${CASSANDRA_SNAPSHOT_NAME}.tar -C "${CASSANDRA_GENERAL_ARCHIVE_PATH}" ${CASSANDRA_SNAPSHOT_NAME}
        # Remove the folder once the archive is created
        rm -rf ${CASSANDRA_GENERAL_ARCHIVE_PATH}/${CASSANDRA_SNAPSHOT_NAME}

        exit 0
    else
        echo "[CASS] ✗ Cassandra ERROR"
        exit 1
    fi
} &
PID_CASS=$!

ES_EXIT=0
CASS_EXIT=0

# Wait for the two snapshots to finish
wait $PID_ES || ES_EXIT=$?
wait $PID_CASS || CASS_EXIT=$?

# Final check
if [ $ES_EXIT -eq 0 ] && [ $CASS_EXIT -eq 0 ]; then
    echo "=== ✓ Full backup successful ==="

    # Display the location of the Elasticsearch archive
    echo "Elasticsearch backup done!" 

    # Display the location of the Cassandra archive
    echo "Cassandra backup done! Keep the following backup archive safe:"
    echo "${CASSANDRA_GENERAL_ARCHIVE_PATH}/${CASSANDRA_SNAPSHOT_NAME}.tar"

    exit 0
else
    echo "=== ✗ ERROR - ES: exit $ES_EXIT, Cassandra: exit $CASS_EXIT ==="
    exit 1
fi
```