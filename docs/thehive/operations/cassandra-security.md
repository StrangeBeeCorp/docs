# Security in Apache Cassandra

---

## Authentication with Cassandra

!!! Note "References"
    Internal authentication
      
    - [https://docs.datastax.com/en/archived/cassandra/3.0/cassandra/configuration/secureInternalAuthenticationTOC.html](https://docs.datastax.com/en/archived/cassandra/3.0/cassandra/configuration/secureInternalAuthenticationTOC.html){target=_blank}

To authenticate with Cassandra and manage permissions, follow these steps:

1. **Create a Role and Grant Permissions:**

   ```sql
   CREATE ROLE thehive WITH PASSWORD = 'thehive1234' AND LOGIN = true;
   GRANT ALL PERMISSIONS ON KEYSPACE thehive TO thehive;
   ```

1. **Configure TheHive with the Account:**
    
    Update `/etc/thehive/application.conf` with the Cassandra authentication details:

    ```
      db.janusgraph {
        storage {
          ## Cassandra configuration
          # More information at https://docs.janusgraph.org/basics/configuration-reference/#storagecql
          backend: cql
          hostname: ["xxx.xxx.xxx.xxx"]
          # Cassandra authentication (if configured)
          {==username: "thehive" ==}
          {==password: "thehive1234" ==}
          cql {
            cluster-name: thp
            keyspace: thehive
          }
        }
    ```

    Ensure to replace xxx.xxx.xxx.xxx with the appropriate Cassandra host name or IP address.

---

## Configuring Node-to-Node Encryption for Cassandra

!!! Note "References"
    Node-to-Node Encryption
      
    - [https://docs.datastax.com/en/archived/cassandra/3.0/cassandra/configuration/secureSSLNodeToNode.html](https://docs.datastax.com/en/archived/cassandra/3.0/cassandra/configuration/secureSSLNodeToNode.html){target=_blank}


To enable node-to-node encryption, modify the `cassandra.yaml` configuration file with the following settings:

```yaml
server_encryption_options:
    internode_encryption: all
    keystore: /path/to/keystore.jks
    keystore_password: keystorepassword
    truststore: /path/to/truststore.jks
    truststore_password: truststorepassword
    # More advanced defaults below:
    protocol: TLS
    algorithm: SunX509
    store_type: JKS
    cipher_suites: [TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_DHE_RSA_WITH_
AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_R
SA_WITH_AES_256_CBC_SHA]
    require_client_auth: false
```

&nbsp;

### Setting Up Cassandra Dedicated SSL Port (Optional)

Optionally, you can configure a dedicated port for SSL communication in Cassandra. Setting up a dedicated SSL port provides enhanced security for communication with your Cassandra cluster. Follow these steps to update the `/etc/cassandra/cassandra.yaml` configuration file on each node:

1. Open the cassandra.yaml configuration file on each node.

2. Locate the native_transport_port_ssl parameter within the file.

3. Update the native_transport_port_ssl parameter to specify the desired SSL port number (e.g., 9142):

    ```yaml
    native_transport_port_ssl: 9142
    ```

By specifying a dedicated `native_transport_port_ssl`, all SSL communications will utilize this port instead of the default port configured for non-SSL traffic (`native_transport_port`). 

---

## Client to Node Encryption

!!! Note "References"
    Client to Node Encryption
    
    - [https://docs.datastax.com/en/archived/cassandra/3.0/cassandra/configuration/secureSSLClientToNode.html](https://docs.datastax.com/en/archived/cassandra/3.0/cassandra/configuration/secureSSLClientToNode.html){target=_blank}
    - [https://docs.janusgraph.org/basics/configuration-reference/#storagecqlssl](https://docs.janusgraph.org/basics/configuration-reference/#storagecqlssl){target=_blank}

This guide explains how to establish a secure connection between Cassandra clients (specifically TheHive) and the Cassandra server.

&nbsp;

### Requirements

To set up secure encryption, you'll need the following:

1. **X509 Certificate for Cassandra Service**
   - Ensure the certificate has the following standard properties:
     - Key Usage: Digital Signature, Non-Repudiation, Key Encipherment, Key Agreement
     - Extended Key Usage: TLS Web Server Authentication
     - Certificate Type: SSL Server
   - Include a "Subject Alternative Name" (DNS name and/or IP address) that matches how the Cassandra server is identified by the client.
   - The certificate file format should be PKCS12 (with a `.p12` extension).

2. **Truststore**
   - Create a truststore that contains the Certificate Authority (CA) used to generate the Cassandra server's certificate.
   - The truststore should be in Java Keystore (JKS) format.
   - If your CA file is named `ca.crt`, generate the truststore file using the following command:
     ```bash
     keytool -import -file /path/to/ca.crt -alias CA -keystore ca.jks
     ```
     You will be prompted to set a password for file integrity checking.

   **Note:** The `keytool` command is available as part of any JDK distribution.

&nbsp;

### Steps to Set Up Encryption

Follow these steps to enable encryption between Cassandra clients (TheHive) and the Cassandra server:

1. **Obtain the Server Certificate**

    - Acquire a valid X509 certificate for the Cassandra service with the specified properties.

2. **Configure the Server Certificate**

    - Ensure the certificate includes the necessary key usage and extended key usage properties.

3. **Create the Truststore**

    - Use the `keytool` command to import the CA certificate into a Java Keystore (JKS) file (`ca.jks`).

      ```bash
      keytool -import -file /path/to/ca.crt -alias CA -keystore ca.jks
      ```

      You will be prompted to set a password for the truststore.

4. **Configuring Cassandra**

    - Locate the section `client_encryption_options` and set the following options:


    ```yaml
    client_encryption_options:
        enabled: true
        # If enabled and optional is set to true encrypted and unencrypted connections are handled.
        optional: false
        keystore: /pat/to/keystore.jks
        keystore_password: keystorepassword
        require_client_auth: false
        # Set trustore and truststore_password if require_client_auth is true
        # truststore: conf/.truststore
        # truststore_password: cassandra
        # More advanced defaults below:
        protocol: TLS
        algorithm: SunX509
        store_type: JKS
        cipher_suites: [TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_DHE_RSA_WITH_
    AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_R
    SA_WITH_AES_256_CBC_SHA]
    ```

    - After making these changes, restart the Cassandra service.

5. **Configure TheHive to Use Encryption**

    - Update TheHive Cassandra client configuration to specify the location of the truststore (`ca.jks`) and provide any additional connection properties required for SSL/TLS encryption.

    ```
    db.janusgraph {
      storage {
        ## Cassandra configuration
        # More information at https://docs.janusgraph.org/basics/configuration-reference/#storagecql
        backend: cql
        hostname: ["ip_node_1", "ip_node_2", "ip_node_3"]
        # Cassandra authentication (if configured)
        username: "thehive"
        password: "thehive1234"
        {==port: 9142 # if alternative port has been set in Cassandra configuration==}
        cql {
          cluster-name: thp
          keyspace: thehive
          {==ssl {==}
            {==enabled: true==}
            {==truststore {==}
              {==location: "/path/to/truststore.jks"==}
              {==password: "truststorepassword"==}
            {==}==}
          }
        }
      }
    ```
    
    - After making these changes, restart TheHive to apply the new configuration settings.

&nbsp;