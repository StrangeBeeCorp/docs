# Deploy Cortex on Kubernetes

Deploying Cortex on Kubernetes improves scalability, reliability, and resource management. Kubernetes handles automated deployment, dynamic resource allocation, and isolated execution of analyzers and responders, boosting performance and security. This setup supports high availability and simplifies the management of large workloads.

This guide provides step-by-step instructions for deploying Cortex on a Kubernetes cluster.

You will learn how to:

* Configure a shared filesystem to enable Cortex and its jobs to exchange data by allowing different pods to share input files, store job results, and ensure consistent data access across the Kubernetes cluster

* Set up a Cortex service account (SA) with the necessary permissions for Cortex to communicate with the Kubernetes API and create jobs for running analyzers and responders

## Configure a shared filesystem

!!! warning "Configuration errors"
    Improperly configured shared filesystems can cause errors when running jobs with Cortex.

When deploying Cortex on Kubernetes, analyzers and responders run on separate pods. A shared filesystem allows these jobs to share input data, store and retrieve results, ensure consistency across pods, and enable concurrent access.

Kubernetes supports several methods for sharing filesystems between pods, including:

* [PersistentVolume (PV) using an NFS server](https://kubernetes.io/docs/concepts/storage/volumes/#nfs)
* Dedicated storage solutions like [Longhorn](https://longhorn.io/) or [Rook](https://rook.io/)

This guide focuses on configuring a PV using an NFS server, with an example for [AWS Elastic File System (EFS)](https://aws.amazon.com/fr/efs/).

### 1. Ensure all users can access files on the shared filesystem

At runtime, Cortex and its jobs run on different pods and may use different user IDs (UIDs) and group IDs (GIDs):

* Cortex defaults to uid:gid `1001:1001`.
* Analyzers may use different uid:gid, such as `1000:1000` or `0:0` if running as root.

To prevent permission errors when reading or writing files on the shared filesystem, [configure the NFS server](https://manpages.ubuntu.com/manpages/noble/man5/exports.5.html) with the `all_squash` parameter. This ensures all filesystem operations use uid:gid `65534:65534`, regardless of the user's actual UID and GID.

### 2. Define a PersistentVolume for the NFS server

A [PersistentVolume (PV)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) represents a piece of storage provisioned by an administrator or dynamically provisioned using storage classes. When using an NFS server, the PV allows multiple pods to access shared storage concurrently.

To define a PV for your NFS server:

1. Ensure NFS server accessibility.

    Confirm that your NFS server is running and accessible from the Kubernetes cluster.

    !!! note "Using a different storage solution?"
    If you're using another storage system, create a ReadWriteMany PV following your tool’s documentation, then continue with the next step.

2. Create a PersistentVolume manifest.

    This manifest connects Kubernetes to your NFS server:

    ```yaml
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: cortex-shared-fs
    spec:
      storageClassName: standard
      capacity:
        storage: 10Gi  # Allocate enough storage to fit your observables
      accessModes:
        - ReadWriteMany # Allows multiple pods to read and write simultaneously
      nfs:
        server: 172.31.0.1 # IP address of the NFS server
        path: "/srv/cortex" # Path on the NFS server used as the PV root
        mountOptions:
        - nfsvers=4.2 # Specify the NFS client version
    ``` 

### 3. Create a PersistentVolumeClaim

A [PersistentVolumeClaim (PVC)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) is a request for storage by a pod. It connects to an existing PV, specifies the required storage, and defines how to access it.

This manifest references the previously defined PV:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cortex-shared-fs-claim
spec:
  # Ensure the following parameters match your previously defined PV
  storageClassName: standard
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
```

### 4. Edit your Cortex deployment

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

### Example: Deploy Cortex on Kubernetes using AWS EFS

#### Prerequisites

Before setting up the PV for AWS EFS, complete the following steps:

1. [Create an IAM role](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html) to allow the EFS CSI driver to interact with EFS.
2. Install the EFS CSI driver on your Kubernetes cluster using one of the following methods:
    * [EKS add-ons](https://www.eksworkshop.com/docs/fundamentals/storage/efs/efs-csi-driver) (recommended)
    * [Official Helm Chart](https://github.com/kubernetes-sigs/aws-efs-csi-driver/releases?q=helm-chart&expanded=true)
3. [Create an EFS filesystem](https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/efs-create-filesystem.md) and note the associated EFS filesystem ID.

#### 1. Create a StorageClass for EFS

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
  subPathPattern: "${.PVC.namespace}/${.PVC.name}" # Optional subfolder structure for PVCs
```

#### 2. Define a PV using the EFS StorageClass

Create a new PV that connects to your AWS EFS using the previously defined StorageClass:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: cortex-shared-fs
spec:
  storageClassName: efs-sc # Must match the StorageClass created earlier
  persistentVolumeReclaimPolicy: Retain # Retains data after PVC release (optional). Used by Cortex for temporary job data transfer only.
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteMany
  csi:
    driver: efs.csi.aws.com # Specifies the EFS CSI driver
    volumeHandle: fs-01234567 # Replace with your EFS filesystem ID
```

#### 3. Create a PVC using the EFS StorageClass

The PVC manifest is nearly identical to the one defined earlier. The only change required is updating the storageClassName to reference the EFS StorageClass:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cortex-shared-fs-claim
spec:
  # The only change is the updated storageClassName
  storageClassName: efs-sc # Updated to reference the EFS StorageClass
  # (...)
```

## Set up a Cortex service account

!!! warning "Service account configuration required"
    If you don't configure the Cortex service account properly, it won't be able to create Kubernetes jobs to run analyzers or responders.

In Kubernetes, a service account (SA) allows a pod to authenticate and interact with the Kubernetes API, enabling it to perform specific actions within the cluster.

When deploying Cortex, a dedicated SA is essential for creating and managing Kubernetes jobs that run analyzers and responders. Without proper configuration, Cortex can't execute these jobs.

### 1. Create a SA for Cortex

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cortex
```

### 2. Define a role for Cortex job execution

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: cortex-job-runner
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list"]
  - apiGroups: ["batch"]
    resources: ["jobs"]
    verbs: ["create", "delete", "get", "list", "watch"]
```

### 3. Create a RoleBinding to link the SA and role

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: cortex-job-runner-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: cortex-job-runner
subjects:
  - kind: ServiceAccount
    name: cortex
```
### 4. Assign the SA in the Cortex deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cortex
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: cortex
  template:
    metadata:
      labels:
        app.kubernetes.io/name: cortex
    spec:
      containers:
        # (...)
      volumes:
        # (...)
      serviceAccountName: cortex
```

## Verify the deployment and service account

Run the following command to ensure the deployment is running with the correct service account (SA):

```bash
kubectl get deployment cortex -o=jsonpath='{.spec.template.spec.serviceAccountName}'
```

Verify the PVC is bound:

```bash
kubectl get pvc cortex-shared-fs-claim
```

## Next steps

* [Analyzers & Responders](analyzers-responders.md)
* [Advanced Configuration](advanced-configuration.md)