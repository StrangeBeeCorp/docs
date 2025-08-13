=== "DEB"

    !!! tip "Destination path"
        The commands below use `/tmp/` as the download path. Replace it with the full local directory path where you want to save the files.

    1. Download the installation package along with its SHA256 checksum and signature files.

        * Using Wget:

            ```bash
            wget -O /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/deb/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb
            wget -O /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb.sha256 https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/sha256/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb.sha256
            wget -O /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb.asc https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/asc/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            wget -O /tmp/<file_name>.deb https://cortex.download.strangebee.com/<major.minor_version>/deb/<file_name>.deb
            wget -O /tmp/<file_name>.deb.sha256 https://cortex.download.strangebee.com/<major.minor_version>/sha256/<file_name>.deb.sha256
            wget -O /tmp/<file_name>.deb.asc https://cortex.download.strangebee.com/<major.minor_version>/asc/<file_name>.deb.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `cortex_3.1.8-1_all`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `3.1`.

        * Using cURL:

            ```bash
            curl -o /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/deb/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb
            curl -o /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb.sha256 https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/sha256/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb.sha256
            curl -o /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb.asc https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/asc/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            curl -o /tmp/<file_name>.deb https://cortex.download.strangebee.com/<major.minor_version>/deb/<file_name>.deb
            curl -o /tmp/<file_name>.deb.sha256 https://cortex.download.strangebee.com/<major.minor_version>/sha256/<file_name>.deb.sha256
            curl -o /tmp/<file_name>.deb.asc https://cortex.download.strangebee.com/<major.minor_version>/asc/<file_name>.deb.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `cortex_3.1.8-1_all`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `3.1`.
            

    2. Verify the integrity of the downloaded package.

          * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with installation, and contact the [StrangeBee Security Team](mailto:security@strangebee.com).

          * Verify the GPG signature using the public key.
     
            a. Download the public key at [keys.download.strangebee.com](https://keys.download.strangebee.com) using Wget or cURL.

            ```bash
            wget -O /tmp/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```
            
            ```bash
            curl -o /tmp/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```

            b. Import the key into your GPG keyring.

            ```bash
            gpg --import /tmp/strangebee.gpg
            ```

            c. Verify the downloaded package signature.

            ```bash
            gpg --verify /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb.asc /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb
            ```

            d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors, don't install the package as its integrity or authenticity can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).

    3. Install the package.

        * Using `apt-get` to manage dependencies automatically:

            ```bash
            sudo apt-get install /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb
            ```

        * Using `dpkg`:

            ```bash
            sudo dpkg -i /tmp/cortex_{!includes/cortex-latest-version.md!lines=2}-2_all.deb
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

    !!! tip "Destination path"
        The commands below use `/tmp/` as the download path. Replace it with the full local directory path where you want to save the files.

    1. Download the installation package along with its SHA256 checksum and signature files.

        * Using Wget:

            ```bash
            wget -O /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/rpm/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm
            wget -O /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm.sha256 https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/sha256/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm.sha256
            wget -O /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm.asc https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/asc/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            wget -O /tmp/<file_name>.noarch.rpm https://cortex.download.strangebee.com/<major.minor_version>/rpm/<file_name>.noarch.rpm
            wget -O /tmp/<file_name>.noarch.rpm.sha256 https://cortex.download.strangebee.com/<major.minor_version>/sha256/<file_name>.noarch.rpm.sha256
            wget -O /tmp/<file_name>.noarch.rpm.asc https://cortex.download.strangebee.com/<major.minor_version>/asc/<file_name>.noarch.rpm.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `cortex-3.1.8-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `3.1`.

        * Using cURL:

            ```bash
            curl -o /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/rpm/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm
            curl -o /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm.sha256 https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/sha256/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm.sha256
            curl -o /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm.asc https://cortex.download.strangebee.com/{!includes/cortex-latest-version.md!lines=1}/asc/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            curl -o /tmp/<file_name>.noarch.rpm https://cortex.download.strangebee.com/<major.minor_version>/rpm/<file_name>.noarch.rpm
            curl -o /tmp/<file_name>.noarch.rpm.sha256 https://cortex.download.strangebee.com/<major.minor_version>/sha256/<file_name>.noarch.rpm.sha256
            curl -o /tmp/<file_name>.noarch.rpm.asc https://cortex.download.strangebee.com/<major.minor_version>/asc/<file_name>.noarch.rpm.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `cortex-3.1.8-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `3.1`.

    2. Verify the integrity of the downloaded package.

          * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with installation, and contact the [StrangeBee Security Team](mailto:security@strangebee.com).

          * Verify the GPG signature using the public key.
     
            a. Download the public key at [keys.download.strangebee.com](https://keys.download.strangebee.com) using Wget or cURL.

            ```bash
            wget -O /tmp/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```
            
            ```bash
            curl -o /tmp/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```

            b. Import the key into your GPG keyring.

            ```bash
            gpg --import /tmp/strangebee.gpg
            ```

            c. Verify the downloaded package signature.

            ```bash
            gpg --verify /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm.asc /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm
            ```

            d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors, don't install the package as its integrity or authenticity can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).

    3. Install the package.

        * Using `yum` to manage dependencies automatically:

            ```bash
            sudo yum install /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm
            ```

        * Using `dnf` to manage dependencies automatically:

            ```bash
            sudo dnf install /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm
            ```

        * Using `rpm`:

            ```bash
            sudo rpm -ivh /tmp/cortex-{!includes/cortex-latest-version.md!lines=2}-2.noarch.rpm
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
            ```