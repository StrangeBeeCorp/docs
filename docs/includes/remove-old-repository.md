Then, remove or deactivate the old repository to avoid stale configurations.

!!! danger "Why you should remove or deactivate the old repository"
    Keeping the old repository configuration can cause your system to download outdated or conflicting packages during updates, potentially breaking your installation or causing unexpected behavior.

=== "DEB"

    Run the following commands:

    ```bash
    sudo rm /etc/apt/sources.list.d/strangebee.list
    sudo apt-get update
    ```

=== "RPM"

    a. Deactivate the repository.

        ```bash
        sudo yum-config-manager --disable strangebee
        ```

    b. Optional: Remove the repository file.

        ```bash
        sudo rm /etc/yum.repos.d/strangebee.repo
        sudo yum clean all
        ```