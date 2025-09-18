# SSL/TLS Client Configuration

Authentication providers and connectors may require SSL/TLS configuration to connect securely with TheHive.

SSL/TLS trust is typically configured [at the Java virtual machine (JVM) level](configure-ssl-jvm.md) for certificate validation. The parameters below provide additional SSL/TLS capabilities. These parameters are defined in the TheHive `application.conf` configuration file.

## Configuration parameters

The following parameters control SSL/TLS behavior for outbound connections from TheHive to external services.

| Parameter                                | Type           | Description                          |
| -----------------------------------------| -------------- | ------------------------------------ |
| `wsConfig.ssl.keyManager.stores`         | list           | Stores client certificates |
| `wsConfig.ssl.trustManager.stores`       | list           | Stores custom certificate authorities |
| `wsConfig.ssl.protocol`                  | string         | Defines a different default protocol |
| `wsConfig.ssl.enabledProtocols`          | list           | List of enabled protocols |
| `wsConfig.ssl.enabledCipherSuites`       | list           | List of enabled cipher suites |
| `wsConfig.ssl.loose.acceptAnyCertificate`| boolean        | Accept any certificates |

## Key manager configuration

Client certificates enable certificate-based authentication when connecting to external services that require mutual TLS authentication.

``` yaml
    wsConfig.ssl.keyManager {
        stores = [
            {
            type = "pkcs12" // JKS or PEM
            path = "path/to/<certificate_file>"
            password = "<certificate_password>"
            }
        ]
    }
```

## Trust manager configuration

Custom certificate authorities extend the default JVM truststore for specific TheHive connections when system-wide trust configuration isn't suitable.

``` yaml
wsConfig.ssl.trustManager {
    stores = [
        {
        type = "JKS" // JKS or PEM
        path = "path/to/<keystore_file>"
        password = "<keystore_password>"
        }
    ]
}
```

## Protocol configuration

Protocol settings control which SSL/TLS versions TheHive uses for outbound connections.

### Default protocol

```yaml
wsConfig.ssl.protocol = "<protocol_version>"
```

Example: `"TLSv1.2"`

### Enabled protocols

```yaml
wsConfig.ssl.enabledProtocols = ["<protocol_version_1>", "<protocol_version_2>", "<protocol_version_3>"]
```

Example: `["TLSv1.2", "TLSv1.1", "TLSv1"]`

## Cipher suites

Cipher suite configuration restricts the cryptographic algorithms used for SSL/TLS connections.

```yaml
wsConfig.ssl.enabledCipherSuites = [
    "<cipher_suite_1>",
    "<cipher_suite_2>",
    "<cipher_suite_3>",
    "<cipher_suite_4>",
]
```

Example: `"TLS_DHE_RSA_WITH_AES_128_GCM_SHA256"`, `"TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"`, `"TLS_DHE_RSA_WITH_AES_256_GCM_SHA384"`, `"TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"`

## Debug configuration

Debug flags are available to troubleshoot SSL/TLS connections:

```yaml
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

<h2>Next steps</h2>

* [Configure HTTPS for TheHive With a Reverse Proxy](configure-https-reverse-proxy.md)