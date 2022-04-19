# Deploy on Kubernetes

The deployment on kubernetes uses the docker image, so refer to the [docker image documentation](docker.md) for reference. 

## Sample

Get [this file](kubernetes.yml) to find a kubernetes configuration file that will deploy on kubernetes: 

- 1 instance of TheHive
- 1 instance of Cassandra
- 1 instance of Elasticsearch
- 1 instance Minio

This setup is good for a quick try out of TheHive but you should adapt the data stores to be more robust. We invite you to check their documentation on how to deploy on kubernetes for production uses.

To deploy more than one node, you will need to update your license. Only one node is included in the Community License.

Start with `kubectl apply -f kubernetes.yml`. This will create a namespace `thehive` and deploy the instances in it. 

!!! warning

    The volumes used here are `emptyDir`s, so the data will be lost when a pod is restarted. You should update the volume description if you want to use persistend data.

### Cleanup

Delete all the resources belonging to the `thehive` namespace:

```
kubectl delete namespace thehive
```


## Kubernetes configuration

In kubernetes with several TheHive pods, the application needs to form a cluster between its nodes. For this, it will use the akka discovery method using the [kubernetes API](https://doc.akka.io/docs/akka-management/current/discovery/kubernetes.html).

To enable this you need:

- A service account that can connect to the kubernetes API
- Tell TheHive to use kubernetes API to discover the other nodes

### RBAC

Create a ServiceAccount named `thehive` that can get the running pods

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

### Deployment

In your pod / deployment specification, you need to specify the created service account.
Also make sure to add a label and a `POD_IP` environment variable.

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

### Configuration

#### Using docker entrypoint

If you use the docker entry point, add the flag `--kubernetes`.

You can also use the following options:
```
--kubernetes-pod-label-selector <selector>  | selector to use to select other pods running the app (default app=thehive)
--cluster-min-nodes-count <count>           | minimum number of nodes to form a cluster (default to 1)
```

#### Using custom application.conf

If you use your own `application.conf` file, add the following:
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

### Pod probes

You can use the following probes to make sure the application is started and running correctly. The first startup can be a bit slow so you may enable those probes after validating the correct start of the application.

!!! Tip
    When applying a big migration, it's recommended to deactivate those probes as the HTTP server will not start until the migration is done.
    
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