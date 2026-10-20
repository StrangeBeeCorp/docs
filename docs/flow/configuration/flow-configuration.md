# TheHive Flow Application Configuration

<!-- md:version 6.0 --> <!-- md:license One -->

The `thehive-flow/config/thehive-flow.yml` file holds the application configuration of [TheHive Flow](../user-guides/about-flow.md). It's mounted read-only at `/thehive-flow.yml` inside the `thehive-flow` container.

After any change, recreate the service:

```bash
docker compose up -d --force-recreate thehive-flow
```

The file is mounted into the container on its own, and some editors replace the file instead of writing into it. A plain `docker compose restart thehive-flow` can then leave the container reading the previous version, while recreating it always picks up the file on disk.

On a Kubernetes deployment, the Helm chart exposes only a subset of these keys, mostly through the `config.*` values. Settings it doesn't expose, such as the [blob size limits](#blob-size-limits), aren't available there. Apply a change with `helm upgrade`, as described in [Configuration and operations on Kubernetes](../installation/kubernetes.md#configuration-and-operations-on-kubernetes).

## Shipped configuration

Secrets aren't stored in the file. They're read from `/secret`, mounted from `./thehive-flow/secret/`, and from the `BEEFLOW_SECRET_*` variables `docker-compose.yml` passes to the container from [`.env`](environment-variables.md#variables-of-the-thehive-flow-container).

```yaml
secret_path: /secret

temporal:
  addr: temporal:7233

database:
  postgres:
    connection_string: postgres://thehive_flow:${FLOW_DB_PASSWORD}@postgresql:5432/thehive_flow?sslmode=disable

blobstore:
  backend: s3
  s3:
    # Shipped SeaweedFS; the bucket is created by init-s3-store before TheHive Flow starts.
    # Credentials are injected from .env by docker-compose.yml.
    endpoint: http://s3-store:8333
    bucket: thehive-flow
    # Required by the S3 client for request signing, ignored by SeaweedFS
    region: us-east-1
    use_path_style: true

api:
  public:
    enable: true
    addr: "0.0.0.0:8081"
    jwt:
      # Shared with TheHive; set by BEEFLOW_SECRET_JWT_SYMMETRIC_KEY
      secret: ""

modules:
  observability:
    # /livez and /readyz
    listener:
      addr: "0.0.0.0:9090"
    metrics:
      prometheus:
        enabled: true
    pprof:
      enabled: false
  runs:
    # This stack owns its Temporal namespace: keep its retention aligned with runs retention
    sync_temporal_retention: true
  workers:
    workflows:
      max_concurrent_workflow_task_pollers: 32
    activities:
      max_concurrent_activity_task_pollers: 32
      # Outbound connections to non-public addresses (loopback, RFC 1918, link-local, ...)
      # are blocked. To reach TheHive, Cortex or another service on a private network,
      # allowlist its CIDR range. A bare IP without prefix fails startup.
      # egress:
      #   allowlist:
      #     - 192.168.1.0/24
      #     - 192.168.1.10/32
      thehive:
        # TheHive URL reachable from this stack (flow_thehive_url in .env)
        url: ${FLOW_THEHIVE_URL}
        # File name inside /secret, used when BEEFLOW_SECRET_THEHIVE_API_KEY is empty
        api_key: thehive-api-key
```

The `${FLOW_DB_PASSWORD}` and `${FLOW_THEHIVE_URL}` references are expanded from the container environment when the file loads. Any other value can be overridden the same way, as described in [Environment variable overrides](#environment-variable-overrides).

## Run retention

The run retention sets how long a run stays reachable. It drives the purge of the run list and the deletion of the files those runs reference in the [blob store](#blob-store). Because `sync_temporal_retention` is enabled in the shipped file, it also drives the history retention of the Temporal namespace. It's set with the `modules.runs.retention` key.

The shipped file deliberately leaves the key out, which keeps the application default of 30 days. To use another value, add the key under `modules.runs` and recreate the `thehive-flow` service. To use the environment variable override instead, set `BEEFLOW_MODULES__RUNS__RETENTION=168h` in the `environment:` block of the service and apply it with `docker compose up -d thehive-flow`. The namespace follows shortly after.

!!! danger "Shortening the retention deletes history"
    The Temporal namespace retention is aligned downward too. Lowering `modules.runs.retention` deletes the history of runs older than the new value, and that history can't be recovered by raising the value again.

For the operational details, including the 24-hour floor, the non-retroactive behavior, and how to check what the namespace currently holds, see [Temporal workflow history retention](../operations/maintenance.md#temporal-workflow-history-retention).

## Code transformation images

[Python and JavaScript code transformations](../user-guides/configure-transformation-node.md) run in disposable containers, launched for each execution and removed as soon as the script exits. The two default images are pinned by immutable digest in the application itself and don't appear in the shipped file:

| Language | Default image |
| -------- | ------------- |
| Python 3.11 | `gcr.io/distroless/python3-debian12` |
| JavaScript on Node.js 24 | `gcr.io/distroless/nodejs24-debian12` |

Both are distroless images that ship the language runtime and its standard library only. To make additional libraries available to scripts, or to pull from an internal registry on an air-gapped host, build or mirror an image. Then override the `image` key under `modules.codex.languages`, using the built-in language names:

```yaml
modules:
  codex:
    languages:
      python@v3_11:
        image: <registry>/<image>:<tag>
      javascript@v24:
        image: <registry>/<image>:<tag>
```

Omitted keys keep their built-in values, so overriding `image` alone is enough as long as the image keeps the interpreter at the same path: `/usr/bin/python3` for Python and `/nodejs/bin/node` for JavaScript. For an image that places it elsewhere, override the `entrypoint` key too. For a registry that requires authentication, declare it under `modules.codex.docker.docker_registries`.

On Kubernetes deployments, transformations run as [Kubernetes jobs](../installation/kubernetes.md#configuration-and-operations-on-kubernetes) and the images are set through the `codex.languageImages` chart values instead.

## Concurrent code transformations per language

TheHive Flow caps how many [code transformations](../user-guides/configure-transformation-node.md) one language runs at once. The cap is set with the `modules.codex.max_concurrent_activity_execution_size` key. Each language runs its own worker, so the cap applies per language. With both built-in languages enabled, the stack runs up to the configured value for Python and, separately, up to the same value for JavaScript. A transformation submitted above the cap waits in the Temporal task queue. The wait doesn't count against the node's own timeout, but it does count against the workflow-level timeout.

The key is absent from the shipped file, which keeps the Temporal SDK default of 1000 per language. To override it, set `BEEFLOW_MODULES__CODEX__MAX_CONCURRENT_ACTIVITY_EXECUTION_SIZE` in the `environment:` block of the `thehive-flow` service, as described in [Environment variable overrides](#environment-variable-overrides). On Kubernetes deployments, set the `codex.maxConcurrentActivityExecutionSize` chart value instead. Each transformation runs as a Kubernetes job, so the value caps how many jobs one language runs at once. An empty value or `0` keeps the default.

## Egress allowlist

Workflow authors control the target URL of the nodes that open outbound connections: the [*HTTP request*](../user-guides/configure-action-node.md#configure-an-http-request-action-node), [integration](../user-guides/configure-integration-node.md), and [*AI*](../user-guides/configure-action-node.md#configure-an-ai-action-node) nodes. To prevent server-side request forgery (SSRF), TheHive Flow blocks these connections when the target resolves to a non-public address: loopback, link-local, private, unique local, carrier-grade NAT, and reserved ranges. The check runs on the resolved IP address at connection time, after DNS resolution, so it also covers redirects and DNS rebinding.

A blocked connection fails the workflow step with the following error:

```text
egress guard: outbound connection to non-public address blocked
```

Allowlist legitimate internal targets, such as TheHive or Cortex on a private network, or a locally hosted [LLM provider](../../thehive/administration/manage-llm-providers.md). List their address ranges under `modules.workers.activities.egress.allowlist` in Classless Inter-Domain Routing (CIDR) notation, an IP address followed by a prefix length: `192.168.1.0/24` covers a whole subnet, and `192.168.1.10/32` covers a single host. The shipped file carries the block as a comment: uncomment it and fill it in, then recreate the service with `docker compose up -d --force-recreate thehive-flow`:

```yaml
modules:
  workers:
    activities:
      egress:
        allowlist:
          - <internal_cidr>
```

Five properties are worth knowing:

* An allowlisted range is reachable even though it falls in an otherwise blocked range. Public addresses stay reachable either way, and the guard itself can't be turned off.
* Requests sent through the *Default* proxy mode aren't checked at connection time. The [proxy configured in TheHive](../../thehive/configuration/proxy-settings.md) is treated as the egress boundary: only its own address is validated against the allowlist, when TheHive pushes it. A proxy defined on the node itself, with the *Enabled* mode, stays checked.
* The allowlist is validated at startup. A malformed CIDR, including a bare IP address without a prefix length, stops TheHive Flow from starting instead of silently dropping the exception.
* The same allowlist also validates the proxy, email server, and LLM provider hosts pushed by TheHive. Widening it for workflow traffic widens it for them too. An [email server override](#email-server-override) isn't checked.
* [*Python code* and *JavaScript code* nodes](../user-guides/configure-transformation-node.md#configure-a-python-code-node) aren't covered: their scripts open connections from their own container, outside the guard. See [Code transformation isolation](../operations/security.md#code-transformation-isolation).

On Kubernetes, the same list is set through the `config.modules.workers.activities.egress.allowlist` value, in the values file written at [installation time](../installation/kubernetes.md#step-6-install-the-chart), then applied with `helm upgrade`:

```yaml
config:
  modules:
    workers:
      activities:
        egress:
          allowlist:
            - <internal_cidr>
```

## Email server override

By default, [*Send email* nodes](../user-guides/configure-action-node.md#configure-a-send-email-action-node) use the [SMTP configuration defined in TheHive](../../thehive/administration/smtp/configure-smtp-server.md), which TheHive pushes to TheHive Flow. When that SMTP server isn't reachable from TheHive Flow, define another one in the `modules.workers.activities.mailer` section. TheHive Flow then ignores the configuration pushed by TheHive. Recreate the service with `docker compose up -d --force-recreate thehive-flow` to apply the change:

```yaml
modules:
  workers:
    activities:
      mailer:
        host: <smtp_host>
        port: <smtp_port>
        tls: true
        user: <smtp_user>
        password: <password_file_name>   # Filename inside secret_path (/secret)
        from: <sender_address>
```

| Key | Description |
| --- | --- |
| `host` | SMTP server address. Setting it turns the override on. |
| `port` | SMTP port. Required. |
| `tls` | Upgrades the connection with STARTTLS. Required to send credentials to a server other than `localhost`. |
| `tls_required` | Same as `tls`. |
| `ssl` | Accepted only together with `tls`. TheHive Flow doesn't support implicit TLS, also called SMTPS, commonly served on port `465`. |
| `user` | SMTP username. Must be set together with `password`: setting only one of them stops TheHive Flow from starting. |
| `password` | Name of the file holding the SMTP password, in `./thehive-flow/secret/`, readable by its owner only like the API key file. The `BEEFLOW_SECRET_MAILER_PASSWORD` environment variable can hold the password instead. |
| `from` | Default sender address. |

The [egress allowlist](#egress-allowlist) doesn't apply to this server. To go back to the configuration pushed by TheHive, remove the section and recreate the service. On Kubernetes, the same settings are exposed through the `config.modules.workers.activities.mailer.*` values, with the password in the Secret named by `secrets.mailerPassword.existingSecret`.

## Trusted proxies

Each [*Webhook* trigger](../user-guides/add-trigger.md#add-a-webhook-trigger) accepts 120 requests per minute from a given client address. Requests reach TheHive Flow through the shipped nginx, so every webhook call carries the address of nginx, and all callers of a webhook share the same limit. See [Rate limiting](../operations/security.md#rate-limiting).

To apply the limit to each caller instead, list the range nginx connects from in the `api.public.trusted_proxies` key of `thehive-flow/config/thehive-flow.yml`, then recreate the service:

```yaml
api:
  public:
    trusted_proxies:
      - <thehive_flow_network_cidr>
```

For a request coming from one of these ranges, TheHive Flow reads the caller address from the `X-Forwarded-For` header, which nginx fills with the address of its own client. Each entry is a Classless Inter-Domain Routing (CIDR) range, such as `172.20.0.0/16`. Docker Compose names the network of the stack after the profile directory, for example `prod1-thehive-flow_thehive-flow-network`. Find its range with the following commands:

```bash
docker network ls --filter name=thehive-flow-network
docker network inspect <network_name> --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}'
```

A bare IP address, a `/0` range, or an IPv4-mapped range prevents TheHive Flow from starting. The list is empty by default. When callers reach TheHive Flow through another reverse proxy placed in front of nginx, that proxy must append the address of its own client to `X-Forwarded-For`, and its range must be listed too.

## Graceful shutdown

When the `thehive-flow` service stops, TheHive Flow finishes its in-flight work within the delay set by the `shutdown.timeout` key: 20 seconds by default. The key is absent from the shipped file.

Keep the value at or below 25 seconds. The `stop_grace_period` of the `thehive-flow` service in `docker-compose.yml` is 30 seconds, and TheHive Flow needs about 5 more seconds after the timeout to flush its telemetry. Above 25 seconds, Docker may kill the process before it finishes, and TheHive Flow logs a warning at startup. To raise the timeout anyway, raise `stop_grace_period` by the same amount.

## Environment variable overrides

Any value in `thehive-flow.yml` can be overridden with an environment variable using the pattern `BEEFLOW_<SECTION>__<KEY>`, where a double underscore separates each nesting level. For example:

```bash
BEEFLOW_TEMPORAL__ADDR=temporal:7233
BEEFLOW_MODULES__OBSERVABILITY__LISTENER__ADDR=0.0.0.0:9091
```

Set overrides in the `environment:` block of the `thehive-flow` service. To keep the shipped `docker-compose.yml` untouched, which makes [upgrades](../installation/upgrade-docker.md#step-2-get-the-new-deployment-files) simpler, put them in a `docker-compose.override.yml` file created next to it. Docker Compose reads that file automatically and merges it with `docker-compose.yml`. For example:

```yaml
services:
  thehive-flow:
    environment:
      BEEFLOW_MODULES__OBSERVABILITY__LISTENER__ADDR: "0.0.0.0:9091"
```

Apply an override change by recreating the service with `docker compose up -d thehive-flow`. A plain restart doesn't re-read the file. Don't set overrides in `.env`: its values only reach the container through the variables `docker-compose.yml` declares, listed in [TheHive Flow Environment Variables](environment-variables.md#variables-of-the-thehive-flow-container).

## Blob store

TheHive Flow requires durable blob storage for files ingested through [webhooks](../user-guides/add-trigger.md#add-a-webhook-trigger) or runs, and for activity outputs too large to keep in the database. The `blobstore.backend` key selects one of two back ends:

* `s3`, the shipped and recommended back end, using an S3-compatible object store. The stack ships one, the `s3-store` service, so there's nothing to provision.
* `local`, which writes blobs to a directory on the host. It's available on the Docker Compose deployment only, for a single-node installation that accepts the [restrictions below](#local-filesystem-back-end).

The `blobstore.backend` key is required: TheHive Flow doesn't start when it's missing.

Whichever back end is selected, the storage behavior is identical: blobs are addressed by organization and SHA-256 hash, identical content is [deduplicated within an organization](../installation/system-requirements.md#blob-store-volume-sizing), and files follow the [run retention](#run-retention).

### Blob size limits

Three keys of the `modules.variables` section set the size limits described in [Files](../user-guides/about-flow.md#files). They're absent from the shipped file, which keeps the defaults. Values are in bytes.

| Key | Default | Description |
| --- | --- | --- |
| `max_blob_size` | 25 MiB (`26214400`) | Largest file the blob store accepts. A node output above this size is rejected. |
| `min_size_promote_to_blobref` | 1 MiB (`1048576`) | Node outputs of this size or more are stored as files instead of inline. Binary content is always stored as a file, whatever its size. |
| `max_blob_inline_size` | 1.5 MiB (`1572864`) | Largest JSON file content that a variable reference returns transparently. Above this size, the reference returns the file metadata instead. |

TheHive Flow doesn't start when `max_blob_inline_size` or `min_size_promote_to_blobref` is zero or negative, or when `min_size_promote_to_blobref` exceeds `max_blob_size`.

A fourth key, `modules.workers.activities.integration.max_response_body_bytes`, caps the response body that an [integration node](../user-guides/configure-integration-node.md) accepts. Its default is 10 MiB (`10485760`). A larger response fails the node without a retry. TheHive Flow doesn't start when the value is smaller than `min_size_promote_to_blobref` or larger than `max_blob_size`.

### S3 back end

The shipped configuration selects the `s3` back end. It points at the shipped `s3-store` service over the internal Docker network, with the bucket provisioned by `init-s3-store` before startup. The shipped service is a single-process [SeaweedFS](https://github.com/seaweedfs/seaweedfs){target=_blank} instance, the supported default for a single-host deployment. It keeps its data in the `./s3-store/data` directory.

The back end works with any S3-compatible object storage, whether managed by a cloud provider, such as [Amazon S3](https://aws.amazon.com/s3/){target=_blank}, or self-hosted. To use an external store instead of the shipped one, point `blobstore.s3.endpoint` and `blobstore.s3.bucket` at it in `thehive-flow/config/thehive-flow.yml`, and set `region` to the one the store expects. Keep `use_path_style: true` for non-AWS gateways, and provide the credentials in [`.env`](environment-variables.md#s3-credentials). The stack still starts the `s3-store` and `init-s3-store` services, which then hold no data.

!!! note "Endpoint and availability"
    TheHive Flow uses a single S3 endpoint. With self-hosted object storage, make sure the endpoint is highly available, for example through the storage platform itself or a correctly configured load balancer.

Three properties of the back end are worth knowing:

* Both credentials travel together. The application rejects a configuration where exactly one of `access_key_id` and `secret_access_key` is set. With both empty, it doesn't fail. It falls back to the AWS SDK credential chain, which against the shipped store means unsigned or wrong requests rather than a clear error. That's why `thehive-flow.yml` leaves both out and `docker-compose.yml` injects the pair from [`.env`](environment-variables.md#s3-credentials).
* Changing a credential after first start requires provisioning again. The store must learn the new value: run `docker compose up -d init-s3-store`. A new secret under the same access key ID replaces the previous one in place. A new access key ID is added beside the previous one, which stays valid. See [Rotate secrets](../operations/security.md#s3-secret-access-key) for the full procedure.
* The identity needs delete rights. The application deletes the files of purged runs with `DeleteObject`, so on an external store the principal needs `s3:ListBucket`, `s3:GetObject`, `s3:PutObject`, and `s3:DeleteObject` on the bucket. Without `s3:DeleteObject`, runs are still purged, but their files stay in the bucket, queued for deletion, and each deletion pass logs an error. On a versioned bucket, `DeleteObject` leaves a noncurrent version, so add a noncurrent-version expiration rule to reclaim that space. Don't add a lifecycle rule that expires current objects. A run that reuses stored content doesn't always rewrite the object, so such a rule can delete a file that a retained run still uses. The shipped store needs nothing more, because its `Write` action covers both uploads and deletions.

### Local filesystem back end

The `local` back end stores blobs as plain files in a directory, for a single-node Docker Compose installation that prefers a plain disk over an object store. Kubernetes deployments don't support it: the Helm chart refuses to render with any `blobstore.backend` other than `s3`, because the application and the code transformation jobs don't share a disk on a cluster. Selecting the back end is a manual configuration change: `init.sh` doesn't offer it, and the stack ships, provisions, and starts the shipped object storage either way.

```yaml
blobstore:
  backend: local
  local:
    path: <blob_directory>
```

`path` is required and must be an absolute path. Both constraints are checked when the configuration loads, before anything starts. The directory must already exist and be writable by the application: nothing creates it, and startup performs a real write test and aborts on failure. In practice, mount a dedicated host directory at that path in the `thehive-flow` service, through the `volumes:` block of the service in `docker-compose.yml` or in a `docker-compose.override.yml` file. The directory ownership must match the user the stack runs as.

Blobs are stored as `<path>/<organization>/<prefix>/<sha256>`, where `<prefix>` is the first four characters of the hash, so that no single directory grows too large. Writes are atomic and durable. Each blob is written to a temporary file, flushed to disk, then renamed, so a visible file is always complete, even after a power loss. Temporary files orphaned by a crash are removed at a later startup, once they're old enough not to belong to a write in progress. Disk full and I/O errors are treated as transient and retried, like S3 errors.

!!! warning "Guardrails the object store provides fall on the operator here"
    * A single shared directory is required. Every process of the stack must read and write the same directory on the same host. Nothing verifies it, and a mismatch surfaces as file-not-found errors at run time, never as a startup refusal.
    * A local filesystem is required. The atomicity guarantee relies on the rename operation, so network filesystems such as NFS, and overlay filesystems, aren't supported. This isn't verified at startup.
    * A case-sensitive filesystem is required. On a case-insensitive filesystem, two organizations whose names differ only by case end up sharing one directory, which breaks tenant isolation. This isn't verified at startup either.
    * No disk supervision exists. The application exposes no metric for the space left in the directory, and a full disk shows up as workflow steps failing and being retried, not as an operational alert. Add a host-level disk alert on the filesystem holding `path`, as described in [Monitor TheHive Flow](../operations/monitoring.md#disk-alerting-for-the-blob-store).
    * The backup scripts don't cover the directory. `backup.sh` and `restore.sh` copy the folders of the profile directory only: a blob directory located elsewhere must be captured together with the PostgreSQL data by other means. See [Back Up and Restore TheHive Flow](../operations/backup-restore.md).

!!! warning "Switching back end doesn't migrate the blobs"
    The database references blobs by content hash without recording where they live. Pointing an existing installation at another back end, or at an empty directory, leaves every existing reference dangling: workflows reading files ingested before the switch fail at run time, not at startup.

<h2>Next steps</h2>

* [TheHive Flow Configuration Files](configuration-files-overview.md)
* [TheHive Flow Environment Variables](environment-variables.md)
* [Temporal Runtime Configuration](temporal-configuration.md)
* [Nginx Reverse Proxy Configuration](nginx-configuration.md)
* [Troubleshoot TheHive Flow](../operations/troubleshooting.md)
