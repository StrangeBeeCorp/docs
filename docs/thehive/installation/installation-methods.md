# TheHive Installation Methods

TheHive can be installed on a single server or deployed in a clustered environment, depending on your infrastructure requirements. Choose the best approach for your use case.

## Single server installation

Install TheHive and all required components on a single server. This configuration is ideal for testing environments, small teams, or production deployments that don't require high availability. See [the architecture overview](../overview/index.md#architecture) for details.

### :material-debian: Debian / :material-ubuntu: Ubuntu

For Debian- or Ubuntu-based OS, follow the [installation guide](installation-guide-linux-standalone-server.md) using the **DEB** tab to install and configure TheHive.

### :material-redhat: RedHat Enterprise Linux / :material-fedora: Fedora

For RedHat- or Fedora-based OS, follow the [installation guide](installation-guide-linux-standalone-server.md) using the **RPM** tab to install and configure TheHive.

### :material-folder-zip: ZIP binary packages

For manual installation or environments without package managers, follow the [installation guide](installation-guide-linux-standalone-server.md) using the **ZIP binary packages** tab to install and configure TheHive.

### :material-docker: Docker

Deploy TheHive as a single container using [the official pre-built Docker images](https://hub.docker.com/r/strangebee/TheHive). See [Running TheHive with Docker](../installation/docker.md) for instructions.

## Cluster deployment

Deploy TheHive and all required components across multiple nodes to achieve scalability and high availability. See [the architecture overview](../overview/index.md#architecture) for details.

### :material-linux: Linux

Configure a multi-node cluster with TheHive and its components running on dedicated hosts. See [Setting Up a Cluster with TheHive](deploying-a-cluster.md) for instructions.

### :material-kubernetes: Kubernetes

Deploy TheHive on Kubernetes using the [official Helm chart](https://github.com/StrangeBeeCorp/helm-charts/tree/main/thehive-charts/thehive). See [Deploy TheHive on Kubernetes](../installation/kubernetes.md) for instructions.