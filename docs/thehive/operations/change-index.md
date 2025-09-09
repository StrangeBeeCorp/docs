
# Change Index from Lucene to Elasticsearch

Lucene index support was removed starting from TheHive version 5.1. Follow this procedure to change your index to Elasticsearch. This procedure is compatible with any 5.x version.

## Setup Your Elasticsearch Server

Please refer to our [installation manual](../installation/installation-guide-linux-standalone-server.md) or use your own server. Ensure that Elasticsearch is started.

## Update TheHive Configuration

=== "DEB / RPM"

Update your `/etc/thehive/application.conf` file:

```plaintext
# Update this configuration section
db.janusgraph {
    # Retain this section for now, as TheHive will need it to migrate the index correctly
    index.search {
        backend: lucene
        directory: ...
    }

    # Add this section below the Lucene configuration
    index.search {
        backend: elasticsearch
        # Hostname(s) of your Elasticsearch server(s)
        hostname: ["localhost"]
        # Default is "thehive"
        index-name: thehive
    }
}
```

Refer to the [configuration reference](../configuration/database.md) for more options.

=== "Docker"

Update your Docker arguments:

```plaintext
# Docker compose file
command:
    # ... other args
    - "--index-backend"
    - "elasticsearch"
    - "--es-hostnames"
    - "elasticsearch"
```

## Restart TheHive Application

TheHive will detect the index change, create the new index in Elasticsearch, and start reindexing the documents into the new index. This process may take some time depending on the size of your database.

In your logs, you should see the following lines:

```plaintext
[warn] o.j.d.c.b.ReadConfigurationBuilder [] Local setting index.search.backend=elasticsearch (Type: GLOBAL_OFFLINE) is overridden by globally managed value (lucene). Use the ManagementSystem interface instead of the local configuration to control this setting.
```


During the reindexing process, you will see lines similar to these (the name `global1` may be different for you):

```plaintext
[info] o.j.g.o.j.IndexRepairJob [] Index global1 metrics: success-tx: 110 doc-updates: 10992 succeeded: 10992
[info] o.j.g.o.j.IndexRepairJob [] Index global1 metrics: success-tx: 111 doc-updates: 10992 succeeded: 10992
[info] o.j.g.d.m.ManagementSystem [] Index update job successful for [global1]
```

Finally, the application will start listening on the HTTP port, and you will be able to access the interface.

## Remove the Lucene Configuration

Once the reindexing is complete, you can remove the Lucene configuration from your configuration file.

=== "DEB / RPM"

Update your `/etc/thehive/application.conf` file:

```plaintext
# Update this configuration section
db.janusgraph {
    # Delete this section now
    index.search {
        backend: lucene
        directory: ...
    }

    # Retain this section
    index.search {
        backend: elasticsearch
        # Hostname(s) of your Elasticsearch server(s)
        hostname: ["localhost"]
        # Default is "thehive"
        index-name: thehive
    }
}
```
