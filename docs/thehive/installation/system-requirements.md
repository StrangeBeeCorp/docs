# TheHive Installation System Requirements

TheHive requires supported operating systems, along with sufficient hardware resources and data storage, to ensure stable and efficient operation.

## Hardware requirements

Estimated resource recommendations are provided to offer guidance based on typical usage scenarios:

!!! note "Hardware sizing guidance"
    The listed hardware values represent typical usage scenarios. However, hardware sizing for TheHive installation depends on several factors:

    * Usage intensity: Number of users accessing the system at the same time, including [service accounts](../user-guides/organization/configure-organization/manage-user-accounts/about-user-accounts.md#types) and external integrations
    * Data volume: Amount of data ingested, processed, and stored
    * Performance expectations: Expected system responsiveness under typical and peak loads
    * Deployment method: Installation via Linux packages or Docker containers

    Initial deployments can start with minimal configurations and be scaled based on observed performance. Hardware adjustments should be guided by ongoing monitoring of system resource utilization.

=== "Packages installation"

    The following table lists recommended CPU and memory allocations per service when TheHive, Apache Cassandra, and Elasticsearch are hosted on a single machine, based on the number of concurrent users.

    | Number of concurrent users  | TheHive               | Cassandra             | Elasticsearch         |
    | ---------------- | --------------------- | --------------------- | --------------------- |
    | :fontawesome-solid-user-group: < 10 | 3 CPUs / 4 GB RAM | 3 CPUs / 4 GB RAM | 3 CPUs / 4 GB RAM |
    | :fontawesome-solid-user-group: < 20 | 3-4 CPUs / 6 GB RAM | 3-4 CPUs / 6 GB RAM | 3-4 CPUs / 6 GB RAM |
    | :fontawesome-solid-user-group: < 50 | 4-6 CPUs / 8 GB RAM | 4-6 CPUs / 8 GB RAM | 4-6 CPUs / 8 GB RAM |

=== "Docker deployments"

    For Docker deployments, hardware requirements depend on the selected setup profile, with each profile defining a specific performance level.

    Available profiles and corresponding hardware specifications are documented in the [Docker Compose environments for TheHive and Cortex GitHub repository](https://github.com/StrangeBeeCorp/docker/tree/main?tab=readme-ov-file#available-deployment-profiles).

!!! warning "Elasticsearch heap size configuration"
    Elasticsearch requires explicit heap size configuration in the `jvm.options` file. Heap allocation must not exceed 50% of the total system RAM. On a 12 GB RAM system, for example:

    ```
    -Xms6g
    -Xmx6g
    ```

    Undefined heap settings may cause memory contention or out-of-memory errors.

!!! info "Cluster deployments"
    In cluster deployments, each node must independently meet the recommended per-service CPU and memory requirements. The number of nodes, as well as CPU and RAM, may need to be adjusted based on the specific demands of the deployment.

### Data storage

The recommended storage requirements for TheHive vary based on the use case and data volume:

* 100GB of storage is recommended for most use cases, primarily for storing application data such as alerts, cases, observables, and logs.
* 150GB of storage is recommended for more intensive use cases with higher data volume or complex workflows.

## Recommended operating systems

=== "Packages installation"

    TheHive is officially supported on the following Linux distributions:

    * Ubuntu 20.04 LTS | 22.04 LTS | 24.04 LTS
    * Debian 11
    * RHEL 8.5 | 9.3
    * Rocky Linux 9.4
    * Fedora 35 | 37

    Other distributions or versions aren't tested or supported.

=== "Docker deployments"

    For containerized setups, an [official TheHive Docker image](https://hub.docker.com/r/strangebee/TheHive/tags) is available.

<h2>Next steps</h2>

* [Step by Step Installation Guide](step-by-step-installation-guide.md)
* [Running TheHive with Docker](docker.md)
* [Deploy TheHive on Kubernetes](kubernetes.md)
* [Setting up a Cluster with TheHive](deploying-a-cluster.md)