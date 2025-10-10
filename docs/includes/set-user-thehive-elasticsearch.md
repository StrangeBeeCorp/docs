1. Create a `thehive` user.

    ```bash
    sudo /usr/share/elasticsearch/bin/elasticsearch-users useradd thehive -p <thehive_user_password> -r superuser
    ```

    Replace `<thehive_user_password>` with a secure password you choose for your TheHive user.

    !!! tip "Note this password"
        Keep this password secure. You will need to enter it later in TheHive configuration file so the application can connect to Elasticsearch.

2. Optional: Set a password for the `elastic` user.

    * [For Elasticsearch 7.x](https://www.elastic.co/docs/reference/elasticsearch/command-line-tools/setup-passwords):

    ```bash
    sudo /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
    ```

    * [For Elasticsearch 8.0](https://www.elastic.co/docs/reference/elasticsearch/command-line-tools/reset-password):

    ```bash
    sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password
    ```

    Skip this step if the password is already set.

3. Create or update a role with the privileges needed for TheHive.

    * Create a role:

    ```bash
    curl -u elastic:<elastic_user_password> -X POST "http://localhost:9200/_security/role/thehive_role" -H "Content-Type: application/json" -d '
    {
      "cluster": ["manage"],
      "indices": [
        {
          "names": ["thehive*"],
          "privileges": ["all"]
        }
      ]
    }'
    ```

    Replace `<elastic_user_password>` with the password you set for the `elastic` user.

    If successful, the command should return: `{"role":{"created":true}}`.

    For more details, refer to [the official Elasticsearch API documentation for role creation](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-put-role).

    * Update a role:

    ```bash
    curl -u elastic:<elastic_user_password> -X PUT "http://localhost:9200/_security/role/<role>" -H "Content-Type: application/json" -d '
    {
      "cluster": ["manage"],
      "indices": [
        {
          "names": ["thehive*"],
          "privileges": ["all"]
        }
      ]
    }'
    ```

    Replace `<role>` with the actual role name you want to update.
    
    Replace `<elastic_user_password>` with the password you set for the `elastic` user.

    For more details, refer to [the official Elasticsearch API documentation for updating roles](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-put-role).

4. Assign the role to the user you'll use for TheHive.

    ```bash
    curl -u elastic:<elastic_user_password> -X PUT "http://localhost:9200/_security/user/thehive" \
    -H "Content-Type: application/json" \
    -d '{
        "password" : "<thehive_user_password>",
        "roles" : ["thehive_role"]
    }'
    ```

    Replace `<thehive_user_password>` with the password you set for the `thehive` user.
    
    Replace `<elastic_user_password>` with the password you set for the `elastic` user.
    
    Replace `thehive_role` with actual role name if different.

    If successful, the command should return: `{"created":true}`.

    For more details, refer to [the official Elasticsearch API documentation for updating users](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-put-user).