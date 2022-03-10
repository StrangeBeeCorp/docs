This page will guide you on how to use the docker image of TheHive

## Running with docker

```
// TODO change with strangebee image
docker run --rm -p 9000:9000 <thehive-image>
```
This will start an instance of thehive using a local database and index. Note that the data will be deleted when the container is deleted. So this should only be used for evaluation and tests.

### Recommended setup

```
docker run --rm -p 9000:9000 -v <host_data_folder>:/data/files <thehive-image> \
    --secret <secret>
    --cql-hostnames <cqlhost1>,<cqlhost2>,...
    --cql-username <cqlusername>
    --cql-password <cqlusername>
    --index-backend elasticsearch
    --es-hostnames <eshost1>,<eshost2>,...
```

This will connect your docker container to external cassandra and elasticsearch nodes. The data files will be stored on the host file system.
The container exposes TheHive on the port `9000`.

### Passing a configuration file

The entrypoint arguments are used to create an `application.conf` file in the container. A user can also provide its own configuration file:

```
docker run --rm -p 9000:9000 -v <host_data_folder>:/data/files -v <host_conf_folder>:/data/conf <thehive-image> --config-file /data/conf/application.conf 
```

The folder `<host_conf_folder>` needs to contain an `application.conf` file

### All options

You can get a list of all options supported by the docker entrypoint with `-h`:
```
docker run --rm <thehive-image> -h
```

## Using docker compose




## Usage in kubernetes

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

If you use the docker entrypoint, add the flag `--kubernetes`.

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

You can use the following probes to make sure the application is started and running correctly

**Note**: when applying a big migration, it's recommended to deactivate those probes as the http server will not start until the migration is done

```yaml
startupProbe:
    httpGet:
        path: /api/v1/status
        port: 9000
    failureThreshold: 30
    periodSeconds: 10
livenessProbe:
    httpGet:
        path: /api/v1/status
        port: 9000
    periodSeconds: 10
```
