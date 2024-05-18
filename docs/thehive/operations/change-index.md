# Change Index from Lucene to Elasticsearch

Lucene index support was removed since TheHive version 5.1. Here is the procedure to change your index to Elasticsearch.
This procedure can be used with any 5.x version.

## Setup your Elasticsearch server

Please refer to our [installation manual](../installation/step-by-step-guide.md) or use your own server. Make sure that elasticsearch is started.

## Update TheHive configuration

=== "DEB / RPM"

    Update your `/etc/thehive/application.conf` file:

    ```
    # Update this configuration section
    db.janusgraph {
        # Keep this section for now, TheHive will need this configuration to migrate the index correctly
        index.search {
            backend: lucene
            directory: ...
        }

        # Add this section below the lucene one
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

In your logs, you should see the lines:

```
[warn] o.j.d.c.b.ReadConfigurationBuilder [] Local setting index.search.backend=elasticsearch (Type: GLOBAL_OFFLINE) is overridden by globally managed value (lucene).  Use the ManagementSystem interface instead of the local configuration to control this setting.
```

You can safely ignore this warning caused by the library Janusgraph:
```
[warn] o.j.g.t.v.EmptyVertexCache [] Vertex cache is already closed
```

During the reindex you will see those lines (the name `global1` may be different for you):

```
[info] [info] o.j.g.o.j.IndexRepairJob [] Index global1 metrics: success-tx: 110 doc-updates: 10992 succeeded: 10992
[info] [info] o.j.g.o.j.IndexRepairJob [] Index global1 metrics: success-tx: 111 doc-updates: 10992 succeeded: 10992
[info] [info] o.j.g.d.m.ManagementSystem [] Index update job successful for [global1]
```

Finally the application will start to listen on the http port and you will be able to access the interface.

## Remove the lucene config

In your configuration file, you can now remove the configuration for lucene

=== "DEB / RPM"

    Update your `/etc/thehive/application.conf` file:

    ```
    # Update this configuration section
    db.janusgraph {
        # Delete this section now
        index.search {
            backend: lucene
            directory: ...
        }

        # Keep this section
        index.search {
            backend: elasticsearch
            # Hostname(s) or your elasticsearch server(s)
            hostname: ["localhost"]
            # default is "thehive"
            index-name: thehive
        }
    }
    ```
