Configure SSL settings for secure SSL/TLS communication with external services.

Use this section when the external service relies on a private certificate authority (CA), requires mutual TLS (client certificate authentication), or uses a non-standard trust chain.

| Field                     | Description  |
|---------------------------|-----------------------------------------|
| Client certificate (mTLS) | Enable to authenticate with a client certificate (mutual TLS). Turned off by default.  |
| SSL key (PEM)             | The private key associated with the client certificate, in PEM format. Required only when **Client certificate (mTLS)** is enabled. |
| SSL certificate (PEM)     | The client certificate to present during the SSL/TLS handshake, in PEM format. Required only when **Client certificate (mTLS)** is enabled. |
| Certificate Authorities   | Server certificate verification mode. **Default**: uses the system's pre-installed certificate authorities. **Custom**: provide a CA certificate to verify the server. **Disabled**: skips server identity verification. Not recommended in production, as it exposes the connection to security risks. |
| SSL CA certificate (PEM)  | The CA certificate used to verify the server's identity, in PEM format. Required only when **Certificate Authorities** is set to **Custom**. |
