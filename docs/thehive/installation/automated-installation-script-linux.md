# Quick Install on Linux Systems: One-Command Setup

If you prefer a faster setup than going through [the complete installation guide](installation-guide-linux-standalone-server.md), you can run the automated installation script instead. It will install TheHive along with all [required services](../overview/index.md#architecture) and dependencies on a standalone Linux server using predefined settings.

!!! warning "Before you begin"
    To ensure a smooth installation process, make sure you have:

    * A basic understanding of [TheHive architecture](../overview/index.md#architecture)
    * [System requirements fully met and verified](system-requirements.md) for script-based installation
    * [Wget](https://www.gnu.org/software/wget/){target=_blank} installed

!!! danger "No authentication configured for Cassandra and Elasticsearch"
    This script doesn't set up authentication for Cassandra or Elasticsearch. For security—especially in production—enable authentication on both services before going live. See [Configure Database and Index Authentication](../configuration/configure-authentication-cassandra-elasticsearch.md) for instructions.

{% include-markdown "includes/data-protection-link.md" %}

<h2>Procedure</h2>

1. Download and run the script.

    ```bash
    wget -q -O /tmp/install_script.sh https://scripts.download.strangebee.com/latest/sh/install_script.sh ; sudo -v ; bash /tmp/install_script.sh
    ```

2. Enter the number corresponding to the installation option you want to run.

    * 1) **Setup proxy settings**: Configure the host to operate behind an HTTP proxy and integrate custom certificate authorities (CAs) if needed. This ensures secure and compatible communication with external services.
    * 2) **Install TheHive**: Automatically install TheHive, including its required components and dependencies, using predefined and production-ready settings.

3. Press **Enter**.

4. Once the installation is complete, select the URL shown in the final output to start using TheHive.

5. Perform the initial setup of the application by following the instructions in [Perform Initial Login and Setup as an Admin](../administration/perform-initial-setup-as-admin.md).

If you also want to use the script to install Cortex, refer to the [Cortex installation guide](../../cortex/installation-and-configuration/index.md#installation-guide) for additional details.

<h2>Next steps</h2>

* [Configure JVM Trust for SSL/TLS Certificates](../configuration/ssl/configure-ssl-jvm.md)
* [Update TheHive Service Configuration](../configuration/update-service-configuration.md)
* [Turn Off The Cortex Integration](../configuration/turn-off-cortex-connector.md)
* [Turn Off The MISP Integration](../configuration/turn-off-misp-connector.md)
* [Update Log Configuration](../configuration/update-log-configuration.md)
* [Update TheHive Service Configuration](../configuration/update-service-configuration.md)
* [Enable the GDPR Compliance Feature](../configuration/enable-gdpr.md)
* [Hot Backups](../operations/backup-restore/backup/hot-backup.md)
* [Cold Backups for Physical Servers](../operations/backup-restore/backup/physical-server.md)
* [Cold Backups for Virtual Servers](../operations/backup-restore/backup/virtual-server.md)
* [Monitoring](../operations/monitoring.md)
* [Troubleshooting](../operations/troubleshooting.md)