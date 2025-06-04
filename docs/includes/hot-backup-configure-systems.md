#### Cassandra keyspace

Identify the keyspace used by TheHive. This is typically defined in the *application.conf* file under the `db.janusgraph.storage.cql.keyspace` attribute. If you followed the [step by step installation guide](/thehive/installation/step-by-step-installation-guide/), this keyspace should be named `thehive`. This name is also used in the scripts provided to create Cassandra snapshots.

#### Elasticsearch repository

This repository is used to create snapshots with timestamped names.

1. Configure the repository path by adding the `path.repo` parameter in the `elasticsearch.yml` file:

    ```yaml 
    path.repo: /mnt/backup
    ```

2. Restart Elasticsearch to apply the configuration changes.

3. Register the repository named `thehive_repository` by sending the following request:

    ```http
    curl -X PUT "http://127.0.0.1:9200/_snapshot/thehive_repository" \
      -H "Content-Type: application/json" \
      -d '{
        "type": "fs",
        "settings": {
          "location": "/mnt/backup"
        }
      }'
    ```
    
    A successful response looks like this:

    ```json
    {
      "acknowledged": true
    }
    ```

#### File storage location

Locate the folder where TheHive stores files, which is backed up with the database and indices. If using a local filesystem or Network File System (NFS), the location is defined in the *application.conf* file under the `storage.localfs.location` attribute.