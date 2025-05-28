# Deploy Cortex on Kubernetes

Deploying Cortex on Kubernetes improves scalability, reliability, and resource management. Kubernetes handles automated deployment, dynamic resource allocation, and isolated execution of analyzers and responders, boosting performance and security. This setup simplifies the management of large workloads.

This guide provides step-by-step instructions for deploying Cortex on a Kubernetes cluster using [the StrangeBee Helm chart](https://github.com/StrangeBeeCorp/helm-charts).

!!! warning "Prerequisites"
    Make sure you have:  
    - A running Kubernetes cluster (version 1.23.0 or later)  
    - [Helm](https://helm.sh/) installed (version 3.8.0 or later)

## Step 1: Ensure all users can access files on the shared filesystem

!!! warning "Configuration errors"
    Improperly configured shared filesystems can cause errors when running jobs with Cortex.

!!! info "Why a shared filesystem"
    When running on Kubernetes, Cortex launches a new pod for each analyzer or responder execution. After the job completes and Cortex retrieves the result, the pod is terminated. A shared filesystem allows these jobs to share input data, store and retrieve results, ensure consistency across pods, and enable concurrent access.

    Kubernetes supports several methods for sharing filesystems between pods, including:  
    - [PersistentVolume (PV) using an NFS server](https://kubernetes.io/docs/concepts/storage/volumes/#nfs)  
    - Dedicated storage solutions like [Longhorn](https://longhorn.io/) or [Rook](https://rook.io/)

    This guide focuses on configuring a PV using an NFS server, with an example for [AWS Elastic File System (EFS)](#example-deploy-cortex-using-aws-efs).

At runtime, Cortex and its jobs run on different pods and may use different user IDs (UIDs) and group IDs (GIDs):

* Cortex defaults to uid:gid `1001:1001`.
* Analyzers may use different uid:gid, such as `1000:1000` or `0:0` if running as root.

To prevent permission errors when reading or writing files on the shared filesystem, [configure the NFS server](https://manpages.ubuntu.com/manpages/noble/man5/exports.5.html) with the `all_squash` parameter. This ensures all filesystem operations use uid:gid `65534:65534`, regardless of the user's actual UID and GID.

## Step 2: Set up PersistentVolume, PersistentVolumeClaim and a service account using the StrangeBee Helm chart

!!! info "Definitions"
    - A [PersistentVolume (PV)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) represents a piece of storage provisioned by an administrator or dynamically provisioned using storage classes. When using an NFS server, the PV allows multiple pods to access shared storage concurrently.  
    - A [PersistentVolumeClaim (PVC)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) is a request for storage by a pod. It connects to an existing PV or dynamically creates one, specifying the required storage capacity.  
    - A service account (SA) allows a pod to authenticate and interact with the Kubernetes API, enabling it to perform specific actions within the cluster. When deploying Cortex, a dedicated SA is essential for creating and managing Kubernetes jobs that run analyzers and responders. Without proper configuration, Cortex can't execute these jobs.

Use the StrangeBee Helm chart to automate the creation of the PV, PVC, and SA during deployment.

### Quick start

1. Add the StrangeBee Helm repository

    ```bash
    helm repo add strangebee https://strangebeecorp.github.io/helm-charts
    ```

2. Update your local Helm repositories

    ```bash
    helm repo update
    ```

3. Create a release using the StrangeBee Helm chart

    ```bash
    helm install <release_name> strangebee/cortex
    ```

!!! warning "First start"
    At first start, you must access the Cortex web page to update the Elasticsearch database.

For more options, see [the Helm documentation for installation](https://helm.sh/docs/helm/helm_install/).

!!! info "Dependency"
    The StrangeBee Helm chart relies on the [Bitnami Elasticsearch Stack](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch) by default as the search index.

!!! note "Upgrades"
    To upgrade your release to the latest version of StrangeBee Helm chart, run:
    ```bash
    helm upgrade <release_name> strangebee/cortex
    ```
    For additional options and best practices, see [the Helm upgrade documentation](https://helm.sh/docs/helm/helm_upgrade/).

### Advanced configuration

For convenience, the StrangeBee Helm chart includes all required components out of the box. While this setup is suitable for a development environment, it's highly recommended to review and configure both Cortex and its dependency before deploying to production.

Use the following command to view all available configuration options for the StrangeBee Helm chart:

```bash
helm show values strangebee/cortex
```

For more information on customization, see [the dedicated Helm documentation](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). You can also review the available options for the dependency.

#### StorageClasses

!!! warning "Shared storage requirement"
    Cortex requires a shared PVC with `ReadWriteMany` access mode to allow multiple pods to read and write data simultaneously—essential for job inputs and outputs.

By default, this chart attempts to create such a PVC using your cluster’s default StorageClass. Ensure this StorageClass supports `ReadWriteMany` to avoid deployment issues.

Target a StorageClass in your cluster compatible with this access mode. 

Common solutions include:

* Running an NFS server reachable from your cluster and creating a PV targeting it
* Using dedicated storage solutions like [Longhorn](https://longhorn.io/) or [Rook](https://rook.io/)
* Leveraging cloud provider-specific solutions like [AWS EFS with the EFS CSI Driver](https://github.com/kubernetes-sigs/aws-efs-csi-driver)

Also note that Cortex stores data in Elasticsearch. Regular backups are strongly recommended to prevent data loss, especially when deploying Elasticsearch on Kubernetes using the [Bitnami Elasticsearch Stack](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch).

#### Elasticsearch

!!! warning "Elasticsearch support"
    Cortex currently supports only Elasticsearch version 7.x.

By default, this chart deploys an Elasticsearch cluster with two nodes, both master-eligible and general-purpose.

You can review the [Bitnami Elasticsearch Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch) for available configuration options.

!!! note "Same Elasticsearch instance for both TheHive and Cortex"
    Using the same Elasticsearch instance for both TheHive and Cortex isn't recommended. If this setup is necessary, ensure proper connectivity and configuration for both TheHive and Cortex pods. Be aware that sharing an Elasticsearch instance creates an interdependency that may lead to issues during updates or downtime.

#### Cortex server in TheHive

See [Add a Cortex Server](../../thehive/administration/cortex/add-a-cortex-server.md) for detailed instructions.

When TheHive and Cortex deploy in the same Kubernetes cluster, use the Cortex service Domain Name System (DNS) as the server URL.

```bash
http://cortex.<namespace>.svc:9001
```

## Step 3: Edit your Cortex deployment

Edit your Cortex deployment manifest to configure how Cortex runs within your Kubernetes cluster. This configuration connects Cortex to the shared filesystem by mounting the PVC, enabling Cortex to access and store job data.

!!! warning "Partial deployment manifest"
    The following manifest is only a snippet of the full deployment. It highlights the relevant parameters, and you should integrate them into your complete deployment configuration.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cortex
spec:
  replicas: 1 # Number of pods to run
  selector:
    matchLabels:
      app.kubernetes.io/name: cortex
  template:
    metadata:
      labels:
        app.kubernetes.io/name: cortex
    spec:
      containers:
        - name: cortex
          # Command configuration can also be set using environment variables or an application.conf file
          command:
            - /opt/cortex/entrypoint
            # Directory for storing job data, should match the mountPath defined below
            - --job-directory
            - /tmp/cortex-jobs
            # Reference the name of the ReadWriteMany PVC you created
            - --kubernetes-job-pvc
            - cortex-shared-fs-claim
          volumeMounts:
            # Must match the name defined in the volumes section
            - name: cortex-job-pvc
              mountPath: /tmp/cortex-jobs
          # (...)
      volumes:
        - name: cortex-job-pvc
          persistentVolumeClaim:
            # Reference the previously defined PVC
            claimName: cortex-shared-fs-claim
```

## Step 4: Verify the deployment and service account

Run the following command to ensure the deployment is running with the correct SA:

```bash
kubectl get deployment cortex -o=jsonpath='{.spec.template.spec.serviceAccountName}'
```

Verify the PVC is bound:

```bash
kubectl get pvc cortex-shared-fs-claim
```

## Example: Deploy Cortex using AWS EFS

### Prerequisites

Before setting up the PV for AWS EFS, complete the following steps:

1. [Create an Identity and Access Management (IAM) role](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html) to allow the EFS CSI driver to interact with EFS.
2. Install the EFS CSI driver on your Kubernetes cluster using one of the following methods:
    * [EKS add-ons](https://www.eksworkshop.com/docs/fundamentals/storage/efs/efs-csi-driver) (recommended)
    * [Official Helm Chart](https://github.com/kubernetes-sigs/aws-efs-csi-driver/releases?q=helm-chart&expanded=true)
3. [Create an EFS filesystem](https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/efs-create-filesystem.md) and note the associated EFS filesystem ID.

### 1. Create a StorageClass for EFS

!!! note "Reference example"
    The following manifests are based on the [EFS CSI driver multiple pods example](https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master/examples/kubernetes/multiple_pods).

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

### 2. Create a PVC using the EFS StorageClass

Kubernetes automatically creates a PV when defining a PVC with the EFS StorageClass.

Define the PVC as follows:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cortex-shared-fs-claim
spec:
  storageClassName: efs-sc # References the EFS StorageClass
  # (...)
```

## Next steps

* [Analyzers & Responders](analyzers-responders.md)
* [Advanced Configuration](advanced-configuration.md)