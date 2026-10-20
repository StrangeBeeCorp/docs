# TheHive Flow Environment Variables

<!-- md:version 6.0 --> <!-- md:license One -->

The `.env` file at the root of the profile directory of [TheHive Flow](../user-guides/about-flow.md) holds the secrets, image versions, and runtime parameters of the stack. The [`init.sh` script](../installation/docker.md#step-7-initialize-the-stack) generates it from `dot.env.template`, from `versions.env` at the root of the repository, and from the values it detects or prompts for.

The file is covered by `.gitignore`, so it isn't committed to git, and it's readable by its owner only. Edit it directly on the host after the initialization. To apply a change, recreate the service that reads the variable with `docker compose up -d <service>`. For most variables, that's the `thehive-flow` service. A plain `docker compose restart` reuses the existing container without re-reading `.env`.

Running `init.sh` again rewrites the file from the template. The script keeps the secrets and the values it prompted for, and refreshes the image versions from `versions.env`. Without a custom certificate, it also generates a new self-signed certificate, as described in [TLS certificate renewal](../operations/security.md#tls-certificate-renewal). A line added by hand outside the keys the template declares doesn't survive: set extra container variables in the `environment:` block of the service instead, as described in [Optional container variables](#optional-container-variables).

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Variables

| Variable | Set by | Description |
| -------- | ------ | ----------- |
| `thehive_flow_image_version` | `versions.env` | Tag of the `docker.io/strangebee/thehive-flow` image. Copied from `versions.env` by `init.sh`, with the other image versions below. See [Upgrade TheHive Flow with Docker Compose](../installation/upgrade-docker.md). |
| `postgresql_image_version` | `versions.env` | Tag of the `postgres` image. |
| `temporal_image_version` | `versions.env` | Tag of the `temporalio/server` and `temporalio/admin-tools` images. |
| `seaweedfs_image_version` | `versions.env` | Tag of the `chrislusf/seaweedfs` image, used by the `s3-store` and `init-s3-store` services. |
| `nginx_image_version` | `versions.env` | Tag of the `nginx` image. |
| `postgres_password` | `init.sh` | PostgreSQL superuser password, a random 256-bit hex value. PostgreSQL reads it at its first start only. |
| `flow_db_password` | `init.sh` | Password of the `thehive_flow` database role. Each run of `init.sh` aligns the role with the value. |
| `temporal_db_password` | `init.sh` | Password of the `temporal` database role. Each run of `init.sh` aligns the role with the value and renders it into `temporal/config/temporal-server.yaml`. |
| `s3_access_key_id` | Preset | Access key ID of the shipped object storage. Not a secret. Default: `thehive-flow`. |
| `s3_secret_access_key` | `init.sh` | Secret access key of the shipped object storage, a random 256-bit hex value. See [S3 credentials](#s3-credentials). |
| `jwt_signing_key` | `init.sh` | HS256 symmetric key shared with TheHive. At least 32 characters: TheHive Flow doesn't start with a shorter key. See [Configure TheHive to reach TheHive Flow](../installation/docker.md#step-10-configure-thehive-to-reach-thehive-flow). |
| `flow_thehive_url` | `init.sh` | Required. URL of TheHive host reachable from the `thehive-flow` container. The `init.sh` script prompts for it and refuses an empty or malformed value. |
| `thehive_api_key` | Operator | TheHive API key for outbound requests. Optional: when empty, the `thehive-flow/secret/thehive-api-key` file is used instead. The variable wins when both are set. See [Provision TheHive API key](../installation/docker.md#step-9-provision-thehive-api-key). |
| `flow_public_url` | `init.sh` | Public URL at which callers reach TheHive Flow, used to build webhook URLs. Set to `https://<nginx_server_name>` at the first run and kept on later runs. See [Public URL](#public-url). |
| `UID`, `GID` | `init.sh` | User and group identifiers of the user who ran `init.sh`. The `postgresql`, `temporal`, `s3-store`, and `thehive-flow` services run as that user, which must keep read and write access to the profile directory. The other services, such as `nginx`, keep the default user of their image. |
| `docker_gid` | `init.sh` | Group identifier of the Docker socket, as seen from inside a container. Added to the groups of the `thehive-flow` container so that it can start code transformation containers. See [Docker engine access](#docker-engine-access). |
| `nginx_server_name` | `init.sh` | Host name used in the TLS certificate and as the nginx server name. |
| `nginx_ssl_trusted_certificate` | `init.sh` | Filled when a custom certificate authority (CA) is provided. |
| `nginx_thehive_addresses` | `init.sh` / Operator | Needed for TheHive to reach TheHive Flow. IPv4 addresses TheHive calls from, comma-separated. A range in Classless Inter-Domain Routing (CIDR) notation is also accepted. The `init.sh` script prompts for it and only warns when the answer is empty, without stopping. Nginx forwards TheHive requests only from these addresses, and refuses them from every address while the value is empty. Webhook calls aren't affected. Entries covering the Docker network gateway are skipped. A change is applied with `docker compose up -d --no-deps nginx`. |

The file also carries the image versions of the profiles of TheHive and Cortex, copied from `versions.env` with the others. The stack doesn't use them.

!!! note "The lowercase names are deliberate"
    `docker-compose.yml` reads the lowercase names to fill the variables of each container, such as `SERVER_NAME`, `NGINX_SSL_TRUSTED_CERTIFICATE`, and `NGINX_THEHIVE_ADDRESSES` for the [nginx service](nginx-configuration.md). Don't rename them to upper case: the interpolation silently falls back to an empty value.

## Variables of the `thehive-flow` container

The `docker-compose.yml` file passes the values of `.env` to the `thehive-flow` container under the names TheHive Flow reads:

| Container variable | Value | Role |
| ------------------ | ----- | ---- |
| `BEEFLOW_SECRET_JWT_SYMMETRIC_KEY` | `jwt_signing_key` | JWT signing key, injected into the `api.public.jwt.secret` key of [`thehive-flow.yml`](flow-configuration.md) |
| `BEEFLOW_SECRET_THEHIVE_API_KEY` | `thehive_api_key` | TheHive API key, read from the secret file when empty |
| `FLOW_DB_PASSWORD` | `flow_db_password` | Expanded into the PostgreSQL connection string of `thehive-flow.yml` |
| `FLOW_THEHIVE_URL` | `flow_thehive_url` | Expanded into the `modules.workers.activities.thehive.url` key of `thehive-flow.yml` |
| `BEEFLOW_API__PUBLIC__URL` | `flow_public_url` | Overrides the `api.public.url` key |
| `BEEFLOW_BLOBSTORE__S3__ACCESS_KEY_ID` | `s3_access_key_id` | Overrides the `blobstore.s3.access_key_id` key |
| `BEEFLOW_SECRET_S3_SECRET_ACCESS_KEY` | `s3_secret_access_key` | Secret access key of the object storage |
| `GOMEMLIMIT` | Fixed in `docker-compose.yml` | Go memory limit, sized for the memory limit of the profile. See [System Requirements](../installation/system-requirements.md#go-memory-limit-of-the-thehive-flow-service) |
| `OTEL_SERVICE_NAME`, `USER` | Fixed in `docker-compose.yml` | Service name of the telemetry, and user name required by the telemetry runtime |

### Optional container variables

The following variables aren't declared in `.env` or in the shipped `docker-compose.yml`. To set one, add it to the `environment:` block of the `thehive-flow` service, in `docker-compose.yml` or in a `docker-compose.override.yml` file created next to it, as described in [Environment variable overrides](flow-configuration.md#environment-variable-overrides). Then apply it with `docker compose up -d thehive-flow`.

| Variable | Description |
| -------- | ----------- |
| `BEEFLOW_LOG_LEVEL` | Log level threshold of the `thehive-flow` service. See [Change the log level](../operations/logging.md#change-the-log-level). |
| `BEEFLOW_CONFIG_FILES` | Comma-separated paths of configuration files inside the container, merged in order: a later file overrides the keys of an earlier one, and environment variables still override every file. The variable replaces the `-config /thehive-flow.yml` argument of the service, so list `/thehive-flow.yml` first. Mount each extra file in the `volumes:` block of the service. |
| `BEEFLOW_VERBOSE_ERRORS` | Set to `true` to return the full error details, cause chain and stack included, in `5xx` responses instead of a generic message. Authentication still applies. Debug aid only: never set it in production, since the details can reveal internal information. See [HTTP errors](../operations/troubleshooting.md#http-errors). |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | OTLP endpoint of an external observability back end, receiving the application traces, metrics, and logs. OTLP export is off when unset. |
| `OTEL_EXPORTER_OTLP_PROTOCOL` | OTLP transport protocol, for example `grpc`. |
| `OTEL_EXPORTER_OTLP_HEADERS` | Headers added to OTLP requests, such as an authorization token. |
| `OTEL_TRACES_SAMPLER` | Trace sampling strategy, for example `parentbased_traceidratio`. |
| `OTEL_TRACES_SAMPLER_ARG` | Argument of the sampling strategy, such as the ratio of traces to sample. |
| `OTEL_RESOURCE_ATTRIBUTES` | Extra resource attributes, such as a service namespace separating clients in a shared observability back end. |
| `SSL_CERT_FILE` | CA bundle replacing the system trust store of the container. See [TLS toward TheHive](../operations/security.md#tls-toward-thehive). |
| `BEEFLOW_MODULES__WORKERS__ACTIVITIES__MAX_CONCURRENT_ACTIVITY_TASK_POLLERS` | Number of Temporal pollers fetching activity tasks. When unset, the value of `32` from [`thehive-flow.yml`](flow-configuration.md#shipped-configuration) applies. A value of `0` lets the Temporal SDK decide, server-side autoscaling included. A higher value is only justified after measuring under load. A negative value stops TheHive Flow from starting. |
| `BEEFLOW_MODULES__WORKERS__WORKFLOWS__MAX_CONCURRENT_WORKFLOW_TASK_POLLERS` | Number of Temporal pollers fetching workflow tasks. When unset, the value of `32` from [`thehive-flow.yml`](flow-configuration.md#shipped-configuration) applies. A value of `0` lets the Temporal SDK decide, server-side autoscaling included. A higher value is only justified after measuring under load. A negative value or `1` stops TheHive Flow from starting. |

## S3 credentials

The two object storage credentials travel together: the application rejects a configuration where exactly one of them is set. The `init.sh` script generates `s3_secret_access_key` and keeps `s3_access_key_id` at its preset value, `thehive-flow`.

The pair the `thehive-flow` service uses must match what the `init-s3-store` container provisioned. Because both read the same two variables, they can't disagree unless `.env` is edited between the two starts. For the full behavior, including what changing a credential after first start involves, see the [blob store section](flow-configuration.md#blob-store) of the application configuration.

## Public URL

`flow_public_url` is the public URL at which callers reach the root of TheHive Flow. TheHive Flow builds the URL of each [*Webhook* trigger](../user-guides/add-trigger.md#add-a-webhook-trigger) from it, as `<flow_public_url>/webhook/<webhook_id>`. Webhook callers use this address directly, not through TheHive, so it must be reachable from each of them.

The `init.sh` script sets it to `https://<nginx_server_name>` at the first run, which suits a standard installation, and keeps the value on later runs. Change it only when callers reach TheHive Flow through another reverse proxy, host name, path prefix, or port, then run `docker compose up -d thehive-flow`. With a path prefix, the proxy in front must remove the prefix before forwarding requests to TheHive Flow.

The value is checked at startup. TheHive Flow doesn't start if it's malformed. It must be an absolute `http` or `https` URL with a host, and without credentials, a query, or a fragment.

## Docker engine access

TheHive Flow launches containers on the host Docker daemon to run [Python and JavaScript code transformations](../user-guides/configure-transformation-node.md). The `docker-compose.yml` file mounts the Docker socket, `/var/run/docker.sock`, into the `thehive-flow` container, and adds the group owning the socket to the container process, so that the non-root process can use it. The [`init.sh` script](../installation/docker.md#step-7-initialize-the-stack) detects that group by reading the socket from inside a throwaway container and writes it to `docker_gid`. The detection therefore also works where the socket group differs between the host and the containers, such as Docker Desktop.

If the Docker setup changes after the initial install, run `bash ./scripts/init.sh` again to detect the group again, then apply it with `docker compose up -d thehive-flow`. A Docker daemon reachable over TCP only isn't supported by the shipped file.

Mounting the socket grants the `thehive-flow` container root-equivalent access to the host, as mounting it in Cortex does for analyzers. See [Code transformation isolation](../operations/security.md#code-transformation-isolation).

<h2>Next steps</h2>

* [TheHive Flow Configuration Files](configuration-files-overview.md)
* [TheHive Flow Application Configuration](flow-configuration.md)
* [Deploy TheHive Flow with Docker Compose](../installation/docker.md)
