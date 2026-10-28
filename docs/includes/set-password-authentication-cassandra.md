{% include-markdown "includes/python-compatibility-cqlsh.md" %}

By default, Cassandra uses the `cassandra` username and the password `cassandra`. For security reasons, especially in production environments, you must change this password immediately after setup.

To do this, you'll use CQL, the Cassandra Query Language, which is similar in purpose to SQL.

1. Install `cqlsh`.

    Install `cqlsh` from PyPI in a Python virtual environment:

    ```bash
    VENV_PATH=$HOME/.venv
    sudo apt update
    sudo apt install python3-venv
    python3 -m venv "${VENV_PATH}"
    "${VENV_PATH}/bin/pip" install cqlsh
    ```

    On RPM-based distributions, skip the two `apt` commands. The `venv` module is included with Python.

    Activate the virtual environment so that the `cqlsh` command runs from it, then verify the installation:

    ```bash
    source "${VENV_PATH}/bin/activate"
    cqlsh --version
    ```

2. Connect to Cassandra using default credentials.

    ```bash
    cqlsh -u cassandra -p cassandra
    ```

    If the connection is successful, you'll see output similar to:

    ```
    Connected to xxx at xx.xx.xx.xx:xxxx
    [cqlsh 6.2.0 | Cassandra 4.1.9 | CQL spec 3.4.6 | Native protocol v5]
    ```

3. Change the default password.

    ```bash
    ALTER USER cassandra WITH PASSWORD '<authentication_cassandra_password>';
    ```

    Replace `<authentication_cassandra_password>` with the password you intend to use for the `cassandra` superuser account.

4. Disconnect from the session.

    Press **Ctrl+D** to exit the `cqlsh` shell.

5. Reconnect using your new password.

    ```bash
    cqlsh -u cassandra
    ```