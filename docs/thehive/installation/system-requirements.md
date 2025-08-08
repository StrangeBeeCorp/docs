# Installation System Requirements

TheHive requires supported operating systems and sufficient hardware resources to ensure stable and efficient operation.

## Hardware requirements

Hardware sizing depends on several factors:

* Usage intensity: Number of users accessing the system at the same time, including [service accounts](../user-guides/organization/configure-organization/manage-user-accounts/about-user-accounts.md#types) and external integrations
* Data volume: Amount of data ingested, processed, and stored
* Performance expectations: Expected system responsiveness under typical and peak loads
* Deployment method: Installation via Linux packages or Docker containers

=== "Linux packages installation"

    The following table lists recommended CPU and memory allocations per service when TheHive, Apache Cassandra, and Elasticsearch are hosted on a single machine.

    | Number of concurrent users  | TheHive               | Cassandra             | Elasticsearch         |
    | ---------------- | --------------------- | --------------------- | --------------------- |
    | :fontawesome-solid-user-group: < 10 | 3 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 3 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 3 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: |
    | :fontawesome-solid-user-group: < 20 | 3-4 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 3-4 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 3-4 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: |
    | :fontawesome-solid-user-group: < 50 | 4-6 :fontawesome-solid-microchip: / 8 GB :fontawesome-solid-memory: | 4-6 :fontawesome-solid-microchip: / 8 GB :fontawesome-solid-memory: | 4-6 :fontawesome-solid-microchip: / 8 GB :fontawesome-solid-memory: |

=== "Docker deployments"

    For Docker deployments, hardware requirements depend on the selected profile. Each profile defines a specific performance level.

    Available profiles and corresponding hardware specifications are documented in the [Docker Compose environments for TheHive and Cortex GitHub repository](https://github.com/StrangeBeeCorp/docker/tree/main?tab=readme-ov-file#available-deployment-profiles).

!!! note "Hardware sizing guidance"
    The listed hardware values represent typical usage scenarios. Environments with high data retention or intensive workloads may require additional resources. Initial deployments can start with minimal configurations and be scaled based on observed performance. Hardware adjustments should be guided by ongoing monitoring of system resource utilization.

!!! warning "Elasticsearch heap size configuration"
    Elasticsearch requires explicit heap size configuration in the `jvm.options` file. Heap allocation must not exceed 50% of the total system RAM. On a 12 GB RAM system, for example:

    ```
    -Xms6g
    -Xmx6g
    ```

    Undefined heap settings may cause memory contention or out-of-memory errors.

!!! info "Cluster deployments"
    In cluster deployments, each node must independently meet the recommended per-service CPU and memory requirements.

## Recommended operating systems

=== "Linux packages installation"

    TheHive is officially supported on the following Linux distributions:

    * Ubuntu 20.04 LTS | 22.04 LTS | 24.04 LTS
    * Debian 11
    * RHEL 8.5 | 9.3
    * Rocky Linux 9.4
    * Fedora 35 | 37

    Other distributions or versions aren't tested or supported.

=== "Docker deployments"

    For containerized setups, an [official Docker image](https://hub.docker.com/r/strangebee/TheHive/tags) is available.

<h2>Next steps</h2>

* [Step by Step Installation Guide](step-by-step-installation-guide.md)
* [Running TheHive with Docker](docker.md)
* [Deploy TheHive on Kubernetes](kubernetes.md)
* [Setting up a Cluster with TheHive](deploying-a-cluster.md)