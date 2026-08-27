# Quick Install Cortex with Packages: One-Command Setup

If you prefer a faster setup than going through [the complete installation guide](step-by-step-guide.md), you can run the automated installation script instead. It's the same script used to install TheHive, and it can also install Cortex along with its dependencies on a standalone Linux server using predefined settings.

!!! warning "Before you begin"
    To ensure a smooth installation process, make sure you have:

    * A basic understanding of [the role and architecture of Cortex](../index.md)
    * [System requirements fully met and verified](system-requirements.md) for script-based installation
    * [`wget`](https://www.gnu.org/software/wget/){target=_blank} installed

!!! danger "No authentication configured for Elasticsearch"
    This script doesn't set up authentication for Elasticsearch. For security—especially in production—enable authentication on Elasticsearch before going live.

<h2>Procedure</h2>

1. Download and run the script.

    ```bash
    wget -q -O /tmp/install_script.sh https://scripts.download.strangebee.com/latest/sh/install_script.sh ; sudo -v ; bash /tmp/install_script.sh
    ```

2. Enter the number corresponding to the installation option you want to run.

    * 3) **Install Cortex and all its dependencies to run Analyzers & Responders as Docker images**: The recommended option. Also installs the Docker engine.
    * 4) **Install Cortex and all its dependencies to run Analyzers & Responders on the host**: Debian and Ubuntu only.

3. Press **Enter**.

4. Once the installation is complete, select the URL shown in the final output to start using Cortex.

5. Perform the initial setup of the application by following the instructions in [First start](../user-guides/first-start.md).

If you also want to use the script to install TheHive, refer to [Quick Install with Packages: One-Command Setup](../../thehive/installation/automated-installation-script-linux.md) for additional details.

<h2>Next steps</h2>

* [Cortex Package Repository](cortex-packages.md)
* [Authentication](authentication.md)
* [Analyzers & Responders](analyzers-responders.md)
* [Advanced Configuration](advanced-configuration.md)
* [Backup and Restore Data](../operations/backup-restore.md)
