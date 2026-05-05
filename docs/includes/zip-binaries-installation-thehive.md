=== "ZIP binary packages"

    If you prefer more control over where TheHive is installed, need to use it in environments without package managers, or want to avoid dependency issues, you can install TheHive by downloading a ZIP binary package.

    !!! tip "Destination path"
        The commands below use `/opt/` as the download path. Replace it with the full local directory path where you want to save the files.

    1. Download the binary package along with its SHA256 checksum and signature files. You can install TheHive anywhere on your filesystem.
   
        * Using `wget`

            ```bash
            wget -O /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/zip/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip
            wget -O /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.sha256 https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/sha256/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.sha256
            wget -O /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.asc https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/asc/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            wget -O /opt/<file_name>.zip thehive.download.strangebee.com/<major.minor_version>/zip/<file_name>.zip
            wget -O /opt/<file_name>.zip.sha256 thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.zip.sha256
            wget -O /opt/<file_name>.zip.asc thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.zip.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `thehive-5.6.2-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `5.6`.

            !!! tip "Package repository"
                For details on package organization and naming conventions, see [TheHive Package Repository](/thehive/installation/thehive-packages/).

        * Using `curl`

            ```bash
            curl -o /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/zip/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip
            curl -o /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.sha256 https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/sha256/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.sha256
            curl -o /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.asc https://thehive.download.strangebee.com/{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}/asc/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.asc
            ```

            To download a specific version instead of the latest, use the following format:

            ```bash
            curl -o /opt/<file_name>.zip thehive.download.strangebee.com/<major.minor_version>/zip/<file_name>.zip
            curl -o /opt/<file_name>.zip.sha256 thehive.download.strangebee.com/<major.minor_version>/sha256/<file_name>.zip.sha256
            curl -o /opt/<file_name>.zip.asc thehive.download.strangebee.com/<major.minor_version>/asc/<file_name>.zip.asc
            ```

            * Replace `<file_name>` with the full name of the versioned file you want to install. For example, use `thehive-5.6.2-1`.
            * Replace `<major.minor_version>` with the corresponding version directory. For example, use `5.6`.

            !!! tip "Package repository"
                For details on package organization and naming conventions, see [TheHive Package Repository](/thehive/installation/thehive-packages/).

    2. Verify the integrity of the downloaded package.

        * Check the SHA256 checksum by comparing it with the provided value.

            a. Generate the SHA256 checksum of your downloaded package.

            ```bash
            sha256sum /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip
            ```

            b. Compare the output hash with the official SHA256 value listed in the .sha256 file.

            ```bash
            cat /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.sha256
            ```

            c. If both hashes match exactly, the file integrity is verified. If not, the file may be corrupted or tampered with—don't proceed with unzipping or installation, and contact the [StrangeBee Security team](mailto:security@strangebee.com).

          * Verify the GPG signature using the public key.
     
            a. Download the public key at [keys.download.strangebee.com](https://keys.download.strangebee.com){target=_blank} using `wget` or `curl`.

            ```bash
            wget -O /opt/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```
            
            ```bash
            curl -o /opt/strangebee.gpg https://keys.download.strangebee.com/latest/gpg/strangebee.gpg
            ```

            b. Import the key into your GPG keyring.

            ```bash
            gpg --import /opt/strangebee.gpg
            ```

            c. Verify the downloaded package signature.

            ```bash
            gpg --verify /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip.asc /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip
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

            If you don't see `Good signature`, if the fingerprint differs, or if the signature is reported as `BAD`, don't install the package. This indicates the integrity or authenticity of the file can't be confirmed. Report the issue to the [StrangeBee Security team](mailto:security@strangebee.com).


    3. Unzip the package.

        !!! info "Unzip paths"
            
            * Replace `/opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip` with the full path to the ZIP file you downloaded.
            * Replace `/opt/` after `-d` with the directory where you want to extract the contents of the archive.

        ```bash
        unzip /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1.zip -d /opt/
        sudo ln -s /opt/thehive-{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}-1 /opt/thehive
        ```

    4. Prepare the system by creating a dedicated, non-privileged user account to run TheHive. Ensure this user has permission to create log files in `/opt/thehive/logs`.

        ```bash
        sudo addgroup thehive
        sudo adduser --system thehive
        sudo chown -R thehive:thehive /opt/thehive
        sudo mkdir /etc/thehive
        sudo touch /etc/thehive/application.conf
        sudo chown root:thehive /etc/thehive
        sudo chgrp thehive /etc/thehive/application.conf
        sudo chmod 640 /etc/thehive/application.conf
        ```

    5. Copy the systemd script into `/etc/systemd/system/thehive.service`.

        ```bash
        cd /tmp
        wget https://raw.githubusercontent.com/TheHive-Project/TheHive/master/package/thehive.service
        sudo cp thehive.service /etc/systemd/system/thehive.service
        ```