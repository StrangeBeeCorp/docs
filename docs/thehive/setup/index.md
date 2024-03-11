---
hide:
  - toc
---

# TheHive Documentation

## Overview

![Application Stack](images/thehive.svg){ width="300" align=right }

TheHive offers a comprehensive 4-in-1 Security Incident Response Platform, serving as a vital tool for Security Operations Centers (SOCs), Computer Security Incident Response Teams (CSIRTs), Computer Emergency Response Teams (CERTs), and all information security professionals involved in swift and effective handling of security incidents. It composes of a robust suite of features designed to streamline incident response workflows, enhance collaboration, and empower information security practitioners to effectively investigate and mitigate security threats. With its seamless integration with MISP and advanced capabilities for task management, evidence handling, and threat intelligence integration, TheHive is an indispensable tool for modern SOC, CSIRT, and CERT teams.

## Key Features

**Integration with MISP:** 
- Tightly integrated with MISP (Malware Information Sharing Platform) for seamless collaboration and information sharing.

**Real-Time Collaboration:** 
- Multiple analysts can collaborate simultaneously with live stream updates on cases, tasks, observables, and Indicators of Compromise (IOCs).

**Efficient Task Management:** 
- Special notifications enable efficient task handling and assignment, with previews and imports from various sources such as email reports, CTI providers, and SIEMs.

**Customizable Templates:** 
- Create cases and tasks using a flexible template engine, allowing customization with metrics and custom fields to drive team activity and identify areas for automation.

**Evidence Management:** 
- Analysts can record progress, attach evidence or files, add tags, and import password-protected ZIP archives containing suspicious data securely.

**Observables Management:** 
- Easily add and manage observables, either individually or in bulk, with options to import directly from MISP events or alerts. Triaging and filtering capabilities streamline the process.

**Threat Intelligence Integration:** 
- Utilize Cortex and its analyzers and responders to gain insights, accelerate investigations, and contain threats. Leverage tags, flag IOCs, and identify previously seen observables to enrich threat intelligence.


## Architecture

TheHive can be set up on either a single server or as a cluster (a group of servers) to accommodate different levels of growth requirements.  TheHive's architecture is highly modular, allowing each layer (TheHive application, database & indexing engine, and file storage) to be deployed independently as standalone nodes or as part of a clustered setup. This flexibility enables complex clustered architectures with virtual IP addresses and load balancers for optimal performance and scalability. 

The essential components of TheHive's setup include:

- :fontawesome-solid-database: [Apache Cassandra](https://cassandra.apache.org/_/index.html) for robust data storage, with support for version 4.x.
- :fontawesome-solid-list: [Elasticsearch](https://www.elastic.co), serving as a powerful indexing engine, with support for version 7.x.
- :fontawesome-solid-folder-tree: A file storage solution, which can be the local filesystem of the server hosting the application for standalone setups or [S3 MINIO](https://min.io/) for clustered environments.

![Application Stack](images/thehive-application-stack.png)

!!! Danger "Using Lucene"
    Starting from version 5.1, TheHive no longer supports the Lucene backend for indexing. Users who were previously utilizing Lucene with TheHive 4.1.x are advised to migrate their index to Elasticsearch using [this comprehensive guide](./operations/change-index.md).



=== "Standalone Server" 
    ![Standalone Server](images/TheHive-standalone.png){ align=left width=150 }

    A standalone server setup involves installing all necessary components on a single server:

    - Cassandra
    - Elasticsearch
    - File storage on the local filesystem (or MinIO if desired)
    - TheHive
    - Optional NGINX for managing HTTPS communications

    For detailed installation instructions, refer to the [step-by-step installation guide](installation/step-by-step-guide.md).

=== "Cluster or Hybrid Architecture"
    TheHive and its associated applications offer flexibility in choosing the right setup based on specific requirements. This includes the ability to mix and match different nodes and applications within a cluster.

    ![](images/TheHive-architecture-full-cluster.png){ align=center }

    Each layer and node within the architecture can be installed on dedicated operating systems, allowing for tailored configurations. The [installation guide for a 3-node cluster](installation/3-node-cluster.md) provides comprehensive instructions for setting up a more complex clustered environment.

<!-- - [Requirements](./requirements.md)
- [Operating Systems](./operating_systems.md)
- [Installation Guides](./installation_guides.md)
- Configuration Guides
- Advanced Use Cases
  - Upgrade from TheHive 4.x (Standalone Server)
  - TheHive as a Cluster
    - Install a Cluster with 3 Nodes
    - Upgrade a Cluster
  - Update from TheHive 3.x -->