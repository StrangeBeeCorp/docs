# Configure Database and Index Authentication

We're going to secure your TheHive installation by configuring authentication for both Cassandra and Elasticsearch. By the end, you'll have password-protected access to your database and index backends.

{% include-markdown "includes/maintenance-window-required.md" %}

## Configure authentication for Cassandra

### Step 1: Stop your services

First, we need to stop your running services in the following order to avoid data corruption:

1. Stop TheHive service

2. Stop Cassandra service

!!! info "Service commands"
    For stop/restart commands depending on your installation method, refer back to the relevant installation guide.

### Step 2: Update Cassandra configuration

Now we'll modify Cassandra configuration to require authentication.

1. Locate the `cassandra.yaml` file.

2. Open the `cassandra.yaml` file using a text editor.

3. In the `cassandra.yaml` file, enable authentication.

    Set the following parameters with these exact values:

    ```yaml
    authenticator: PasswordAuthenticator
    authorizer: CassandraAuthorizer 
    ```

4. Save your modifications in the `cassandra.yaml` file.

5. Restart Cassandra service.

### Step 3: Set a secure password for authentication

{% include-markdown "includes/set-password-authentication-cassandra.md" %}

### Step 4: Create a new administrator role for authentication

{% include-markdown "includes/create-administrator-role-cassandra.md" %}

### Step 5: Create a role for TheHive

Let's create a dedicated role that TheHive will use to connect to Cassandra.

1. Create a dedicated role for TheHive.

    ```bash
    CREATE ROLE thehive WITH LOGIN = true AND PASSWORD = '<thehive_role_password>';
    ```

    Replace `<thehive_role_password>` with the password you intend to use for the `thehive` role.

    !!! tip "Note this password"
        Keep this password secure. You will need to enter it later in TheHive configuration file so the application can connect to the Cassandra database.

2. Grant access to the keyspace.

    ```bash
    GRANT ALL PERMISSIONS ON KEYSPACE thehive TO 'thehive';
    ```

### Step 6: Update TheHive configuration

Now we'll configure TheHive to use the credentials we just created.

1. Open the `application.conf` file using a text editor.

2. In the `application.conf` file, update the database configuration.

    !!! example "Example of database configuration with authentication"
        ```yaml
        [..]
        # Database and index configuration
        db.janusgraph {
            storage {
                [..]
                # Cassandra authentication
                username = "thehive"
                password = "<thehive_role_password>"
                cql {
                    keyspace = thehive
                }
            }
            index.search {
                [..]
            }
        }
        [..]
        ```

    Replace `<thehive_role_password>` with the password set in [Step 5](#step-5-create-a-role-for-thehive).

    To set up SSL for Cassandra connections, see [Configure Database and Index SSL](configure-ssl-cassandra-elasticsearch.md#configure-ssl-for-cassandra).

    For additional connection parameters and advanced options, see [TheHive Database and Index Connection Settings](cassandra-elasticsearch-connection-settings.md).

3. Save your modifications in the `application.conf` file.

4. Restart TheHive service.

At this point, your Cassandra database is secured with authentication.

## Configure authentication for Elasticsearch

### Step 1: Stop services

First, we need to stop your running services in the following order to avoid data corruption:

1. Stop TheHive service

2. Stop Elasticsearch service

### Step 2: Update Elasticsearch configuration

Now we'll modify Elasticsearch configuration to require authentication.

1. Open the `/etc/elasticsearch/elasticsearch.yml` file using a text editor.

2. In the `elasticsearch.yml` file, add the desired security parameters from [the official Elasticsearch security settings documentation](https://www.elastic.co/docs/reference/elasticsearch/configuration-reference/security-settings).
    
    At minimum add the following line (or edit it if it already exists):

    ```yaml
    xpack.security.enabled: true
    ```

3. Restart Elasticsearch service.

### Step 3: Set a user with the right permissions for TheHive

{% include-markdown "includes/set-user-thehive-elasticsearch.md" %}

### Step 4: Update TheHive configuration

Now we'll configure TheHive to use the credentials we just created.

1. Open the `application.conf` file using a text editor.

2. In the `application.conf` file, update the index configuration.

    !!! example "Example of index configuration with authentication"
        ```yaml
        [..]
        # Database and index configuration
        db.janusgraph {
            storage {
                [..]
            }
            index.search {
                [..]
                # Elasticsearch authentication
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
                }
            }
        }
        [..]
        ```

    Replace `<thehive_user_password>` with the password set in [Step 3](#step-3-set-a-user-with-the-right-permissions-for-thehive).

    To set up SSL for Elasticsearch connections, see [Configure Database and Index SSL](configure-ssl-cassandra-elasticsearch.md#configure-ssl-for-elasticsearch).

    For additional connection parameters and advanced options, see [TheHive Database and Index Connection Settings](cassandra-elasticsearch-connection-settings.md).

3. Save your modifications in the `application.conf` file.

4. Restart TheHive service.

At this point, Elasticsearch is secured and requires valid credentials for access.

<h2>Next steps</h2>

* [Configure Database and Index SSL](configure-ssl-cassandra-elasticsearch.md)