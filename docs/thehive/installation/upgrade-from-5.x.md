# Upgrade from TheHive 5.x

> **Important:** Starting with version 5.4, our web framework has been upgraded to Play3/Pekko. Depending on your TheHive installation and configuration, certain updates may be required in your configuration files. Refer to the [configuration guide](../configuration/pekko.md) for details.

---

## Important Considerations

Before proceeding with the upgrade, please keep the following points in mind:

1. **Database Backup**: We strongly recommend performing a full database backup before upgrading. For detailed instructions on how to perform a backup, please refer to the backup instructions.

2. **Downgrade Limitation**: Once upgraded to TheHive 5.4, your instance cannot be downgraded. This means reverting to a previous version of TheHive 5 will require restoring your data from the backup.

3. When upgrading an existing TheHive 5.x instance, the first application launch will trigger a database evolution, including schema and data updates. This operation may take some time depending on your database size.

4. Since version 5.1, TheHive no longer supports the Lucene backend as the index engine. Lucene was an option for handling data indexing with TheHive 4.1.x. To migrate your index to Elasticsearch, please follow the [**provided guide**](../operations/change-index.md).

---

## Overview

This guide provides step-by-step instructions for upgrading an existing TheHive 5.x instance to TheHive 5.4.x.

---

## Upgrade Instructions

TheHive 5.x deliverables are hosted in distinct package repositories. Depending on your installation method, follow the instructions below:


=== "DEB Package (Debian/Ubuntu)"

    1. (Optional) Install the package repository signature key, if not already installed:

        ```bash
        wget -O- https://raw.githubusercontent.com/StrangeBeeCorp/Security/main/PGP%20keys/packages.key | sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
        ```

    2. Edit the file ``/etc/apt/sources.list.d/strangebee.list`` and adjust the repository address as follows:

        ```bash
        deb [arch=all signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.4 main
        ``` 

    3. Install TheHive package:

        ```bash
        sudo apt-get update
        sudo apt-get install -y thehive 
        ``` 

=== "RPM Package (Red Hat/CentOS)"

    1. (Optional) Install the package repository signature key, if not already installed:

        ```bash
        sudo rpm --import https://raw.githubusercontent.com/StrangeBeeCorp/Security/main/PGP%20keys/packages.key
        ```

    2. Edit the file ``/etc/yum.repos.d/strangebee.repo`` and adjust the repository address as follows:

        ```bash
        [thehive]
        enabled=1
        priority=1
        name=StrangeBee RPM repository
        baseurl=https://rpm.strangebee.com/thehive-5.4/noarch
        gpgkey=https://raw.githubusercontent.com/StrangeBeeCorp/Security/main/PGP%20keys/packages.key
        gpgcheck=1
        ``` 

    3. Then install the package using yum:

        ```bash
        sudo yum update
        sudo yum install thehive 
        ``` 

=== "Docker"

    Update your existing TheHive 5.x Docker stack (docker-compose file or similar) using the image named ``strangebee/thehive:5.4``

    !!! Note "Important note"
        Ensure that you update your Docker tags accordingly. The strangebee/thehive:latest tag is deprecated and remains associated with TheHive 5.0.x versions. A new strangebee/thehive:5.4 tag is now available and associated with the latest 5.4.x version.

---

### Health Checks

If you have health checks on the application HTTP interface, they should be disabled during the upgrade process. Otherwise, the orchestrator may kill TheHive during the update process.

&nbsp;