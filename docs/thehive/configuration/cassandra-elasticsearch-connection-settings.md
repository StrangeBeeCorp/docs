# TheHive Database and Index Connection Settings

TheHive uses JanusGraph for database and index connections. These parameters configure Cassandra and Elasticsearch back ends.

## Database storage parameters

### Core storage settings

| Parameter                   | Type           |  Description               |
| --------------------------- | -------------- | ---------------------------|
| `db.provider`                                                      | string         | Provider name for the database back end. Must be: `janusgraph`. |
| `db.janusgraph.storage.backend`                                               | string         | Storage back end type. Must be: `cql`. |
| `db.janusgraph.storage.hostname`                                              | list of string | IP addresses or host names of Cassandra nodes. Must be `["127.0.0.1"]` for a standalone server deployment. |
| `db.janusgraph.storage.port`                                                 | integer        | Port number for Cassandra connection. Default: `9042` for CQL. Use a different port when SSL is enabled or when Cassandra is configured with a custom port. |

### Cassandra authentication

| Parameter                   | Type           |  Description               |
| --------------------------- | -------------- | ---------------------------|
| `db.janusgraph.storage.username`                                             | string         | Username for Cassandra authentication. Required when authentication is enabled. |
| `db.janusgraph.storage.password`                                             | string         | Password for Cassandra authentication. Required when authentication is enabled. |

### Cassandra CQL configuration

| Parameter                   | Type           |  Description               |
| --------------------------- | -------------- | ---------------------------|
| `db.janusgraph.storage.cql.keyspace`                                          | string         | Keyspace name for TheHive data storage in Cassandra. Must be: `thehive`. |
| `db.janusgraph.storage.cql.replication-factor`                                          | integer         | Replication factor for the keyspace. Use `1` for a standalone server, `3` or higher for production clusters. |

### Cassandra SSL/TLS settings

| Parameter                   | Type           |  Description               |
| --------------------------- | -------------- | ---------------------------           |
| `db.janusgraph.storage.cql.ssl.enabled`                                       | boolean        | Enable SSL for Cassandra connections. Default: `false`.  |
| `db.janusgraph.storage.cql.ssl.truststore.location`                           | string         | Path to the Java truststore file containing CA certificates.  |
| `db.janusgraph.storage.cql.ssl.truststore.password`                                      | string         | Password to access the truststore.  |
| `db.janusgraph.storage.cql.ssl.client-authentication-enabled`                 | boolean        | Enable client certificate authentication. Default: `false`.  |
| `db.janusgraph.storage.cql.ssl.keystore.location`                             | string         | Path to the Java keystore containing client certificate. Required when client authentication is enabled. |
| `db.janusgraph.storage.cql.ssl.keystore.storepassword`                      | string         | Password to access the keystore.  |
| `db.janusgraph.storage.cql.ssl.keystore.keypassword`                          | string         | Password for the private key in the keystore.  |

For more detailed information on configuring Cassandra connection, refer to the [official JanusGraph documentation.](https://docs.janusgraph.org/configs/configuration-reference/){target=_blank}.

## Index search parameters

### Core index settings

| Parameter                   | Type           |  Description               |
| --------------------------- | -------------- | ---------------------------           |
| `index.search.backend`                                          | string         | Index back end type. Must be: `elasticsearch`. |
| `index.search.hostname`                                         | list of string | IP addresses or host names of Elasticsearch nodes with optional port. Must be `["127.0.0.1"]` for a standalone server deployment. |
| `index.search.index-name`                                       | string         | Name of the Elasticsearch index for TheHive data. Must be: `thehive`. |

### Elasticsearch HTTP authentication

| Parameter                   | Type           |  Description               |
| --------------------------- | -------------- | ---------------------------           |
| `index.search.elasticsearch.http.auth.type`              | string         | Authentication type. Must be: `basic`. |
| `index.search.elasticsearch.http.auth.basic.username`           | string         | Username for Elasticsearch authentication. Required when authentication is enabled. |
| `index.search.elasticsearch.http.auth.basic.password`           | string         | Password for Elasticsearch authentication. Required when authentication is enabled. |

!!! note "Required Elasticsearch privileges"
    The Elasticsearch user must have specific privileges to work with TheHive. See the detailed configuration steps in the [installation guide](../installation/installation-guide-linux-standalone-server.md#step-44-permissions).

### Elasticsearch SSL/TLS settings

| Parameter                   | Type           |  Description               |
| --------------------------- | -------------- | ---------------------------           |
| `index.search.elasticsearch.ssl.enabled`                        | boolean        | Enable SSL for Elasticsearch connections. Default: `false`. |
| `index.search.elasticsearch.ssl.truststore.location`            | string         | Path to the Java truststore file containing CA certificates. |
| `index.search.elasticsearch.ssl.truststore.password`            | string         | Password to access the truststore. |
| `index.search.elasticsearch.ssl.keystore.location`              | string         | Path to the Java keystore containing client certificate for mutual TLS.  |
| `index.search.elasticsearch.ssl.keystore.storepassword`         | string         | Password to access the keystore. |
| `index.search.elasticsearch.ssl.keystore.keypassword`           | string         | Password for the private key in the keystore. |
| `index.search.elasticsearch.ssl.disable-hostname-verification`  | boolean        | Turn off host name verification in SSL certificates. Default: `false`. |
| `index.search.elasticsearch.ssl.allow-self-signed-certificates` | boolean        | Accept self-signed certificates. Default: `false`. |

For more detailed information on configuring Elasticsearch connection, refer to the [official JanusGraph documentation.](https://docs.janusgraph.org/configs/configuration-reference/){target=_blank}.

## Configuration example with authentication and ssl

!!! example "Database and index configuration with authentication and ssl for a standalone server installation"
    ```yaml
    # Content from /etc/thehive/application.conf
    [..]
    # Database and index configuration
    db.janusgraph {
        storage {
            backend = cql
            hostname = ["127.0.0.1"]
            username = "thehive"
            password = "<thehive_role_password>"
            cql {
                keyspace = thehive
                ssl {
                    enabled = true
                    truststore {
                        location = /path/to/<truststore_file>
                        password = <truststore_password>
                    }
                }
            }
        }
        index.search {
            backend = elasticsearch
            hostname = ["127.0.0.1"]
            index-name = thehive
            elasticsearch {
              http {
                  auth {
                      type = basic
                      basic {
                          username = "thehive"
                          password = "<thehive_user_password>"
                      }
                  }
              }
              ssl {
                    enabled = true
                    truststore {
                        location = /path/to/<truststore_file>
                        password = <truststore_password>
                    }
                }
            }
        }
    }
    [..]
    ```

<h2>Next steps</h2>

* [Configure Database and Index Authentication](configure-authentication-cassandra-elasticsearch.md)
* [Configure Database and Index SSL](configure-ssl-cassandra-elasticsearch.md)