=== "DEB"

    1. Download the package along with its SHA256 checksum and signature files.

        * Using Wget:

        ```bash
        wget https://cortex.download.strangebee.com/<major.minor_version>/deb/cortex-<full_version>.deb
        wget https://cortex.download.strangebee.com/<major.minor_version>/sha256/cortex-<full_version>.deb.sha256
        wget https://cortex.download.strangebee.com/<major.minor_version>/asc/cortex-<full_version>.deb.asc
        ```

        Example:

        ```bash
        wget https://cortex.download.strangebee.com/3.2/deb/cortex-3.2.1.deb
        wget https://cortex.download.strangebee.com/3.2/sha256/cortex-3.2.1.deb.sha256
        wget https://cortex.download.strangebee.com/3.2/asc/cortex-3.2.1.deb.asc
        ```

        * Using cURL:

        ```bash
        curl -O https://cortex.download.strangebee.com/<major.minor_version>/deb/cortex-<full_version>.deb
        curl -O https://cortex.download.strangebee.com/<major.minor_version>/sha256/cortex-<full_version>.deb.sha256
        curl -O https://cortex.download.strangebee.com/<major.minor_version>/asc/cortex-<full_version>.deb.asc
        ```

        Example:
        
        ```bash
        curl -O https://cortex.download.strangebee.com/3.2/deb/cortex-3.2.1.deb
        curl -O https://cortex.download.strangebee.com/3.2/sha256/cortex-3.2.1.deb.sha256
        curl -O https://cortex.download.strangebee.com/3.2/asc/cortex-3.2.1.deb.asc
        ```

    2. Verify the integrity of the downloaded package.

       * Check the SHA256 checksum by comparing it with the provided value.

        a. Generate the SHA256 checksum of your downloaded package.

       ```bash
       sha256sum cortex-<full_version>.deb
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
       gpg --verify cortex-<full_version>.deb.asc cortex-<full_version>.deb
       ```

       d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors such as `BAD signature` or `no public key`, don't install the package as its integrity or authenticity can't be confirmed.

    3. Install the package.

        * Using `dpkg`:

        ```bash
        sudo dpkg -i cortex-<full_version>.deb
        ```

        Fix any missing dependencies with `apt`:

        ```bash
        sudo apt-get install -f
        ```

        * Using `apt-get`:

        ```bash
        sudo apt-get install ./cortex-<full_version>.deb
        ```

    4. When switching from or upgrading the previous repository-based installation: Remove the old repository to avoid stale configurations.

        ```bash
        sudo rm /etc/apt/sources.list.d/strangebee.list
        sudo apt-get update
        ```

=== "RPM"

    1. Download the package along with its SHA256 checksum and signature files.

        * Using Wget:

        ```bash
        wget https://cortex.download.strangebee.com/<major.minor_version>/rpm/cortex-<full_version>.rpm
        wget https://cortex.download.strangebee.com/<major.minor_version>/sha256/cortex-<full_version>.rpm.sha256
        wget https://cortex.download.strangebee.com/<major.minor_version>/asc/cortex-<full_version>.rpm.asc
        ```

        Example:

        ```bash
        wget https://cortex.download.strangebee.com/3.2/rpm/cortex-3.2.1.rpm
        wget https://cortex.download.strangebee.com/3.2/sha256/cortex-3.2.1.rpm.sha256
        wget https://cortex.download.strangebee.com/3.2/asc/cortex-3.2.1.rpm.asc
        ```

        * Using cURL:

        ```bash
        curl -O https://cortex.download.strangebee.com/<major.minor_version>/rpm/cortex-<full_version>.rpm
        curl -O https://cortex.download.strangebee.com/<major.minor_version>/sha256/cortex-<full_version>.rpm.sha256
        curl -O https://cortex.download.strangebee.com/<major.minor_version>/asc/cortex-<full_version>.rpm.asc
        ```

        Example:

        ```bash
        curl -O https://cortex.download.strangebee.com/3.2/rpm/cortex-3.2.1.rpm
        curl -O https://cortex.download.strangebee.com/3.2/sha256/cortex-3.2.1.rpm.sha256
        curl -O https://cortex.download.strangebee.com/3.2/asc/cortex-3.2.1.rpm.asc
        ```

    2. Verify the integrity of the downloaded package.

       * Check the SHA256 checksum by comparing it with the provided value.

        a. Generate the SHA256 checksum of your downloaded package.

       ```bash
       sha256sum cortex-<full_version>.rpm
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
       gpg --verify cortex-<full_version>.rpm.asc cortex-<full_version>.rpm
       ```

       d. You should see a message stating indicating that the signature is valid and the package is authentic. If you see warnings or errors such as `BAD signature` or `no public key`, don't install the package as its integrity or authenticity can't be confirmed.

    3. Install the package.

        * Using `rpm`:

        ```bash
        sudo rpm -ivh cortex-<full_version>.rpm
        ```

        * Using `yum`:

        ```bash
        sudo yum localinstall cortex-<full_version>.rpm
        ```

        * Using `dnf`:

        ```bash
        sudo dnf install cortex-<full_version>.rpm
        ```

    4. When switching from or upgrading the previous repository-based installation: Remove the old repository to avoid stale configurations.

        a. Disable the repository.

        ```bash
        sudo yum-config-manager --disable strangebee
        ```

        b. Optional: Remove the repository file.

        ```bash
        sudo rm /etc/yum.repos.d/strangebee.repo
        ```