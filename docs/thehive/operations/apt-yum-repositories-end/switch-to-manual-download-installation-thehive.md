# Switch to Manual Download and Installation for TheHive

Following the [APT and YUM repositories deprecation notice](apt-yum-deprecation-notice.md), TheHive installations must switch from repository-based package management to a manual download and installation process.

For instructions on performing the same process for Cortex, see [Switch to Manual Download and Installation for Cortex](../../../cortex/operations/switch-to-manual-download-installation-cortex.md).

!!! info "Are you concerned?"
    Use this procedure if you currently install or update TheHive On-prem on Linux distributions using `apt-get install`, `apt-get upgrade`, `yum install`, or `yum update`.

    You aren't affected if you use the TheHive Cloud Platform or run TheHive through Docker deployments.

    If you are a new user, follow the instructions in the [installation guide](../../installation/installation-guide-linux-standalone-server.md).

!!! warning "Dependencies"
    Before starting this procedure, run the following commands:

    ### For DEB-based systems:

    ```bash
    sudo apt update
    sudo apt install wget curl gnupg coreutils
    ```

    ### For RPM-based systems:

    ```bash
    sudo yum update
    sudo yum install wget curl gnupg coreutils
    ```

<h2>Procedure</h2>

### Step 1: Manually install TheHive

{% include-markdown "includes/manual-download-installation-thehive.md" %}

### Step 2: Remove the old repository

{% include-markdown "includes/remove-old-repository.md" %}

<h2>Next steps</h2>

* [Switch to Manual Download and Installation for Cortex](../../../cortex/operations/switch-to-manual-download-installation-cortex.md)