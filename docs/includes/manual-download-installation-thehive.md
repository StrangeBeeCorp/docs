=== "DEB"

    1. Download the package along with its SHA256 checksum and signature files.

        !!! tip "Destination path"
            The examples below use `/tmp/` as the download path. Replace it with the full local directory path where you want to save the files.

        * Using Wget:

            ```bash
            wget -O /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/deb/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb
            wget -O /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.sha256 https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/sha256/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.sha256
            wget -O /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.asc https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/asc/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.asc
            ```

            To download a different version, use this format:

            ```bash
            wget -O /tmp/thehive_<full_version>-1_all.deb https://thehive.download.strangebee.com/<major.minor>/deb/thehive_<full_version>-1_all.deb
```

            * {!includes/thehive-latest-version.md!lines=2} with the full version number you are interested in.
            * {!includes/thehive-latest-version.md!lines=1} with the major and minor version you are interested in.

        * Using cURL:

            ```bash
            curl -o /path/to/<file_name>.deb https://thehive.download.strangebee.com/<major.minor_version>/deb/<file_name>.deb
            curl -o /path/to/<file_name>.deb.sha256 https://thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.deb.sha256
            curl -o /path/to/<file_name>.deb.asc https://thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.deb.asc
            ```

            Example:
            
            ```bash
            curl -o /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/deb/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb
            curl -o /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.sha256 https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/sha256/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.sha256
            curl -o /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.asc https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/asc/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.asc
            ```
        
    2. Verify the integrity of the downloaded package.

          * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /path/to/<file_name>.deb
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
            gpg --verify /path/to/<file_name>.deb.asc /path/to/<file_name>.deb
            ```

            d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors, don't install the package as its integrity or authenticity can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).

    3. Install the package.

        * Using `apt-get` to manage dependencies automatically:

            ```bash
            sudo apt-get install /path/to/<file_name>.deb
            ```

        * Using `dpkg`:

            ```bash
            sudo dpkg -i /path/to/<file_name>.deb
            ```

            !!! tip "Missing dependencies"
                While using `dpkg`, you might encounter warnings about missing dependencies during installation. To resolve this, run the commands described in the [Dependencies section of the installation guide](/thehive/installation/step-by-step-installation-guide/).

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
            wget -O /path/to/<file_name>.rpm https://thehive.download.strangebee.com/<major.minor_version>/rpm/<file_name>.rpm
            wget -O /path/to/<file_name>.rpm.sha256 https://thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.rpm.sha256
            wget -O /path/to/<file_name>.rpm.asc https://thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.rpm.asc
            ```

            Example:

            ```bash
            wget -O /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/rpm/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm
            wget -O /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.sha256 https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/sha256/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.sha256
            wget -O /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.asc https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/asc/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.asc
            ```

        * Using cURL:

            ```bash
            curl -o /path/to/<file_name>.rpm https://thehive.download.strangebee.com/<major.minor_version>/rpm/<file_name>.rpm
            curl -o /path/to/<file_name>.rpm.sha256 https://thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.rpm.sha256
            curl -o /path/to/<file_name>.rpm.asc https://thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.rpm.asc
            ```

            Example:

            ```bash
            curl -o /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/rpm/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm
            curl -o /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.sha256 https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/sha256/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.sha256
            curl -o /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.asc https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/asc/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.asc
            ```

    2. Verify the integrity of the downloaded package.
              
          * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /path/to/<file_name>.rpm
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with installation, and contact the [StrangeBee Security Team](mailto:security@strangebee.com)

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
            gpg --verify /path/to/<file_name>.rpm.asc /path/to/<file_name>.rpm
            ```

            d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors, don't install the package as its integrity or authenticity can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).

    3. Install the package.

        * Using `yum` to manage dependencies automatically:

            ```bash
            sudo yum install /path/to/<file_name>.rpm
            ```

        * Using `dnf` to manage dependencies automatically:

            ```bash
            sudo dnf install /path/to/<file_name>.rpm
            ```

        * Using `rpm`:

            ```bash
            sudo rpm -ivh /path/to/<file_name>.rpm
            ```

            !!! tip "Missing dependencies"
                While using `rpm`, you might encounter warnings about missing dependencies during installation. To resolve this, run the commands described in the [Dependencies section of the installation guide](/thehive/installation/step-by-step-installation-guide/).

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