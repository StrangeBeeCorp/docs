To avoid relying on the default `cassandra` superuser account, create a new administrator role and then deactivate or delete the default user.

1. Create the `admin` role.

    ```bash
    CREATE ROLE admin WITH PASSWORD = '<authentication_admin_password>' AND LOGIN = true AND SUPERUSER = true;
    ```

    Replace `<authentication_admin_password>` with the password you intend to use for the `admin` superuser account.

2. Disconnect from the session.

    Press **Ctrl+D** to exit the `cqlsh` shell.

3. Reconnect as the new admin.

    ```bash
    cqlsh -u admin
    ```

4. Deactivate the default `cassandra` user.

    ```bash
    ALTER ROLE cassandra WITH SUPERUSER = false AND LOGIN = false;
    ```

    If your security policy requires deleting default accounts, delete the role instead:

    ```bash
    DROP ROLE cassandra;
    ```