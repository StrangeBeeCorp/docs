# How to Switch to Manual Download and Installation for TheHive

This topic provides step-by-step instructions for switching from APT and YUM repositories to a manual process for installing and upgrading TheHive, following the [APT and YUM repositories deprecation notice](apt-yum-deprecation-notice.md).

For instructions on performing the same process for Cortex, see [Switch to Manual Download and Installation for Cortex](../../../cortex/operations/switch-to-manual-download-installation-cortex.md).

!!! info "Are you concerned?"
    Use this procedure if you currently install or update TheHive On-Prem on Linux distributions using `apt-get install`, `apt-get upgrade`, `yum install`, or `yum update`.

    You aren't affected if you use the TheHive Cloud Platform or run TheHive through Docker deployments.

    If you are a new user, follow the instructions in the [step-by-step installation guide](../../installation/step-by-step-installation-guide.md).

!!! warning "Prerequisites"
    Before starting this procedure, check that you have installed the following tools:

    * [Wget](https://www.gnu.org/software/wget/) or [cURL](https://curl.se/download.html) to download package files
    * [GPG](https://www.gnupg.org/) to verify the package’s GPG signature
    * [sha256sum](https://linux.die.net/man/1/sha256sum) to check the SHA256 checksum of the downloaded package

<h2>Procedure</h2>

1. Download the package along with its SHA256 checksum and signature files.

    === "Debian-based systems (Ubuntu, Debian)"

        * Using Wget:

        ```bash
        wget https://thehive.download.strangebee.com/<major.minor_version>/DEB/thehive-<full_version>.deb
        wget https://thehive.download.strangebee.com/<major.minor_version>/SHA256/thehive-<full_version>.deb.sha256
        wget https://thehive.download.strangebee.com/<major.minor_version>/ASC/thehive-<full_version>.deb.asc
        ```

        Example:

        ```bash
        wget https://thehive.download.strangebee.com/5.5/DEB/thehive-5.5.5.deb
        wget https://thehive.download.strangebee.com/5.5/SHA256/thehive-5.5.5.deb.sha256
        wget https://thehive.download.strangebee.com/5.5/ASC/thehive-5.5.5.deb.asc
        ```

        * Using cURL:

        ```bash
        curl -O https://thehive.download.strangebee.com/<major.minor_version>/DEB/thehive-<full_version>.deb
        curl -O https://thehive.download.strangebee.com/<major.minor_version>/SHA256/thehive-<full_version>.deb.sha256
        curl -O https://thehive.download.strangebee.com/<major.minor_version>/ASC/thehive-<full_version>.deb.asc
        ```

        Example:
        
        ```bash
        curl -O https://thehive.download.strangebee.com/5.5/DEB/thehive-5.5.5.deb
        curl -O https://thehive.download.strangebee.com/5.5/SHA256/thehive-5.5.5.deb.sha256
        curl -O https://thehive.download.strangebee.com/5.5/ASC/thehive-5.5.5.deb.asc
        ```

    === "RHEL-based systems (CentOS, Fedora, Rocky Linux)"

        * Using Wget:

        ```bash
        wget https://thehive.download.strangebee.com/<major.minor_version>/RPM/thehive-<full_version>.rpm
        wget https://thehive.download.strangebee.com/<major.minor_version>/SHA256/thehive-<full_version>.rpm.sha256
        wget https://thehive.download.strangebee.com/<major.minor_version>/ASC/thehive-<full_version>.rpm.asc
        ```

        Example:

        ```bash
        wget https://thehive.download.strangebee.com/5.5/RPM/thehive-5.5.5.rpm
        wget https://thehive.download.strangebee.com/5.5/SHA256/thehive-5.5.5.rpm.sha256
        wget https://thehive.download.strangebee.com/5.5/ASC/thehive-5.5.5.rpm.asc
        ```

        * Using cURL:

        ```bash
        curl -O https://thehive.download.strangebee.com/<major.minor_version>/RPM/thehive-<full_version>.rpm
        curl -O https://thehive.download.strangebee.com/<major.minor_version>/SHA256/thehive-<full_version>.rpm.sha256
        curl -O https://thehive.download.strangebee.com/<major.minor_version>/ASC/thehive-<full_version>.rpm.asc
        ```

        Example:

        ```bash
        curl -O https://thehive.download.strangebee.com/5.5/RPM/thehive-5.5.5.rpm
        curl -O https://thehive.download.strangebee.com/5.5/SHA256/thehive-5.5.5.rpm.sha256
        curl -O https://thehive.download.strangebee.com/5.5/ASC/thehive-5.5.5.rpm.asc
        ```

2. Verify the integrity of the downloaded package.

    === "Debian-based systems"

       * Check the SHA256 checksum by comparing it with the provided value.

        a. Generate the SHA256 checksum of your downloaded package.

       ```bash
       sha256sum thehive-<full_version>.deb
       ```

        b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

        c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with installation.

       * Verify the GPG signature using the public key.
  
        a. Download the public key at [keys.download.strangebee.com](https://keys.download.strangebee.com) using Wget or cURL.

        ```bash
        wget https://keys.download.strangebee.com/strangebee.gpg
        ```
        
        ```bash
        curl -O https://keys.download.strangebee.com/strangebee.gpg
        ```

        b. Import the key into your GPG keyring.

        ```bash
        gpg --import strangebee.gpg
        ```

        c. Verify the downloaded package signature.

       ```bash
       gpg --verify thehive-<full_version>.deb.asc thehive-<full_version>.deb
       ```

       d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors such as `BAD signature` or `no public key`, don't install the package as its integrity or authenticity can't be confirmed.

    === "RHEL-based systems"

       * Check the SHA256 checksum by comparing it with the provided value.

        a. Generate the SHA256 checksum of your downloaded package.

       ```bash
       sha256sum thehive-<full_version>.rpm
       ```

        b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

        c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with installation.

       * Verify the GPG signature using the public key.
  
        a. Download the public key at [keys.download.strangebee.com](https://keys.download.strangebee.com) using Wget or cURL.

        ```bash
        wget https://keys.download.strangebee.com/strangebee.gpg
        ```
        
        ```bash
        curl -O https://keys.download.strangebee.com/strangebee.gpg
        ```

        b. Import the key into your GPG keyring.

        ```bash
        gpg --import strangebee.gpg
        ```

        c. Verify the downloaded package signature.

       ```bash
       gpg --verify thehive-<full_version>.rpm.asc thehive-<full_version>.rpm
       ```

       d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors such as `BAD signature` or `no public key`, don't install the package as its integrity or authenticity can't be confirmed.

3. Install the package.

    === "Debian-based systems"

        * Using `dpkg`:

        ```bash
        sudo dpkg -i thehive-<full_version>.deb
        ```

        Fix any missing dependencies with `apt`:

        ```bash
        sudo apt-get install -f
        ```

        * Using `apt`:

        ```bash
        sudo apt install ./thehive-<full_version>.deb
        ```

    === "RHEL-based systems"

        * Using `rpm`:

        ```bash
        sudo rpm -ivh thehive-<full_version>.rpm
        ```

        * Using `yum`:

        ```bash
        sudo yum localinstall thehive-<full_version>.rpm
        ```

        * Using `dnf`:

        ```bash
        sudo dnf install thehive-<full_version>.rpm
        ```

4. Remove the old repository to avoid stale configurations.

    === "Debian-based systems"

        ```bash
        sudo rm /etc/apt/sources.list.d/strangebee.list
        sudo apt-get update
        ```

    === "RHEL-based systems"

        a. Disable the repository.

        ```bash
        sudo yum-config-manager --disable strangebee
        ```

        b. Optional: Remove the repository file.

        ```bash
        sudo rm /etc/yum.repos.d/strangebee.repo
        ```

<h2>Next steps</h2>