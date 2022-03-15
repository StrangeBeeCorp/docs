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
Hardware requirements depends on the number of concurrent users (including integrations) and how they use the system. The following table diplays safe thresholds when hosting all services on the same machine:

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

StrangeBee also provides an [official Docker image](https://hub.docker.com/repository/docker/strangebee/thehive/general). 

## Installation guides

!!! Tip "Too much in a hurry to read ? "

    If you are using [one of the supported](#operating-systems) operating system, use our all-in-one **installation script**: 


    - Using Ubuntu or Debian

    ``` bash
    sudo -v ; wget -q -O /tmp/install-thehive.sh https://archives.strangebee.com/scripts/install-deb.sh ; bash /tmp/install-thehive.sh
    ```

    - Using RHEL or Fedora

    ``` bash
    sudo -v ; wget -q -O /tmp/install-thehive.sh https://archives.strangebee.com/scripts/install-rpm.sh ; bash /tmp/install-thehive.sh
    ```

For each release, DEB, RPM and ZIP binary packages are built and provided.
Discover how to install TheHive quickly by following our installation guides:

### Use a dedicated server
TheHive can be used on virtual or physical servers.

Our [step-by-step guide](installation/step-by-step-guide.md) let you **prepare**, **install** and **configure** TheHive and its prerequisites for Debian and RPM packages based Operating Systems, as well as for other systems and using our binary packages.

### Use Docker :material-docker:
An Official Docker image publicly available. Follow our [installation guide for Docker](installation/docker.md) to use it in production.

### Use Kubernetes :material-kubernetes:

XXX



## Configuration Guides
The configuration files are stored in the `/etc/thehive` folder:

  - `application.conf` contains all parameters and options
  - `logback.xml` is dedicated to log management

```
/etc/thehive
├── application.conf
├── logback.xml
└── secret.conf
```

A separate [secret.conf](configuration/secret.md) file is automatically created by DEB or RPM packages. This file contains a secret that should be used by one instance.

The configuration should only contain the necessary information to start the application: 

- [database and indexing](./configuration/database.md)
- [File storage](./configuration/file-storage.md)
- Connectors enabled
- [Other service parameters](./configuration/service.md)
  
All other settings are available in the application WebUI. 

## Advanced uses cases

### Upgrade from TheHive 4.x (standalone server)

!!! Info "F.A.Q"
    ### Can I upgrade from TheHive 4.0.x ?
    _Yes, all TheHive 4.x can be updated to TheHive 5; the documentation is coming soon!_

    ### I use TheHive 3.x, can I upgrade my data to TheHive 5 ? 
    _TheHive 3 is out of support since 31st december, 2021. Please contact [StrangeBee](mailto:contact@strangebee.com) for further assistance._
    __



### TheHive as a cluster

####  Install a cluster with 3 nodes
If you are looking to install a cluster (fault tolerant, H.A., ...), the following [guide](installation/3-node-cluster.md) details all the installation and configuration steps to make a cluster with 3 nodes working. In this example, the cluster is composed of:

  - 3 TheHive nodes
  - 3 Cassandra nodes
  - 3 Elasticsearch nodes
  - 3 Min.IO nodes

#### Upgrade a cluster 

[Upgrade a cluster](./installation/upgrade-cluster.md)

### Update from TheHive 3.x
TheHive 3.x is not supported any more since 31st of December, 2021. 

Contact [StrangeBee](https://www.strangebee.com) for further assistance at [contact@strangebee.com](mailto:contact@strangebee.com). 