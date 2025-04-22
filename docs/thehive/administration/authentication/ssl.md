# How to Configure SSL

This topic provides step-by-step instructions for configuring Secure Sockets Layer (SSL) in TheHive for [AD](ad.md), [LDAP](ldap.md), and [OAuth 2.0](oauth2.md) authentication providers.

This guide provides configuration instructions for different environments:

* [DEB package](#deb-package)
* [Docker environment](#docker-environment)

## DEB package

1. Edit the TheHive environment configuration:

    Open the `/etc/default/thehive` file and uncomment the `JAVA_OPTS` variable. 
    
    Set the path to your Java KeyStore (JKS) file:

    ``` bash
    JAVA_OPTS="-Djavax.net.ssl.trustStore=</path/to/your-jks-file>.jks -Djavax.net.ssl.trustStorePassword=<your-keystore-password>"
    ```

2. Restart TheHive service:

    ``` bash
    sudo systemctl restart thehive
    ```

## Docker environment

1. Mount the Java KeyStore (JKS) inside the container:

    Make sure your KeyStore is accessible from within the Docker container by mounting it as a volume:

    ``` bash
    docker run -d \
      -e "JAVA_OPTS=-Djavax.net.ssl.trustStore=/container/path/<your-jks-file>.jks -Djavax.net.ssl.trustStorePassword=<your-keystore-password>" \
      -v </host/path/to/jks>:</container/path> \
      your-thehive-image
    ```

2. Restart TheHive Docker container:

    ``` bash
    docker restart <your-thehive-container>
    ```

<h2>Next steps</h2>

* [How to Configure Authentication](configure-authentication.md)
* [Configure a Local Authentication Provider](local.md)
* [Configure an Active Directory Authentication Provider](ad.md)
* [Configure an LDAP Authentication Provider](ldap.md)
* [Configure an OAuth 2.0 Authentication Provider](oauth2.md)
* [Configure a SAML Authentication Provider](saml.md)
* [Configure an OpenID Authentication Provider](openid.md)