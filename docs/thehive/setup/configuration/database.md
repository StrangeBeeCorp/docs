# Database and Index Configuration

TheHive utilizes [Cassandra](https://cassandra.apache.org/) and [Elasticsearch](https://www.elastic.co/elasticsearch/) databases for data management and indexing purposes. Below outlines the configuration options available:

## Basic Configuation 

A typical database configuration for TheHive is structured as follows:

```
## Database configuration
db {
  provider = janusgraph
  janusgraph {
    ## Storage configuration
    storage {
      backend = cql
      hostname = ["IP_ADDRESS"]
      cql {
        cluster-name = thp
        keyspace = thehive
      }
    }
    ## Index configuration
    index.search {
      backend = elasticsearch
      hostname = ["127.0.0.1"]
      index-name = thehive
    }
  }
}
```

This configuration specifies the following components:

**Database Provider**: The database provider is set to JanusGraph, a distributed graph database.

**Storage Configuration**:
  - Backend: Cassandra is specified as the backend storage system.

  - Hostname: The IP address of the Cassandra cluster is provided.

  - Cluster Name: The name of the Cassandra cluster is set to 'thp'.

  - Keyspace: The keyspace within Cassandra where TheHive data will be stored is named 'thehive'.

**Index Configuration**:
  - Backend: Elasticsearch is designated as the backend for indexing.

  - Hostname: The IP address of the Elasticsearch instance is set to '127.0.0.1'.

  - Index Name: The index name within Elasticsearch for TheHive is specified as 'thehive'.


## List of Parameters

| Parameter                   | Type           |  Description               |
| --------------------------- | -------------- | ---------------------------| 
| `provider`                                                      | string         | Provider name. Default: `janusgraph.` | 
| `storage`                                                       | dict           | Storage configuration.               |
| `storage.backend`                                               | string         | Storage type. Can be `cql` or `berkeleyje`. |
| `storage.hostname`                                              | list of string | List of IP addresses or hostnames when using the `cql` backend. |
| `storage.directory`                                             | string         | Local path for data when using the berkeleyje backend. |
| `storage.username `                                             | string         | Account username with the cql backend if Cassandra authentication is configured. |
| `storage.password `                                             | string         | Account password with the cql backend if Cassandra authentication is configured. |
| `storage.port `                                                 | integer        | Port number with the cql backend (9042 by default). Change this if using an alternate port or a dedicated port number when using SSL with Cassandra. |
| `storage.cql`                                                   | dict           | Configuration for the cql backend if used.                |
| `storage.cql.cluster-name`                                      | string         | Name of the cluster used in the configuration of Apache Cassandra. |
| `storage.cql.keyspace`                                          | string         | Keyspace name used to store TheHive data in Apache Cassandra. |
| `storage.cql.ssl.enabled`                                       | boolean        | false by default. Set it to true if SSL is used with Cassandra.  |
| `storage.cql.ssl.truststore.location`                           | string         | Path to the truststore. Specify it when using SSL with Cassandra.  |
| `storage.cql.ssl.password`                                      | string        | Password to access the truststore.  |
| `storage.cql.ssl.client-authentication-enabled`                 | boolean       | Enables the use of a client key to authenticate with Cassandra.  |
| `storage.cql.ssl.keystore.location`                             | string         | Path to the keystore. Specify it when using SSL and client authentication with Cassandra.  |
| `storage.cql.ssl.keystore.keypassword`                          | string         | Password to access the key in the keystore.  |
| `storage.cql.ssl.truststore.storepassword`                      | string         | Password to access the keystore.  |
| `index.search`                                                  | dict           | Configuration for indexes.               |
| `index.search.backend`                                          | string         | Index engine. Default: lucene provided with TheHive. Can also be elasticsearch.  |
| `index.search.directory`                                        | string         | Path to the folder where indexes should be stored when using the lucene engine.           |
| `index.search.hostname`                                         | list of string | List of IP addresses or hostnames when using the elasticsearch engine.          |
| `index.search.index-name`                                       | string         | Name of index when using the elasticsearch engine.           |
| `index.search.elasticsearch.http.auth.type: basic`              | string         | basic is the only possible value. |
| `index.search.elasticsearch.http.auth.basic.username`           | string         | Username account on Elasticsearch. |
| `index.search.elasticsearch.http.auth.basic.password`           | string         | Password of the account on Elasticsearch. |
| `index.search.elasticsearch.ssl.enabled`                        | boolean        | Enable SSL (true/false). |
| `index.search.elasticsearch.ssl.truststore.location`            | string         | Location of the truststore. |
| `index.search.elasticsearch.ssl.truststore.password`            | string         | Password of the truststore. |
| `index.search.elasticsearch.ssl.keystore.location`              | string         | 	Location of the keystore for client authentication.  |
| `index.search.elasticsearch.ssl.keystore.storepassword`         | string         | Password of the keystore. |
| `index.search.elasticsearch.ssl.keystore.keypassword`           | string         | Password of the client certificate. |
| `index.search.elasticsearch.ssl.disable-hostname-verification`  | boolean        | Disable SSL verification (true/false). |
| `index.search.elasticsearch.ssl.allow-self-signed-certificates` | boolean        | Allow self-signed certificates (true/false). |

!!! Warning "The initial start, or first start after configuring indexes, might take some time if the database contains a large amount of data. This time is due to the index creation process."

For more detailed information on configuring Elasticsearch connection, refer to the [**official JanusGraph documentation.**](https://docs.janusgraph.org/index-backend/elasticsearch/)


## Use Cases

The database and index engine configurations can vary depending on the use case and target setup.

=== "Standalone Server with Cassandra & Elasticsearch" 

  To set up TheHive on a standalone server with Cassandra and Elasticsearch:

  1. Install a Cassandra server locally.
  2. Install Elasticsearch.
  3. Configure TheHive with the following settings:

      ```hocon
      ## Database Configuration
      db {
        provider = janusgraph
        janusgraph {
          ## Storage configuration
          storage {
            backend = cql
            hostname = ["127.0.0.1"]
            ## Cassandra authentication (if configured)
            username = "thehive_account"
            password = "cassandra_password"
            cql {
              cluster-name = thp
              keyspace = thehive
            }
          }
          ## Index configuration
          index.search {
            backend = elasticsearch
            hostname = ["127.0.0.1"]
            index-name = thehive
          }
        }
    ```

=== "Cluster with Cassandra & Elasticsearch" 

    To deploy TheHive on a cluster with Cassandra and Elasticsearch:

    1. Install a cluster of Cassandra servers.
    2. Set up access to an Elasticsearch server.
    3. Configure TheHive with the following settings:

        ```hocon
        ## Database Configuration
        db {
          provider = janusgraph
          janusgraph {
            ## Storage configuration
            storage {
              backend = cql
              hostname = ["10.1.2.1", "10.1.2.2", "10.1.2.3"]
              ## Cassandra authentication (if configured)
              username = "thehive_account"
              password = "cassandra_password"
              cql {
                cluster-name = thp
                keyspace = thehive
              }
            }
            ## Index configuration
            index {
              search {
                backend  = elasticsearch
                hostname  = ["10.1.2.5"]
                index-name  = thehive
                elasticsearch {
                  http {
                    auth {
                      type = basic
                      basic {
                        username = httpuser
                        password = httppassword
                      }
                    }
                  }
                  ssl {
                    enabled = true
                    truststore {
                      location = /path/to/your/truststore.jks
                      password = truststorepwd
                    }
                  }
                }
              }
            }
          }
        }
        ```

    !!! Warning
        In this configuration, all TheHive nodes should have the same configuration.
        
        Elasticsearch configuration should use the default value for `script.allowed_types`, or contain the following configuration line = 

        ```yaml
        script.allowed_types: inline,stored
        ```