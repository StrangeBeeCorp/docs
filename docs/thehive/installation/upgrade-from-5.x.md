# Upgrade from TheHive 5.x

> **Important:** Starting with version 5.4, our web framework has been upgraded to Play3/Pekko. Depending on your TheHive installation and configuration, certain updates may be required in your configuration files. Refer to the [configuration guide](../configuration/pekko.md) for details.

!!! info "Cortex support"
    <!-- md:version 5.5 --> Cortex 3.1.5 and earlier are no longer supported since version 5.5.

---

## Important considerations

Before proceeding with the upgrade, please keep the following points in mind:

1. **Database Backup**: We strongly recommend performing a full database backup before upgrading. For detailed instructions on how to perform a backup, please refer to the backup instructions.

2. **Downgrade Limitation**: Once upgraded to TheHive 5.5, your instance can't be downgraded. This means reverting to a previous version of TheHive 5 will require restoring your data from the backup.

3. When upgrading an existing TheHive 5.x instance, the first application launch will trigger a database evolution, including schema and data updates. This operation may take some time depending on your database size.

4. Since version 5.1, TheHive no longer supports the Lucene backend as the index engine. Lucene was an option for handling data indexing with TheHive 4.1.x. To migrate your index to Elasticsearch, please follow the [**provided guide**](../operations/change-index.md).

---

## Overview

This guide provides step-by-step instructions for upgrading an existing TheHive 5.x instance to TheHive 5.5.x.

---

## Upgrade instructions

TheHive packages are distributed as RPM and DEB files available for direct download via tools like `wget` or `curl`, with installation performed manually.

All packages are hosted on an HTTPS-secured website and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum){target=_blank} and a [GPG](https://www.gnupg.org/){target=_blank} signature for verification.

Alternatively, you can deploy TheHive using Docker images.

{% include-markdown "includes/manual-download-installation-thehive.md" %}

=== "Docker"

    Update your existing TheHive 5.x Docker stack (docker-compose file or similar) using the image named `strangebee/thehive:5.6`

    !!! Note "Important note"
        Ensure that you update your Docker tags accordingly. The strangebee/thehive:latest tag is deprecated and remains associated with TheHive 5.0.x versions. A new strangebee/thehive:5.6 tag is now available and associated with the latest 5.6.x version.

---

### Health checks

If you have health checks on the application HTTP interface, they should be disabled during the upgrade process. Otherwise, the orchestrator may kill TheHive during the update process.

&nbsp;