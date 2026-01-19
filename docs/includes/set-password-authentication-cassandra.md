{% include-markdown "includes/python-compatibility-cqlsh.md" %}

By default, Cassandra uses the `cassandra` username and the password `cassandra`. For security reasons, especially in production environments, you must change this password immediately after setup.

To do this, we'll use CQL, the Cassandra Query Language, which is similar in purpose to SQL.

1. Connect to Cassandra using default credentials.

    ```bash
    cqlsh -u cassandra -p cassandra
    ```

    !!! info "Cqlsh may not be available on RPM-based systems"
        On some RPM-based distributions, the `cqlsh` client isn't included with the `cassandra` package. If running cqlsh gives an error, download the [official Apache Cassandra tarball](https://downloads.apache.org/cassandra/){target=_blank} that matches your server version and extract it. Then run the bundled client: `./bin/cqlsh -u cassandra -p cassandra`.

    If the connection is successful, you'll see output similar to:

    ```
    Connected to xxx at xx.xx.xx.xx:xxxx
    [cqlsh 6.1.0 | Cassandra 4.1.9 | CQL spec 3.4.6 | Native protocol v5]
    ```

2. Change the default password.

    ```bash
    ALTER USER cassandra WITH PASSWORD '<authentication_cassandra_password>';
    ```

    Replace `<authentication_cassandra_password>` with the password you intend to use for the `cassandra` superuser account.

3. Disconnect from the session.

    Press **Ctrl+D** to exit the `cqlsh` shell.

4. Reconnect using your new password.

    ```bash
    cqlsh -u cassandra
    ```