# Installation & configuration guides

## Overview
TheHive can be deployed on a standalone server or as a cluster. The application relies on:

:fontawesome-solid-database: [Apache Cassandra](https://cassandra.apache.org/_/index.html) to store data (Supported version: 4.x).

:fontawesome-solid-list:  [Elasticsearch](https://www.elastic.co) as indexing engine (Supported version: 7.x).

:fontawesome-solid-folder-tree:  A file storage solution is also required ; the local filesystem of the server hosting the application is adequate in the standalone server scenario ; [S3 MINIO](https://min.io/) otherwise.

!!! Warning "Using Lucene"
    Starting with TheHive 5.x we strongly recommend using Elasticsearch for production servers. 
    TheHive 4.1.x embbeded **Lucene** to handle the data index ; this is still the case with the latest version with which we suggest to use it only for testing purpose.

## Resources
Hardware requirements depends on the number of concurrent users (including integrations) and how they use the system. The following table diplays safe thresholds:

| Number of users                                | CPU :fontawesome-solid-microchip: | RAM :fontawesome-solid-memory: |
| -----------------------------------------------|: --------------------------------- :|: -------------------------- :|
| :fontawesome-solid-user-group: < 20            | 4                                 | 16 GB                      |
| :fontawesome-solid-user-group: < 50            | 8                                 | 32 GB                      |


## Operating systems
TheHive has been tested and is supported on following operating systems: 

- :material-ubuntu: Ubuntu 20.04 LTS
- :material-debian: Debian 11 
- :material-redhat: RHEL 8
- :material-fedora: Fedora 35

StrangeBee also provides an [official Docker image](https://hub.docker.com/r/thehiveproject/thehive). 

## Installation guides

!!! Tip "Too much in a hurry to read ? "

    If you are using [one of the supported](#operating-systems) operating system, use our all-in-one **installation script**: 


    - Using Ubuntu or Debian

    ``` bash
    sudo -v && wget -O- https://docs.thehive-project.org/install-DEB.sh | bash
    ```

    - Using RHEL or Fedora

    ``` bash
    sudo -v && wget -O- https://docs.thehive-project.org/install-RPM.sh | bash
    ```

For each release, DEB, RPM and ZIP binary packages are built and provided.
Discover how to install TheHive quicky by following our installation guides:

### Use a dedicated server
TheHive can be used on virtual or physical servers.

Our [step-by-step guide](Installation/step-by-step-guide.md) let you **prepare**, **install** and **configure** TheHive and its prerequisites for Debian and RPM packages based Operating Systems, as well as for other systems and using our binary packages.

### Using Docker :material-docker:
An Official Docker image publicly available. Follow our [installation guide for Docker](Installation/docker.md) tu use it in production.

### Using Kubernetes :material-kubernetes:

XXX



## Configuration Guides
The configuration is stored in files stored in the `/etc/thehive` folder:

  - `application.conf` contains all parameters and options
  - `logback.xml` is dedicated to log management

```
/etc/thehive
├── application.conf
├── logback.xml
└── secret.conf
```

A separate [secret.conf](Configuration/secret.md) file is automatically created by DEB or RPM packages. This file should contain a secret that should be used by one instance.

The configuration should only contain the necessary information to start the application: 

- [database and indexing](./Configuration/database.md)
- [File storage](./Configuration/file-storage.md)
- [Connectors enabled](../Configuration/connectors-cortex.md)
- [Other service parameters](./Configuration/service.md)
  
All other settings are available in the UI of the application. 


## Secific uses cases

### Install a cluster with 3 nodes
If you require the installation of a cluster (fault tolerant, H.A., ...), the following [guide](./Architecture/3_nodes_cluster.md) details all the installation and configuration steps to get a cluster with 3 nodes working. In this example, the cluster is composed of:

  - 3 TheHive nodes
  - 3 Cassandra nodes
  - 3 Elasticsearch nodes
  - 3 Min.IO nodes

### Update from TheHive 4.1.x

XXX

### Update from TheHive 3.x
TheHive 3.x is not supported any more since 31st of December, 2021. 

Contact [StrangeBee](https://www.strangebee.com) for further assistance at [contact@strangebee.com](contact@strangebee.com). 