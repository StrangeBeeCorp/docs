# SSL Configuration

---

## Connect TheHive using HTTPS

It is recommended to set up a reverse proxy, such as Nginx, to manage the SSL layer for TheHive.

!!! Example ""

    === "Nginx"

        For detailed instructions on configuring HTTPS servers with Nginx, refer to the [**Nginx documentation**](https://nginx.org/en/docs/http/configuring_https_servers.html)

        ```title="/etc/nginx/sites-available/thehive.conf"
        server {
          listen 443 ssl http2;
          server_name thehive;

          ssl on;
          ssl_certificate       /path-to/thehive-server-chained-cert.pem;
          ssl_certificate_key   /path-to/thehive-server-key.pem;

          proxy_connect_timeout   600;
          proxy_send_timeout      600;
          proxy_read_timeout      600;
          send_timeout            600;
          client_max_body_size    2G;
          proxy_buffering off;
          client_header_buffer_size 8k;

          location / {
            add_header              Strict-Transport-Security "max-age=31536000; includeSubDomains";
            proxy_pass              http://127.0.0.1:9000/;
            proxy_http_version      1.1;
          }
        }
        ```

---

## Client Configuration

SSL configuration settings may be necessary to connect remote services. Below are the parameters that can be defined:

| Parameter                                | Type           | Description                          |
| -----------------------------------------| -------------- | ------------------------------------ |
| `wsConfig.ssl.keyManager.stores`         | list           | Stores client certificates (see [#certificate-manager](#certificate-manager) )    |
| `wsConfig.ssl.trustManager.stores`       | list           | Stores custom Certificate Authorities (see [#certificate-manager](#certificate-manager) |
| `wsConfig.ssl.protocol`                  | string         | Defines a different default protocol (see [#protocols](#protocols)) |
| `wsConfig.ssl.enabledProtocols`          | list           | List of enabled protocols (see [#protocols](#protocols)) |
| `wsConfig.ssl.enabledCipherSuites`       | list           | List of enabled cipher suites (see [#ciphers](#ciphers)) |
| `wsConfig.ssl.loose.acceptAnyCertificate`| boolean        | Accept any certificates *true / false* |

&nbsp;

### Certificate Manager

The certificate manager is used to store client certificates and certificate authorities.

&nbsp;

#### Using Custom Certificate Authorities

The preferred method for using custom Certificate Authorities is to use the system configuration.

<!-- If setting up a custom Certificate Authority (to connect web proxies, remote services like LPAPS server ...) is required globally in the application, the better solution consists of installing it on the OS and restarting TheHive.  -->

!!! Example ""

    === "Debian"

        Ensure the `ca-certificates-java` package is installed, copy the CA certificate to the appropriate folder, then reconfigure certificates and restart TheHive service.

        ```bash
        apt-get install -y ca-certificates-java
        mkdir /usr/share/ca-certificates/extra
        cp mycustomcert.crt /usr/share/ca-certificates/extra
        dpkg-reconfigure ca-certificates
        service thehive restart
        ```

    === "RPM"

        Copy the CA certificate to the correct folder, update CA trust, and restart TheHive service.

          ```bash
          cp mycustomcert.crt /etc/pki/ca-trust/source/anchors
          sudo update-ca-trust 
          service thehive restart
          ```


An alternative approach is to use dedicated trust stores, although this is not the recommended option. Use the `trustManager` key in TheHive configuration to establish secure connections with remote hosts. Ensure that server certificates are signed by trusted certificate authorities.

!!! Example ""
    ```
      wsConfig.ssl.trustManager {
        stores = [
          {
            type = "JKS" // JKS or PEM
            path = "keystore.jks"
            password = "password1"
          }
        ]
      }
    ```

&nbsp;

#### Client Certificates

The `keyManager` parameter specifies which certificate the HTTP client can use for authentication on remote hosts when certificate-based authentication is required.

!!! Example ""

    ```
      wsConfig.ssl.keyManager {
        stores = [
          {
            type = "pkcs12" // JKS or PEM
            path = "mycert.p12"
            password = "password1"
          }
        ]
      }
    ```

&nbsp;

### Protocols

To define a different default protocol use the following configuration:

!!! Example ""
    ```
    wsConfig.ssl.protocol = "TLSv1.2"
    ```

To define a list of enabled protocols, use the following configuration:

!!! Example ""
    ```
    wsConfig.ssl.enabledProtocols = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    ```

&nbsp;

### Advanced Options

####  Ciphers

Configure cipher suites using `wsConfig.ssl.enabledCipherSuites`:

!!! Example ""

    ```
    wsConfig.ssl.enabledCipherSuites = [
      "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_DHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    ]
    ```

&nbsp;

#### Debugging

Enable debugging flags to troubleshoot key managers and trust managers:

!!! Example ""

    ```
      wsConfig.ssl.debug = {
        ssl = true
        trustmanager = true
        keymanager = true
        sslctx = true
        handshake = true
        verbose = true
        data = true
        certpath = true
      }
    ```

&nbsp;