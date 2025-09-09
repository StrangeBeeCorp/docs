1. Open the `/etc/thehive/application.conf` file.

2. In the `application.conf` file, activate audit log storage in Elasticsearch by adding the following lines:

    ```json
    audit {
      storage = elasticsearch
    }
    ```

3. Save your modifications in the `application.conf` file.