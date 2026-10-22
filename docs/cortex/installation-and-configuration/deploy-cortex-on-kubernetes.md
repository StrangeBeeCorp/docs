# Deploy Cortex on Kubernetes

Deploy Cortex on a Kubernetes cluster using [the StrangeBee Helm chart repository](https://github.com/StrangeBeeCorp/helm-charts){target=_blank}.

{% include-markdown "includes/kubernetes-chart-poc-only.md" %}

!!! danger "Dependency image"
    The default Elasticsearch image used by the dependency Helm chart comes from [Bitnami](https://bitnami.com/){target=_blank}.  

    Following [Bitnami decision to stop maintaining multiple freely available image versions](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications){target=_blank}, StrangeBee Helm charts now reference the `bitnamilegacy` repository for Elasticsearch.

    This has important consequences:

    * This legacy image won't receive security updates and will become increasingly vulnerable over time. You may continue to use it at your own risk, but it isn't production-ready.
    * You can pay Bitnami for access to updated images and configure the Helm chart to reference them.
    * Alternatively, you can deactivate the dependency Helm charts and bring your own Elasticsearch deployment.

## Architecture overview

The default deployment includes:

* A single Cortex application Pod
* A one-node Elasticsearch cluster for search indexing, using Elasticsearch 8
* Shared storage for analyzer job data

## Infrastructure requirements

* Kubernetes cluster v1.23.0 or later
* Helm v3.8.0 or later
* Minimum resources per node: see [Cortex Installation System Requirements](system-requirements.md#hardware-requirements)
* StorageClass supporting `ReadWriteMany` access mode
* Network policies allowing inter-Pod communication

## Step 1: Ensure all users can access files on the shared filesystem

!!! warning "Configuration errors"
    Improperly configured shared filesystems can cause errors when running jobs with Cortex.

!!! info "Why a shared filesystem"
    When running on Kubernetes, Cortex launches a new Pod for each analyzer or responder execution. After the job completes and Cortex retrieves the result, the Pod is terminated. Without a shared filesystem accessible by both the Cortex Pod and these analyzer and responder Pods, they can't access the data they need to operate, causing the jobs to fail.

    Kubernetes supports several methods for sharing filesystems between Pods, including:

    * [PV using an NFS server](https://kubernetes.io/docs/concepts/storage/volumes/#nfs){target=_blank}
    * Dedicated storage solutions like [Longhorn](https://longhorn.io/){target=_blank} or [Rook](https://rook.io/){target=_blank}

    This guide focuses on configuring a PV using an NFS server, with an example for [AWS Elastic File System (EFS)](#example-deploy-cortex-using-aws-efs).

At runtime, Cortex and its jobs run on different Pods and may use different user IDs (UIDs) and group IDs (GIDs):

* Cortex defaults to uid:gid `1001:1001`.
* Analyzers may use different uid:gid, such as `1000:1000` or `0:0` if running as root.

To prevent permission errors when reading or writing files on the shared filesystem, [configure the NFS server](https://man7.org/linux/man-pages/man5/exports.5.html){target=_blank} with the `all_squash` parameter. This ensures all filesystem operations use uid:gid `65534:65534`, regardless of the user's actual UID and GID.

## Step 2: Deploy Cortex

### Deploy with default configuration

!!! info "ServiceAccount"
    A ServiceAccount allows a Pod to authenticate and interact with the Kubernetes API, enabling it to perform specific actions within the cluster. When deploying Cortex, a dedicated ServiceAccount is essential for creating and managing Kubernetes Jobs that run analyzers and responders. Without proper configuration, Cortex can't execute these jobs.

!!! note "Using an existing PV"
    The `cortex` Helm chart can operate without creating a new PV, provided that an existing PV—created by the cluster administrator—matches the PVC configuration specified in the Helm chart.

Use the `cortex` Helm chart to automate the creation of the PV, PVC, and ServiceAccount during deployment.

The default configuration is designed for development environments and requires modifications for production use. See [Production configuration](#production-configuration) for required adjustments.

1. Add the StrangeBee Helm repository

    ```bash
    helm repo add strangebee https://strangebeecorp.github.io/helm-charts
    ```

2. Update your local Helm repositories

    ```bash
    helm repo update
    ```

3. Generate a unique HTTP secret and update the `httpSecret` value in your `values.yaml` file.

4. Create a release using the `cortex` Helm chart

    ```bash
    helm install <release_name> strangebee/cortex
    ```

!!! warning "First start"
    At first start, you must access the Cortex web page to update the Elasticsearch database.

For more options, see [the Helm documentation for installation](https://helm.sh/docs/helm/helm_install/){target=_blank}.

!!! info "Dependency"
    The `cortex` Helm chart relies on the [Bitnami Elasticsearch Stack](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch){target=_blank} by default as the search index.

!!! note "Upgrades"
    To upgrade your release to the latest version of the `cortex` Helm chart, run:
    ```bash
    helm upgrade <release_name> strangebee/cortex
    ```
    For additional options and best practices, see [the Helm upgrade documentation](https://helm.sh/docs/helm/helm_upgrade/){target=_blank}.

### Production configuration

The default `cortex` Helm chart bundles all dependencies for quick deployment but uses development-oriented configurations. Production deployments require adjustments to Cortex and its dependencies for security, performance, and reliability.

Use the following command to view all available configuration options for the `cortex` Helm chart:

```bash
helm show values strangebee/cortex
```

If you want to run Cortex as a multi-node cluster, increase the `cortex.replicas` value in `values.yaml`. For a reliable cluster setup, you should run a minimum of three nodes. If you're using the bundled dependencies, also adjust `elasticsearch.master.replicaCount` to scale Elasticsearch accordingly.

For more information on customization, see [the dedicated Helm documentation](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing){target=_blank}. You can also review the available options for the dependency.

#### Storage configuration

!!! warning "Shared storage requirement"
    Cortex requires a shared PVC with `ReadWriteMany` access mode to allow multiple Pods to read and write data simultaneously—essential for job inputs and outputs.

By default, this chart attempts to create such a PVC using your cluster’s default StorageClass. Ensure this StorageClass supports `ReadWriteMany` to avoid deployment issues or target a StorageClass in your cluster compatible with this access mode.

Common solutions include:

* Running an NFS server reachable from your cluster and creating a PV targeting it
* Using dedicated storage solutions like [Longhorn](https://longhorn.io/){target=_blank} or [Rook](https://rook.io/){target=_blank}
* Leveraging cloud provider-specific solutions like [AWS EFS with the EFS CSI Driver](https://github.com/kubernetes-sigs/aws-efs-csi-driver){target=_blank}

Also note that Cortex stores data in Elasticsearch. Regular backups are strongly recommended to prevent data loss, especially when deploying Elasticsearch on Kubernetes using the [Bitnami Elasticsearch Stack](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch){target=_blank}.

#### Elasticsearch

This chart deploys a master-eligible and general-purpose Elasticsearch cluster with a single node, using Elasticsearch 8 by default.

You can review the [Bitnami Elasticsearch Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch){target=_blank} for available configuration options.

!!! note "Same Elasticsearch instance for both TheHive and Cortex"
    Using the same Elasticsearch instance for both TheHive and Cortex isn't recommended. If this setup is necessary, ensure proper connectivity and configuration, and use an Elasticsearch version that is compatible with both applications. Be aware that sharing an Elasticsearch instance creates an interdependency that may lead to issues during updates or downtime.

#### Cortex server in TheHive

See [Add a Cortex Server](../../thehive/administration/cortex/add-a-cortex-server.md) for detailed instructions.

When TheHive and Cortex deploy in the same Kubernetes cluster, use the DNS name of the Cortex Service as the server URL.

```bash
http://cortex.<namespace>.svc:9001
```

#### Private registry for analyzers and responders

<!-- md:version 4.2 -->

On Kubernetes, Cortex runs each analyzer or responder job as a Kubernetes Job, and Kubernetes pulls the analyzer or responder image for this Job. If your images are in a private registry, Kubernetes needs credentials to pull them. Without credentials, the Pod of the Job stays in the `ImagePullBackOff` state and the job fails when the job timeout is reached.

The `job.kubernetes.imagePullSecrets` setting lists Kubernetes Secrets that hold your registry credentials. Cortex adds these Secrets to every analyzer and responder Job it creates, and Kubernetes uses them to log in to the registry.

This setting applies only when Cortex runs analyzers and responders on Kubernetes. With Docker, use the `docker.registry.*` settings described in [Parameters for Docker](parameters-docker.md).

!!! warning "Pull secrets on the default ServiceAccount"
    Kubernetes adds the image pull secrets of the default ServiceAccount only to Pods that declare none. Once you set `job.kubernetes.imagePullSecrets`, analyzer and responder Pods use only the Secrets in this list.

    If you added registry credentials to the default ServiceAccount of the namespace, also add these Secrets to `job.kubernetes.imagePullSecrets`. Otherwise, Kubernetes can no longer pull images from the registries that only the ServiceAccount knew about.

!!! note "Chart `imagePullSecrets` value"
    The top-level `imagePullSecrets` value of the `cortex` Helm chart applies only to the Cortex Pod, to pull the Cortex image. It has no effect on analyzer and responder Jobs.

1. Create a Secret holding your registry credentials in the namespace where Cortex runs. Cortex creates its Jobs in this namespace.

    ```bash
    kubectl create secret docker-registry <secret_name> \
      --namespace <cortex_namespace> \
      --docker-server=<registry_host> \
      --docker-username=<username> \
      --docker-password=<password>
    ```

    Kubernetes accepts Secrets of type `kubernetes.io/dockerconfigjson`, which is the type this command creates, and of the older type `kubernetes.io/dockercfg`. It ignores Secrets of type `Opaque` and Secrets in another namespace.

    Cortex never reads the content of these Secrets and needs no Kubernetes permission on Secrets. Kubernetes reads them when it pulls the image.

2. Make sure each analyzer and responder image name includes the registry host, for example `registry.example.com/team/analyzer:1.0`. If the image names in your catalog don't include it, set the `cortex.dockerImageRegistryPrefix` value in your `values.yaml` file. Cortex adds this prefix as is in front of every analyzer and responder image name, so include the trailing `/`.

3. In your `values.yaml` file, add the `job.kubernetes.imagePullSecrets` setting at the end of `cortex.configFile`. Keep the existing content of `cortex.configFile`.

    !!! tip "Setting format"

    * Always write a list, even for a single Secret. A plain string stops Cortex at startup, even if Cortex doesn't run jobs on Kubernetes.
    * With environment variables, use one variable per Secret: `[${?PULL_SECRET}]`, not `${?PULL_SECRETS}`.
    * Cortex uses Secret names exactly as written, without trimming or checking them.

    ```yaml
    cortex:
      configFile: |
        # Keep the existing configuration above this line
        job.kubernetes.imagePullSecrets = ["<secret_name>"]
    ```

    To use several Secrets, for example one for each registry, list them all: `["<secret_name_1>", "<secret_name_2>"]`.

4. Apply the new configuration.

    ```bash
    helm upgrade <release_name> strangebee/cortex -f values.yaml
    ```

5. Restart Cortex. Cortex reads `job.kubernetes.imagePullSecrets` only at startup, and a change to `cortex.configFile` doesn't restart the Cortex Pod.

    ```bash
    kubectl rollout restart deployment <cortex_deployment_name> --namespace <cortex_namespace>
    ```

You can create or rotate the Secrets at any time without restarting Cortex. The next job uses the current content of the Secrets.

If Kubernetes can't pull an image because of a wrong Secret name, wrong credentials, or an unreachable registry, Cortex reports no specific error. The job fails when the job timeout is reached, with a generic timeout message.

To find the cause, list the analyzer and responder Pods and check their events:

```bash
kubectl get pods --namespace <cortex_namespace> -l cortex-neuron-job=true
kubectl describe pod <pod_name> --namespace <cortex_namespace>
```

A wrong Secret name shows as the event `Unable to retrieve some image pull secrets`.

Kubernetes doesn't pull an image again when it's already on the node and its tag is pinned, so no registry login happens for this image. Kubernetes pulls images tagged `latest` for every job.

### Example: Deploy Cortex using AWS EFS

#### Prerequisites

Before setting up the PV for AWS EFS, complete the following steps:

* [Create an Identity and Access Management (IAM) role](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html) to allow the EFS CSI driver to interact with EFS.
* Install the EFS CSI driver on your Kubernetes cluster using one of the following methods:
    * [EKS add-ons](https://www.eksworkshop.com/docs/fundamentals/storage/efs/efs-csi-driver){target=_blank} (recommended)
    * [Official Helm chart](https://github.com/kubernetes-sigs/aws-efs-csi-driver/releases?q=helm-chart&expanded=true){target=_blank}
* [Create an EFS filesystem](https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/efs-create-filesystem.md){target=_blank} and note the associated EFS filesystem ID.

#### 1. Create a StorageClass for EFS

!!! note "Reference example"
    The following manifests are based on the [EFS CSI driver multiple pods example](https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master/examples/kubernetes/efs/multiple_pods){target=_blank}.

Create a StorageClass that references your EFS filesystem:

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: efs-sc
provisioner: efs.csi.aws.com
# https://github.com/kubernetes-sigs/aws-efs-csi-driver?tab=readme-ov-file#storage-class-parameters-for-dynamic-provisioning
parameters:
  provisioningMode: efs-ap # EFS access point provisioning mode
  fileSystemId: fs-01234567 # Replace with your EFS filesystem ID
  directoryPerms: "700" # Permissions for newly created directories
  uid: 1001 # User ID to set file permissions
  gid: 1001 # Group ID to set file permissions
  ensureUniqueDirectory: "false" # Set to false to allow shared folder access between Cortex and job containers
  subPathPattern: "${.PVC.namespace}/${.PVC.name}" # Optional subfolder structure inside the NFS filesystem
```

#### 2. Create a PVC using the EFS StorageClass

Kubernetes automatically creates a PV when defining a PVC with the EFS StorageClass.

Use the `cortex` Helm chart to configure the `storageClass` value in the chart settings. This ensures the PVC is created automatically during deployment. To do so, open the [`values.yaml`](https://github.com/StrangeBeeCorp/helm-charts/blob/main/cortex-charts/cortex/values.yaml){target=_blank} file and look for the `persistentVolumeClaim` section.

<h2>Next steps</h2>

* [Analyzers & Responders](analyzers-responders.md)
* [Advanced Configuration](advanced-configuration.md)