# How to Deploy TheHive on Kubernetes

This topic provides step-by-step instructions for deploying TheHive on a Kubernetes cluster using [the TheHive Helm chart](https://github.com/StrangeBeeCorp/helm-charts/tree/main/thehive-charts/thehive).

!!! warning "License"
    The Community license supports only a single node. To deploy multiple TheHive nodes, you must upgrade to a Gold or Platinum license.

## Step 1: Deploy TheHive using Helm

TheHive provides an [official Helm chart for Kubernetes deployments](https://github.com/StrangeBeeCorp/helm-charts/tree/main/thehive-charts/thehive).

!!! warning "Prerequisites"
    Make sure you have:
    - A running Kubernetes cluster (version 1.23.0 or later)  
    - [Helm](https://helm.sh/) installed (version 3.8.0 or later)

1. Add the TheHive Helm repository

  ```bash
  helm repo add strangebee https://strangebeecorp.github.io/helm-charts
  ```

2. Update your local Helm repositories

  ```bash
  helm repo update
  ```

3. Install TheHive

  Create a release using the TheHive Helm chart.

  ```bash
  helm install <release_name> strangebee/thehive
  ```

  For more options, see [the Helm documentation for installation](https://helm.sh/docs/helm/helm_install/).

!!! info "Dependencies"
    The TheHive Helm chart relies on the following charts by default:
    - [Bitnami Apache Cassandra](https://github.com/bitnami/charts/tree/main/bitnami/cassandra) - used as the database
    - [Bitnami Elasticsearch Stack](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch) - used as the search index
    - [MinIO Community Helm Chart](https://github.com/minio/minio/tree/master/helm/minio) - used as S3-compatible object storage

!!! note "Upgrades"
    To upgrade your release to the latest version of TheHive Helm chart, run:
    ```bash
    helm upgrade <release_name> strangebee/thehive
    ```
    For additional options and best practices, see [the Helm upgrade documentation](https://helm.sh/docs/helm/helm_upgrade/).

## Step 2: Customize the Helm chart

For convenience, the TheHive Helm chart includes all required components out of the box. While this setup is suitable for a development environment, it's highly recommended to review and configure each dependency carefully before deploying to production.

Use the following command to view all available configuration options for the TheHive Helm chart:

```bash
helm show values strangebee/thehive
```

For more information on customization, see [the dedicated Helm documentation](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). You can also review the available options for each dependency.

### Pods resources

Resources allocated to pods are optimized for production use. If you need to adjust these values, especially memory limits, make sure you update the `JVM_OPTS` environment variable accordingly to avoid OOM (out of memory) crashes.

```bash
# JVM_OPTS variable for TheHive
thehive:
  jvmOpts: "-Xms2g -Xmx2g -Xmn300m"

# JVM_OPTS variable for Cassandra dependency chart
cassandra:
  jvm:
    extraOpts: "-Xms2g -Xmx2g -Xmn200m"
    maxHeapSize: "2g"
    newHeapSize: "200m"

# JVM_OPTS variable for Elasticsearch dependency chart
elasticsearch:
  master:
    heapSize: "2g"
    extraEnvVars:
      - name: JVM_OPTS
        value: "-Xms2g -Xmx2g -Xmn200m"
```

Refer to the official [Cassandra](https://cassandra.apache.org/doc/latest/cassandra/getting-started/production.html) and [Elasticsearch](https://www.elastic.co/docs/deploy-manage/production-guidance/elasticsearch-in-production-environments) documentation to learn how to optimize these values.

### StorageClasses

By default, this chart uses your cluster's default `StorageClass` to create persistent volumes (PVs).

If you want to modify it, ensure that the StorageClass you use:

* Is regularly backed up to prevent data loss—tools like [Velero](https://velero.io/) can help automate this process
* Has an appropriate `reclaimPolicy` to minimize the risk of data loss

To configure `StorageClasses` according to your needs, refer to the relevant CSI drivers for your infrastructur—for example, the EBS CSI driver for AWS or the Persistent Disk CSI driver for GCP.

### Cassandra

This chart deploys two Cassandra pods to store TheHive's data.

You can review the [Bitnami Cassandra Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/cassandra) for available configuration options.

### Elasticsearch

By default, this chart deploys an Elasticsearch cluster with two nodes, both master-eligible and general-purpose.

You can review the [Bitnami Elasticsearch Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch) for available configuration options.

### Object storage

To support multiple replicas of TheHive, this chart defines an object storage in the configuration and deploys a single instance of MinIO.

For production environments, use a managed object storage service to ensure optimal performance and resilience, such as:

* AWS S3
* Google Cloud Storage

Network shared filesystems, like NFS, are supported but can be more complex to implement and may offer lower performance.

### Cortex

No Cortex server is defined by default in TheHive configuration.

There are two main ways to add Cortex servers to TheHive:

* Add them directly through TheHive interface.
* Define them in the Helm chart’s `values.yaml` file.

For the second method, here's an example configuration:

```bash
cortex:
  enabled: true
  protocol: "http"
  hostnames:
    - "cortex.default.svc" # Assuming Cortex is deployed in the "default" namespace
  port: 9001
  api_keys:
    - "<cortex_api_key>" # Or even better, use an existing secret using the parameters below
  #k8sSecretName: ""
  #k8sSecretKey: "api-keys"
```

<h2>Next steps</h2>

* [Monitoring TheHive](../operations/monitoring.md)
* [Troubleshooting](../operations/troubleshooting.md)
* [Perform a Cold Backup ]()