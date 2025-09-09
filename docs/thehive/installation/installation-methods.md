# TheHive Installation Methods

TheHive is distributed in various formats to suit different environments and deployment preferences. Whether you want to install it on traditional Linux systems, run it as a container with Docker, or deploy it in a Kubernetes cluster, you’ll find the appropriate options and instructional links in this page.

## :material-debian: Debian / :material-ubuntu: Ubuntu

If you're using a Debian- or Ubuntu-based OS, follow the steps in the [installation guide](installation-guide-linux-standalone-server.md) using the **DEB** tab to install and configure TheHive.

## :material-redhat: RedHat Enterprise Linux / :material-fedora: Fedora

If you're using a RedHat or Fedora-based OS, follow the steps in the [installation guide](installation-guide-linux-standalone-server.md) using the **RPM** tab to install and configure TheHive.

## :material-folder-zip: ZIP binary packages

If you prefer more control over where TheHive is installed, need to use it in environments without package managers, or want to avoid dependency issues, you can install TheHive by downloading a ZIP binary package.

Follow the steps in the [installation guide](installation-guide-linux-standalone-server.md) using the **ZIP binary packages** tab to install and configure TheHive.

## :material-docker: Docker

Prefer containerized deployment? Use [the official pre-built Docker images on TheHive Docker Hub](https://hub.docker.com/r/strangebee/TheHive).

Follow the [Docker deployment instructions](../installation/docker.md) to get started.

## :material-kubernetes: Kubernetes

For Kubernetes users, deploy TheHive using the [official Helm chart](https://github.com/StrangeBeeCorp/helm-charts/tree/main/thehive-charts/thehive). 

Refer to the [Kubernetes deployment guide](../installation/kubernetes.md) for detailed instructions.