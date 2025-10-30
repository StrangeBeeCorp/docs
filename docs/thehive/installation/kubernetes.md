# Deploy TheHive on Kubernetes

Deploy TheHive on a Kubernetes cluster using [the StrangeBee Helm chart repository](https://github.com/StrangeBeeCorp/helm-charts){target=_blank}.

!!! info "License"
    The Community license supports only a single node. To deploy multiple TheHive nodes, you must [upgrade to a Gold or Platinum license](../installation/licenses/license.md). A fresh deployment of TheHive on an empty database includes a 14-day Platinum trial, allowing you to test multi-node setups.

!!! danger "Dependency images"
    The default Cassandra and Elasticsearch images used by the dependency Helm charts come from [Bitnami](https://bitnami.com/){target=_blank}.  

    Following [Bitnami decision to stop maintaining multiple freely available image versions](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications){target=_blank}, StrangeBee Helm charts now reference the `bitnamilegacy` repository for Cassandra and Elasticsearch. Bitnami latest public images ship Cassandra 5, which isn't compatible with TheHive, and Elasticsearch 9.

    This has important consequences:

    * These legacy images won't receive security updates and will become increasingly vulnerable over time. You may continue to use them at your own risk, but they aren't production-ready.
    * You can pay Bitnami for access to updated images and configure the Helm chart to reference them.
    * Alternatively, you can deactivate the dependency Helm charts and bring your own Cassandra and Elasticsearch deployments.

## Architecture overview

The default deployment includes:

* TheHive application pods
* A two-node Cassandra cluster for data storage
* A two-node Elasticsearch cluster for search indexing
* A MinIO instance for S3-compatible object storage

## Infrastructure requirements

* Kubernetes cluster v1.23.0 or later
* Helm v3.8.0 or later
* Minimum resources per node: see [TheHive Installation System Requirements](system-requirements.md#hardware-requirements)
* StorageClass with dynamic provisioning
* Network policies allowing inter-pod communication

## Deploy with default configuration

TheHive provides an [official Helm chart for Kubernetes deployments](https://github.com/StrangeBeeCorp/helm-charts/tree/main/thehive-charts/thehive){target=_blank}. The default configuration is designed for development environments and requires modifications for production use. See [Production configuration](#production-configuration) for required adjustments.

1. Add the StrangeBee Helm repository.

    ```bash
    helm repo add strangebee https://strangebeecorp.github.io/helm-charts
    ```

2. Update your local Helm repositories.

    ```bash
    helm repo update
    ```

3. Create a release using the `thehive` Helm chart.

    ```bash
    helm install <release_name> strangebee/thehive
    ```

    For more options, see [the Helm documentation for installation](https://helm.sh/docs/helm/helm_install/){target=_blank}.

!!! info "Dependencies"
    The `thehive` Helm chart relies on the following charts by default:

    * [Bitnami Apache Cassandra](https://github.com/bitnami/charts/tree/main/bitnami/cassandra){target=_blank}-used as the database (uses legacy images by default)
    * [Bitnami Elasticsearch Stack](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch){target=_blank}-used as the search index (uses legacy images by default)
    * [MinIO Community Helm Chart](https://github.com/minio/minio/tree/master/helm/minio){target=_blank}-used as S3-compatible object storage

!!! note "Upgrades"
    To upgrade your release to the latest version of the `thehive` Helm chart, run:
    ```bash
    helm upgrade <release_name> strangebee/thehive
    ```
    For additional options and best practices, see [the Helm upgrade documentation](https://helm.sh/docs/helm/helm_upgrade/){target=_blank}.

### Production configuration

The default `thehive` Helm chart bundles all dependencies for quick deployment but uses development-oriented configurations. Production deployments require adjustments to TheHive and its dependencies for security, performance, and reliability.

Use the following command to view all available configuration options for the `thehive` Helm chart:

```bash
helm show values strangebee/thehive
```

For more information on customization, see [the dedicated Helm documentation](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing){target=_blank}. You can also review the available options for each dependency.

#### Resource allocation

Default pod resources are optimized for production workloads. If you need to adjust these values, especially memory limits, make sure you update the `JVM_OPTS` environment variable accordingly to avoid OOM crashes.

```yaml
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

Refer to the official [Cassandra](https://cassandra.apache.org/doc/latest/cassandra/getting-started/production.html){target=_blank} and [Elasticsearch](https://www.elastic.co/docs/deploy-manage/production-guidance/elasticsearch-in-production-environments){target=_blank} documentation to learn how to optimize these values.

#### Storage configuration

By default, this chart uses your cluster's default StorageClass to create PVs.

You can customize the StorageClass to suit your environment. In all cases, whether you use the default or a custom configuration, make sure it meets the following criteria:

* It's regularly backed up to prevent data loss. Tools like [Velero](https://velero.io/){target=_blank} can help automate this process.
* It has an appropriate `reclaimPolicy` to minimize the risk of data loss when volumes are deleted or released.
* It provides sufficient performance to ensure reliable operation of databases and applications.

To configure StorageClasses based on your needs, refer to the relevant CSI drivers for your infrastructure. For example, use the EBS CSI driver for AWS or the Persistent Disk CSI driver for Google Cloud Platform.

#### Cassandra

This chart deploys two Cassandra pods to store TheHive data.

You can review the [Bitnami Cassandra Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/cassandra){target=_blank} for available configuration options.

#### Elasticsearch

This chart deploys an Elasticsearch cluster with two nodes, both master-eligible and general-purpose.

You can review the [Bitnami Elasticsearch Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch){target=_blank} for available configuration options.

!!! note "Same Elasticsearch instance for both TheHive and Cortex"
    Using the same Elasticsearch instance for both TheHive and Cortex isn't recommended. If this setup is necessary, ensure proper connectivity and configuration for both pods and use Elasticsearch version 7.x. Be aware that sharing an Elasticsearch instance creates an interdependency that may lead to issues during updates or downtime.

#### Object storage

To support multiple replicas of TheHive, this chart defines an object storage in the configuration and deploys a single instance of MinIO.

For production environments, use a managed object storage service to ensure optimal performance and resilience, such as:

* AWS S3
* Google Cloud Storage

Network shared filesystems, like NFS, are supported but can be more complex to implement and may offer lower performance.

#### Cortex server in TheHive

No Cortex server is defined by default in TheHive configuration.

There are two main ways to add Cortex servers to TheHive:

* [Add them directly through TheHive interface](../administration/cortex/add-a-cortex-server.md).
* Define them in the Helm chart’s `values.yaml` file.

For the second method, here's an example configuration:

```yaml
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

When TheHive and Cortex are deployed in the same Kubernetes cluster, use the Cortex service DNS as the server URL:

```bash
http://cortex.<namespace>.svc:9001
```

<h2>Next steps</h2>

* [Monitoring TheHive](../operations/monitoring.md)
* [Troubleshooting](../operations/troubleshooting.md)