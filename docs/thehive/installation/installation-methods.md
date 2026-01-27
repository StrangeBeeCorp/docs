# TheHive Installation Methods

TheHive can be installed in several ways depending on your operating system, deployment preferences, and infrastructure requirements. Choose the method that best fits your environment.

## :material-debian: Debian / :material-ubuntu: Ubuntu

Install TheHive on a standalone server using DEB packages on Debian- or Ubuntu-based systems.

See [Install TheHive on Linux Systems](installation-guide-linux-standalone-server.md) using the **DEB** tab for instructions.

## :material-redhat: RedHat Enterprise Linux / :material-fedora: Fedora

Install TheHive on a standalone server using RPM packages on RedHat- or Fedora-based systems.

See [Install TheHive on Linux Systems](installation-guide-linux-standalone-server.md) using the **RPM** tab for instructions.

## :material-folder-zip: ZIP binary packages

Install TheHive on a standalone server using the ZIP binary package for manual installations or for environments without package managers.

See [Install TheHive on Linux Systems](installation-guide-linux-standalone-server.md) using the **ZIP binary packages** tab for instructions.

## :material-docker: Docker

TheHive image is available on [Docker Hub](https://hub.docker.com/r/strangebee/TheHive){target=_blank}.

Deploy TheHive and its [required services](../overview/index.md#architecture) as a single-server instance using Docker Compose.

See [Deploy TheHive with Docker Compose](../installation/docker.md) for instructions.

## :material-kubernetes: Kubernetes

Deploy TheHive as a single-node or multi-node installation on Kubernetes using the [official Helm chart](https://github.com/StrangeBeeCorp/helm-charts/tree/main/thehive-charts/thehive){target=_blank}.

See [Deploy TheHive on Kubernetes](../installation/kubernetes.md) for instructions.

## :material-linux: Cluster deployment on Linux

Deploy TheHive on Linux as a multi-node cluster across dedicated hosts for high-availability setups.

See [Set Up a Cluster on Linux Systems](deploying-a-cluster.md) for instructions.