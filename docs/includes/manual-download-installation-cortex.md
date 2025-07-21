=== "DEB"

    1. Download the package along with its SHA256 checksum and signature files.

        !!! tip "Destination path"
            Replace `/path/to/` with the full local directory path where you want to save the downloaded files.

        * Using Wget:

            ```bash
            wget -O /path/to/cortex-<full_version>.deb https://cortex.download.strangebee.com/<major.minor_version>/deb/cortex-<full_version>.deb
            wget -O /path/to/cortex-<full_version>.deb.sha256 https://cortex.download.strangebee.com/<major.minor_version>/sha256/cortex-<full_version>.deb.sha256
            wget -O /path/to/cortex-<full_version>.deb.asc https://cortex.download.strangebee.com/<major.minor_version>/asc/cortex-<full_version>.deb.asc
            ```

            Example:

            ```bash
            wget -O /tmp/cortex-3.2.1.deb https://cortex.download.strangebee.com/3.2/deb/cortex-3.2.1.deb
            wget -O /tmp/cortex-3.2.1.deb.sha256 https://cortex.download.strangebee.com/3.2/sha256/cortex-3.2.1.deb.sha256
            wget -O /tmp/cortex-3.2.1.deb.asc https://cortex.download.strangebee.com/3.2/asc/cortex-3.2.1.deb.asc
            ```

        * Using cURL:

            ```bash
            curl -o /path/to/cortex-<full_version>.deb https://cortex.download.strangebee.com/<major.minor_version>/deb/cortex-<full_version>.deb
            curl -o /path/to/cortex-<full_version>.deb.sha256 https://cortex.download.strangebee.com/<major.minor_version>/sha256/cortex-<full_version>.deb.sha256
            curl -o /path/to/cortex-<full_version>.deb.asc https://cortex.download.strangebee.com/<major.minor_version>/asc/cortex-<full_version>.deb.asc
            ```

            Example:
            
            ```bash
            curl -o /tmp/cortex-3.2.1.deb https://cortex.download.strangebee.com/3.2/deb/cortex-3.2.1.deb
            curl -o /tmp/cortex-3.2.1.deb.sha256 https://cortex.download.strangebee.com/3.2/sha256/cortex-3.2.1.deb.sha256
            curl -o /tmp/cortex-3.2.1.deb.asc https://cortex.download.strangebee.com/3.2/asc/cortex-3.2.1.deb.asc
            ```

    2. Verify the integrity of the downloaded package.

          * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /path/to/cortex-<full_version>.deb
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with installation, and contact the [StrangeBee Security Team](mailto:security@strangebee.com).

          * Verify the GPG signature using the public key.
     
            a. Download the public key at [keys.download.strangebee.com](https://keys.download.strangebee.com) using Wget or cURL.

            ```bash
            wget -O /path/to/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```
            
            ```bash
            curl -o /path/to/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```

            b. Import the key into your GPG keyring.

            ```bash
            gpg --import /path/to/strangebee.gpg
            ```

            c. Verify the downloaded package signature.

            ```bash
            gpg --verify /path/to/cortex-<full_version>.deb.asc /path/to/cortex-<full_version>.deb
            ```

            d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors, don't install the package as its integrity or authenticity can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).

    3. Install the package.

        * Using `apt-get` to manage dependencies automatically:

            ```bash
            sudo apt-get install /path/to/cortex-<full_version>.deb
            ```

        * Using `dpkg`:

            ```bash
            sudo dpkg -i /path/to/cortex-<full_version>.deb
            ```

            !!! tip "Missing dependencies"
                While using `dpkg`, you might encounter warnings about missing dependencies during installation. To resolve this, run the commands described in the [Required packages section of the installation guide](/cortex/installation-and-configuration/step-by-step-guide/).

    4. When switching from the previous repository-based installation, remove the old repository to avoid stale configurations.

        !!! danger "Why you should remove the old repository"
            Keeping the old repository configuration can cause your system to download outdated or conflicting packages during updates, potentially breaking your installation or causing unexpected behavior.

        ```bash
        sudo rm /etc/apt/sources.list.d/strangebee.list
        sudo apt-get update
        ```

=== "RPM"

    1. Download the package along with its SHA256 checksum and signature files.

        !!! tip "Destination path"
            Replace `/path/to/` with the full local directory path where you want to save the downloaded files.

        * Using Wget:

            ```bash
            wget -O /path/to/cortex-<full_version>.rpm https://cortex.download.strangebee.com/<major.minor_version>/rpm/cortex-<full_version>.rpm
            wget -O /path/to/cortex-<full_version>.rpm.sha256 https://cortex.download.strangebee.com/<major.minor_version>/sha256/cortex-<full_version>.rpm.sha256
            wget -O /path/to/cortex-<full_version>.rpm.asc https://cortex.download.strangebee.com/<major.minor_version>/asc/cortex-<full_version>.rpm.asc
            ```

            Example:

            ```bash
            wget -O /tmp/cortex-3.2.1.rpm https://cortex.download.strangebee.com/3.2/rpm/cortex-3.2.1.rpm
            wget -O /tmp/cortex-3.2.1.rpm.sha256 https://cortex.download.strangebee.com/3.2/sha256/cortex-3.2.1.rpm.sha256
            wget -O /tmp/cortex-3.2.1.rpm.asc https://cortex.download.strangebee.com/3.2/asc/cortex-3.2.1.rpm.asc
            ```

        * Using cURL:

            ```bash
            curl -o /path/to/cortex-<full_version>.rpm https://cortex.download.strangebee.com/<major.minor_version>/rpm/cortex-<full_version>.rpm
            curl -o /path/to/cortex-<full_version>.rpm.sha256 https://cortex.download.strangebee.com/<major.minor_version>/sha256/cortex-<full_version>.rpm.sha256
            curl -o /path/to/cortex-<full_version>.rpm.asc https://cortex.download.strangebee.com/<major.minor_version>/asc/cortex-<full_version>.rpm.asc
            ```

            Example:

            ```bash
            curl -o /tmp/cortex-3.2.1.rpm https://cortex.download.strangebee.com/3.2/rpm/cortex-3.2.1.rpm
            curl -o /tmp/cortex-3.2.1.rpm.sha256 https://cortex.download.strangebee.com/3.2/sha256/cortex-3.2.1.rpm.sha256
            curl -o /tmp/cortex-3.2.1.rpm.asc https://cortex.download.strangebee.com/3.2/asc/cortex-3.2.1.rpm.asc
            ```

    2. Verify the integrity of the downloaded package.

          * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /path/to/cortex-<full_version>.rpm
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with installation, and contact the [StrangeBee Security Team](mailto:security@strangebee.com).

          * Verify the GPG signature using the public key.
     
            a. Download the public key at [keys.download.strangebee.com](https://keys.download.strangebee.com) using Wget or cURL.

            ```bash
            wget -O /path/to/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```
            
            ```bash
            curl -o /path/to/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```

            b. Import the key into your GPG keyring.

            ```bash
            gpg --import /path/to/strangebee.gpg
            ```

            c. Verify the downloaded package signature.

            ```bash
            gpg --verify /path/to/cortex-<full_version>.rpm.asc /path/to/cortex-<full_version>.rpm
            ```

            d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors, don't install the package as its integrity or authenticity can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).

    3. Install the package.

        * Using `yum` to manage dependencies automatically:

            ```bash
            sudo yum install /path/to/cortex-<full_version>.rpm
            ```

        * Using `dnf` to manage dependencies automatically:

            ```bash
            sudo dnf install /path/to/cortex-<full_version>.rpm
            ```

        * Using `rpm`:

            ```bash
            sudo rpm -ivh /path/to/cortex-<full_version>.rpm
            ```

            !!! tip "Missing dependencies"
                While using `rpm`, you might encounter warnings about missing dependencies during installation. To resolve this, run the commands described in the [Required packages section of the installation guide](/cortex/installation-and-configuration/step-by-step-guide/).

    4. When switching from the previous repository-based installation, deactivate the old repository to avoid stale configurations.

        !!! danger "Why you should deactivate the old repository"
            Keeping the old repository configuration can cause your system to download outdated or conflicting packages during updates, potentially breaking your installation or causing unexpected behavior.

        a. Deactivate the repository.

            ```bash
            sudo yum-config-manager --disable strangebee
            ```

        b. Optional: Remove the repository file.

            ```bash
            sudo rm /etc/yum.repos.d/strangebee.repo
            sudo yum clean all
            sudo yum makecache
            ```