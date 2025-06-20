To restore Cassandra snapshots, run the following script:

```bash
#!/bin/bash

# Cassandra variables
CASSANDRA_KEYSPACE=thehive

# Backup variables
GENERAL_ARCHIVE_PATH=/mnt/backup

# Look for the latest archived Cassandra snapshot
CASSANDRA_BACKUP_LIST=(${GENERAL_ARCHIVE_PATH}/cassandra_????????_??h??m??s.tar)
CASSANDRA_LATEST_BACKUP_NAME=$(basename ${CASSANDRA_BACKUP_LIST[-1]})

echo "Latest Cassandra backup archive found is ${GENERAL_ARCHIVE_PATH}/${CASSANDRA_LATEST_BACKUP_NAME}"

# Extract the latest archive
CASSANDRA_SNAPSHOT_NAME=$(echo ${CASSANDRA_LATEST_BACKUP_NAME} | cut -d '.' -f 1)
CASSANDRA_SNAPSHOT_FOLDER="${GENERAL_ARCHIVE_PATH}/${CASSANDRA_SNAPSHOT_NAME}"

tar xvf "${GENERAL_ARCHIVE_PATH}/${CASSANDRA_LATEST_BACKUP_NAME}"
echo "Latest Cassandra backup archive extracted in ${CASSANDRA_SNAPSHOT_FOLDER}"

# Go inside the Cassandra snapshot recently extracted
cd ${CASSANDRA_SNAPSHOT_FOLDER}

# Check if Cassandra already has an existing keyspace
cqlsh -e "DESCRIBE KEYSPACE ${CASSANDRA_KEYSPACE}" > "${CASSANDRA_SNAPSHOT_FOLDER}/target_keyspace_${CASSANDRA_KEYSPACE}.cql"

if cmp --silent -- "${CASSANDRA_SNAPSHOT_FOLDER}/create_keyspace_${CASSANDRA_KEYSPACE}.cql" "${CASSANDRA_SNAPSHOT_FOLDER}/target_keyspace_${CASSANDRA_KEYSPACE}.cql"; then
    echo "Existing ${CASSANDRA_KEYSPACE} keyspace definition is identical to the one in the backup, no need to drop and recreate it"
else
    echo "Existing ${CASSANDRA_KEYSPACE} keyspace definition does not match the one in the backup, dropping it"
    cqlsh --request-timeout=120 -e "DROP KEYSPACE IF EXISTS ${CASSANDRA_KEYSPACE};"
    sleep 5s
    echo "Creating ${CASSANDRA_KEYSPACE} keyspace using the definition from the backup"
    cqlsh --request-timeout=120 -f ${CASSANDRA_SNAPSHOT_FOLDER}/create_keyspace_${CASSANDRA_KEYSPACE}.cql
fi

# Create the tables and load related data
cd ${CASSANDRA_KEYSPACE}
for TABLE in $(ls); do
    TABLE_BASENAME=$(basename ${TABLE})
    TABLE_NAME=${TABLE_BASENAME%%-*}
    echo "Importing ${TABLE_NAME} table and related data"
    nodetool import ${CASSANDRA_KEYSPACE} ${TABLE_NAME} ${CASSANDRA_SNAPSHOT_FOLDER}/${CASSANDRA_KEYSPACE}/${TABLE}
    echo ""
done

echo "Cassandra data restoration done!"
rm -rf ${CASSANDRA_SNAPSHOT_FOLDER}
```

For additional details, refer to the [official Cassandra documentation](https://cassandra.apache.org/doc/stable/cassandra/operating/backups.html).