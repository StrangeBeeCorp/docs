# :material-docker: Running with docker

This page will guide you on how to use the docker image of TheHive

!!! Tip Default admin credentials are admin@thehive.local / secret

```bash
docker run --rm -p 9000:9000 strangebee/thehive:<version>
```
This will start an instance of thehive using a local database and index. Note that the **data will be deleted when the container is deleted**. So this should only be used for evaluation and tests.

We recommend to always set the version of your docker image in production scenarios and not to use `latest`. 

### Recommended setup

```bash
docker run --rm -p 9000:9000 -v <host_data_folder>:/data/files strangebee/thehive:<version> \
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

```bash
docker run --rm -p 9000:9000 -v <host_data_folder>:/data/files -v <host_conf_folder>:/data/conf <thehive-image> --config-file /data/conf/application.conf 
```

The folder `<host_conf_folder>` needs to contain an `application.conf` file

### All options

You can get a list of all options supported by the docker entrypoint with `-h`:
```bash
docker run --rm strangebee/thehive:<version> -h
```

```
Available options:
    --config-file <file>                        | configuration file path
    --no-config                                 | do not try to configure TheHive (add secret and elasticsearch)
    --no-config-secret                          | do not add random secret to configuration
    --secret <secret>                           | secret to secure sessions
    --show-secret                               | show the generated secret
    --no-config-db                              | do not configure database automatically
    --cql-hostnames <host>,<host>,...           | resolve these hostnames to find cassandra instances
    --cql-username <username>                   | username of cassandra database
    --cql-password <password>                   | password of cassandra database
    --no-cql-wait                               | don't wait for cassandra
    --bdb-directory <path>                      | location of local database, if cassandra is not used (default: /data/db)
    --index-backend                             | backend to use for index. One of 'lucene' or 'elasticsearch' (default: lucene)
    --es-hostnames                              | elasticsearch instances used for index
    --es-index                                  | elasticsearch index name to used (default: thehive)
    --no-config-storage                         | do not configure storage automatically
    --storage-directory <path>                  | location of local storage, if s3 is not used (default: /data/files)
    --s3-endpoint <endpoint>                    | endpoint of s3 (or other object storage) if used, use 's3.amazonaws.com' for aws s3
    --s3-region <region>                        | s3 region, optional for minio
    --s3-bucket <bucket>                        | name of the bucket to use (default: thehive), the bucket must already exists
    --s3-access-key <key>                       | s3 access key (required for s3)
    --s3-secret-key <key>                       | s3 secret key (required for s3)
    --s3-use-path-access-style                  | set this flag if you use minio or other non aws s3 provider, default to virtual host style
    --no-config-cortex                          | do not add Cortex configuration
    --cortex-proto <proto>                      | define protocol to connect to Cortex (default: http)
    --cortex-port <port>                        | define port to connect to Cortex (default: 9001)
    --cortex-hostnames <host>,<host>,...        | resolve this hostname to find Cortex instances
    --cortex-keys <key>,<key>,...               | define Cortex key
    --kubernetes                                | will use kubernetes api to join other nodes
    --kubernetes-pod-label-selector <selector>  | selector to use to select other pods running the app (default app=thehive)
    --cluster-min-nodes-count <count>           | minimum number of nodes to form a cluster (default to 1)
    migrate <param> <param> ...                 | run migration tool
    cloner <param> <param> ...                  | run cloner tool
```

## Using docker compose

Below is an example of a docker-compose file. It's composed of several services: cassandra, elasticsearch, minio and TheHive.

```yaml
version: "3"
services:
  thehive:
    image: strangebee/thehive:<version>
    depends_on:
      - cassandra
      - elasticsearch
      - minio
    mem_limit: 1500m
    ports:
      - "9000:9000"
    environment:
      - JVM_OPTS="-Xms1024M -Xmx1024M"
    command:
      - --secret
      - "mySecretForTheHive"
      - "--cql-hostnames"
      - "cassandra"
      - "--index-backend"
      - "elasticsearch"
      - "--es-hostnames"
      - "elasticsearch"
      - "--s3-endpoint"
      - "http://minio:9000"
      - "--s3-access-key"
      - "minioadmin"
      - "--s3-secret-key"
      - "minioadmin"
      - "--s3-use-path-access-style"
      - "--no-config-cortex"

  cassandra:
    image: 'cassandra:4'
    mem_limit: 1000m
    ports:
      - "9042:9042"
    environment:
      - CASSANDRA_CLUSTER_NAME=TheHive
    volumes:
      - cassandradata:/var/lib/cassandra

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.16.2
    mem_limit: 512m
    ports:
      - "9200:9200"
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    volumes:
      - elasticsearchdata:/usr/share/elasticsearch/data
  
  minio:
    image: quay.io/minio/minio
    command: ["minio", "server", "/data", "--console-address", ":9001"]
    environment:
      - MINIO_ROOT_USER=minioadmin
      - MINIO_ROOT_PASSWORD=minioadmin
    ports:
      - "9001:9001"
    volumes:
      - "miniodata:/data"

volumes:
  miniodata:
  cassandradata:
  elasticsearchdata:

```

It's highly recommended to change the default credentials and secrets.

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

You can use the following probes to make sure the application is started and running correctly. The first startup can be a bit slow so you may enable those probes after validating the correct start of the application.

**Note**: when applying a big migration, it's recommended to deactivate those probes as the http server will not start until the migration is done

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
