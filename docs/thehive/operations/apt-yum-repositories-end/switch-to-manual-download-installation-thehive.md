# How to Switch to Manual Download and Installation for TheHive

This topic provides step-by-step instructions for switching from APT and YUM repositories to a manual process for installing and upgrading TheHive, following the [APT and YUM repositories deprecation notice](apt-yum-deprecation-notice.md).

For instructions on performing the same process for Cortex, see [Switch to Manual Download and Installation for Cortex](../../../cortex/operations/switch-to-manual-download-installation-cortex.md).

!!! info "Are you concerned?"
    Use this procedure if you currently install or update TheHive on-premises on Linux distributions using `apt-get install`, `apt-get upgrade`, `yum install`, or `yum update`.

    You aren't affected if you use the SaaS solution or run TheHive through Docker deployments.

    If you are a new user, follow the updated instructions in the [step-by-step installation guide](../../installation/step-by-step-installation-guide.md).

!!! warning "Prerequisites"
    Before starting this procedure, check that you have installed the following tools:

    * [Wget](https://www.gnu.org/software/wget/) to download package files (.deb or .rpm)
    * [GPG](https://www.gnupg.org/) to verify the package’s GPG signature
    * [sha256sum](https://linux.die.net/man/1/sha256sum) to check the SHA256 checksum of the downloaded package

<h2>Procedure</h2>

1. Download the package.

    === "Debian-based systems (Ubuntu, Debian)"

        ```bash
        wget https://thehive.download.strangebee.com/thehive-x.y.z.deb
        ```

        ```bash
        curl -O https://thehive.download.strangebee.com/thehive-x.y.z.deb
        ```

    === "RHEL-based systems (CentOS, Fedora, Rocky Linux)"

        ```bash
        wget https://thehive.download.strangebee.com/thehive-x.y.z.rpm
        ```

        ```bash
        curl -O https://thehive.download.strangebee.com/thehive-x.y.z.rpm
        ```

2. Verify the downloaded package.

    * Match the SHA256 checksum against the value provided alongside the package link.

    ```bash
    sha256sum thehive-latest.deb
    ```

    * Verify the GPG signature using the public key available at XXX.

    ```bash
    gpg --verify thehive-latest.deb.sig thehive-latest.deb
    ```

3. Install the package.

    === "Debian-based systems"

        ```bash
        sudo dpkg -i thehive-x.y.z.deb
        ```

        Then, resolve any missing dependencies:

        ```bash
        sudo apt-get install -f
        ```

    === "RHEL-based systems"

        ```bash
        sudo rpm -ivh thehive-x.y.z.rpm
        ```

4. Remove the old repository to avoid stale configurations.

    === "Debian-based systems"

        ```bash
        sudo rm /etc/apt/sources.list.d/strangebee.list
        sudo apt update
        ```

    === "RHEL-based systems"

        ```bash
        sudo yum-config-manager --disable strangebee
        ```

        Optionally, remove the repository file:

        ```bash
        sudo rm /etc/yum.repos.d/strangebee.repo
        ```

<h2>Next steps</h2>