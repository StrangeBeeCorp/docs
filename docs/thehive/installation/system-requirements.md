# TheHive Installation System Requirements

TheHive requires supported operating systems, along with sufficient hardware resources and data storage, to ensure stable and efficient operation.

## Hardware requirements

Estimated resource recommendations are provided to offer guidance based on typical usage scenarios.

!!! note "Hardware sizing guidance"
    The listed hardware values represent typical usage scenarios. However, hardware sizing for TheHive installation depends on several factors:

    * Usage intensity: Number of users accessing the system at the same time, including [service accounts](../user-guides/organization/configure-organization/manage-user-accounts/about-user-accounts.md#types) and external integrations
    * Data volume: Amount of data ingested, processed, and stored
    * Performance expectations: Expected system responsiveness under typical and peak loads
    * Deployment method: Installation via Linux packages or Docker containers

    Initial deployments can start with minimal configurations and be scaled based on observed performance. Hardware adjustments should be guided by ongoing [monitoring of system resource utilization](../operations/monitoring.md).

=== "Linux installation"

    The following table lists recommended CPU and memory allocations per service when TheHive, Apache Cassandra, and Elasticsearch are hosted on a single machine, based on the number of concurrent users.

    | Number of concurrent users  | TheHive               | Cassandra             | Elasticsearch         |
    | ---------------- | --------------------- | --------------------- | --------------------- |
    | :fontawesome-solid-user-group: < 10 | 3 CPU cores / 4 GB RAM | 3 CPU cores / 4 GB RAM | 3 CPU cores / 4 GB RAM |
    | :fontawesome-solid-user-group: < 20 | 3-4 CPU cores / 6 GB RAM | 3-4 CPU cores / 6 GB RAM | 3-4 CPU cores / 6 GB RAM |
    | :fontawesome-solid-user-group: < 50 | 4-6 CPU cores / 8 GB RAM | 4-6 CPU cores / 8 GB RAM | 4-6 CPU cores / 8 GB RAM |

=== "Docker Compose deployment"

    For Docker Compose deployments of TheHive with all [required services](../overview/index.md#architecture), hardware requirements vary by setup profile. Each profile defines a specific performance level.

    | Profile  | Usage               | Recommended memory               | Recommended CPU               |
    | ---------------- | --------------------- | --------------------- |  --------------------- |
    | [*Testing environment*](https://github.com/StrangeBeeCorp/docker/tree/main/testing){target=_blank}  | Functional testing of TheHive and Cortex | 8 GB RAM               | 4 vCPUs               |
    | [*Production environment #1*](https://github.com/StrangeBeeCorp/docker/tree/main/prod1-thehive){target=_blank}  | Standard production workload | 16 GB RAM               | 4 vCPUs               |
    | [*Production environment #2*](https://github.com/StrangeBeeCorp/docker/tree/main/prod2-thehive){target=_blank}  | High-performance production workload | 32 GB RAM               | 8 vCPUs               |

=== "Kubernetes deployment with Helm"

    For Kubernetes deployments, apply the same hardware recommendations as for the Docker Compose deployment in single-replica configurations. When deploying multiple replicas in a clustered setup, per-node hardware requirements can be reduced, as workload and resource utilization are distributed across replicas.

!!! warning "Elasticsearch heap size configuration"
    Elasticsearch requires explicit [heap size configuration in the `jvm.options` file](installation-guide-linux-standalone-server.md#configure-the-etcelasticsearchjvmoptionsdjvmoptions-file). Heap allocation [must not exceed 50% of the total system RAM](https://www.elastic.co/search-labs/blog/elasticsearch-heap-size-jvm-garbage-collection){target=_blank}.
    
    On a 12 GB RAM system, for example:

    ```
    -Xms6g
    -Xmx6g
    ```

    Undefined heap settings may cause memory contention or out-of-memory errors.

!!! info "Cluster deployments"
    In cluster deployments, each node must independently meet the recommended per-service CPU and memory requirements. The number of nodes, as well as CPU and RAM, may need to be adjusted based on the specific demands of the deployment.

### Data storage

The recommended storage requirements for TheHive vary based on the use case and data volume:

* 100 GB of storage is recommended for most use cases, primarily for storing application data such as alerts, cases, observables, and logs.
* 150 GB of storage is recommended for more intensive use cases with higher data volume or complex workflows.

## Recommended operating systems

TheHive is officially supported on the following Linux distributions:

* Ubuntu 20.04 LTS | 22.04 LTS | 24.04 LTS
* Debian 11
* RHEL 8.5 | 9.3
* Rocky Linux 9.4
* Fedora 35 | 37

Other distributions or versions aren't tested or supported.

<h2>Next steps</h2>

* [Software Requirements](software-requirements.md)
* [Quick Install on Linux Systems: One-Command Setup](automated-installation-script-linux.md)
* [Install TheHive on Linux Systems](installation-guide-linux-standalone-server.md)
* [Deploy TheHive with Docker Compose](docker.md)
* [Deploy TheHive on Kubernetes](kubernetes.md)
* [Setting up a Cluster with TheHive](deploying-a-cluster.md)