=== "DEB"

    1. Download the package along with its SHA256 checksum and signature files.

        * Using Wget:

            ```bash
            wget https://thehive.download.strangebee.com/<major.minor_version>/deb/thehive-<full_version>.deb
            wget https://thehive.download.strangebee.com/<major.minor_version>/sha256/thehive-<full_version>.deb.sha256
            wget https://thehive.download.strangebee.com/<major.minor_version>/asc/thehive-<full_version>.deb.asc
            ```

            Example:

            ```bash
            wget https://thehive.download.strangebee.com/5.5/deb/thehive-5.5.5.deb
            wget https://thehive.download.strangebee.com/5.5/sha256/thehive-5.5.5.deb.sha256
            wget https://thehive.download.strangebee.com/5.5/asc/thehive-5.5.5.deb.asc
            ```

        * Using cURL:

            ```bash
            curl -O https://thehive.download.strangebee.com/<major.minor_version>/deb/thehive-<full_version>.deb
            curl -O https://thehive.download.strangebee.com/<major.minor_version>/sha256/thehive-<full_version>.deb.sha256
            curl -O https://thehive.download.strangebee.com/<major.minor_version>/asc/thehive-<full_version>.deb.asc
            ```

            Example:
            
            ```bash
            curl -O https://thehive.download.strangebee.com/5.5/deb/thehive-5.5.5.deb
            curl -O https://thehive.download.strangebee.com/5.5/sha256/thehive-5.5.5.deb.sha256
            curl -O https://thehive.download.strangebee.com/5.5/asc/thehive-5.5.5.deb.asc
            ```
        
    2. Verify the integrity of the downloaded package.

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
            wget https://keys.download.strangebee.com/gpg/strangebee.gpg
            ```
            
            ```bash
            curl -O https://keys.download.strangebee.com/gpg/strangebee.gpg
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

    3. Install the package.

        * Using `dpkg`:

            ```bash
            sudo dpkg -i thehive-<full_version>.deb
            ```

            Fix any missing dependencies with `apt`:

            ```bash
            sudo apt-get install -f
            ```

        * Using `apt-get`:

            ```bash
            sudo apt-get install ./thehive-<full_version>.deb
            ```

    4. When switching from the previous repository-based installation, remove the old repository to avoid stale configurations.

        ```bash
        sudo rm /etc/apt/sources.list.d/strangebee.list
        sudo apt-get update
        ```

=== "RPM"

    1. Download the package along with its SHA256 checksum and signature files.

        * Using Wget:

            ```bash
            wget https://thehive.download.strangebee.com/<major.minor_version>/rpm/thehive-<full_version>.rpm
            wget https://thehive.download.strangebee.com/<major.minor_version>/sha256/thehive-<full_version>.rpm.sha256
            wget https://thehive.download.strangebee.com/<major.minor_version>/asc/thehive-<full_version>.rpm.asc
            ```

            Example:

            ```bash
            wget https://thehive.download.strangebee.com/5.5/rpm/thehive-5.5.5.rpm
            wget https://thehive.download.strangebee.com/5.5/sha256/thehive-5.5.5.rpm.sha256
            wget https://thehive.download.strangebee.com/5.5/asc/thehive-5.5.5.rpm.asc
            ```

        * Using cURL:

            ```bash
            curl -O https://thehive.download.strangebee.com/<major.minor_version>/rpm/thehive-<full_version>.rpm
            curl -O https://thehive.download.strangebee.com/<major.minor_version>/sha256/thehive-<full_version>.rpm.sha256
            curl -O https://thehive.download.strangebee.com/<major.minor_version>/asc/thehive-<full_version>.rpm.asc
            ```

            Example:

            ```bash
            curl -O https://thehive.download.strangebee.com/5.5/rpm/thehive-5.5.5.rpm
            curl -O https://thehive.download.strangebee.com/5.5/sha256/thehive-5.5.5.rpm.sha256
            curl -O https://thehive.download.strangebee.com/5.5/asc/thehive-5.5.5.rpm.asc
            ```

    2. Verify the integrity of the downloaded package.
              
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
            wget https://keys.download.strangebee.com/gpg/strangebee.gpg
            ```
            
            ```bash
            curl -O https://keys.download.strangebee.com/gpg/strangebee.gpg
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

    4. When switching from the previous repository-based installation, remove the old repository to avoid stale configurations.

        a. Disable the repository.

            ```bash
            sudo yum-config-manager --disable strangebee
            ```

        b. Optional: Remove the repository file.

            ```bash
            sudo rm /etc/yum.repos.d/strangebee.repo
            ```