# Deploy TheHive Flow on Kubernetes

<!-- md:version 6.0 --> <!-- md:license One -->

[TheHive Flow](../user-guides/about-flow.md) ships as a Helm chart, delivered in a deployment bundle, that you install on a Kubernetes cluster and connect to TheHive. Installing the chart deploys the application and a bundled Temporal workflow engine. Two stateful dependencies must exist on the cluster before the chart is installed, because the chart doesn't deploy them: a PostgreSQL database and S3-compatible object storage. For evaluation and test environments, a bootstrap script shipped in the deployment bundle deploys both. For production, point the chart at a PostgreSQL database and S3-compatible storage you operate.

The application runs as a single replica: the chart enforces `replicaCount: 1`.

!!! warning "Before you begin"
    To ensure a smooth deployment process, make sure you have:

    * A cluster that meets the [software requirements](software-requirements.md) and the [chart sizing defaults](system-requirements.md#chart-sizing-defaults)
    * A maintenance window for TheHive: upgrading it at [step 3](#step-3-deploy-or-upgrade-thehive) stops the service, and a later step requires editing TheHive configuration and restarting TheHive

The examples below use the `soar` namespace and the `thehive-flow` release name, which are the defaults of the scripts shipped in the bundle. Adapt them to your cluster conventions.

## Step 1: Download the deployment bundle

Download the bundle from the distribution link provided by StrangeBee, then extract it on a machine with `kubectl` and `helm` access to the cluster. The commands below run from the `k8s/helm/` chart directory in the bundle, which holds the chart itself and its `scripts/` directory. The image archives are in the `images/` directory at the bundle root.

## Step 2: Provision PostgreSQL and the object storage

The chart itself deploys only TheHive Flow and the Temporal subchart. The two stateful dependencies are provisioned before it, either by the `init.sh` bootstrap script shipped in the bundle, or by your own tooling:

| Component | Provisioned by `init.sh` | External alternative |
| --------- | ------------------------ | -------------------- |
| PostgreSQL | A [CloudNativePG](https://cloudnative-pg.io/){target=_blank} cluster running PostgreSQL 18.4, with the `orchestrator` and `temporal` roles and the `orchestrator`, `temporal`, and `temporal_visibility` databases | Any PostgreSQL reachable from the cluster, as long as the same roles and databases exist |
| Object storage | A single-pod [SeaweedFS](https://github.com/seaweedfs/seaweedfs){target=_blank} release whose resources are named `s3-store`, installed from the upstream SeaweedFS Helm chart | Any S3-compatible storage, set through the `blobstore.s3.*` values |

The `init.sh` defaults are for evaluation and test environments only: the object store runs as a single pod and the bootstrap Secrets hold placeholder credentials. For production, provide your own PostgreSQL and S3-compatible storage.

With the `blobstore.s3.accessKeyId` value left empty on external S3-compatible storage, the application uses the AWS SDK default credential chain, so a deployment on AWS can bind an IAM role to the pod service account instead of storing a static secret.

To provision the defaults, run the bootstrap script against the target cluster:

```bash
./scripts/init.sh
```

The script is idempotent and performs the following setup tasks:

1. Creates the namespace if it's missing.
2. Installs the CloudNativePG operator in the `cnpg-system` namespace, which provides the PostgreSQL custom resources.
3. Installs the SeaweedFS Helm release.
4. Applies the bootstrap manifests: the PostgreSQL cluster with its roles and databases, and placeholder Secrets.
5. Waits for the PostgreSQL cluster and its databases to converge.

Every name and value the script uses comes from an optional environment variable, so the defaults below are what it applies when you set nothing:

| Variable | Default | Sets |
| -------- | ------- | ---- |
| `ORCHESTRATOR_NAMESPACE` | `soar` | Namespace holding the dependencies, and the one to install the chart into |
| `ORCHESTRATOR_PG_CLUSTER` | `thehive-flow-postgresql` | Name of the CloudNativePG cluster |
| `ORCHESTRATOR_BOOTSTRAP_DIR` | `bootstrap` in the chart directory | Directory holding the bootstrap manifests |
| `ORCHESTRATOR_TIMEOUT` | `5m` | How long the script waits for the PostgreSQL cluster and its databases |
| `KUBECONTEXT` | The current context | Value passed to `kubectl --context` |

The operator and the object storage are installed by two installers shipped in the `k8s/database-operator/` and `k8s/s3/` directories, beside the chart directory, each with its own version variable: `DB_OPERATOR_VERSION` pins the CloudNativePG operator chart, `S3_VERSION` the SeaweedFS chart. Both are set to the versions listed in the [software requirements](software-requirements.md#images-pulled-at-first-start), and both are read from the `init.sh` command line as well.

To provision into a different namespace, set the variable on the same command line:

```bash
ORCHESTRATOR_NAMESPACE=<namespace> ./scripts/init.sh
```

## Step 3: Deploy or upgrade TheHive

The following steps require TheHive 6.x running and reachable from the cluster. TheHive 6.0 image ships as the `thehive-<version>.tar` archive in the `images/` directory of the deployment bundle: push it to a registry the cluster can pull from when TheHive runs in the cluster, or load it on TheHive host when TheHive runs outside.

* For TheHive in the cluster, see [Deploy TheHive on Kubernetes](../../thehive/installation/kubernetes.md).
* For TheHive outside the cluster, see [Deploy TheHive with Docker Compose](../../thehive/installation/docker.md) for a new deployment, or [Upgrade from TheHive 5.x](../../thehive/installation/upgrade-from-5.x.md) for an existing one.

## Step 4: Provision the secrets

The chart creates no Secrets itself: it reads every secret from existing Kubernetes Secrets in the release namespace, named as follows by default. The bootstrap script applies them with placeholder values. Without it, create them before the installation. The names and keys are configurable through the `secrets.*` values.

| Secret | Key | Holds |
| ------ | --- | ----- |
| `thehive-flow-jwt` | `jwt-symmetric-key` | JWT signing key shared with TheHive. Generate a strong random value, such as `openssl rand -base64 48`, and keep it stable across upgrades: changing it invalidates every token already issued |
| `thehive-flow-postgresql-orchestrator-user` | `password` | Password of the `orchestrator` database role |
| `thehive-flow-postgresql-temporal-user` | `password` | Password of the `temporal` database role |
| `thehive-flow-thehive` | `api-key` | TheHive API key used for every action workflows perform in TheHive |
| `thehive-flow-s3` | `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` | Object storage credentials, also copied to the code transformation jobs. `AWS_ACCESS_KEY_ID` must match the `blobstore.s3.accessKeyId` value |

For the API key, sign in to TheHive with an account that has the predefined Org-Admin profile, then generate a dedicated key for an account whose profile includes all available permissions: TheHive Flow uses the key for every action workflows perform in TheHive, such as creating cases or updating alerts. A [service account](../../thehive/user-guides/organization/configure-organization/manage-user-accounts/about-user-accounts.md#types) is recommended: it can't sign in to the UI and isn't tied to a person. See [Create a User Account](../../thehive/user-guides/organization/configure-organization/manage-user-accounts/create-a-user-account.md) and [Manage a User Account API Key](../../thehive/user-guides/organization/configure-organization/manage-user-accounts/manage-user-accounts.md#manage-a-user-account-api-key).

!!! warning "Sample Secrets are placeholders"
    The bootstrap manifests applied by [`init.sh`](#step-2-provision-postgresql-and-the-object-storage) ship placeholder credentials for local clusters only. In production, manage these Secrets with your own tooling, such as sealed-secrets, External Secrets Operator, or Vault.

## Step 5: Install the chart

The Helm chart ships in the deployment bundle, together with the two TheHive Flow images in the `images/` directory: the application image `thehive-flow-<version>.tar` and the code transformation assistant image `thehive-flow-assistant-<version>.tar`, both multi-architecture archives holding the `amd64` and `arm64` images and their build provenance. The assistant image runs as helper containers inside each [code transformation](../user-guides/configure-transformation-node.md) job, moving the script inputs and outputs between the object storage and the job working directory.

1. Push the two image archives, TheHive Flow application image and the code transformation assistant image, to a registry the cluster can pull from. `skopeo copy --all` carries every architecture across in one command:

    ```bash
    skopeo copy --all oci-archive:<flow_image_archive> \
      docker://<registry>/<flow_image_repository>:<version>
    skopeo copy --all oci-archive:<assistant_image_archive> \
      docker://<registry>/<assistant_image_repository>:<version>
    ```

    Any tool that preserves the architectures works equally well, such as `crane` or your registry's own import tooling. With Docker, load each archive and push it. `docker load` reports an image identifier rather than a name, so tag that identifier:

    ```bash
    docker load -i <flow_image_archive>
    docker tag <image_id> <registry>/<flow_image_repository>:<version>
    docker push <registry>/<flow_image_repository>:<version>
    ```

2. Write a values file pointing the chart at that registry, with a pull secret when the registry requires one, and at TheHive:

    ```yaml
    image:
      repository: <registry>/<flow_image_repository>
      tag: <version>

    imagePullSecrets:
      - name: <registry_pull_secret>

    codex:
      kubernetes:
        assistantImage:
          repository: <registry>/<assistant_image_repository>
          tag: <version>
        imagePullSecrets:
          - <registry_pull_secret>

    config:
      modules:
        workers:
          activities:
            thehive:
              url: <thehive_url>
    ```

    * An empty or omitted `tag` falls back to the chart `appVersion`, which is the delivered version.
    * The `codex.kubernetes.imagePullSecrets` entries are plain Secret names, without the `name:` key the top-level `imagePullSecrets` list uses.
    * The `config.modules.workers.activities.thehive.url` value is the address TheHive Flow calls TheHive at, as reachable from the cluster. The default, `http://thehive:9000`, assumes a Service named `thehive` in the release namespace: set it whenever TheHive runs elsewhere.

3. With an external PostgreSQL, align the bundled Temporal with it. TheHive Flow and Temporal share one PostgreSQL server, and the chart refuses to render when their addresses diverge: changing `postgresql.host` or `postgresql.port` means setting both Temporal datastore addresses to the same `<host>:<port>` in the values file:

    ```yaml
    postgresql:
      host: <postgres_host>
      port: <postgres_port>

    temporal:
      server:
        config:
          persistence:
            datastores:
              default:
                sql:
                  connectAddr: "<postgres_host>:<postgres_port>"
              visibility:
                sql:
                  connectAddr: "<postgres_host>:<postgres_port>"
    ```

4. Render the chart before installing. This catches the PostgreSQL mismatch above and any placeholder you missed, without touching the cluster:

    ```bash
    helm template thehive-flow <path_to_chart> \
      --namespace soar --values <values_file> > /dev/null && echo OK
    ```

5. Install the chart from the bundle:

    ```bash
    helm install thehive-flow <path_to_chart> \
      --namespace soar \
      --values <values_file> \
      --wait --timeout 10m
    ```

The installation runs a pre-install job that applies the database migrations, then deploys the application and the bundled Temporal Server subchart, so the first installation takes longer than later upgrades. The pre-install job pulls TheHive Flow image, so the images must be pushed and the pull secret must exist before the installation starts.

The [code transformation](../user-guides/configure-transformation-node.md) jobs pull the assistant image in their own namespace, `soar-jobs` by default. Image pull secrets are namespace-scoped: declare the secret name through the `codex.kubernetes.imagePullSecrets` value at install time, then create the same secret in the job namespace once the chart has created that namespace.

To use an external Temporal cluster instead of the bundled one, set `temporal.enabled: false` and fill the `externalTemporal.*` values. The external frontend must be reachable in-cluster or over a private network without TLS or API keys: Temporal Cloud isn't supported.

For the bundled Temporal, the `temporal.server.config.persistence.numHistoryShards` value is immutable once its databases exist: change it before the first installation or not at all.

## Step 6: Verify the deployment

Check that the pods are running and that the release passes its smoke test:

```bash
kubectl -n soar get pods
helm test thehive-flow -n soar --logs
```

The test runs a throwaway pod that calls the unauthenticated version endpoint of the API, and passes on a `2xx` response.

To check the [health endpoints](../operations/monitoring.md#health-endpoints) directly, forward the observability port and query it:

```bash
kubectl -n soar port-forward deploy/thehive-flow 9090:9090
curl -fsS http://127.0.0.1:9090/readyz
```

## Step 7: Configure TheHive to reach TheHive Flow

TheHive must know the URL of TheHive Flow and the JWT signing key.

1. Read the key from the `thehive-flow-jwt` Secret:

    ```bash
    kubectl -n soar get secret thehive-flow-jwt \
      -o jsonpath='{.data.jwt-symmetric-key}' | base64 -d
    ```

2. Add the connection to TheHive `application.conf` file:

    ```yaml
    orchestrator.url             = "<flow_url>"
    orchestrator.jwt_signing_key = "<jwt_signing_key>"
    features.Orchestrator.enabled = true
    scalligraph.modules += "org.thp.thehive.connector.orchestrator.OrchestratorModule"
    ```

    The `orchestrator.url` value depends on where TheHive runs:

    * TheHive in the same cluster: use the API service directly, `http://thehive-flow-api.soar.svc.cluster.local:8081`.
    * TheHive outside the cluster: expose the `thehive-flow-api` service through an ingress or a load balancer of your own, then use its public URL. The chart ships no ingress and no TLS termination: see the example below.

3. Restart TheHive.

### Expose the API to TheHive outside the cluster

The application serves plain HTTP on port 8081 and authenticates every request at the application level with the JWT, so terminate TLS at the ingress and route the whole host to the service: TheHive calls the API at the root path.

The following manifest uses the ingress-nginx controller, with the TLS certificate stored in the `thehive-flow-api-tls` Secret:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: thehive-flow-api
  namespace: soar
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: 2g
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - <flow_host>
      secretName: thehive-flow-api-tls
  rules:
    - host: <flow_host>
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: thehive-flow-api
                port:
                  number: 8081
```

The annotations mirror the limits the [nginx reverse proxy](../configuration/nginx-configuration.md#listener) applies on the Docker Compose deployment: a 2 GB request body cap, needed for file ingestion through [*Webhook* triggers](../user-guides/add-trigger.md#add-a-webhook-trigger), and 600-second proxy timeouts. On another ingress controller, set the equivalent options.

With this manifest, `orchestrator.url` is `https://<flow_host>/`. TheHive validates the certificate of the URL it calls: a certificate signed by a public certificate authority works as is. For a certificate signed by an internal certificate authority, or self-signed, configure TheHive to trust it, with the same options as on a Docker Compose deployment: see [TLS with a self-signed certificate](docker.md#tls-with-a-self-signed-certificate).

## Step 8: Check the connection in TheHive

Sign in to TheHive with an account that has the predefined Org-Admin profile, which includes the TheHive Flow permissions automatically.

The health indicator at the bottom of the sidebar menu reports the connection from any view. It covers every configured connector, TheHive Flow along with Cortex, MISP, and Email Intake, so its color answers for all of them at once:

* Green: every configured connector is healthy.
* Red: at least one configured connector is in error.
* Faded: no connector is configured.

Select the indicator to see the details. Its **Flow** section shows TheHive Flow URL and its own status, `OK` or `ERROR`. TheHive probes TheHive Flow every minute by default, so allow that long for the status to reflect a fix. Changing `orchestrator.url` or `orchestrator.jwt_signing_key` triggers an immediate check.

Then go to the **Flow** view from the sidebar menu.

* If the view displays the workflow list, empty on a fresh deployment but with the **Import workflow** button visible, TheHive and TheHive Flow are connected.
* If the view is missing from the sidebar, review the configuration from [step 7](#step-7-configure-thehive-to-reach-thehive-flow) and restart TheHive.
* If the view displays an error notification over an empty workflow list, TheHive can't reach TheHive Flow: check that the `orchestrator.url` address is reachable from TheHive host, then read the application logs with `kubectl -n soar logs deploy/thehive-flow`.

## Step 9: Grant users access to TheHive Flow

Users who don't have one of the predefined Org-Admin and Analyst profiles need the TheHive Flow permissions through a custom profile: see [Perform TheHive Flow Initial Setup as an Admin](perform-initial-setup-as-admin.md).

## Configuration and operations on Kubernetes

The application configuration is set through the `config.*` Helm values, rendered into a ConfigMap mounted at `/orchestrator.yml`. The keys and their meanings are the same as in [TheHive Flow Application Configuration](../configuration/flow-configuration.md). The chart sets the [run retention](../configuration/flow-configuration.md#run-retention) to `168h` by default.

Python and JavaScript [code transformations](../user-guides/configure-transformation-node.md) run as short-lived Kubernetes jobs in a dedicated namespace, `soar-jobs` by default, so no Docker socket is needed. The chart provisions the namespace and its role-based access control. The transformation images must be pullable by the cluster: on an air-gapped cluster, mirror them to an internal registry and set `codex.languageImages`.

The following table lists how to run each routine operation on Kubernetes.

| Operation | On Kubernetes |
| --------- | ------------- |
| Update | Load and push the new images from the refreshed deployment bundle, then run `helm upgrade` with its chart |
| Backup and restore | The state lives in PostgreSQL and the object storage. Back up the bundled PostgreSQL with the [CloudNativePG backup tooling](https://cloudnative-pg.io/documentation/current/backup/){target=_blank}, or your own database tooling for an external instance, and snapshot the object storage volume. Capture both together: the database references blobs by content hash, and restoring one without the other leaves dangling references |
| Logs | Every container logs to its standard output: read them with `kubectl logs` and ship them with the cluster log stack |
| Monitoring | Scrape the `/metrics` endpoint on port 9090 with your own Prometheus, and alert on `/readyz` returning non-200 |
| Troubleshooting | Check the pod state with `kubectl get pods`, the application logs with `kubectl logs`, and the health endpoints through a port forward as in [step 6](#step-6-verify-the-deployment) |
| Uninstall | The `teardown.sh` script shipped beside `init.sh` removes TheHive Flow and the object storage, and keeps the data by default: the PostgreSQL cluster and its volumes, the Secrets, and the CloudNativePG operator stay in place. Run it with `--delete-data` to remove those as well, which destroys the stored data |

<h2>Next steps</h2>

* [Build Your First Workflow](../user-guides/build-your-first-workflow.md)
* [TheHive Flow Application Configuration](../configuration/flow-configuration.md)
* [Authentication Between TheHive Flow Components](../operations/component-authentication.md)
