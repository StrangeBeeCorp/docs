# How to Switch to Manual Download and Installation for Cortex

This topic provides step-by-step instructions for switching from APT and YUM repositories to a manual process for installing and upgrading Cortex, following the [APT and YUM repositories deprecation notice](../../thehive/operations/apt-yum-repositories-end/apt-yum-deprecation-notice.md).

For instructions on performing the same process for TheHive, see [Switch to Manual Download and Installation for TheHive](../../thehive/operations/apt-yum-repositories-end/switch-to-manual-download-installation-thehive.md).

!!! info "Are you concerned?"
    Use this procedure if you currently install or update Cortex on Linux distributions using `apt-get install`, `apt-get upgrade`, `yum install`, or `yum update`.

    You aren't affected if you run Cortex through Docker deployments.

    If you are a new user, follow the instructions in the [step-by-step installation guide](../installation-and-configuration/step-by-step-guide.md).

!!! warning "Prerequisites"
    Before starting this procedure, check that you have installed the following tools:

    * [Wget](https://www.gnu.org/software/wget/) or [cURL](https://curl.se/download.html) to download package files
    * [GPG](https://www.gnupg.org/) to verify the package’s GPG signature
    * [sha256sum](https://linux.die.net/man/1/sha256sum) to check the SHA256 checksum of the downloaded package

<h2>Procedure</h2>

{!includes/manual-download-installation-cortex.md!}

<h2>Next steps</h2>