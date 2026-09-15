# Troubleshoot TheHive Flow

<!-- md:version 6.0 --> <!-- md:license One -->

When a [TheHive Flow](../user-guides/about-flow.md) deployment misbehaves, run the first steps below to locate the failing component, then look up your symptom in the tables.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## First steps for any incident

1. Check the container state:

    ```bash
    docker compose ps
    ```

2. Check the readiness:

    ```bash
    curl -fsS http://127.0.0.1:9090/readyz
    ```

3. Check the recent logs:

    ```bash
    docker compose logs --tail=100 orchestrator
    ```

4. Generate a full [support bundle](logging.md#collect-logs-during-an-incident):

    ```bash
    ./scripts/diagnose.sh
    ```

## Startup and initialization

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| The `orchestrator` service can't reach TheHive | `ORCHESTRATOR_THEHIVE_URL` unset or wrong | TheHive Flow reaches TheHive over an explicit URL, without a shared Docker network. Set [`ORCHESTRATOR_THEHIVE_URL`](../configuration/environment-variables.md) to TheHive address in `.env`, then run `docker compose up -d orchestrator` to recreate the container with the new value |
| The `temporal` service exits with `no usable database connection found` | `temporal/.resolved.yaml` is missing or has wrong permissions | Run `./scripts/init.sh` again. Verify with `ls -la temporal/.resolved.yaml`: the file must exist and be readable by the `temporal` container, mode 644 |
| The `orchestrator` service logs `Namespace default is not found` | The Temporal `default` namespace wasn't created during init | Run `./scripts/init.sh` again, or create it manually: `docker compose --profile admin run --rm temporal-admin temporal operator namespace create -n default --address temporal:7233` |
| The `orchestrator` service exits with `in-memory blob store is a unit-test-only backend` | The `blobstore:` block is missing from `orchestrator/orchestrator.yml`, or was overridden to `memory` | TheHive Flow requires a durable S3 backend. Restore the shipped [`blobstore:` block](../configuration/flow-configuration.md#blob-store) and run `docker compose up -d orchestrator` |
| `docker compose up` fails with `BEEFLOW_SECRET_S3_SECRET_ACCESS_KEY must be set in .env` | `.env` predates the bundled object storage | Run `./scripts/init.sh` again: it backfills the missing secret without touching the rest of `.env` |
| A run stays in the run list but its details can't be displayed, and the log repeats hourly: `retention sync: Temporal namespace retention differs from runs.retention` | `orchestrator/orchestrator.yml` predates the `modules.runs` block, so the Temporal namespace keeps a shorter retention than the run list and Temporal deletes the history first. Nothing crashes: the only signal is the hourly warning | Add the [`modules.runs` block](../configuration/flow-configuration.md#run-retention) and run `docker compose restart orchestrator`. Runs whose history is already deleted stay listed, without their details, until `modules.runs.retention` expires them. Raising the retention doesn't bring their history back |
| The `orchestrator` service exits at startup on a bucket or credentials error | `init-s3-store` didn't complete, or the credentials in `.env` no longer match the identity stored on the object storage | Check `docker compose logs init-s3-store`. Provision again with `docker compose up -d init-s3-store`, then `docker compose up -d orchestrator` |
| `init-s3-store` logs `FATAL: s3.configure failed` | The `s3-store` service rejected the identity setup | Check `docker compose logs s3-store`: the service must be healthy first. Then run `docker compose up -d init-s3-store` |
| `init-s3-store` logs `FATAL: the orchestrator S3 access key is absent from the store` | The identity setup reported no error but the access key isn't there | Check `docker compose logs s3-store`. If the store is healthy, recreate it and provision again: `docker compose up -d --force-recreate s3-store && docker compose up -d init-s3-store` |
| `init-s3-store` logs `FATAL: bucket orchestrator does not exist` | Bucket creation silently failed: the store answered but didn't create it | Check `docker compose logs s3-store` and the store disk with `docker system df -v`, then run `docker compose up -d init-s3-store` |
| `init-s3-store` shows `Exited (0)` in `docker compose ps` | Normal. It's a one-shot provisioning container: it configures the identity, asserts the bucket exists, then exits | Nothing to do. Only a non-zero exit code is a failure |
| `init-s3-store` never finishes and shows no exit code | It can't reach the `s3-store` master. Each provisioning call is bounded by a timeout | Check `docker compose logs s3-store` and `docker compose ps s3-store`. The `FATAL` message appears once the timeout fires |

## Docker engine access

TheHive Flow launches containers on the host Docker daemon to run [Python and JavaScript code transformations](../user-guides/configure-transformation-node.md). See [Docker engine access](../configuration/environment-variables.md#docker-engine-access) for how the endpoint is configured.

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| A code transformation fails with `permission denied` on the Docker socket | Group ID mismatch between the container process and the Docker socket | Compare `stat -c '%g' /var/run/docker.sock` with `DOCKER_GID` in `.env`. If they differ, delete `docker-compose.override.yml` and run `./scripts/init.sh` again |
| A code transformation fails with `cannot connect to Docker daemon at unix:///var/run/docker.sock` | Socket path mismatch, or the socket isn't mounted | Run `docker inspect orchestrator` and verify the socket appears under `Mounts`. Check `DOCKER_SOCKET_PATH` in `.env` |
| A code transformation fails with `cannot connect to Docker daemon` in TCP mode | `DOCKER_HOST` isn't reachable from inside the container | Don't use `localhost`: use the host IP. Verify with `docker compose exec orchestrator curl http://<host_ip>:<port>/v1.41/info` |

## Authentication and JWT

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| The log shows `token signature is invalid` | JWT key mismatch | Verify both sides use the exact same `JWT_SIGNING_KEY` value, and check for [stray quotes in the Docker Compose environment variable syntax](component-authentication.md#jwt-between-thehive-and-thehive-flow) |
| Requests from TheHive are rejected with an expired token error | Clock skew between TheHive and TheHive Flow hosts | Tokens expire 1 minute after signing, with a 30-second leeway. Compare `date` on both hosts and synchronize them with NTP |
| Requests from TheHive return 401 | API key missing or wrong | Check that `orchestrator/secret/thehive-api-key` contains the correct token, then run `docker compose restart orchestrator` |
| TheHive can't reach TheHive Flow over HTTPS with a self-signed certificate | TheHive JVM rejects the untrusted certificate | See [TLS with a self-signed certificate](../installation/docker.md#tls-with-a-self-signed-certificate): turn off certificate verification or trust the specific certificate |

## HTTP errors

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| A `500` response returns only `{"message":"Internal Server Error"}` with no detail | By design, `5xx` bodies hide internals in production to avoid leaking sensitive data | The real cause is always in the logs: `docker compose logs --tail=200 orchestrator`. To surface the full error over HTTP without turning off authentication, temporarily add `BEEFLOW_VERBOSE_ERRORS: "true"` to the `orchestrator` service `environment:` block, then run `docker compose up -d orchestrator`. This is a debug aid: remove it once done |

## Health and readiness

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| `/readyz` returns 503 | PostgreSQL or Temporal isn't reachable | Check `docker compose logs orchestrator` for `failed to connect to database` or `failed to create temporal client`, and `docker compose ps` for unhealthy services |
| `/livez` returns connection refused | The `orchestrator` container is down or crashed | Run `docker compose up -d orchestrator` and check `docker compose logs orchestrator` for crash details |
| The `orchestrator` container restarts in a loop | Startup error, such as a database that isn't healthy yet or a configuration error | Check `docker compose logs orchestrator` for `FATAL` entries. A common cause is a missing `temporal/.resolved.yaml`: run `./scripts/init.sh` |

## Nginx and connectivity

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| Nginx returns `502 Bad Gateway` | The `orchestrator` service isn't running or isn't ready yet | Run `docker compose restart orchestrator` and wait for `/livez` to return 200 |
| Nginx returns `504 Gateway Timeout` | The request took longer than 600 s | Check the workflow run duration. If legitimate, increase `proxy_read_timeout` in `nginx/templates/default.conf.template` |
| An interrupted upload returns an HTML error page instead of a JSON error | Nginx buffers request bodies, so it absorbs a stalled upload at its own `client_body_timeout` and answers before TheHive Flow sees it | Expected in this topology. The JSON `408` for a stalled body transfer is only returned when the API is exposed directly, or behind a proxy configured to stream request bodies through |
| TLS handshake error in the browser | The browser doesn't trust the self-signed certificate | Accept the browser security warning, or deploy a CA-signed certificate |
| Port 443 isn't reachable from outside the host | The port isn't open in the host firewall | Open the port: `firewall-cmd --add-port=443/tcp --permanent && firewall-cmd --reload` on RHEL, or `ufw allow 443` on Debian and Ubuntu |

## Temporal and workflows

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| The `temporal` service exits with `schema version mismatch` | The Temporal Server image was bumped without running schema migrations | Run the schema tool first: `docker compose --profile admin run --rm temporal-admin temporal-sql-tool --plugin postgres12 --ep postgresql -p 5432 -u temporal --pw <temporal_db_password> --db temporal update-schema -d /etc/temporal/schema/postgresql/v12/temporal/versioned` |
| A workflow run is stuck indefinitely | The Temporal worker isn't polling the task queue | Run `docker compose restart orchestrator`. If the issue persists, check the Temporal logs for the workflow history |
| The Temporal logs show `history size limit exceeded` | A workflow accumulated too many events, for example through a very large loop | Terminate the stuck workflow: `docker compose --profile admin run --rm temporal-admin temporal workflow terminate --workflow-id <workflow_id> --reason "history limit" --address temporal:7233` |

## Disk and resources

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| Disk full on the host | The PostgreSQL volume, blob store volume, Docker logs, or backup files grow unbounded | Check `docker system df -v`. [Rotate old backups](backup-restore.md#optional-step-4-schedule-automated-backups): `find ./backups \( -name "*.pgdump" -o -name "*.tar.gz" \) -mtime +30 -delete`. Shorten run retention by lowering [`modules.runs.retention`](../configuration/flow-configuration.md#run-retention): read the warning there first, because shortening deletes history. Configure [Docker log rotation](logging.md#configure-docker-log-rotation) |
| The blob store volume keeps growing | Expected: blobs are never deleted in this release, because there's no garbage collection | Check with `docker system df -v \| grep orchestrator-s3`. The only lever is more disk: see [Blob store volume sizing](../installation/system-requirements.md#blob-store-volume-sizing) |
| A container is terminated by the OOM killer | The memory limit is too low for the workload | Check `docker stats --no-stream`, increase `mem_limit` for the affected service in `docker-compose.yml`, then run `docker compose up -d <service>`. For the `orchestrator` service, raise `mem_limit`, `memswap_limit`, and [`GOMEMLIMIT`](../installation/system-requirements.md#go-memory-limit-of-the-orchestrator-service) together |
| The `s3-store` container is terminated by the OOM killer | Concurrent request volume exceeded the [512 MB cap](../installation/system-requirements.md#memory-limits-per-service), which is unrelated to how much data the store holds | Confirm with `docker inspect orchestrator-s3-store --format '{{.State.OOMKilled}}'`. Raise `mem_limit` and `memswap_limit` together in `docker-compose.override.yml`: raising only `mem_limit` lets the container swap instead of failing loudly |

## Get support

If the steps above don't resolve the issue, collect the support bundle and open a ticket:

```bash
DIAGNOSE_TICKET=SUP-XXXX \
DIAGNOSE_DESC="<one_line_description>" \
./scripts/diagnose.sh
```

Attach the produced `.tar.gz` file to the ticket. The support bundle contains sanitized logs, configuration, and container state. Secrets are redacted automatically. See [Collect logs during an incident](logging.md#collect-logs-during-an-incident) for details.

<h2>Next steps</h2>

* [Monitor TheHive Flow](monitoring.md)
* [Deploy TheHive Flow with Docker Compose](../installation/docker.md)
* [TheHive Flow Environment Variables](../configuration/environment-variables.md)
