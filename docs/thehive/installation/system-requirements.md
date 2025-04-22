# TheHive Installation System Requirements

This topic outlines the hardware and operating system requirements for installing TheHive.

## Hardware requirements

The hardware requirements for TheHive depend on factors such as the number of concurrent users (including integrations) and their usage patterns. Below are the recommended hardware thresholds for hosting all services on the same machine:

| Number of Users  | TheHive               | Cassandra             | Elasticsearch         |
| ---------------- | --------------------- | --------------------- | --------------------- |
| :fontawesome-solid-user-group: < 10 | 2 :fontawesome-solid-microchip: / 2 GB :fontawesome-solid-memory: | 2 :fontawesome-solid-microchip: / 2 GB :fontawesome-solid-memory: | 2 :fontawesome-solid-microchip: / 2 GB :fontawesome-solid-memory: |
| :fontawesome-solid-user-group: < 20 | 2-4 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 2-4 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: | 2-4 :fontawesome-solid-microchip: / 4 GB :fontawesome-solid-memory: |
| :fontawesome-solid-user-group: < 50 | 4-6 :fontawesome-solid-microchip: / 8 GB :fontawesome-solid-memory: | 4-6 :fontawesome-solid-microchip: / 8 GB :fontawesome-solid-memory: | 4-6 :fontawesome-solid-microchip: / 8 GB :fontawesome-solid-memory: |

!!! note "Recommendations"
    Deploying all services on the same server requires at least 4 cores and 16 GB of RAM. Additionally, configure `jvm.options` appropriately for Elasticsearch.

## Recommended operating systems

TheHive runs on and is officially supported on the following operating systems:

* Ubuntu 20.04 LTS | 22.04 LTS | 24.04 LTS
* Debian 11
* RHEL 8.5 | 9.3
* Rocky Linux 9.4
* Fedora 35 | 37

Additionally, an [**official Docker image**](https://hub.docker.com/r/strangebee/TheHive/tags) is available for users who prefer containerized deployments.

<h2>Next steps</h2>

* [Step by Step Installation Guide](step-by-step-installation-guide.md)