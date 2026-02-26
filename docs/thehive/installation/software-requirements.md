# TheHive Installation Software Requirements

TheHive installation requires specific software components at specific versions, depending on the installation method.

The tables below list the supported versions for Linux installations, Docker Compose deployments, and Kubernetes environments.

=== "Linux installation"

    | TheHive version | Java | Cassandra | Elasticsearch | OpenSearch | Cortex | Notes |
    |-----------------|------|-----------|---------------|------------|-------|-------|
    | 5.5.10 - 5.6.1 | 11 | 4.0.x - 4.1.x | 7.11.x - 9.1.x | Supported, except for audit log storage | 3.1.6 - 4.x | ES 8.x required for Cortex 4.x · ES 7.17+ required for [audit log storage](installation-guide-linux-standalone-server.md#step-53-audit-log-storage) |
    | 5.5.0 - 5.5.9 | 11 | 4.0.x - 4.1.x  | 7.11.x - 8.x | Supported, except for audit log storage | 3.1.6 - 4.x | ES 8.x required for Cortex 4.x · ES 7.17+ required for [audit log storage](installation-guide-linux-standalone-server.md#step-53-audit-log-storage) |
    | 5.3.0 - 5.4.11 | 11 | 4.0.x - 4.1.x  | 7.10.x - 8.x | Supported | All versions | ES 8.x required for Cortex 4.x |
    | 5.0.0 - 5.2.16 | 11 | 4.0.x - 4.1.x | 7.2.x - 7.17.x | Not supported | 3.2.1 and earlier | --- |
    
    Sharing a single Elasticsearch instance between TheHive and Cortex isn't recommended. If you must do it, ensure the Elasticsearch version is compatible with [both applications](../../cortex/installation-and-configuration/index.md#software-requirements).

=== "Docker Compose deployment"

    | TheHive version | Docker Engine | Docker Compose plugin |
    |-----------------|---------------|----------------|
    | 5.0.0 - 5.6.1 | v23.0.15+ | v2.20.2+ |

=== "Kubernetes deployment with Helm"

    | TheHive version | Kubernetes cluster | Helm |
    |-----------------|---------------|----------------|
    | 5.0.0 - 5.6.1 | v1.23.0+ | v3.8.0+ |

<h2>Next steps</h2>

* [System Requirements](system-requirements.md)
* [TheHive Package Repository](thehive-packages.md)
* [Quick Install on Linux Systems: One-Command Setup](automated-installation-script-linux.md)
* [Install TheHive on Linux Systems](installation-guide-linux-standalone-server.md)
* [Deploy TheHive with Docker Compose](docker.md)
* [Deploy TheHive on Kubernetes](kubernetes.md)
* [Set Up a Cluster on Linux Systems](deploying-a-cluster.md)