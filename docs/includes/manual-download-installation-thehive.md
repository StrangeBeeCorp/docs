=== "DEB"

    !!! tip "Destination path"
        The commands below use `/tmp/` as the download path. Replace it with the full local directory path where you want to save the files.

    1. Download the installation package along with its SHA256 checksum and signature files.

        * Using Wget:

            ```bash
            wget -O /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/deb/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb
            wget -O /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.sha256 https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/sha256/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.sha256
            wget -O /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.asc https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/asc/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            wget -O /tmp/<file_name>.deb https://thehive.download.strangebee.com/<major.minor_version>/deb/<file_name>.deb
            wget -O /tmp/<file_name>.deb.sha256 https://thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.deb.sha256
            wget -O /tmp/<file_name>.deb.asc https://thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.deb.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `thehive_5.4.10-1_all`. 
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `5.4`.

        * Using cURL:

            ```bash
            curl -o /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/deb/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb
            curl -o /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.sha256 https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/sha256/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.sha256
            curl -o /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.asc https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/asc/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            curl -o /tmp/<file_name>.deb https://thehive.download.strangebee.com/<major.minor_version>/deb/<file_name>.deb
            curl -o /tmp/<file_name>.deb.sha256 https://thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.deb.sha256
            curl -o /tmp/<file_name>.deb.asc https://thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.deb.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `thehive_5.4.10-1_all`. 
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `5.4`.

        
    2. Verify the integrity of the downloaded package.

          * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            ```bash
            cat /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.sha256
            ```

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
            gpg --verify /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb.asc /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb
            ```

            d. Expected result.

            You should see output similar to:

            ```
            gpg: Good signature from "TheHive Project (TheHive release key) <support@thehive-project.org>"
            ```

            The key fingerprint must match: `0CD5 AC59 DE5C 5A8E 0EE1  3849 3D99 BB18 562C BC1C`

            !!! info "Expected GPG warning"
                ```
                gpg: WARNING: This key is not certified with a trusted signature!
                gpg:          There is no indication that the signature belongs to the owner.
                ```
                This warning is expected. It means the package is signed with the official TheHive release key, but you haven't marked this key as `trusted` in your local GPG setup. As long as you see `Good signature` and the fingerprint matches, the verification is successful. Don't mark our key as globally trusted—the warning is a normal safety reminder and should remain visible.

            If you don't see `Good signature`, if the fingerprint differs, or if the signature is reported as `BAD`, don't install the package. This indicates the integrity or authenticity of the file can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).

    3. Install the package.

        * Using `apt-get` to manage dependencies automatically:

            ```bash
            sudo apt-get install /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb
            ```

        * Using `dpkg`:

            ```bash
            sudo dpkg -i /tmp/thehive_{!includes/thehive-latest-version.md!lines=2}-1_all.deb
            ```

=== "RPM"

    !!! tip "Destination path"
        The commands below use `/tmp/` as the download path. Replace it with the full local directory path where you want to save the files.

    1. Download the installation package along with its SHA256 checksum and signature files.

        * Using Wget:

            ```bash
            wget -O /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/rpm/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm
            wget -O /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.sha256 https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/sha256/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.sha256
            wget -O /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.asc https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/asc/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            wget -O /tmp/<file_name>.noarch.rpm https://thehive.download.strangebee.com/<major.minor_version>/rpm/<file_name>.noarch.rpm
            wget -O /tmp/<file_name>.noarch.rpm.sha256 https://thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.noarch.rpm.sha256
            wget -O /tmp/<file_name>.noarch.rpm.asc https://thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.noarch.rpm.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `thehive-5.4.10-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `5.4`.

        * Using cURL:

            ```bash
            curl -o /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/rpm/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm
            curl -o /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.sha256 https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/sha256/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.sha256
            curl -o /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.asc https://thehive.download.strangebee.com/{!includes/thehive-latest-version.md!lines=1}/asc/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            curl -o /tmp/<file_name>.noarch.rpm https://thehive.download.strangebee.com/<major.minor_version>/rpm/<file_name>.noarch.rpm
            curl -o /tmp/<file_name>.noarch.rpm.sha256 https://thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.noarch.rpm.sha256
            curl -o /tmp/<file_name>.noarch.rpm.asc https://thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.noarch.rpm.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `thehive-5.4.10-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `5.4`.
            

    2. Verify the integrity of the downloaded package.
              
          * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            ```bash
            cat /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.sha256
            ```

            c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with installation, and contact the [StrangeBee Security Team](mailto:security@strangebee.com)

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
            gpg --verify /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm.asc /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm
            ```

            d. Expected result.

            You should see output similar to:

            ```
            gpg: Good signature from "TheHive Project (TheHive release key) <support@thehive-project.org>"
            ```

            The key fingerprint must match: `0CD5 AC59 DE5C 5A8E 0EE1  3849 3D99 BB18 562C BC1C`

            !!! info "Expected GPG warning"
                ```
                gpg: WARNING: This key is not certified with a trusted signature!
                gpg:          There is no indication that the signature belongs to the owner.
                ```
                This warning is expected. It means the package is signed with the official TheHive release key, but you haven't marked this key as `trusted` in your local GPG setup. As long as you see `Good signature` and the fingerprint matches, the verification is successful. Don't mark our key as globally trusted—the warning is a normal safety reminder and should remain visible.

            If you don't see `Good signature`, if the fingerprint differs, or if the signature is reported as `BAD`, don't install the package. This indicates the integrity or authenticity of the file can't be confirmed. Report the issue to the [StrangeBee Security Team](mailto:security@strangebee.com).

    3. Install the package.

        * Using `yum` to manage dependencies automatically:

            ```bash
            sudo yum install /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm
            ```

        * Using `dnf` to manage dependencies automatically:

            ```bash
            sudo dnf install /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm
            ```

        * Using `rpm`:

            ```bash
            sudo rpm -ivh /tmp/thehive-{!includes/thehive-latest-version.md!lines=2}-1.noarch.rpm
            ```