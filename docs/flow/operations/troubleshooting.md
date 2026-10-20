# Troubleshoot TheHive Flow

<!-- md:version 6.0 --> <!-- md:license One -->

When a [TheHive Flow](../user-guides/about-flow.md) deployment misbehaves, run the first steps below to locate the failing component, then look up your symptom in the tables.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## First steps for any incident

1. Check the container state:

    ```bash
    docker compose ps -a
    ```

2. Check the readiness:

    ```bash
    curl -fsS http://127.0.0.1:9090/readyz
    ```

3. Check the recent logs:

    ```bash
    docker compose logs --tail=100 thehive-flow
    ```

4. Collect the logs of every service, as described in [Collect logs during an incident](logging.md#collect-logs-during-an-incident).

## Startup and initialization

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| `init.sh` stops with `Invalid TheHive URL` | The prompt for TheHive URL was left empty, or the value isn't an `http://` or `https://` address | Run `bash ./scripts/init.sh` again and enter TheHive address as reachable from the `thehive-flow` container, for example `http://<thehive_host>:9000` |
| `init.sh` stops with `Cannot read the Docker socket group` | The user running the script can't run Docker commands, or the Docker socket isn't at `/var/run/docker.sock` | Check that `docker run hello-world` works for that user, then run the script again |
| `init.sh` stops with `Initialisation did not complete due to permissions issue` | The files of the profile directory aren't owned by the user running the script, or their permissions are off, and the fix was declined | Run `bash ./scripts/check_permissions.sh` and accept the fix, or run `init.sh` again and answer `y` |
| The `thehive-flow` service can't reach TheHive | `flow_thehive_url` is wrong | TheHive Flow reaches TheHive over an explicit URL, without a shared Docker network. Set [`flow_thehive_url`](../configuration/environment-variables.md) to TheHive address in `.env`, then run `docker compose up -d thehive-flow` to recreate the container with the new value |
| An *Analyzer* or *Responder* [action node](../user-guides/configure-action-node.md) fails on a DNS error | `flow_thehive_url` points at a host name that doesn't resolve | The `/readyz` endpoint doesn't probe TheHive, so it stays `200` and the stack looks healthy. Fix the value in `.env`, then run `docker compose up -d thehive-flow` |
| The `thehive-flow` service exits at startup with `invalid api.public.url` | `flow_public_url` in `.env` isn't an absolute `http` or `https` URL, or it carries credentials, a query, or a fragment | Fix the value as described in [Public URL](../configuration/environment-variables.md#public-url), then run `docker compose up -d thehive-flow` |
| A webhook caller receives a `404` response, or can't connect, on the webhook URL | The [public URL](../configuration/environment-variables.md#public-url) doesn't match the address callers reach TheHive Flow at, typically behind another reverse proxy or a path prefix | Set `flow_public_url` in `.env` to the public address, then run `docker compose up -d thehive-flow` |
| The `thehive-flow` service exits at startup because no TheHive API key is set | Neither the `thehive-flow/secret/thehive-api-key` file nor `thehive_api_key` in `.env` holds a key. The `init.sh` script warns about it at the end of its run | [Provision the key](../installation/docker.md#step-9-provision-thehive-api-key), then run `docker compose up -d thehive-flow` |
| The `temporal` service exits with `no usable database connection found` | `temporal/config/temporal-server.yaml` is missing or holds a stale password | Run `bash ./scripts/init.sh` again: it renders the file from its template with the current password. Verify with `ls -la temporal/config/temporal-server.yaml`: the file must exist, at mode 600, owned by the user the stack runs as |
| The `thehive-flow` service logs `Namespace default is not found` | The Temporal `default` namespace wasn't created during init | Run `bash ./scripts/init.sh` again, or create it manually: `docker compose --profile admin run --rm temporal-admin temporal operator namespace create -n default --address temporal:7233` |
| The `thehive-flow` service exits with `in-memory blob store is a unit-test-only backend` | The `blobstore:` block is missing from `thehive-flow/config/thehive-flow.yml`, or was overridden to `memory` | TheHive Flow requires a durable back end, `s3` or `local`. Restore the shipped [`blobstore:` block](../configuration/flow-configuration.md#blob-store) and run `docker compose up -d --force-recreate thehive-flow` |
| The `thehive-flow` service exits at startup on a `blobstore.local.path` error | The back end is `local` and the path is missing, relative, or points to a directory that doesn't exist or isn't writable | The [local filesystem back end](../configuration/flow-configuration.md#local-filesystem-back-end) creates nothing itself: the path must be absolute, and the directory must exist, be writable by TheHive Flow, and pass the write test performed at startup. Fix the volume mount or its permissions, then run `docker compose up -d thehive-flow` |
| A run stays in the run list but opening it shows *This execution log is not available anymore*, and the log repeats hourly: `retention sync: Temporal namespace retention differs from runs.retention` | `thehive-flow/config/thehive-flow.yml` lost the `modules.runs` block. The Temporal namespace therefore keeps a shorter retention than the run list, and Temporal deletes the history first. Nothing crashes: the only signal is the hourly warning | Restore the [`modules.runs` block](../configuration/flow-configuration.md#run-retention) and run `docker compose up -d --force-recreate thehive-flow`. Runs whose history is already deleted stay listed, without their details, until `modules.runs.retention` expires them. Raising the retention doesn't bring their history back |
| The `thehive-flow` service exits at startup on a bucket or credentials error | `init-s3-store` didn't complete, or the credentials in `.env` no longer match the identity stored on the object storage | Check `docker compose logs init-s3-store`. Provision again with `docker compose up -d init-s3-store`, then `docker compose up -d thehive-flow` |
| `init-s3-store` logs `FATAL: s3.configure failed` | The `s3-store` service rejected the identity setup | Check `docker compose logs s3-store`: the service must be healthy first. Then run `docker compose up -d init-s3-store` |
| `init-s3-store` logs `FATAL: the thehive-flow S3 access key is absent from the store` | The identity setup reported no error but the access key isn't there | Check `docker compose logs s3-store`. If the store is healthy, recreate it and provision again: `docker compose up -d --force-recreate s3-store && docker compose up -d init-s3-store` |
| `init-s3-store` logs `FATAL: bucket thehive-flow does not exist` | Bucket creation silently failed: the store answered but didn't create it | Check `docker compose logs s3-store` and the free space of the disk holding `./s3-store/data`, then run `docker compose up -d init-s3-store` |
| `init-s3-store` shows `Exited (0)` in `docker compose ps -a` | Normal. It's a one-shot provisioning container: it configures the identity, asserts the bucket exists, then exits | Nothing to do. Only a non-zero exit code is a failure |
| `init-s3-store` never finishes and shows no exit code | It can't reach the `s3-store` master. Each provisioning call is bounded by a timeout | Check `docker compose logs s3-store` and `docker compose ps s3-store`. The `FATAL` message appears once the timeout fires |

## Docker engine access

TheHive Flow launches containers on the host Docker daemon to run [Python and JavaScript code transformations](../user-guides/configure-transformation-node.md). See [Docker engine access](../configuration/environment-variables.md#docker-engine-access) for how the socket is shared with the container.

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| A code transformation fails with `permission denied` on the Docker socket | The group of the Docker socket changed since the initialization, so `docker_gid` in `.env` no longer matches it | Run `bash ./scripts/init.sh` again to detect the group, then `docker compose up -d thehive-flow` |
| A code transformation fails with `Cannot connect to the Docker daemon at unix:///var/run/docker.sock` | The socket isn't mounted, or the Docker daemon doesn't listen on `/var/run/docker.sock` on this host | Run `docker inspect thehive-flow` and verify the socket appears under `Mounts`. The shipped `docker-compose.yml` mounts `/var/run/docker.sock`: on a host whose daemon listens elsewhere, point the volume entry of the `thehive-flow` service at the actual socket path |

## Authentication and JWT

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| The log shows `token signature is invalid` | JWT key mismatch | Verify both sides use the exact same `jwt_signing_key` value, and check for [stray quotes in the Docker Compose environment variable syntax](component-authentication.md#jwt-between-thehive-and-thehive-flow) |
| Requests from TheHive are rejected with an expired token error | Clock skew between TheHive and TheHive Flow hosts | Tokens expire 1 minute after signing, with a 30-second leeway. Compare `date` on both hosts and synchronize them with NTP |
| An *Analyzer* or *Responder* [action node](../user-guides/configure-action-node.md) fails with `401` | The API key that TheHive Flow uses to call TheHive is wrong or revoked | Check that `thehive-flow/secret/thehive-api-key` holds a valid TheHive API key, then run `docker compose restart thehive-flow`. If `thehive_api_key` is set in `.env`, it wins over the file: fix it there and run `docker compose up -d thehive-flow` instead |
| TheHive can't reach TheHive Flow over HTTPS with a self-signed certificate | The Java Virtual Machine (JVM) running TheHive rejects the untrusted certificate | See [TLS with a self-signed certificate](../installation/docker.md#tls-with-a-self-signed-certificate): turn off certificate verification or trust the specific certificate |

## HTTP errors

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| A `500` response returns only `{"message":"Internal Server Error"}` with no detail | By design, `5xx` bodies hide internals in production to avoid leaking sensitive data | The real cause is always in the logs: `docker compose logs --tail=200 thehive-flow`. To surface the full error over HTTP without turning off authentication, temporarily add `BEEFLOW_VERBOSE_ERRORS: "true"` to the `environment:` block of the `thehive-flow` service, then run `docker compose up -d thehive-flow`. This is a debug aid: remove it once done |

## Health and readiness

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| `/readyz` returns 503 | TheHive Flow is still starting or is shutting down, or PostgreSQL or Temporal isn't reachable | If the response body reports `modules` as `not ready` and the other checks as `ok`, startup is still in progress, which can take several minutes: wait and retry. Otherwise, check `docker compose logs thehive-flow` for `readyz check failed` lines: their `check` field names the failing dependency, `db` or `temporal`. At startup, the same failures appear as `failed to ping database` or `failed to create temporal client`. Also check `docker compose ps` for unhealthy services |
| `/livez` returns connection refused | The `thehive-flow` container is down or crashed | Run `docker compose up -d thehive-flow` and check `docker compose logs thehive-flow` for crash details |
| The `thehive-flow` container restarts in a loop | Startup error, such as a database that isn't healthy yet, a missing API key, or a configuration error | Check `docker compose logs thehive-flow` for the `failed to start` line, logged at `ERROR` level: its `error` field gives the cause. Look it up in [Startup and initialization](#startup-and-initialization) |

## Nginx and connectivity

### Check the path from TheHive host

When TheHive reports TheHive Flow in error, start from TheHive host and call the version endpoint through nginx. The endpoint needs no token, so the check isolates the network and nginx from the JWT and TheHive configuration:

```bash
curl -sk https://<nginx_server_name>/api/v1/version
```

* A JSON document whose `version` field holds the version of TheHive Flow means the path is open. The problem is on TheHive side: see [Authentication and JWT](#authentication-and-jwt), and check `flow.url` in TheHive configuration.
* A `403` means the address TheHive host calls from isn't in `nginx_thehive_addresses`: see the first rows of the table below. With a TheHive cluster, run the check from every node.
* A connection error means nginx isn't reachable: see the last rows of the table below.
* Without `-k`, a failure before the request is sent means `curl` doesn't trust the certificate. TheHive hits the same failure: see [TLS with a self-signed certificate](../installation/docker.md#tls-with-a-self-signed-certificate).

!!! example "Expected output"

    The version endpoint returns the version of TheHive Flow and the versions of the services it reached, trimmed here to the relevant fields:

    ```json
    {"version":"{% include-markdown "includes/thehive-latest-version.md" start="<!--start-fullversion-->" end="<!--end-fullversion-->" %}","dependencies":{"postgresql":"...","docker":"...","temporal":"..."}}
    ```

### Symptoms

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| TheHive can't reach TheHive Flow and nginx answers `403` to TheHive requests while webhooks work | [`nginx_thehive_addresses`](../configuration/environment-variables.md) in `.env` is empty, doesn't list the address TheHive calls from, or lists only entries nginx skipped because they cover the Docker network gateway | Set `nginx_thehive_addresses` to the addresses TheHive calls from, then run `docker compose up -d --no-deps nginx`. The `40-thehive-allow.sh` lines of `docker compose logs --no-log-prefix nginx` show what nginx allowed and skipped |
| The nginx log shows `access forbidden by rule` for TheHive requests | The `client:` address of that log line isn't in `nginx_thehive_addresses` | If it's the gateway of `thehive-flow-network`, see the next row. Otherwise, add that address to `nginx_thehive_addresses` in `.env`, then run `docker compose up -d --no-deps nginx` |
| The `client:` of refused TheHive requests in the nginx log is the `.1` address of `thehive-flow-network` | Docker relays the connection through `docker-proxy` and masks the source address | Don't add that address: nginx skips it. See [TheHive address filtering](security.md#thehive-address-filtering) |
| At start, nginx logs `skipping '<entry>'` | An entry of `nginx_thehive_addresses` isn't an IPv4 address or range, or covers the Docker network gateway | Fix the entry in `.env`, then run `docker compose up -d --no-deps nginx` |
| Nginx returns `502 Bad Gateway` | The `thehive-flow` service isn't running or isn't ready yet | Run `docker compose restart thehive-flow` and wait for `/livez` to return 200 |
| Nginx returns `502 Bad Gateway` right after a restart of the `thehive-flow` service | Nginx still uses the IP address it resolved before the restart, for up to 10 seconds | Wait a few seconds and retry. You don't need to restart nginx |
| Nginx returns `504 Gateway Timeout` | The request took longer than 600 s | Check the workflow run duration. If the duration is legitimate, increase `proxy_read_timeout` in `nginx/templates/default.conf.template` |
| An interrupted upload returns an HTML error page instead of a JSON error | Nginx buffers request bodies, so it absorbs a stalled upload at its own `client_body_timeout` and answers before TheHive Flow sees it | This is expected in this topology. TheHive Flow returns the JSON `408` for a stalled body transfer only when it's exposed directly, or behind a proxy configured to stream request bodies through |
| TLS handshake error in the browser | The browser doesn't trust the self-signed certificate | Accept the browser security warning, or deploy a certificate signed by a certificate authority (CA) |
| Port 443 isn't reachable from outside the host | The port isn't open in the host firewall | Open the port: `firewall-cmd --add-port=443/tcp --permanent && firewall-cmd --reload` on RHEL, or `ufw allow 443` on Debian and Ubuntu |

## Outbound connections

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| A workflow step fails with `egress guard: outbound connection to non-public address blocked`, for example an *HTTP request* node calling TheHive on a private network, or an *AI* node calling a locally hosted LLM provider | The step targets an address that resolves to a non-public IP address. By design, nodes that open outbound connections can't reach loopback, link-local, private, carrier-grade NAT, or reserved addresses unless the range is allowlisted | Add the target range to the [egress allowlist](../configuration/flow-configuration.md#egress-allowlist) in `thehive-flow/config/thehive-flow.yml`, then run `docker compose up -d --force-recreate thehive-flow` |

## Temporal and workflows

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| The `temporal` service exits with `sql schema version compatibility check failed: version mismatch` | The Temporal Server image moved to a new minor version without the schema upgrade | Run the [Temporal schema upgrade](../installation/upgrade-docker.md#optional-step-4-upgrade-the-temporal-schema) for the new version, then `docker compose up -d temporal` |
| A workflow run is stuck indefinitely | The Temporal worker isn't polling the task queue | Run `docker compose restart thehive-flow`. If the issue persists, check the Temporal logs for the workflow history |
| The Temporal logs show `history size exceeds warn limit` | A workflow history passed 10 MB, for example through a large loop. Above 50 MB, Temporal logs `history size exceeds error limit` and terminates the workflow itself | No action is needed: above 50 MB, Temporal terminates the workflow. To stop it sooner, terminate it: `docker compose --profile admin run --rm temporal-admin temporal workflow terminate --workflow-id <workflow_id> --reason "history limit" --address temporal:7233`. If a workflow regularly reaches the warning, reduce the data it carries between steps |
| With the blob store on the `local` back end, workflow steps reading files fail with a file-not-found error | The processes don't all see the same directory, because the deployment splits them across hosts or volumes, or the database was restored without the matching blob directory | Nothing detects this at startup. The [local filesystem back end](../configuration/flow-configuration.md#local-filesystem-back-end) requires every process to share one directory on one host. [Back up and restore](backup-restore.md) the database and the blob directory together |

## Disk and resources

| Symptom | Likely cause | Fix |
| ------- | ------------ | --- |
| Disk full on the host | The PostgreSQL data, the blob store data, Docker logs, or backup folders grow unbounded | Check `du -sh ./postgresql/data ./s3-store/data` and `docker system df`. [Rotate old backups](backup-restore.md#optional-step-4-schedule-automated-backups). Shorten run retention by lowering [`modules.runs.retention`](../configuration/flow-configuration.md#run-retention): read the warning there first, because shortening deletes history. Configure [Docker log rotation](logging.md#configure-docker-log-rotation) |
| The blob store directory keeps growing | Files follow [run retention](../configuration/flow-configuration.md#run-retention), so a long retention or a burst of large files fills the directory. Deletions may also be failing, for example when the S3 identity lacks the delete permission | Check with `du -sh ./s3-store/data`. Look for `blob-drain: could not delete file` in `docker compose logs thehive-flow`, and for `files_failed` and `files_pending` on the `blob-drain: processed queued file deletions` lines. See [Blob store volume sizing](../installation/system-requirements.md#blob-store-volume-sizing) |
| The OOM killer terminates a container | The memory limit is too low for the workload | Check `docker stats --no-stream`, raise the memory limit of the affected service in `docker-compose.yml`, under `deploy.resources.limits.memory` and `memswap_limit` together, then run `docker compose up -d <service>`. For the `thehive-flow` service, raise [`GOMEMLIMIT`](../installation/system-requirements.md#go-memory-limit-of-the-thehive-flow-service) with them |
| The OOM killer terminates the `s3-store` container | Concurrent request volume exceeded the [memory limit of the service](../installation/system-requirements.md#memory-limits-per-service), which is unrelated to how much data the store holds | Confirm with `docker inspect thehive-flow-s3-store --format '{{.State.OOMKilled}}'`. Raise `deploy.resources.limits.memory` and `memswap_limit` together in `docker-compose.yml`: raising only the first lets the container swap instead of failing loudly |

## Get support

If the steps above don't resolve the issue, collect the logs of every service as described in [Collect logs during an incident](logging.md#collect-logs-during-an-incident), and open a ticket with the archive attached. Describe the symptom, when it started, and the steps that reproduce it. Never attach `.env`, the files of `thehive-flow/secret/`, or the rendered Temporal configuration.

<h2>Next steps</h2>

* [Monitor TheHive Flow](monitoring.md)
* [Deploy TheHive Flow with Docker Compose](../installation/docker.md)
* [TheHive Flow Environment Variables](../configuration/environment-variables.md)
