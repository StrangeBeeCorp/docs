Before creating Elasticsearch snapshots, ensure Elasticsearch has the appropriate permissions to write to the snapshot repository.

For shared file systems:

!!! Example ""

    ```bash
    chown elasticsearch:elasticsearch </mnt/backup>
    chmod 770 </mnt/backup>
    ```

Then, use the following script:

!!! warning "Script restrictions"
    This script works only when Elasticsearch runs directly on a machine. It doesn't support deployments using Docker or Kubernetes.

!!! note "Default values"
    Before running this script:

    * Update the snapshot repository name to match your environment. The default name in the script is `thehive_repository`.
    * Verify that the index name matches the one used in the script, which defaults to `thehive_global`. This name may differ if you have rebuilt or customized the index.

```bash
#!/bin/bash

# Elasticsearch variables
ELASTICSEARCH_API_URL='http://127.0.0.1:9200'
ELASTICSEARCH_SNAPSHOT_REPOSITORY=thehive_repository
ELASTICSEARCH_INDEX=thehive_global

# Backup variables
GENERAL_ARCHIVE_PATH=/mnt/backup
SNAPSHOT_NAME="elasticsearch_$(date +%Y%m%d_%Hh%Mm%Ss)"

# Creating the backup folder if needed
mkdir -p ${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}

# Check if the snapshot repository is correctly registered
repository_config=$(curl -s -L "${ELASTICSEARCH_API_URL}/_snapshot")
repository_ok=$(jq 'has("'${ELASTICSEARCH_SNAPSHOT_REPOSITORY}'")' <<< ${repository_config})
if ! ${repository_ok}; then
  echo "Abort, no snapshot repository registered in ElasticSearch"
  echo "Set the repository folder 'path.repo'"
  echo "in an environment variable"
  echo "or in elasticsearch.yml"
  exit 1
fi

# Starting the snapshot
create_snapshot=$(curl -s -L -X PUT "${ELASTICSEARCH_API_URL}/_snapshot/thehive_repository/${SNAPSHOT_NAME}" -H 'Content-Type: application/json' -d '{"indices":"'${ELASTICSEARCH_INDEX}'", "ignore_unavailable":true, "include_global_state":false}')

# Verify that the snapshot started correctly
create_started=$(jq '.accepted == true' <<< ${create_snapshot})
if [ ${create_started} != true ]
then
    echo "Couldn't start the snapshot"
    exit 1
fi
echo "Snapshot started"

# Verify that the snapshot is finshed
state="NONE"
while [ "${state}" != "\"SUCCESS\"" ]; do
    echo "Snapshot in progress, waiting 5 seconds before checking status again..."
    sleep 5
    snapshot_list=$(curl -s -L "${ELASTICSEARCH_API_URL}/_snapshot/${ELASTICSEARCH_SNAPSHOT_REPOSITORY}/*?verbose=false")
    state=$(jq '.snapshots[] | select(.snapshot == "'${SNAPSHOT_NAME}'").state' <<< ${snapshot_list})
done
echo "Snapshot finished"

# Print the snapshot short informations
final_state=$(jq '.snapshots[] | select(.snapshot == "'${SNAPSHOT_NAME}'")' <<< ${snapshot_list})
echo ${final_state} | jq --color-output .

# Create a ".tar" archive with the folder containing the backed up Elasticsearch index
cd ${GENERAL_ARCHIVE_PATH}
tar cf ${SNAPSHOT_NAME}.tar ${SNAPSHOT_NAME}

# Remove the folder once the archive is created
rm -rf ${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}

# Display the location of the Elasticsearch archive
echo ""
echo "ElasticSearch backup done! Keep the following backup archive safe:"
echo "${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}.tar"
```

!!! info "Where to find the backup archive?"
    After running the script, the backup archive is available at `/mnt/backup` with a `elasticsearch_` prefix. Be sure to copy this archive to a separate server or storage location to safeguard against data loss if the TheHive server fails.

For more details, refer to the [official Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html).