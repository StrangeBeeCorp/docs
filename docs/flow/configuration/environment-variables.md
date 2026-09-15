# TheHive Flow Environment Variables

<!-- md:version 6.0 --> <!-- md:license One -->

The `.env` file at the root of [TheHive Flow](../user-guides/about-flow.md) Docker Compose directory holds secrets, versions, and runtime parameters. The [`init.sh` bootstrap script](../installation/docker.md#step-3-run-the-bootstrap-script) generates it from `.env.example`.

The file isn't committed to git—it's covered by `.gitignore`. Edit it directly on the host after bootstrap. To apply a change, recreate the service that reads the variable with `docker compose up -d <service>`, which is the `orchestrator` service for most variables: a plain `docker compose restart` reuses the existing container without re-reading `.env`.

## Variables

| Variable | Set by | Description |
| -------- | ------ | ----------- |
| `ORCHESTRATOR_VERSION` | Operator | Image tag of the `orchestrator` service. Bump it to update the binary. |
| `POSTGRES_USER` | Preset | PostgreSQL superuser. Default: `postgres`. |
| `POSTGRES_DB` | Preset | Maintenance database of the PostgreSQL instance. Default: `postgres`. |
| `POSTGRES_PASSWORD` | `init.sh` | PostgreSQL superuser password, a random 256-bit hex value. |
| `ORCHESTRATOR_DB_PASSWORD` | `init.sh` | Password of the `orchestrator` database user. |
| `TEMPORAL_DB_PASSWORD` | `init.sh` | Password of the `temporal` database user. |
| `S3_ACCESS_KEY_ID` | Operator | Access key ID of the bundled object storage. Not a secret, and optional: defaults to `orchestrator` when unset. |
| `BEEFLOW_SECRET_S3_SECRET_ACCESS_KEY` | `init.sh` | Secret access key of the bundled object storage, a random 256-bit hex value. Must be set: the stack won't start without it. |
| `JWT_SIGNING_KEY` | `init.sh` | HS256 symmetric key shared with TheHive. See [Configure TheHive to reach TheHive Flow](../installation/docker.md#step-6-configure-thehive-to-reach-thehive-flow). |
| `ORCHESTRATOR_THEHIVE_URL` | Operator | Required. URL of TheHive host reachable from the `orchestrator` container. |
| `BEEFLOW_SECRET_THEHIVE_API_KEY` | Operator | TheHive API key for outbound requests. Optional: leave it empty to use the `orchestrator/secret/thehive-api-key` file instead. The variable wins when both are set. See [Provision TheHive API key](../installation/docker.md#step-5-provision-thehive-api-key). |
| `DOCKER_SOCKET_PATH` | `init.sh` | Host Docker socket path, in Unix socket mode. |
| `DOCKER_GID` | `init.sh` | Group ID of the Docker socket, in Unix socket mode. |
| `DOCKER_HOST` | `init.sh` | Docker TCP endpoint, in TCP mode. |
| `nginx_server_name` | `init.sh` | Host name used in the TLS certificate. |
| `nginx_ssl_trusted_certificate` | `init.sh` | Filled when a custom certificate authority (CA) is provided. |
| `GRAFANA_ADMIN_PASSWORD` | `init.sh` | Grafana admin login, only used by the optional `--profile observability`. See [Monitor TheHive Flow](../operations/monitoring.md#bundled-observability-stack). |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | Operator | OTLP endpoint of your own observability back end, receiving the application traces, metrics, and logs. Optional: OTLP export is off when unset. |
| `OTEL_EXPORTER_OTLP_PROTOCOL` | Operator | OTLP transport protocol, for example `grpc`. |
| `OTEL_EXPORTER_OTLP_HEADERS` | Operator | Headers added to OTLP requests, such as an authorization token. |
| `OTEL_TRACES_SAMPLER` | Operator | Trace sampling strategy, for example `parentbased_traceidratio`. |
| `OTEL_TRACES_SAMPLER_ARG` | Operator | Argument of the sampling strategy, such as the ratio of traces to sample. |
| `OTEL_RESOURCE_ATTRIBUTES` | Operator | Extra resource attributes, such as a service namespace separating clients in a shared observability back end. |

!!! note "The two lowercase names are deliberate"
    `docker-compose.yml` reads `nginx_server_name` and `nginx_ssl_trusted_certificate` to fill the upper-case `SERVER_NAME` and `NGINX_SSL_TRUSTED_CERTIFICATE` template variables of the [nginx service](nginx-configuration.md). Don't rename them to upper case: the interpolation silently falls back to `localhost` as the server name.

## S3 credentials

The two object storage credentials travel together: the application rejects a configuration where exactly one of them is set. Only `BEEFLOW_SECRET_S3_SECRET_ACCESS_KEY` is strictly required in `.env`. Docker Compose refuses to start without it, while `S3_ACCESS_KEY_ID` falls back to `orchestrator` when unset or absent.

What matters is that the pair the `orchestrator` service uses matches what the `init-s3-store` container provisioned. Since both read the same two variables, they can't disagree unless `.env` is edited between the two starts. For the full behavior, including what changing a credential after first start involves, see the [blob store section](flow-configuration.md#blob-store) of the application configuration.

## Docker engine access

TheHive Flow launches containers on the host Docker daemon to run [Python and JavaScript code transformations](../user-guides/configure-transformation-node.md). The [`init.sh` script](../installation/docker.md#step-3-run-the-bootstrap-script) autodetects the endpoint, fills the `DOCKER_*` variables, and generates `docker-compose.override.yml` accordingly.

* Unix socket, the default on most installs: the socket is mounted into the `orchestrator` container, and the group owning the socket is added so the non-root process can use it. The group ID is detected automatically via `stat`.
* TCP endpoint: the `DOCKER_HOST` environment variable is passed into the container. The address must be reachable from inside the container, so use the host IP, not `localhost`.

If the Docker setup changes after the initial install, delete `docker-compose.override.yml` and run `./scripts/init.sh` again.

<h2>Next steps</h2>

* [TheHive Flow Configuration Files](configuration-files-overview.md)
* [TheHive Flow Application Configuration](flow-configuration.md)
* [Deploy TheHive Flow with Docker Compose](../installation/docker.md)
