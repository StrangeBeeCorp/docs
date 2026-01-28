# Set Up a Cluster on Linux Systems

<!-- md:version 5.4 -->

!!! Note

    * This documentation applies to TheHive versions 5.4 and later. For earlier versions, [refer to the Akka Configuration](../configuration/akka.md).
    * This documentation applies for a fresh installation for a new instance.

This guide presents configuration examples for setting up a fault-tolerant cluster for TheHive. Each cluster comprises three active nodes, featuring:

* Cassandra for the database
* Elasticsearch for the indexing engine
* NFS or S3-compatible object storage for file storage
* TheHive
* HAProxy for load balancing
* Keepalived for virtual IP setup

!!! Info
    You can install these applications on separate servers or on the same server. For the purpose of this documentation, we've chosen to demonstrate the setup on three distinct operating systems.

!!! warning "Before you begin"
  
    * Verify that all [Linux system requirements](system-requirements.md) are met on every node.
    * Ensure that Python 3.9 is available for using the Cassandra Query Language (CQL) shell `cqlsh`. Later Python versions aren't compatible.

{% include-markdown "includes/data-protection-link.md" %}

## Architecture diagram

![TheHive cluster architecture](../images/overview/thehive-architecture-full-cluster.png){ width=70% .center }

The diagram above illustrates the key components and their interactions within the cluster architecture.

Each component fulfills a critical role in the functionality and resilience of the cluster:

* Keepalived manages a virtual IP address to provide automatic failover and maintain service continuity.
* HAProxy distributes incoming requests across TheHive nodes to improve availability and handle node failures transparently.
* Cassandra ensures durable and consistent storage of TheHive data across nodes.
* Elasticsearch enables efficient indexing and fast search capabilities.
* Shared file storage centralizes attachments and file-type observables, making them available to all cluster nodes.
* TheHive nodes run the application logic and coordinate incident response workflows and collaboration.

The subsequent sections will provide detailed configuration examples and step-by-step instructions for setting up each component within the cluster environment.

## Step 1: Install and configure Apache Cassandra

When configuring a Cassandra cluster, we aim to establish a setup comprising three active nodes with a replication factor of `3`. This configuration ensures that all nodes are active and data is replicated across each node, thus providing tolerance to the failure of a single node. It means that if one node experiences hardware issues or network disruptions, the other two nodes continue to store and process incident data seamlessly. This fault-tolerant configuration guarantees uninterrupted access to critical security information, enabling the SOC to effectively manage and respond to cybersecurity threats without downtime or data loss.

!!! Info "Note: Note: For the purposes of this documentation, we assume that all nodes reside within the same network environment. Ideally, the nodes should be deployed in different racks within the same data center."

### Step 1.1: Install Cassandra

To ensure the successful deployment of Cassandra within your cluster, it's essential to install Cassandra on each individual node. Follow the steps outlined in the [installation guide](installation-guide-linux-standalone-server.md#step-31-install-cassandra).

!!! Info "A node in this context refers to each server or machine designated to participate in the Cassandra cluster."

### Step 1.2: Configure Cassandra

For each node in the Cassandra cluster, it's crucial to update the configuration files located at `/etc/cassandra/cassandra.yaml` with specific parameters to ensure proper functionality. Follow the steps below to modify the configuration:

1. Update Cassandra configuration file.

    Open the `/etc/cassandra/cassandra.yaml` file on each node using a text editor:

    !!! Example ""

        ```yaml title="/etc/cassandra/cassandra.yaml" hl_lines="13"
        cluster_name: 'thp'
        num_tokens: 4
        authenticator: PasswordAuthenticator
        authorizer: CassandraAuthorizer
        role_manager: CassandraRoleManager
        data_file_directories:
            - /var/lib/cassandra/data
        commitlog_directory: /var/lib/cassandra/commitlog
        saved_caches_directory: /var/lib/cassandra/saved_caches
        seed_provider:
            - class_name: org.apache.cassandra.locator.SimpleSeedProvider
            parameters:
                - seeds: "<ip_node_1>, <ip_node_2>, <ip_node_3>"  # (1)
        listen_interface : eth0 # (2)
        rpc_interface: eth0 # (3)
        endpoint_snitch: GossipingPropertyFileSnitch
        ```

        1.  Ensure to list all IP addresses of the nodes that are included in the cluster
        2.  Ensure to setup the right interface name
        3.  Ensure to setup the right interface name

    * Cluster name: Set the name of the Cassandra cluster.
    * Number of tokens: Configure the number of tokens for each node.
    * Authentication and authorization: Specify the authenticator, authorizer, and role manager.
    * Directories: Define directories for data, commit logs, and saved caches.
    * Seed provider: List all IP addresses of nodes included in the cluster. Ensure to list all IP addresses of the nodes that are included in the cluster.
    * Network interfaces: Set up the appropriate network interfaces. Ensure to setup the right interface name.
    * Endpoint snitch: Specify the snitch for determining network topology.

    !!! Info "For detailed explanations of each parameter in the YAML file, refer to the [Cassandra configuration section](installation-guide-linux-standalone-server.md#step-32-configure-cassandra)."

2. Delete Cassandra topology properties file.

    Remove the `cassandra-topology.properties` file to prevent any conflicts:

    !!! Example ""
        ```
        rm /etc/cassandra/cassandra-topology.properties
        ```

3. Configure Cassandra GossipingPropertyFileSnitch.

    In the `cassandra-rackdc.properties`  file assign the datacenter and rack names for each node:

    !!! Example ""

        ```yaml title="cassandra-rackdc.properties" hl_lines="13"
        ## On node1, edit /etc/cassandra/cassandra-rackdc.properties and add the following conf
        dc=datacenter1
        rack=rack1

        ## On node2, edit /etc/cassandra/cassandra-rackdc.properties and add the following conf
        dc=datacenter1
        rack=rack2

        ## On node3, edit /etc/cassandra/cassandra-rackdc.properties and add the following conf
        dc=datacenter1
        rack=rack3

        ```

### Step 1.3: Start the nodes

To initiate the Cassandra service on each node, follow these steps:

1. Start Cassandra service.

    Execute the following command on each node one at a time to start the Cassandra service:

    !!! Example ""
        ```bash
        service cassandra start
        ```

2. Verify node status.

    Ensure that all nodes are up and running by checking their status using the `nodetool status` command.

    Open a terminal and run:

    !!! Example ""
        ```bash
        root@cassandra:/# nodetool status
        Datacenter: datacenter1
        ===============
        Status=Up/Down
        |/ State=Normal/Leaving/Joining/Moving
        --  Address      Load       Tokens       Owns (effective)  Host ID                               Rack
        UN  <ip_node_1>  776.53 KiB  256          100.0%            a79c9a8c-c99b-4d74-8e78-6b0c252abd86  rack1
        UN  <ip_node_2>  671.72 KiB  256          100.0%            8fda2906-2097-4d62-91f8-005e33d3e839  rack1
        UN  <ip_node_3>  611.54 KiB  256          100.0%            201ab99c-8e16-49b1-9b66-5444044fb1cd  rack1
        ```

### Step 1.4: Initialize the database

{% include-markdown "includes/python-compatibility-cqlsh.md" %}

To initialize the database, perform the following steps:

1. Access CQL shell.

    On one of the nodes, access the Cassandra Query Language (CQL) shell by running the following command, providing the IP address of the respective node:

        !!! Example ""
            ```bash
            cqlsh <ip_node_X> -u cassandra
            ```

        !!! Info "Note that the default password for the Cassandra account is `cassandra`"

        !!! Info "To prevent security issue, the Cassandra default user should be removed from the base."

2. Configure the system authentication replication.

    Before creating a new users, you have to modify the default replication factor for the keyspace system_auth using the following CQL command:

    !!! Example ""
        ```sql
        ALTER KEYSPACE system_auth WITH replication = {'class': 'NetworkTopologyStrategy', 'replication_factor': 3 };
        ```

3. Create a custom administrator account.

    Create a new administrator Cassandra role that will replace the default user:

    !!! Example ""

        ```sql
        CREATE ROLE admin WITH PASSWORD password = 'admin_password' AND LOGIN = true AND SUPERUSER = true;
        ```
    After executing the query, exit the CQL shell and reconnect using the new admin role.

    Remove the default Cassandra user using the following CQL query.

    !!! Example ""

        ```sql
        DROP ROLE cassandra;
        ```

4. Create keyspace.

    Create a keyspace named `thehive` with a replication factor of `3` and durable writes enabled:

    !!! Example ""

        ```sql
        CREATE KEYSPACE thehive WITH replication = {'class': 'NetworkTopologyStrategy', 'replication_factor': '3' } AND durable_writes = 'true';
        ```

5. Create role and grant permissions.

    Finally, create a role named `thehive` and grant permissions on the `thehive` keyspace.

    !!! Example ""

        ```sql
        CREATE ROLE thehive WITH LOGIN = true AND PASSWORD = 'PASSWORD';
        GRANT ALL PERMISSIONS ON KEYSPACE thehive TO 'thehive';
        ```

!!! tip "Cassandra cluster maintenance"
    In a Cassandra cluster, regular repairs are required to maintain data consistency between nodes. Automate a full repair with `nodetool repair -full`, for example by running it weekly using `cron`. Failing to run regular repairs can lead to inconsistent data, read errors, and authorization issues over time.

### (Optional) Step 1.5: Enable encryption for client and inter-node communication

The following steps aim to enable encryption secure communication between a client machine and a database cluster and between nodes within a cluster.

#### Client to node encryption

!!! Notes "Prerequisite: having configured the necessary certificates for encryption (keystores and truststores)."

1. Open the `cassandra.yaml` configuration file and edit the `client_encryption_options` section.

    !!! Example ""

        ```yaml title="cassandra.yaml" hl_lines="13"
        client_encryption_options:
        enabled: true
        optional: false
        keystore: </path/to/node1.keystore>
        keystore_password: <keystore_password>
        require_client_auth: true
        truststore: </path/to/cassandra.truststore>
        truststore_password: <truststore_password>
        protocol: TLS
        algorithm: SunX509
        store_type: JKS
        cipher_suites: [TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_256_CBC_SHA]
        ```

2. Restart the Cassandra service on all nodes.

    !!! Example ""

        ```bash
        sudo service cassandra restart
        ```

3. Check Cassandra logs.

    Review the Cassandra logs to ensure there are no errors related to SSL/TLS.

    !!! Example ""

        ```bash
        tail -n 100 /var/log/cassandra/system.log | grep -iE "error|warning"
        ```

#### Inter-node encryption

!!! Notes "Prerequisite: having configured the necessary certificates for encryption (keystores and truststores)."

1. Open the `cassandra.yaml` configuration file and edit the `server_encryption_options` section.

    !!! Example ""

        ```yaml title="cassandra.yaml" hl_lines="13"
            server_encryption_options:
            internode_encryption: all
            keystore: </etc/cassandra/node1.keystore>
            keystore_password: cassandra
            truststore: </etc/cassandra/cassandra.truststore>
            truststore_password: <cassandra>
            protocol: TLS
            algorithm: SunX509
            store_type: JKS
            cipher_suites: [TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_256_CBC_SHA]
            require_client_auth: true
            enabled: true
        ```

2. Restart the Cassandra service on all nodes.

    !!! Example ""

        ```bash
        sudo service cassandra restart
        ```
        
3. Check Cassandra logs.

    Review the Cassandra logs to ensure there are no errors related to SSL/TLS.

    !!! Example ""

        ```bash
        tail -n 100 /var/log/cassandra/system.log | grep -iE "error|warning"
        ```

## Step 2: Install and configure Elasticsearch

!!! note "Elasticsearch supported versions"

    **TheHive**

    {% include-markdown "includes/elasticsearch-supported-versions-thehive.md" %}
    
    If using Elasticsearch for [audit log storage](installation-guide-linux-standalone-server.md#step-53-audit-log-storage), you must use Elasticsearch 7.17 or later.

    **Cortex**

    {% include-markdown "includes/elasticsearch-supported-versions-cortex.md" %}
    
    Sharing a single Elasticsearch instance between TheHive and Cortex isn't recommended. If you must do it, ensure the Elasticsearch version is compatible with both applications.

### Step 2.1: Install Elasticsearch

To establish a cluster of three active Elasticsearch nodes, follow the [installation instructions](./installation-guide-linux-standalone-server.md#step-41-install-elasticsearch) for each node.

### Step 2.2: Configure Elasticsearch

For each node, update the configuration files located at `/etc/cassandra/elasticsearch.yml` with the following parameters, ensuring to adjust the `network.host` accordingly.

!!! Example ""

    ```yaml hl_lines="8"
    http.host:  0.0.0.0
    network.bind_host:  0.0.0.0
    script.allowed_types:  inline,stored
    cluster.name: thehive
    node.name: 'es1'
    path.data: /usr/share/elasticsearch/data
    path.logs: /usr/share/elasticsearch/logs
    network.host: 'es1' # (1)
    http.port: 9200
    cluster.initial_master_nodes: 
      - es1
    node.master: true
    discovery.seed_hosts: # (2)
      - 'es1'
      - 'es2'
      - 'es3'
    thread_pool.search.queue_size: 100000
    thread_pool.write.queue_size: 100000
    xpack.security.enabled: true
    xpack.security.http.ssl.enabled: true
    xpack.security.transport.ssl.enabled: true
    xpack.security.http.ssl.key: /usr/share/elasticsearch/config/certs/es1/es1.key
    xpack.security.http.ssl.certificate: /usr/share/elasticsearch/config/certs/es1/es1.crt
    xpack.security.http.ssl.certificate_authorities: /usr/share/elasticsearch/config/certs/ca/ca.crt
    xpack.security.transport.ssl.key: /usr/share/elasticsearch/config/certs/es1/es1.key
    xpack.security.transport.ssl.certificate: /usr/share/elasticsearch/config/certs/es1/es1.crt
    xpack.security.transport.ssl.certificate_authorities: /usr/share/elasticsearch/config/certs/ca/ca.crt
    ```

    1. Replace `es1` with the IP or host name of the respective node.
    2. Keep this parameter with the same value for all nodes to ensure proper cluster discovery.

!!! Warning
    When configuring Xpack and SSL with Elasticsearch, it's essential to review the documentation specific to your Elasticsearch version for accurate setup instructions.

### Step 2.3: Customize JVM options

To customize Java virtual machine (JVM) options for Elasticsearch, create a JVM options file named `jvm.options` in the directory `/etc/elasticsearch/jvm.options.d/` with the following lines:

!!! Example ""

    ```
    -Dlog4j2.formatMsgNoLookups=true
    -Xms4g
    -Xmx4g
    ```

!!! Note "Adjust according to available memory-It's important to adjust the heap size values based on the amount of memory available on your system to ensure optimal performance and resource utilization."

### Step 2.4: Start the nodes

To start the Elasticsearch service on each node, execute the following command:

!!! Example ""

    ```bash
    service elasticsearch start
    ```

This command initiates the Elasticsearch service, allowing the node to join the cluster and begin handling data requests.

## Step 3: Set up a shared file storage

To set up shared file storage for TheHive in a clustered environment, several options are available. The primary goal is to provide a common storage space used by all nodes.

=== "NFS"

    Using NFS is one of the simplest methods to implement shared file storage. By configuring a single NFS endpoint, all nodes in the cluster can access and share files seamlessly.

    1. Mount the NFS endpoint to `_/opt/thp/thehive/files_` on each node.
    2. Set permissions: Ensure the `thehive` user has both read and write access to this directory, including the ability to create subdirectories. This allows TheHive to manage files as required across the cluster.

=== "S3-compatible object storage"

    TheHive can store files in object storage that implements the Amazon S3 API. This includes [Amazon S3](https://aws.amazon.com/s3/){target=_blank} itself, as well as many S3-compatible services, whether managed or self-hosted.

    Commonly used S3-compatible options include:

    * [Cloudflare R2](https://developers.cloudflare.com/r2/){target=_blank}
    * [DigitalOcean Spaces](https://www.digitalocean.com/products/spaces){target=_blank}
    * [Wasabi](https://wasabi.com/){target=_blank}
    * [Backblaze B2](https://www.backblaze.com/cloud-storage){target=_blank}
    * [MinIO](https://www.min.io/){target=_blank}
    * [Ceph Object Gateway](https://docs.ceph.com/en/reef/radosgw/){target=_blank}

    !!! note "Endpoint and availability"
        From TheHive perspective, you configure a single S3 endpoint. If you self-host object storage, ensure the endpoint is highly available, for example via the storage platform itself or a correctly configured load balancer.

## Step 4: Install and configure TheHive

TheHive uses the [Apache Pekko](https://pekko.apache.org/){target=_blank} toolkit to manage clustering and scalability. Apache Pekko is a framework for building highly concurrent, distributed, and resilient message-driven applications on the JVM. Within TheHive, Pekko handles inter-node communication, cluster membership, and task coordination, enabling the platform to efficiently process concurrent workloads and operate reliably in a distributed cluster environment.

### Step 4.1: Install TheHive

To deploy TheHive in a clustered environment, you must install TheHive on each TheHive node.

TheHive packages are distributed as RPM and DEB files, as well as ZIP binary packages, all available for direct download via tools like Wget or cURL, with installation performed manually.

Follow the steps in the [installation guide](installation-guide-linux-standalone-server.md#step-51-install-thehive).

### Step 4.2: Configure TheHive

#### Configure the cluster

When configuring TheHive for a clustered environment, it's essential to configure Pekko to ensure efficient management of the cluster by the application.

In this guide, we assume that node 1 serves as the master node. Begin by configuring the `pekko` component in the `/etc/thehive/application.conf` file of each node as follows:

!!! Example ""

    ```yaml title="/etc/thehive/application.conf"  hl_lines="8 14 15 16"
    pekko {
      cluster.enable = on 
      actor {
        provider = cluster
      }
    remote.artery {
      canonical {
        hostname = "<ip_address>" # (1)
        port = 2551
      }
    }
    # seed node list contains at least one active node
    cluster.seed-nodes = [
                          "pekko://application@<node_1_ip_address>:2551",  # (2)
                          "pekko://application@<node_2_ip_address>:2551",
                          "pekko://application@<node_3_ip_address>:2551"
                        ]
    cluster.min-nr-of-members = 2    # (3)
    }
    ```

    1. Set the IP address of the current node.
    2. Ensure consistency of this parameter across all nodes.
    3. Choose a value corresponding to half the number of nodes plus one (for three nodes, use `2`).

#### Configure the database and index engine

To ensure proper database and index engine configuration for TheHive, update the `/etc/thehive/application.conf` file as follows:

!!! Example ""

    ```yaml title="/etc/thehive/application.conf" hl_lines="7"
    ## Database configuration
    db.janusgraph {
        storage {
        ## Cassandra configuration
        # More information at https://docs.janusgraph.org/basics/configuration-reference/#storagecql
            backend = cql
            hostname = ["<ip_node_1>", "<ip_node_2>", "<ip_node_3>"] #(1)
            # Cassandra authentication (if configured)
            username = "thehive"
            password = "PASSWORD"
            cql {
                cluster-name = thp
                keyspace = thehive
            }
        }
        index.search {
        ## Elasticsearch configuration
            backend = elasticsearch
            hostname = ["<ip_node>"]
            index-name = thehive
            # Elasticsearch authentication (recommended)
            elasticsearch {
                http {
                    auth {
                        type = basic
                        basic {
                            username = "httpuser"
                            password = "httppassword"
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

Ensure that you replace `<ip_node_1>`, `<ip_node_2>`, and `<ip_node_3>` with the respective IP addresses of your Cassandra nodes. This configuration ensures proper communication between TheHive and the Cassandra database, facilitating seamless operation of the platform. Additionally, if you enabled authentication for Cassandra, provide the appropriate username and password in the configuration.

To learn about how to configure SSL for Cassandra and Elasticsearch, see [Configure Database and Index SSL](../configuration/configure-ssl-cassandra-elasticsearch.md).

#### Configure file storage

File storage contains [attachments](../user-guides/analyst-corner/cases/attachments/about-attachments.md) from cases, alerts, and organizations, as well as [observables](../user-guides/analyst-corner/cases/observables/about-observables.md) of type *file*. [All files are stored in their original form as plaintext](../../resources/security.md#database-and-storage).

=== "NFS"

    All nodes should have access to the same file storage. So, ideally, all TheHive nodes should have a similar NFS mount point. 
    
    Then, on each node:

    1. Set ownership and permissions so that only the `thehive` user can read and write files.

        !!! Example ""

            ```bash
            sudo chown -R thehive:thehive /opt/thp/thehive/files
            sudo chmod 700 /opt/thp/thehive/files
            ```

    2. Update the `application.conf` TheHive configuration file 

        !!! Example ""

            ```yaml title="/etc/thehive/application.conf"
            # Attachment storage configuration
            # By default, TheHive is configured to store files locally in the folder.
            # The path can be updated and should belong to the user/group running thehive service. (by default: thehive:thehive)
            storage {
            provider = localfs
            localfs.location = /opt/thp/thehive/files
            }
            ```

=== "S3-compatible object storage"

    If you decide to use object storage, configure TheHive to store files using an Amazon S3 or S3-compatible endpoint.

    Before you begin, make sure you have:
    
    * An existing bucket
    * An access key and secret key (or equivalent credentials for your storage service)
    * The S3-compatible endpoint URL
    * The region configured for your S3 service (if applicable)

    To enable S3 file storage in a TheHive cluster, configure the storage section in `/etc/thehive/application.conf` on each TheHive node, using the same bucket and endpoint settings.

    !!! Example ""

        ```yaml title="/etc/thehive/application.conf"
            storage {
              provider: s3
              s3 {
                bucket = "<bucket_name>"
                readTimeout = 1 minute
                writeTimeout = 1 minute
                chunkSize = 1 MB
                endpoint-url = "https://<s3_endpoint>"
                access-key-id = "<access_key>"
                aws.credentials.provider = "static"
                aws.credentials.secret-access-key = "<secret_key>"
                access-style = path
                aws.region.provider = "static"
                aws.region.default-region = "<region>"
              }
            }
        ```

    !!! note "Access style and endpoint"
        Some S3-compatible providers require path-style access, while others support or prefer virtual-hosted style. If you encounter addressing issues, adjust `access-style` accordingly.

    !!! note "High availability"
        Managed services expose a single highly available endpoint. For self-hosted S3-compatible platforms, ensure your endpoint is highly available, for example via the storage platform itself or a properly configured load balancer.

#### Optional: Configure the secret key for the Play Framework

TheHive uses a secret key to sign session cookies and ensure secure user authentication.

Skip this step if you installed TheHive using DEB or RPM packages—they generate the key automatically.

For other installation methods:

1. Generate a secret key on the first node.

    ```bash
    cat > /etc/thehive/secret.conf << _EOF_
    play.http.secret.key="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"
    _EOF_
    ```

    {% include-markdown "includes/minimum-key-length.md" %}

2. Set appropriate file permissions.

    ```bash
    sudo chmod 400 /etc/thehive/secret.conf
    sudo chown thehive:thehive /etc/thehive/secret.conf
    ```

3. Copy the `/etc/thehive/secret.conf` file to all other nodes in the cluster.

4. Verify the same permissions on each node.

    !!! danger "Security requirements"
        Never share or commit your secret key to version control. All nodes in a cluster must use the same key, but different environments (development, staging, production) must use different keys.

### Step 4.3: Start the service

Once you have updated the configuration, start TheHive service using the following command:

!!! Example ""

    ```bash
    sudo systemctl start thehive
    ```
This command initiates TheHive service, enabling file storage functionality as configured. Make sure to execute this command on each node of TheHive cluster to ensure proper functionality across the entire setup.

!!! warning "Initial startup delay"
    The initial start, or first start after configuring indexes, might take some time if the database contains a large amount of data. This time is due to the index creation process.

## Step 5: Set up load balancing with HAProxy

To enhance the availability and distribution of HTTP requests across TheHive cluster, you can integrate a load balancer. The load balancer efficiently distributes incoming requests among the cluster nodes, ensuring optimal resource utilization. Notably, client affinity isn't required, meaning that a client doesn't need to consistently connect to the same node.

Below is a basic example of what you should add to the HAProxy configuration file, typically located at `/etc/haproxy/haproxy.cfg`. This configuration should be consistent across all HAProxy instances:

!!! Example ""

    ```yaml

    # Listen on all interfaces, on port 80/tcp
    frontend thehive-in
            bind <virtual_ip>:80                # (1)
            default_backend thehive
    # Configure all cluster node
    backend thehive
                balance roundrobin
                server node1 THEHIVE-NODE1-IP:9000 check   # (2)
                server node2 THEHIVE-NODE2-IP:9000 check
                server node3 THEHIVE-NODE3-IP:9000 check
    ```

    1.   Configure the virtual IP address dedicated to the cluster.
    2.   Specify the IP addresses and ports of all TheHive nodes to distribute traffic evenly across the cluster.

This configuration ensures that incoming HTTP requests are efficiently distributed among the cluster nodes.

## Step 6: Configure a virtual IP with Keepalived

If you choose to use Keepalived to set up a virtual IP address for your load balancers, this section provides a basic example of configuration.

Keepalived is a service that monitors the status of load balancers, such as [HAProxy](#step-5-set-up-load-balancing-with-haproxy), installed on the same system. In this setup, the load balancer 1 (LB1) acts as the master, and the virtual IP address is assigned to LB1. If the HAProxy service stops running on LB1, Keepalived on LB2 takes over and assigns the virtual IP address until the HAProxy service on LB1 resumes operation.

!!! Example ""

    ```yaml hl_lines="12"
    vrrp_script chk_haproxy {     # (1)
          script "/usr/bin/killall -0 haproxy"  # cheaper than pidof
          interval 2 # check every 2 seconds
          weight 2 # add 2 points of priority if OK
        }
        vrrp_instance VI_1 {
          interface eth0
          state MASTER
          virtual_router_id 51
          priority 101 # 101 on primary, 100 on secondary      # (2)
          virtual_ipaddress {
            10.10.1.50/24 brd 10.10.1.255 dev eth0 scope global  # (3)
          }
          track_script {
            chk_haproxy
        } 
    }
    ```

    1.   Requires Keepalived version > 1.1.13.
    2.   Set `priority 100` for a secondary node.
    3.   :fontawesome-solid-triangle-exclamation: This is an example. Replace it with your actual IP address and broadcast address.

## Troubleshooting

Here are some commonly encountered issues during cluster deployment with TheHive and their solutions:

* InvalidRequest error

    !!! Example "" 

        ```log
        InvalidRequest: code=2200 [Invalid query] message=”org.apache.cassandra.auth.CassandraRoleManager doesn’t support PASSWORD”.`
        ```

    Resolution:

    To resolve this error, set the value `authenticator: PasswordAuthenticator` in the `cassandra.yaml` configuration file.

* UnauthorizedException caused by inconsistent replication

    !!! Example ""

        ```log
        Caused by: java.util.concurrent.ExecutionException: com.datastax.driver.core.exceptions.UnauthorizedException: Unable to perform authorization of permissions: Unable to perform authorization of super-user permission: Cannot achieve consistency level LOCAL_ONE
        ```

    Resolution:

    To address this issue, execute the following CQL command to adjust the replication settings for the `system_auth` keyspace:

    !!! Example ""

        ```sql
        ALTER KEYSPACE system_auth WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3 };
        ```

    After making this adjustment, perform a full repair using the `nodetool repair -full` command to ensure data consistency across the cluster.

## Next steps

* [Turn Off The Cortex Integration](../configuration/turn-off-cortex-connector.md)
* [Turn Off The MISP Integration](../configuration/turn-off-misp-connector.md)
* [Update Log Configuration](../configuration/update-log-configuration.md)
* [Update TheHive Service Configuration](../configuration/update-service-configuration.md)
* [Enable the GDPR Compliance Feature](../configuration/enable-gdpr.md)
* [Configure HTTPS for TheHive With a Reverse Proxy](../configuration/ssl/configure-https-reverse-proxy.md)
* [Update TheHive Service Configuration](../configuration/update-service-configuration.md)
* [Perform a Hot Backup on a Cluster](../operations/backup-restore/backup/hot-backup/hot-backup-cluster.md)
* [Perform a Cold Backup on a Physical Server](../operations/backup-restore/backup/cold-backup/physical-server.md)
* [Perform a Cold Backup on a Virtual Server](../operations/backup-restore/backup/cold-backup/virtual-server.md)
* [Monitoring](../operations/monitoring.md)
* [Troubleshooting](../operations/troubleshooting.md)