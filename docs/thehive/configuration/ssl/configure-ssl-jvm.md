# Configure JVM Trust for SSL/TLS Certificates

Java applications such as TheHive rely on a Java truststore to validate SSL/TLS certificates. By default, the Java virtual machine (JVM) trusts only well-known certificate authorities (CAs).

If you use self-signed certificates or internal CAs, you must configure the JVM to trust them. This configuration is essential for authentication providers and connectors used in TheHive.

## DEB package

=== "Option 1: Custom truststore"

    1. Open the `/etc/default/thehive` file.

    2. Uncomment the `JAVA_OPTS` variable.

    3. Enter the path to your truststore file containing the required CA certificates.

        ``` bash
        JAVA_OPTS="-Djavax.net.ssl.trustStore=/path/to/<truststore_file> -Djavax.net.ssl.trustStorePassword=<truststore_password>"
        ```

    4. Save your modifications.

    5. Restart TheHive service.

        ``` bash
        sudo systemctl restart thehive
        ```

=== "Option 2: System-wide CA certificates"

    1. Ensure the `ca-certificates-java` package is installed.

        ```bash
        sudo apt-get install -y ca-certificates-java
        ```
    
    2. Copy your CA certificates to the system directory.

        ```bash
        sudo mkdir /usr/share/ca-certificates/extra
        sudo cp <custom_certificate>.crt /usr/share/ca-certificates/extra/
        ```

    3. Reconfigure and update the Java truststore.

        * When using the Amazon Corretto JVM, the default truststore is a bundled file rather than a symlink to the system truststore. System CA certificates won't be recognized until you manually replace the bundled truststore with a symlink:

        ```bash
        sudo rm $JAVA_HOME/lib/security/cacerts
        sudo ln -s /etc/ssl/certs/java/cacerts $JAVA_HOME/lib/security/cacerts
        ```

        !!! info "Amazon Corretto JVM path on DEB"
            On Debian/Ubuntu, the Amazon Corretto JVM is usually installed in `/usr/lib/jvm/java-11-amazon-corretto`.

        * For other JVMs, simply run:

        ```bash
        sudo dpkg-reconfigure ca-certificates
        ```
        
    4. Restart TheHive service.

        ```bash
        sudo systemctl restart thehive
        ```

## RPM package

=== "Option 1: Custom truststore"

    1. Open the `/etc/default/thehive` file.

    2. Uncomment the `JAVA_OPTS` variable.

    3. Enter the path to your truststore file containing the CA certificates.

        ``` bash
        JAVA_OPTS="-Djavax.net.ssl.trustStore=/path/to/<truststore_file> -Djavax.net.ssl.trustStorePassword=<truststore_password>"
        ```

    4. Save your modifications.

    5. Restart TheHive service.

        ``` bash
        sudo systemctl restart thehive
        ```

=== "Option 2: System-wide CA certificates"

    1. Copy the CA certificate to the system trust anchors.

        ```bash
        sudo cp <custom_certificate>.crt /etc/pki/ca-trust/source/anchors/
        ```

    2. Update CA trust.

        * When using the Amazon Corretto JVM, the default truststore is a bundled file rather than a symlink to the system truststore. System CA certificates won't be recognized until you manually replace the bundled truststore with a symlink:

        ```bash
        sudo rm $JAVA_HOME/lib/security/cacerts
        sudo ln -s /etc/pki/java/cacerts $JAVA_HOME/lib/security/cacerts
        ```

        !!! info "Amazon Corretto JVM path on RPM"
            On RHEL/Fedora, the Amazon Corretto JVM is usually installed in `/usr/lib/jvm/java-11-amazon-corretto`.

        * For other JVMs, simply run:

        ```bash
        sudo update-ca-trust
        ```

    3. Restart TheHive service.

        ``` bash
        sudo systemctl restart thehive
        ```

## Docker environment

=== "TheHive 5.5.3 and earlier"

    1. Place your truststore file on the host.

    2. Mount it inside the container and pass JVM options.

        ``` bash
        docker run -d \
          --name <thehive_container> \
          -e "JAVA_OPTS=-Djavax.net.ssl.trustStore=/container/path/<truststore_file> -Djavax.net.ssl.trustStorePassword=<truststore_password>" \
          -v /host/path/to/<truststore_file>:/container/path/<truststore_file> \
          <thehive_image>
        ```

    3. Restart TheHive Docker container.

        ``` bash
        docker restart <thehive_container>
        ```

=== "TheHive 5.5.4 and later"

    Starting with TheHive 5.5.4, you no longer need to build or maintain a custom truststore. You can directly mount PEM-format CA certificates, and the entrypoint automatically imports them into the JVM truststore at startup.

    1. Store your CA certificates in a host directory.

        Multiple certificates are supported. No password is required.

    2. Mount the directory into the container.

        ``` bash
        docker run -d \
          --name <thehive_container> \
          -v /host/path/to/<ca_certificates>:/container/path/<ca_certificates> \
          <thehive_image>
        ```

    3. Restart TheHive Docker container.

        ``` bash
        docker restart <thehive_container>
        ```

!!! info "Advanced configuration"
    Most SSL/TLS requirements are handled through JVM-level configuration. For rare cases requiring TheHive-specific SSL/TLS parameters, see [SSL/TLS Client Configuration](ssl-thehive-configuration-settings.md).

<h2>Next steps</h2>

* [Configure Authentication](../../administration/authentication/configure-authentication.md)
* [Configure HTTPS for TheHive With a Reverse Proxy](configure-https-reverse-proxy.md)