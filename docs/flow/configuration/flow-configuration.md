# TheHive Flow Application Configuration

<!-- md:version 6.0 --> <!-- md:license One -->

The `orchestrator/orchestrator.yml` file holds the application configuration of [TheHive Flow](../user-guides/about-flow.md). It's mounted read-only at `/orchestrator.yml` inside the `orchestrator` container.

After any change, restart the service:

```bash
docker compose restart orchestrator
```

## Shipped configuration

```yaml
secret_path: /secret        # Directory for API keys and secrets loaded at startup

temporal:
  addr: temporal:7233       # Temporal frontend — internal Docker network

database:
  postgres:
    connection_string: postgres://orchestrator:${ORCHESTRATOR_DB_PASSWORD}@postgresql:5432/orchestrator?sslmode=disable

blobstore:
  backend: s3              # Only backend selectable at runtime
  s3:
    endpoint: http://s3-store:8333   # Bundled object storage, internal to the stack
    bucket: orchestrator             # Created by init-s3-store before startup
    region: us-east-1                # Required for request signing
    use_path_style: true             # Required by non-AWS S3 gateways
    # Credentials aren't here: docker-compose.yml injects both from .env

api:
  public:
    enable: true
    addr: "0.0.0.0:8081"    # REST API — not published on host by default
    jwt:
      secret: ""            # Leave empty — injected via BEEFLOW_SECRET_JWT_SYMMETRIC_KEY env var

modules:
  observability:
    listener:
      addr: "0.0.0.0:9090"  # /livez, /readyz, /metrics endpoints
    metrics:
      prometheus:
        enabled: true
    pprof:
      enabled: false        # Enable only for profiling sessions
  runs:
    sync_temporal_retention: true   # Keeps the Temporal namespace retention aligned with runs.retention
  workers:
    activities:
      thehive:
        url: ${ORCHESTRATOR_THEHIVE_URL}   # Set in .env
        api_key: thehive-api-key   # Filename inside secret_path (/secret)
```

## Run retention

`modules.runs.retention` is the single knob for how long a run stays reachable. It drives both the purge of the run list and, because `sync_temporal_retention` is enabled in the shipped file, the history retention of the Temporal namespace.

The key is deliberately absent from the shipped file: leaving it out keeps the application default of 30 days. To use another value, add the key under `modules.runs` and restart the `orchestrator` service. To use the environment variable override instead, set `BEEFLOW_MODULES__RUNS__RETENTION=168h` in `docker-compose.override.yml` and apply it with `docker compose up -d orchestrator`. The namespace follows within the hour.

!!! danger "Shortening the retention deletes history"
    The Temporal namespace retention is aligned downward too. Lowering `modules.runs.retention` deletes the history of runs older than the new value, and that history can't be recovered by raising the value again.

For the operational details, including the 24-hour floor, the non-retroactive behavior, and how to check what the namespace currently holds, see [Temporal workflow history retention](../operations/maintenance.md#temporal-workflow-history-retention).

## Code transformation images

[Python and JavaScript code transformations](../user-guides/configure-transformation-node.md) run in disposable containers, launched for each execution and removed as soon as the script exits. The two default images are pinned by immutable digest in the application itself and don't appear in the shipped file:

| Language | Default image |
| -------- | ------------- |
| Python 3.11 | `gcr.io/distroless/python3-debian12` |
| JavaScript on Node.js 24 | `gcr.io/distroless/nodejs24-debian12` |

Both are distroless images that ship the language runtime and its standard library only. To make additional libraries available to scripts, or to pull from an internal registry on an air-gapped host, build or mirror an image and override the `image` key under `modules.codex.languages`, using the built-in language names:

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

## Environment variable overrides

Any value in `orchestrator.yml` can be overridden with an environment variable using the pattern `BEEFLOW_<SECTION>__<KEY>`, where a double underscore separates each nesting level. For example:

```bash
BEEFLOW_TEMPORAL__ADDR=temporal:7233
BEEFLOW_MODULES__OBSERVABILITY__LISTENER__ADDR=0.0.0.0:9091
```

Pass overrides in `docker-compose.override.yml` to avoid editing tracked files. For example:

```yaml
services:
  orchestrator:
    environment:
      BEEFLOW_MODULES__OBSERVABILITY__LISTENER__ADDR: "0.0.0.0:9091"
```

Apply an override change by recreating the service with `docker compose up -d orchestrator`: a plain restart doesn't re-read the override file.

## Blob store

TheHive Flow requires a durable S3-compatible object store: files ingested through [webhooks](../user-guides/add-trigger.md#add-a-webhook-trigger) or runs, and activity outputs too large to keep in the database, are stored there. The stack ships one, the `s3-store` service, so there's nothing to provision. Two properties are worth knowing:

* Both credentials travel together. The application rejects a configuration where exactly one of `access_key_id` and `secret_access_key` is set. With both empty it doesn't fail: it falls back to the AWS SDK credential chain, which against the bundled store means unsigned or wrong requests rather than a clear error. That's why `orchestrator.yml` leaves both blank and `docker-compose.yml` injects the pair from [`.env`](environment-variables.md#s3-credentials).
* Changing a credential after first start requires provisioning again. The store must learn the new identity: run `docker compose up -d init-s3-store`. This adds a credential rather than replacing one, so the old identity remains valid on the store. See [Rotate secrets](../operations/security.md#s3-secret-access-key) for the full procedure.

<h2>Next steps</h2>

* [TheHive Flow Configuration Files](configuration-files-overview.md)
* [TheHive Flow Environment Variables](environment-variables.md)
* [Temporal Runtime Configuration](temporal-configuration.md)
* [Nginx Reverse Proxy Configuration](nginx-configuration.md)
* [Troubleshoot TheHive Flow](../operations/troubleshooting.md)
