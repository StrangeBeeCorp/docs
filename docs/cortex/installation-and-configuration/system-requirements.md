# Cortex Installation System Requirements

Cortex requires a supported operating system, along with sufficient hardware resources, to ensure stable and efficient operation.

## Hardware requirements

Estimated resource recommendations are provided to offer guidance based on typical usage scenarios.

!!! note "Hardware sizing guidance"
    The listed hardware values represent typical usage scenarios. However, hardware sizing for Cortex installation depends on several factors:

    * Usage intensity: Number of analyzers and responders running concurrently
    * Data volume: Number of observables submitted for analysis
    * Performance expectations: Expected job throughput under typical and peak loads
    * Deployment method: Installation via packages, Docker containers, or Kubernetes

    Initial deployments can start with minimal configurations and be scaled based on observed performance.

=== "Package installation"

    The following resources are recommended when Cortex and Elasticsearch are hosted on a single machine:

    * 8 vCPU
    * 16 GB of RAM

=== "Docker Compose deployment"

    For Docker Compose deployments of Cortex with Elasticsearch, hardware requirements vary by setup profile. Each profile defines a specific performance level. The testing profile also deploys Cassandra and TheHive as part of a combined demo stack—see [Deploy a Demo Docker Environment](../../resources/docker-demo.md) for details.

    | Profile  | Usage               | Recommended memory               | Recommended CPU               |
    | ---------------- | --------------------- | --------------------- |  --------------------- |
    | [*Testing environment*](https://github.com/StrangeBeeCorp/docker/tree/main/testing){target=_blank}  | Functional testing of TheHive and Cortex | 8 GB RAM               | 4 vCPUs               |
    | [*Production environment #1*](https://github.com/StrangeBeeCorp/docker/tree/main/prod1-cortex){target=_blank}  | Standard production workload | 16 GB RAM               | 4 vCPUs               |
    | [*Production environment #2*](https://github.com/StrangeBeeCorp/docker/tree/main/prod2-cortex){target=_blank}  | High-performance production workload | 32 GB RAM               | 8 vCPUs               |

=== "Kubernetes deployment with Helm"

    For Kubernetes deployments, apply the same hardware recommendations as for the Docker Compose deployment in single-replica configurations. When deploying multiple replicas in a clustered setup, per-node hardware requirements can be reduced, as workload and resource utilization are distributed across replicas.

!!! warning "Heap size guidelines"
    Cortex and Elasticsearch each run on the JVM and require explicit heap size configuration in production environments. Especially when both services run on the same host, their combined heap allocation competes for available RAM. Undefined heap settings may cause memory contention or out-of-memory errors.

{% include-markdown "includes/disable-swap-elasticsearch.md" %}

## Recommended operating systems

Cortex is officially supported on the following Linux distributions:

* Ubuntu 20.04 LTS
* Debian 11 | 12 | 13
* RHEL 8
* Fedora 35

Other distributions or versions aren't tested or supported.

<h2>Next steps</h2>

* [Software Requirements](software-requirements.md)
* [Cortex Package Repository](cortex-packages.md)
* [Quick Install with Packages: One-Command Setup](automated-installation-script-linux.md)
* [Install Cortex with Packages](step-by-step-guide.md)
* [Run Cortex with Docker](run-cortex-with-docker.md)
* [Deploy Cortex on Kubernetes](deploy-cortex-on-kubernetes.md)
