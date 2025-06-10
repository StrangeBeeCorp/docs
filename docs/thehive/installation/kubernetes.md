# How to Deploy TheHive on Kubernetes

This topic provides step-by-step instructions for deploying TheHive on a Kubernetes cluster using [the StrangeBee Helm chart repository](https://github.com/StrangeBeeCorp/helm-charts).

!!! info "License"
    The Community license supports only a single node. To deploy multiple TheHive nodes, you must upgrade to a Gold or Platinum license. A fresh deployment of TheHive on an empty database includes a two-week Platinum trial, allowing you to test multi-node setups.

## Quick start deployment

TheHive provides an [official Helm chart for Kubernetes deployments](https://github.com/StrangeBeeCorp/helm-charts/tree/main/thehive-charts/thehive).

!!! warning "Prerequisites"
    Make sure you have:

    * A running Kubernetes cluster (version 1.23.0 or later)
    * [Helm](https://helm.sh/) installed (version 3.8.0 or later)

1. Add the StrangeBee Helm repository

    ```bash
    helm repo add strangebee https://strangebeecorp.github.io/helm-charts
    ```

2. Update your local Helm repositories

    ```bash
    helm repo update
    ```

3. Create a release using the `thehive` Helm chart

    ```bash
    helm install <release_name> strangebee/thehive
    ```

    For more options, see [the Helm documentation for installation](https://helm.sh/docs/helm/helm_install/).

!!! info "Dependencies"
    The `thehive` Helm chart relies on the following charts by default:

    * [Bitnami Apache Cassandra](https://github.com/bitnami/charts/tree/main/bitnami/cassandra) - used as the database
    * [Bitnami Elasticsearch Stack](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch) - used as the search index
    * [MinIO Community Helm Chart](https://github.com/minio/minio/tree/master/helm/minio) - used as S3-compatible object storage

!!! note "Upgrades"
    To upgrade your release to the latest version of the `thehive` Helm chart, run:
    ```bash
    helm upgrade <release_name> strangebee/thehive
    ```
    For additional options and best practices, see [the Helm upgrade documentation](https://helm.sh/docs/helm/helm_upgrade/).

## Advanced configuration

For convenience, the `thehive` Helm chart includes all required components out of the box. While this setup is suitable for a development environment, it's highly recommended to review and configure both TheHive and its dependencies before deploying to production.

Use the following command to view all available configuration options for the `thehive` Helm chart:

```bash
helm show values strangebee/thehive
```

For more information on customization, see [the dedicated Helm documentation](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). You can also review the available options for each dependency.

### Pods resources

Resources allocated to pods are optimized for production use. If you need to adjust these values, especially memory limits, make sure you update the `JVM_OPTS` environment variable accordingly to avoid out of memory (OOM) crashes.

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

By default, this chart uses your cluster's default StorageClass to create persistent volumes (PVs).

You can customize the StorageClass to suit your environment. In all cases, whether you use the default or a custom configuration, make sure it meets the following criteria:

* It's regularly backed up to prevent data loss. Tools like [Velero](https://velero.io/) can help automate this process.
* It has an appropriate `reclaimPolicy` to minimize the risk of data loss when volumes are deleted or released.
* It provides sufficient performance to ensure reliable operation of databases and applications.

To configure StorageClasses based on your needs, refer to the relevant CSI drivers for your infrastructure. For example, use the EBS CSI driver for AWS or the Persistent Disk CSI driver for Google Cloud Platform.

### Cassandra

This chart deploys two Cassandra pods to store TheHive's data.

You can review the [Bitnami Cassandra Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/cassandra) for available configuration options.

### Elasticsearch

By default, this chart deploys an Elasticsearch cluster with two nodes, both master-eligible and general-purpose.

You can review the [Bitnami Elasticsearch Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch) for available configuration options.

!!! note "Same Elasticsearch instance for both TheHive and Cortex"
    Using the same Elasticsearch instance for both TheHive and Cortex isn't recommended. If this setup is necessary, ensure proper connectivity and configuration for both pods and use Elasticsearch version 7.x. Be aware that sharing an Elasticsearch instance creates an interdependency that may lead to issues during updates or downtime.

### Object storage

To support multiple replicas of TheHive, this chart defines an [object storage](../configuration/file-storage.md) in the configuration and deploys a single instance of MinIO.

For production environments, use a managed object storage service to ensure optimal performance and resilience, such as:

* AWS S3
* Google Cloud Storage

Network shared filesystems, like NFS, are supported but can be more complex to implement and may offer lower performance.

### Cortex server in TheHive

No Cortex server is defined by default in TheHive configuration.

There are two main ways to add Cortex servers to TheHive:

* [Add them directly through TheHive interface](../administration/cortex/add-a-cortex-server.md).
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

When TheHive and Cortex are deployed in the same Kubernetes cluster, use the Cortex service Domain Name System (DNS) as the server URL.

```bash
http://cortex.<namespace>.svc:9001
```

<h2>Next steps</h2>

* [Monitoring TheHive](../operations/monitoring.md)
* [Troubleshooting](../operations/troubleshooting.md)
* [Perform a Cold Backup for a Stack Running with Docker Compose](../operations/backup-restore/backup/docker-compose.md)