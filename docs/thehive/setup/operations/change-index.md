# Change Index from Lucene to Elasticsearch

Lucene index support was removed starting from TheHive 5.1. Here is the procedure to change your index to Elasticsearch.
This procedure can be used with any 5.x version.

## Setup your Elasticsearch server

Please refer to our [installation manual](../installation/step-by-step-guide.md) or use your own server. Make sure that elasticsearch is started.

## Update TheHive configuration

=== "DEB / RPM"

    Update your `/etc/thehive/application.conf` file:

    ```
    # Update this configuration section
    db.janusgraph {
        index.search {
            backend: elasticsearch
            # Hostname(s) or your elasticsearch server(s)
            hostname: ["localhost"]
            # default is "thehive"
            index-name: thehive
        }
    }
    ```

    See the [configuration reference](../configuration/database.md) for more options.

=== "Docker"

    Update your arguments:

    ```
    # Docker compose file
    command:
        # ... other args
        - "--index-backend"
        - "elasticsearch"
        - "--es-hostnames"
        - "elasticsearch"
    ```

## Restart TheHive application

TheHive will detect the change of index, create the new index in Elasticsearch and start reindexing the documents into the new index. 

This operation may take some time depending on the size of your database.
