Configure SSL/TLS settings for secure communication with the external service.

Use this section when the service relies on a private certificate authority (CA), requires mutual TLS (client certificate authentication), or uses a non-standard trust chain.

| Field | Description |
|---|---|
| Client certificate (mTLS) | Whether the node authenticates with a client certificate (mutual TLS). *disabled*: Don't use a client certificate. This is the default. *enabled*: Provide a client certificate and key. |
| Client certificate (PEM) | The client certificate to present during the SSL/TLS handshake, in PEM format. Required when **Client certificate (mTLS)** is *enabled*. |
| Client certificate key (PEM) | The private key associated with the client certificate, in PEM format. Required when **Client certificate (mTLS)** is *enabled*. |
| Server verification | How the node verifies the identity of the server. *default*: Uses the system's preinstalled certificate authorities. *custom_ca*: Provide a custom CA certificate to verify the server. *disabled*: Don't verify the identity of the server. Not recommended in production, as it exposes the connection to security risks. |
| CA certificate (PEM) | The CA certificate used to verify the identity of the server, in PEM format. Required when **Server verification** is set to *custom_ca*. |
