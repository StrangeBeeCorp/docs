# Configure Database and Index SSL

We're going to enable SSL/TLS for both Cassandra and Elasticsearch to secure communication with TheHive. By the end, all connections to the database and index backends will be encrypted in transit.

{% include-markdown "includes/maintenance-window-required.md" %}

## Configure SSL for Cassandra

### Step 1: Stop TheHive service

Stop TheHive before applying changes to avoid conflicts.

!!! info "Service commands"
    For stop/restart commands depending on your installation method, refer back to the relevant installation guide.

### (Optional) Step 2: Configure Java Virtual Machine (JVM) trust for Cassandra SSL certificates

Java applications such as TheHive rely on a Java trust store to validate SSL/TLS certificates. By default, the JVM trusts only well-known certificate authorities (CAs).

If you use self-signed certificates or internal CAs, you must configure the JVM to trust them.

See [Configure JVM Trust for SSL Certificates](../configuration/ssl/configure-ssl-jvm.md) for instructions.

### Step 3: Update TheHive configuration

1. Open the `application.conf` file using a text editor.

2. In the `application.conf` file, update the database configuration.

    !!! example "Example of database configuration with SSL"
        ```yaml
        [..]
        # Database and index configuration
        db.janusgraph {
            storage {
                [..]
                cql {
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
                [..]
            }
        }
        [..]
        ```

    For additional connection parameters and advanced options, see [TheHive Database and Index Connection Settings](cassandra-elasticsearch-connection-settings.md).

3. Save your modifications in the `application.conf` file.

### Step 4: Restart TheHive service

Restart TheHive to apply the new configuration.

## Configure SSL for Elasticsearch

### Step 1: Stop TheHive service

Stop TheHive before applying changes to avoid conflicts.

### (Optional) Step 2: Configure Java Virtual Machine (JVM) trust for Elasticsearch SSL certificates

Java applications such as TheHive rely on a Java trust store to validate SSL/TLS certificates. By default, the JVM trusts only well-known certificate authorities (CAs).

If you use self-signed certificates or internal CAs, you must configure the JVM to trust them.

See [Configure JVM Trust for SSL Certificates](../configuration/ssl/configure-ssl-jvm.md) for instructions.

### Step 3: Update TheHive configuration

1. Open the `application.conf` file using a text editor.

2. In the `application.conf` file, update the index configuration.

    !!! example "Example of index configuration with SSL"
        ```yaml
        [..]
        # Database and index configuration
        db.janusgraph {
            storage {
                [..]
            }
            index.search {
                [..]
                elasticsearch {
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

    For additional connection parameters and advanced options, see [TheHive Database and Index Connection Settings](cassandra-elasticsearch-connection-settings.md).

3. Save your modifications in the `application.conf` file.

### Step 4: Restart TheHive service

Restart TheHive to apply the new configuration.

<h2>Next steps</h2>

* [Configure Database and Index Authentication](configure-authentication-cassandra-elasticsearch.md)