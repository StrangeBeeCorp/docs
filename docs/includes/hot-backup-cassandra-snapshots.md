Before creating Cassandra snapshots, gather the following information:

* Cassandra administrator password
* SSL certificates and authentication details required to connect securely to Cassandra

Then, use the following script:

!!! warning "Script restrictions"
    This script works only when Cassandra runs directly on a machine. It doesn't support deployments using Docker or Kubernetes.

!!! note "Keyspace name"
    Before running this script, update the keyspace name to match your environment. The keyspace is typically defined in the `application.conf` file under the `db.janusgraph.storage.cql.keyspace` attribute. The script uses `thehive` by default.

```bash
#!/bin/bash

# Cassandra variables
CASSANDRA_KEYSPACE=thehive
CASSANDRA_DATA_FOLDER=/var/lib/cassandra

# Backup variables
GENERAL_ARCHIVE_PATH=/mnt/backup
SNAPSHOT_NAME="cassandra_$(date +%Y%m%d_%Hh%Mm%Ss)"
CASSANDRA_ARCHIVE_PATH="${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}/${CASSANDRA_KEYSPACE}"

# Perform a snapshot of the keyspace
echo "Starting snapshot ${SNAPSHOT_NAME} for keyspace ${CASSANDRA_KEYSPACE}"
nodetool snapshot -t ${SNAPSHOT_NAME} ${CASSANDRA_KEYSPACE}

# Make sure the snapshot folder exists and its subcontent permissions are correct
mkdir -p ${CASSANDRA_ARCHIVE_PATH}
chown -R cassandra:cassandra ${CASSANDRA_ARCHIVE_PATH}
echo "Snapshot of all ${CASSANDRA_KEYSPACE} tables will be stored inside ${CASSANDRA_ARCHIVE_PATH}"

# Save the cql schema of the keyspace
cqlsh -e "DESCRIBE KEYSPACE ${CASSANDRA_KEYSPACE}" > "${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}/create_keyspace_${KEYSPACE}.cql"
echo "The keyspace cql definition for ${CASSANDRA_KEYSPACE} is stored in this file: ${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}/create_keyspace_${CASSANDRA_KEYSPACE}.cql"

# For each table folder in the keyspace folder of the snapshot
for TABLE in $(ls ${CASSANDRA_DATA_FOLDER}/data/${CASSANDRA_KEYSPACE}); do
    # Folder where the snapshot files are stored
    TABLE_SNAPSHOT_FOLDER=${CASSANDRA_DATA_FOLDER}/data/${CASSANDRA_KEYSPACE}/${TABLE}/snapshots/${SNAPSHOT_NAME}

    # Create a folder for each table
    mkdir ${CASSANDRA_ARCHIVE_PATH}/${TABLE}
    chown -R cassandra:cassandra ${CASSANDRA_ARCHIVE_PATH}/${TABLE}

    # Copy the snapshot files to the proper table folder
    # Snapshots files are hardlinks,
    # so we use --remove-destination to make sure the files are actually copied and not just linked
    cp -p --remove-destination ${TABLE_SNAPSHOT_FOLDER}/* ${CASSANDRA_ARCHIVE_PATH}/${TABLE}
done

# Delete Cassandra snapshot once it's backed up
nodetool clearsnapshot -t ${SNAPSHOT_NAME} > /dev/null

# Create a ".tar" archive with the folder containing the backed up Cassandra data
cd ${GENERAL_ARCHIVE_PATH}
tar cf ${SNAPSHOT_NAME}.tar ${SNAPSHOT_NAME}

# Remove the folder once the archive is created
rm -rf ${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}

# Display the location of the Cassandra archive
echo ""
echo "Cassandra backup done! Keep the following backup archive safe:"
echo "${GENERAL_ARCHIVE_PATH}/${SNAPSHOT_NAME}.tar"
```

!!! info "Where to find the backup archive?"
    After running the script, the backup archive is available at `/mnt/backup` with a `cassandra_` prefix. Be sure to copy this archive to a separate server or storage location to safeguard against data loss if the TheHive server fails.

For more details, refer to the [official Cassandra documentation](https://cassandra.apache.org/doc/stable/cassandra/operating/backups.html).