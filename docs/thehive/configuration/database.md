# Database and Index Configuration

TheHive uses [Cassandra](https://cassandra.apache.org/) and [Elasticsearch](https://www.elastic.co/elasticsearch/) databases for data management and indexing. This topic offers instructions for configuring each available option.

!!! warning "Elasticsearch authentication permissions"
    The account used for authenticating with Elasticsearch must have [the `manage` cluster privilege](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-privileges.html#privileges-list-cluster). This is a mandatory configuration for TheHive to function correctly. If you are using an existing Elasticsearch instance, ensure it complies with your internal security policies, as certain configurations might be incompatible. Additionally, the account must have [the `all` indices privilege](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-privileges.html#privileges-list-indices), specifically for the `thehive*` indices.

---

## Basic configuration 

A typical database configuration for TheHive structures as follows:

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

**Database provider**: 

  - The database provider is set to [JanusGraph](https://janusgraph.org/), a distributed graph database.

**Storage configuration**:

  - Backend: Cassandra is specified as the backend storage system.

  - Host name: The IP address of the Cassandra cluster is provided.

  - Cluster name: The name of the Cassandra cluster is set to `thp`.

  - Keyspace: The keyspace within Cassandra where TheHive data will be stored is named `thehive`.

**Index configuration**:

  - Backend: Elasticsearch is designated as the backend for indexing.

  - Host name: The IP address of the Elasticsearch instance is set to `127.0.0.1`.

  - Index name: The index name within Elasticsearch for TheHive is specified as `thehive`.

---

## List of parameters

| Parameter                   | Type           |  Description               |
| --------------------------- | -------------- | ---------------------------| 
| `provider`                                                      | string         | Provider name. Default: `janusgraph.` | 
| `storage`                                                       | dict           | Storage configuration.               |
| `storage.backend`                                               | string         | Storage type. Can be `cql` or `berkeleyje`. |
| `storage.hostname`                                              | list of string | List of IP addresses or host names when using the `cql` backend. |
| `storage.directory`                                             | string         | Local path for data when using the berkeleyje backend. |
| `storage.username `                                             | string         | Account username with the cql backend if Cassandra authentication is configured. |
| `storage.password `                                             | string         | Account password with the cql backend if Cassandra authentication is configured. |
| `storage.port `                                                 | integer        | Port number with the cql backend (9042 by default). Change this if using an alternate port or a dedicated port number when using SSL with Cassandra. |
| `storage.cql`                                                   | dict           | Configuration for the cql backend if used.                |
| `storage.cql.cluster-name`                                      | string         | Name of the cluster used in the configuration of Apache Cassandra. |
| `storage.cql.keyspace`                                          | string         | Keyspace name used to store TheHive data in Apache Cassandra. |
| `storage.cql.ssl.enabled`                                       | boolean        | false by default. Set it to true if SSL is used with Cassandra.  |
| `storage.cql.ssl.truststore.location`                           | string         | Path to the truststore. Specify it when using SSL with Cassandra.  |
| `storage.cql.ssl.password`                                      | string         | Password to access the truststore.  |
| `storage.cql.ssl.client-authentication-enabled`                 | boolean        | Enables the use of a client key to authenticate with Cassandra.  |
| `storage.cql.ssl.keystore.location`                             | string         | Path to the keystore. Specify it when using SSL and client authentication with Cassandra. |
| `storage.cql.ssl.keystore.keypassword`                          | string         | Password to access the key in the keystore.  |
| `storage.cql.ssl.truststore.storepassword`                      | string         | Password to access the keystore.  |
| `index.search`                                                  | dict           | Configuration for indexes.               |
| `index.search.backend`                                          | string         | Index engine. Default: elasticsearch |
| `index.search.directory`                                        | string         | Path to the folder where indexes should be stored when using the elasticsearch engine. |
| `index.search.hostname`                                         | list of string | List of IP addresses or host names when using the elasticsearch engine. |
| `index.search.index-name`                                       | string         | Name of index when using the elasticsearch engine. |
| `index.search.elasticsearch.http.auth.type: basic`              | string         | basic is the only possible value. |
| `index.search.elasticsearch.http.auth.basic.username`           | string         | Username account on Elasticsearch. |
| `index.search.elasticsearch.http.auth.basic.password`           | string         | Password of the account on Elasticsearch. |
| `index.search.elasticsearch.ssl.enabled`                        | boolean        | Enable SSL (true/false). |
| `index.search.elasticsearch.ssl.truststore.location`            | string         | Location of the truststore. |
| `index.search.elasticsearch.ssl.truststore.password`            | string         | Password of the truststore. |
| `index.search.elasticsearch.ssl.keystore.location`              | string         | Location of the keystore for client authentication.  |
| `index.search.elasticsearch.ssl.keystore.storepassword`         | string         | Password of the keystore. |
| `index.search.elasticsearch.ssl.keystore.keypassword`           | string         | Password of the client certificate. |
| `index.search.elasticsearch.ssl.disable-hostname-verification`  | boolean        | Disable SSL verification (true/false). |
| `index.search.elasticsearch.ssl.allow-self-signed-certificates` | boolean        | Allow self-signed certificates (true/false). |

!!! warning "Initial startup delay"
    The initial start, or first start after configuring indexes, might take some time if the database contains a large amount of data. This time is due to the index creation process.

For more detailed information on configuring Elasticsearch connection, refer to the [official JanusGraph documentation.](https://docs.janusgraph.org/index-backend/elasticsearch/)

---

## Use cases

The database and index engine configurations can vary depending on the use case and target setup.

=== "Standalone server with Cassandra and Elasticsearch" 

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

=== "Cluster with Cassandra and Elasticsearch" 

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

    !!! warning "Consistent configuration across all TheHive nodes"
        In this configuration, all TheHive nodes should have the same configuration.
        
        Elasticsearch configuration should use the default value for `script.allowed_types`, or contain the following configuration line: 

        ```yaml
        script.allowed_types: inline,stored
        ```

<h2>Next steps</h2>

* [File Storage Configuration](file-storage.md)
* [TheHive Connectors](connectors.md)
* [Akka Configuration](akka.md)
* [Pekko Configuration (TheHive 5.4+)](pekko.md)
* [Logs Configuration](logs.md)
* [Proxy Settings](proxy.md)
* [Secret Configuration File](secret.md)
* [SSL Configuration](ssl.md)
* [Service Configuration](service.md)
* [GDPR Compliance in TheHive 5.x](gdpr.md)