# Cortex Installation Software Requirements

Cortex installation requires specific software components at specific versions, depending on the installation method. Elasticsearch is the only backend service Cortex relies on to store its data.

=== "Package installation"

    * Java 11+
    * Elasticsearch:

        {% include-markdown "includes/elasticsearch-supported-versions-cortex.md" %}

    Sharing a single Elasticsearch instance between TheHive and Cortex isn't recommended. If you must do it, ensure the Elasticsearch version is compatible with [both applications](../../thehive/installation/software-requirements.md).

=== "Docker Compose deployment"

    | Docker Engine | Docker Compose plugin |
    |----------------|------------------------|
    | v23.0.15+ | v2.20.2+ |

=== "Kubernetes deployment with Helm"

    | Kubernetes cluster | Helm |
    |---------------------|------|
    | v1.23.0+ | v3.8.0+ |

<h2>Next steps</h2>

* [System Requirements](system-requirements.md)
* [Cortex Package Repository](cortex-packages.md)
* [Quick Install with Packages: One-Command Setup](automated-installation-script-linux.md)
* [Install Cortex with Packages](step-by-step-guide.md)
* [Run Cortex with Docker](run-cortex-with-docker.md)
* [Deploy Cortex on Kubernetes](deploy-cortex-on-kubernetes.md)
