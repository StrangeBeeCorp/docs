---
hide:
  - toc
---

# Download TheHive

TheHive is offered in multiple binary package formats for seamless installation on various operating systems. Below are the detailed instructions for obtaining TheHive across different platforms:

---

## :material-debian: Debian / :material-ubuntu: Ubuntu

For users using Debian or Ubuntu operating systems, TheHive can be easily installed by adding the repository to the system's package manager. To accomplish this, proceed by following these steps:

1. Open your terminal.

2. Create a new file named `strangebee.list` within the `/etc/apt/source.list.d/` directory. You can do this by using the following command:
    ```bash
    sudo nano /etc/apt/sources.list.d/strangebee.list
    ```

3. Copy and paste the following line into the file:
    ```text title="/etc/apt/source.list.d/strangebee.list"
    deb [arch=all signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com TheHive-5.2 main
    ```

4. Save the file and exit the text editor.

5. Run the following commands to update the package lists:
    ```bash
    sudo apt update
    ```

You are now ready to install TheHive on your Debian/Ubuntu system.

---

## :material-redhat: RedHat Enterprise Linux / :material-fedora: Fedora

Users on Red Hat Enterprise Linux (RHEL) or Fedora can use the RPM package manager to install TheHive seamlessly. To accomplish this, proceed by following these steps:

1. Open your terminal.

2. Create a new repository file named `strangebee.repo` within the `/etc/yum.repos.d/` directory. You can do this by executing the following command:
    ```bash
    sudo nano /etc/yum.repos.d/strangebee.repo
    ```

3. Insert the following content into the file:
    ```text
    [TheHive]
    enabled=1
    priority=1
    name=strangebee RPM repository
    baseurl=https://rpm.strangebee.com/TheHive-5.2/noarch
    gpgkey=https://archives.strangebee.com/keys/strangebee.gpg
    gpgcheck=1
    ```

4. Save the file and exit the text editor.

You are now ready to install TheHive on your RedHat/Fedora system.

---

## ZIP Archive

Alternatively, users can download TheHive as a ZIP archive for manual installation or deployment scenarios. Follow these steps:

1. Visit the following URL to download the latest ZIP archive: [**thehive-latest.zip**](https://archives.strangebee.com/zip/thehive-latest.zip)

2. Once the download is complete, extract the contents of the ZIP archive to your desired location.

3. Proceed with the installation or configuration process as per your requirements.

---

## Docker
Docker users can leverage pre-built Docker images available on Dockerhub for convenient deployment and containerization of TheHive. The Docker image can be found at [**TheHive Docker Hub**](https://hub.docker.com/r/strangebee/TheHive)

---

## Archives

For users who prefer direct downloads or require access to specific package versions, all binary packages and archives of TheHive are available on our archives websites for easy access:

### DEB Packages
Access DEB packages from the following URL: [**DEB Packages**](https://archives.strangebee.com/deb/). Please follow the instructions provided [**here**](../setup/installation/step-by-step-guide.md) to install the downloaded package.

### RPM Packages
Access RPM packages from the following URL: [**RPM Packages**](https://archives.strangebee.com/rpm/). Please follow the instructions provided [**here**](../setup/installation/step-by-step-guide.md) to install the downloaded package.

### ZIP Archives
Access ZIP archives from the following URL: [**ZIP Archives**](https://archives.strangebee.com/zip/). Please follow the instructions provided [**here**](../setup/installation/step-by-step-guide.md) to install the downloaded package.

&nbsp;