# Configure SSL

## Connect TheHive using HTTPS

We recommend using a reverse proxy to manage SSL layer; for Example, [Nginx](https://www.nginx.com). 

!!! Example ""

    === "Nginx"

        ```title="/etc/nginx/sites-available/thehive.conf"
        server {
          listen 443 ssl http2;
          server_name thehive;

          ssl on;
          ssl_certificate       path-to/thehive-server-cert.pem;
          ssl_certificate_key   path-to/thehive-server-key.pem;

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

## Client configuration

SSL configuration might be required to connect remote services. Following parameters can be defined: 

| Parameter                                | Type           | Description                          |
| -----------------------------------------| -------------- | ------------------------------------ |
| `wsConfig.ssl.keyManager.stores`         | list           | Stores client certificates (see [#certificate-manager](#certificate-manager) )    |
| `wsConfig.ssl.trustManager.stores`       | list           | Stored custom Certificate Authorities (see [#certificate-manager](#certificate-manager) |
| `wsConfig.ssl.protocol`                  | string         | Defines a different default protocol (see [#protocols](#protocols)) |
| `wsConfig.ssl.enabledProtocols`          | list           | List of enabled protocols (see [#protocols](#protocols)) |
| `wsConfig.ssl.enabledCipherSuites`       | list           | List of enabled cipher suites (see [#ciphers](#ciphers)) |
| `wsConfig.ssl.loose.acceptAnyCertificate`| boolean        | Accept any certificates *true / false* |



### Certificate manager
Certificate manager is used to store client certificates and certificate authorities.

#### Use custom Certificate Authorities

The prefered way to use custom Certificate Authorities is to use the system configuration. 

If setting up a custom Certificate Authority (to connect web proxies, remote services like LPAPS server ...) is required globally in the application, the better solution consists of installing it on the OS and restarting TheHive. 

!!! Example ""

    === "Debian"

        Ensure the package `ca-certificates-java` is installed , and copy the CA certificate in the right folder. Then run `dpkg-reconfigure ca-certificates` and restart TheHive service. 

        ```bash
        apt-get install -y ca-certificates-java
        mkdir /usr/share/ca-certificates/extra
        cp mysctomcert.crt /usr/share/ca-certificates/extra
        dpkg-reconfigure ca-certificates
        service thehive restart
        ```

    === "RPM"

        No additionnal packages is required on Fedora or RHEL. Copy the CA certificate in the right folder, run `update-ca-trust` and restart TheHive service.

          ```bash
          cp mysctomcert.crt /etc/pki/ca-trust/source/anchors
          sudo update-ca-trust 
          service thehive restart
          ```


*An alternative way* is to use a dedicated trust stores ; but **this is NOT the prefered option**. Use the `trustManager` key in TheHive configuration. It is used to establish a secure connection with remote host. Server certificate must be signed by a trusted certificate authority.

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


#### Client certificates

`keyManager` indicates which certificate HTTP client can use to authenticate itself on remote host (when certificate based authentication is used)

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

### Protocols
If you want to define a different default protocol, you can set it specifically in the client:

!!! Example ""
    ```
    wsConfig.ssl.protocol = "TLSv1.2"
    ```


If you want to define the list of enabled protocols, you can do so by providing a list explicitly:

!!! Example ""
    ```
    wsConfig.ssl.enabledProtocols = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    ```

### Advanced options

####  Ciphers
Cipher suites can be configured using `wsConfig.ssl.enabledCipherSuites`:

!!! Example ""

    ```
    wsConfig.ssl.enabledCipherSuites = [
      "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_DHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    ]
    ```

#### Debugging
To debug the key manager / trust manager, set the following flags:

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