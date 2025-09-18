Add a certificate authority (CA).

    The server's SSL/TLS certificate must be trusted by the Java virtual machine (JVM) truststore for secure connections. If your server uses a certificate from an internal CA or self-signed certificate, add it to the JVM truststore first. See [Configure JVM Trust for SSL/TLS Certificates](/thehive/configuration/ssl/configure-ssl-jvm/) for instructions.

    You can turn off the **Don't check certificate authority** toggle to bypass certificate validation, but this isn't recommended as it may compromise connection security.