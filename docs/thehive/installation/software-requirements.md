# TheHive Installation Software Requirements

TheHive requires specific software versions depending on the installation method.

The tables below list the supported versions for Linux installations, Docker Compose deployments, and Kubernetes environments.

=== "Linux installation"

    | TheHive version | Java | Cassandra | Elasticsearch | OpenSearch | Cortex support | Notes |
    |-----------------|------|-----------|---------------|------------|-------| -------|
    | 5.5.10+ | 11 | 3.11.x, 4.0.x, 4.1.x | 7.x - 9.1.x | Supported <br>—except for audit logs | 3.1.6+ | • ES 7.17+ required for [audit log storage](installation-guide-linux-standalone-server.md#step-53-audit-log-storage)<br>• ES 7.x required if shared with Cortex |
    | 5.5.0 - 5.5.9 | 11 | 3.11.x, 4.0.x, 4.1.x  | 7.x - 8.x | Supported <br>—except for audit logs | 3.1.6+ | • ES 7.17+ required for [audit log storage](installation-guide-linux-standalone-server.md#step-53-audit-log-storage)<br>• ES 7.x required if shared with Cortex|
    | 5.3.0 - 5.4.10 | 11 | 3.11.x, 4.0.x, 4.1.x  | 7.x - 8.x | Supported | All versions | ES 7.x required if shared with Cortex |
    | 5.0.0 - 5.2.16 | 11 | 3.11.x, 4.0.x, 4.1.x | 7.x | Not supported | All versions | --- |

=== "Docker Compose deployment"

    | TheHive version | Docker Engine | Docker Compose plugin |
    |-----------------|---------------|----------------|
    | 5.0.0 - 5.5.10+ | v23.0.15+ | v2.20.2+ |

=== "Kubernetes deployment with Helm"

    | TheHive version | Kubernetes cluster | Helm |
    |-----------------|---------------|----------------|
    | 5.0.0 - 5.5.10+ | v1.23.0+ | v3.8.0+ |

<h2>Next steps</h2>

* [System Requirements](system-requirements.md)
* [Quick Install on Linux Systems: One-Command Setup](automated-installation-script-linux.md)
* [Install TheHive on Linux Systems](installation-guide-linux-standalone-server.md)
* [Running TheHive with Docker](docker.md)
* [Deploy TheHive on Kubernetes](kubernetes.md)
* [Setting up a Cluster with TheHive](deploying-a-cluster.md)