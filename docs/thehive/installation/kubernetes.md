# Deploy on Kubernetes

To deploy TheHive on Kubernetes, you can utilize the Docker image. For detailed instructions on how to use the Docker image, please refer to the [**docker image documentation**](./docker.md)

---

## Important Considerations

- While this setup is suitable for testing TheHive, it's recommended to enhance the data stores (Elasticsearch, Cassandra, and Minio) for production use by setting up clustering and storage volumes. Refer to the respective documentation for instructions on deploying on Kubernetes for production use.

- The volumes used in this configuration are `emptyDir`s, which means the data will be lost when a pod is restarted. If you want to persist your data, update the volume description accordingly.

- To deploy multiple nodes, you will need to update your license as only one node is included in the Community License.

---

## Deploying TheHive

You can download the Kubernetes configuration file [**here**](./assets/kubernetes.yml). This configuration will deploy the following components:

- 1 instance of TheHive
- 1 instance of Cassandra
- 1 instance of Elasticsearch
- 1 instance of Minio

You can initiate the deployment by executing the following command:

```bash
kubectl apply -f kubernetes.yml
```

This command will create a namespace named ``thehive`` and deploy the instances within it.

---

## Kubernetes Configuration

In a Kubernetes environment with multiple TheHive pods, the application needs to form a cluster between its nodes. To achieve this, it utilizes the akka discovery method with the [**Kubernetes API**](https://doc.akka.io/docs/akka-management/current/discovery/kubernetes.html).

To enable this functionality, you need:

- A service account with permissions to connect to the Kubernetes API
- Configuration to instruct TheHive to use the Kubernetes API for discovering other nodes

&nbsp;

### Role-Based Access Control (RBAC)

Create a ServiceAccount named thehive with the necessary permissions to access the running pods:

```yaml
---
#
# Create a role, `pod-reader`, that can list pods and
# bind the default service account in the namespace
# that the binding is deployed to to that role.
#
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: pod-reader
rules:
  - apiGroups: [""] # "" indicates the core API group
    resources: ["pods"]
    verbs: ["get", "watch", "list"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: thehive
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
subjects:
  - kind: ServiceAccount
    name: thehive
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

&nbsp;

### Deployment

In your pod/deployment specification, specify the created service account. Also, ensure to add a label and a ``POD_IP`` environment variable.

```yaml
metadata:
  labels:
    app: thehive
spec:
  serviceAccountName: thehive
  containers:
  - name: thehive
    image: ...
    env:
      # Make sure that the container can know its own IP
      - name: POD_IP
        valueFrom:
          fieldRef:
            fieldPath: status.podIP
```

&nbsp;

### Configuration

#### Using Docker Entrypoint

If you use the Docker entry point, include the ``--kubernetes`` flag. Additionally, you can use the following options:

```
--kubernetes-pod-label-selector <selector>  | Selector to use to select other pods running the app (default app=thehive)
--cluster-min-nodes-count <count>           | Minimum number of nodes to form a cluster (default to 1)
```

&nbsp;

#### Using Custom application.conf

If you use your own application.conf file, add the following configurations:

```hocon
akka.remote.artery.canonical.hostname = ${?POD_IP}
singleInstance = false
akka.management {
  cluster.bootstrap {
    contact-point-discovery {
      discovery-method = kubernetes-api
      # Set the minimum number of pods to form a cluster
      required-contact-point-nr = 1
    }
  }
}
akka.extensions += "akka.management.cluster.bootstrap.ClusterBootstrap"

akka.discovery {
  kubernetes-api {
    # Set here the pod selector to use for thehive pods
    pod-label-selector = "thehive"
  }
}
```

&nbsp;

#### Pod Probes

You can use the following probes to ensure the application starts and runs correctly. It's recommended to enable these probes after validating the correct start of the application.

!!! Tip
    When applying a large migration, deactivate these probes as the HTTP server will not start until the migration is complete.
    
    ```yaml
    startupProbe:
        httpGet:
            path: /api/v1/status/public
            port: 9000
        failureThreshold: 30
        periodSeconds: 10
    livenessProbe:
        httpGet:
            path: /api/v1/status/public
            port: 9000
        periodSeconds: 10
    ```

---

## Cleanup

To delete all resources belonging to the ``thehive`` namespace, use the following command:

```
kubectl delete namespace thehive
```

---

## Troubleshooting

Below are some common issues that may arise when running TheHive with Docker:

- **Example 1**: Error during Database Initialization

    If your logs contain the following lines:

    !!! Example ""

        ```yaml
        [error] o.t.s.m.Database [|] ***********************************************************************
        [error] o.t.s.m.Database [|] * Database initialization has failed. Restart application to retry it *
        [error] o.t.s.m.Database [|] ***********************************************************************
        ```

    This indicates that an error occurred when attempting to create the database schema. Beneath these lines, you should find additional details regarding the cause of the error.

    **Resolution**:

    1. Cassandra / Elasticsearch Unavailability: Ensure that both databases are running correctly and that TheHive can establish connections to them.

        You can try starting both databases in the Kubernetes cluster before initiating TheHive by setting TheHive deployment to ``replicas: 0``.

    2. Invalid Data in Cassandra / Elasticsearch: Elasticsearch acts as an index for Cassandra, and if the data between the two becomes unsynchronized, errors may occur when accessing the data.

        If this is the first setup of the cluster, consider deleting both database volumes/data and restarting both the databases and TheHive.

&nbsp;

