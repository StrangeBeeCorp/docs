# Upgrade from TheHive 5.x


!!! Danger "*READ FIRST*"
    
    
    1. We strongly recommend you perform a full database backup before upgrading. Please follow the [backup instructions](../operations/backup-restore.md).
    2. Once upgraded to TheHive 5.2, your TheHive instance cannot be _downgraded_, meaning you cannot go back to the previous TheHive 5 version you used, unless you restore your data from your TheHive 5.x backup.
    3. When upgrading an existing TheHive 5.x instance, the first application launch will apply a database evolution (schema and data). This operation might take some time depending on your database size.

!!! Danger "Using Lucene"
    Since version 5.1, TheHive does **NOT** support Lucene backend as index engine any more.
    
    **Lucene** was an option to handle the data index with TheHive 4.1.x  ; to migrate your index to Elasticsearch, follow [this guide](./operations/change-index.md).


## Overview

This guide provides instructions to upgrade an existing TheHive 5.0.x or 5.1.x instance to TheHive 5.2.x.


## Upgrade instructions

TheHive 5.x deliverables are hosted in distinct package repositories. In order to upgrade to version 5.2.x, you need to edit your repository configuration as described below. Docker images have specific version 5.2 tags.


=== "DEB"
    !!! Example ""

        1. (Optional) install the package repository signature key, if you don't already have it
        ```bash
        wget -O- https://archives.strangebee.com/keys/strangebee.gpg | sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
        ```

        2. Edit the file `/etc/apt/sources.list.d/strangebee.list` and adjust the repository address as follows
        ```
        deb [arch=all signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.2 main
        ```

        3. Install TheHive package
        ```bash
        sudo apt-get update
        sudo apt-get install -y thehive
        ```

=== "RPM"
    !!! Example ""

        1. (Optional) install the package repository signature key, if you don't already have it
        ```bash
        sudo rpm --import https://archives.strangebee.com/keys/strangebee.gpg 
        ```

        2. Edit the file `/etc/yum.repos.d/strangebee.repo` and adjust the repository address to obtain the follow configuration:

            !!! Example ""
                ```title="/etc/yum.repos.d/strangebee.repo"
                [thehive]
                enabled=1
                priority=1
                name=StrangeBee RPM repository
                baseurl=https://rpm.strangebee.com/thehive-5.2/noarch
                gpgkey=https://archives.strangebee.com/keys/strangebee.gpg
                gpgcheck=1
                ```

        3. Then install the package using `yum`:

            !!! Example ""
                ```bash
                sudo yum update
                sudo yum install thehive
                ```

=== "Docker"

    !!! Example ""

        Update your existing TheHive 5.x Docker stack (docker-compose file or similar) using the image named `strangebee/thehive:5.2`.

        !!! Warning "*Docker tags*"
        
            1. The `strangebee/thehive:latest` tag is deprecated and remains associated with TheHive 5.0.x versions. It will be released soon.
            2. A new `strangebee/thehive:5.2` tag is now available and associated with the latest `5.2.x` version

### Health checks

If you have health checks on the application http interface, they should be disabled during the upgrade process. Otherwise the orchestrator will kill TheHive during the update process.

