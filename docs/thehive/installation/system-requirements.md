# Installation System Requirements

To ensure reliable operation, TheHive must be installed on officially recommended hardware and operating systems.

## Hardware requirements

Hardware requirements vary based on:

* Usage intensity: number of users accessing the system at the same time, including [service accounts](../user-guides/organization/configure-organization/manage-user-accounts/about-user-accounts.md#types) and external integrations
* Data volume: total amount of data ingested, processed, and retained over time
* Performance expectations: responsiveness and system load during normal and peak usage
* Deployment method: whether TheHive is installed using Linux packages or containerized using Docker

=== "Linux packages installation"

    The table below outlines the recommended CPU and memory allocation per service when TheHive, Apache Cassandra, and Elasticsearch are hosted on the same machine, based on the number of concurrent users.

    | Number of users  | TheHive               | Cassandra             | Elasticsearch         |
    | ---------------- | --------------------- | --------------------- | --------------------- |
    | :fontawesome-solid-user-group: < 10 | 3 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 3 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 3 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: |
    | :fontawesome-solid-user-group: < 20 | 3-4 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 3-4 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 3-4 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: |
    | :fontawesome-solid-user-group: < 50 | 4-6 :fontawesome-solid-microchip: / 8 GB :fontawesome-solid-memory: | 4-6 :fontawesome-solid-microchip: / 8 GB :fontawesome-solid-memory: | 4-6 :fontawesome-solid-microchip: / 8 GB :fontawesome-solid-memory: |

=== "Docker deployments"

    For Docker deployments, hardware requirements depend on the selected profile. These profiles define the expected performance level.

    Hardware specifications for each profile are published in the [Docker Compose environments for TheHive and Cortex GitHub repository](https://github.com/StrangeBeeCorp/docker/tree/main?tab=readme-ov-file#available-deployment-profiles).

!!! note "Hardware sizing guidance"
    These values reflect average usage scenarios. Environments with high data retention or heavy usage may require scaling up hardware. Initial deployments can start small and be adjusted as needs grow.

!!! warning "Elasticsearch heap size configuration"
    Elasticsearch also requires configuration of heap size in the `jvm.options` file. The heap size shouldn't exceed 50% of the total available system RAM. If the system has 12 GB of RAM in total, the following settings are recommended:

    ```
    -Xms6g
    -Xmx6g
    ```

    If no memory limits are defined, it can lead to memory contention or out-of-memory errors.

!!! info "Cluster deployments"
    In clustered environments, ensure that each node meets the per-service CPU and memory requirements.

## Recommended operating systems

### Linux packages installation

TheHive is officially supported on the following Linux distributions:

* Ubuntu 20.04 LTS | 22.04 LTS | 24.04 LTS
* Debian 11
* RHEL 8.5 | 9.3
* Rocky Linux 9.4
* Fedora 35 | 37

Other distributions or versions aren't tested or supported.

### Docker deployments

For containerized setups, an [official Docker image](https://hub.docker.com/r/strangebee/TheHive/tags) is available.

<h2>Next steps</h2>

* [Step by Step Installation Guide](step-by-step-installation-guide.md)