Configure SSL/TLS settings for secure communication with the external service.

Use this section when the service relies on a private certificate authority (CA), requires client certificate authentication through mutual TLS, or uses a non-standard trust chain.

| Field | Description |
|---|---|
| Client certificate (mTLS) | Whether the node authenticates with a client certificate (mutual TLS). *Do not use a client certificate* is the default. Select *Provide a client certificate and key* to fill in the two fields below. |
| Client certificate (PEM) | The client certificate to present during the SSL/TLS handshake, in PEM format. Required when **Client certificate (mTLS)** is *Provide a client certificate and key*. |
| Client certificate key (PEM) | The private key associated with the client certificate, in PEM format. Required when **Client certificate (mTLS)** is *Provide a client certificate and key*. |
| Server verification | How the node verifies the identity of the server. *Uses the system's pre-installed certificate authorities* is the default. *Provide a custom CA certificate to verify the server* uses the certificate in the next field. *Do not verify the server's identity (not recommended for production)* exposes the connection to security risks. |
| CA certificate (PEM) | The CA certificate used to verify the identity of the server, in PEM format. Required when **Server verification** is set to *Provide a custom CA certificate to verify the server*. |
