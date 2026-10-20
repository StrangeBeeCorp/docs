# Manage TheHive Flow Logs

<!-- md:version 6.0 --> <!-- md:license One -->

Every service in a [TheHive Flow](../user-guides/about-flow.md) deployment logs to its container output, collected by the Docker daemon.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Access the logs

To read the last 200 lines of a specific service:

```bash
docker compose logs --tail=200 thehive-flow
docker compose logs --tail=200 temporal
docker compose logs --tail=200 postgresql
docker compose logs --tail=200 nginx
```

To follow a service in real time:

```bash
docker compose logs -f thehive-flow
```

To read all services since a point in time, for example `2h` for the last 2 hours:

```bash
docker compose logs --since <duration>
```

## Interpret the logs of each service

### The `thehive-flow` service

The `thehive-flow` service logs structured JSON. Every log line has at minimum `time`, `level`, and `msg`.

HTTP request lines add `server_name`, `http_method`, and `url_path`. Error lines add `error.cause`, `error.error`, and `error.stack`.

The access log line closing each request, whose `msg` is `HTTP request handled`, adds `http_status_code` and `duration`. When the request was rejected, it also carries the reason under `error`.

A rejected request is client behavior, so the service logs that line at INFO, not ERROR. Filtering on ERROR alone shows server faults and hides every rejection.

Depending on how the error was built, the rejection reason sits under `error.msg` or `error.cause.msg`: read both, as the second recipe below does.

To list server faults with `jq`:

```bash
docker compose logs --no-log-prefix thehive-flow 2>&1 \
  | grep '"level":"ERROR"' \
  | jq '{time, msg, error: (.error.error // .error.msg)}'
```

To list rejected requests, with both places the reason can sit:

```bash
docker compose logs --no-log-prefix thehive-flow 2>&1 \
  | grep '"msg":"HTTP request handled"' \
  | jq -c 'select(.http_status_code >= 400)
           | {time, http_status_code, url_path,
              reason: .error.msg, cause: .error.cause.msg}'
```

The `--no-log-prefix` flag is required: without it, Compose prefixes every line with the service name followed by `|`, and `jq` fails to parse.

Some rejections, such as an unrouted 404 or a 405, carry no `error` field at all, so `reason` is `null`. A 429 from the [webhook rate limiter](security.md#rate-limiting) does carry its reason.

#### Change the log level

Set the `BEEFLOW_LOG_LEVEL` environment variable on the `thehive-flow` service, in the `environment:` block of `docker-compose.yml` or in a `docker-compose.override.yml` file, as described in [Environment variable overrides](../configuration/flow-configuration.md#environment-variable-overrides). The value is a threshold: the service logs every line at that severity and above, so setting `warn` keeps the warning and error lines and drops the rest. The accepted values, from most to least verbose, are:

* `debug`: Adds verbose diagnostic detail, for investigation sessions
* `info`: Default value. Routine operations, including the request lines and rejection reasons described above
* `warn`: Warnings, such as the periodic retention sync warning
* `error`: Server faults only

```yaml
services:
  thehive-flow:
    environment:
      BEEFLOW_LOG_LEVEL: "warn"
```

Apply the change by recreating the service, because a plain restart doesn't re-read the file:

```bash
docker compose up -d thehive-flow
```

To change the level without recreating the container, call the `/loglevel` endpoint of the [observability listener](monitoring.md#health-endpoints) from the host:

```bash
curl -X PUT -H 'Content-Type: application/json' -d '{"level":"debug"}' http://127.0.0.1:9090/loglevel
```

The new level applies at once, and the change is logged as `log level changed at runtime`. It doesn't survive a restart of the container, which goes back to `BEEFLOW_LOG_LEVEL`. To read the current level, run `curl http://127.0.0.1:9090/loglevel`.

!!! warning "Raising the log level hides rejection reasons"
    Raising the level above INFO silences the rejection reasons in the container output. Server faults keep their ERROR line, and a configured OTLP logs export still receives everything, because the level applies per destination.

### The `temporal` service

The `temporal` service logs structured JSON in the Temporal schema. Watch for the following events:

* `history size exceeds warn limit`: A workflow history passed 10 MB. See [Troubleshoot TheHive Flow](troubleshooting.md#temporal-and-workflows)
* `history size exceeds error limit`: A workflow history passed 50 MB, and Temporal terminated the workflow
* Errors about updating or locking a shard: Temporal can't write its state to PostgreSQL, which points to a database issue

A workflow task that a worker takes but doesn't finish in time doesn't produce a log line. It shows as a `WorkflowTaskTimedOut` event in the workflow history.

### The `postgresql` service

PostgreSQL logs connection errors, authentication failures, and slow queries when configured. Turn on slow query logging by adding the following flags to the `command` of the `postgresql` service in `docker-compose.yml`. The *Production environment #2* profile already defines a `command` with memory settings: append the flags to it rather than replacing it.

```yaml
services:
  postgresql:
    command:
      - postgres
      - -c
      - log_min_duration_statement=1000
      - -c
      - log_connections=on
      - -c
      - log_disconnections=on
```

Apply the change. Recreating the database container briefly interrupts the whole stack:

```bash
docker compose up -d postgresql
```

### The `nginx` service

The access log format is `IP - - [timestamp] "METHOD path HTTP/version" status bytes "referer" "user-agent" "x-forwarded-for"`. The error log includes TLS handshake failures and upstream connection errors. At start, the `40-thehive-allow.sh` lines list the addresses nginx allows and skips for TheHive requests.

### The object storage services

The `s3-store` service logs the availability and storage errors of the object storage. The one-shot `init-s3-store` container logs the provisioning of the S3 identity and the bucket, with any failure prefixed with `FATAL:`. Read it with `docker compose logs init-s3-store`.

## Collect logs during an incident

Failing to collect these logs is the primary reason post-mortems can't determine a root cause. Collect the logs of all services as soon as you detect an incident.

| Service | Why it matters |
| ------- | -------------- |
| `thehive-flow` | Workflow run traces, JWT validation errors, HTTP errors, Temporal client errors |
| `temporal` | Workflow scheduling decisions, retry history, timeouts, task queue depth |
| `postgresql` | Connection errors, slow queries, schema migration status |
| `nginx` | Client IP, URL, HTTP status, TLS errors, upstream 502 and 504 errors |
| `s3-store` | Blob store availability and storage errors |
| `init-s3-store` | Provisioning errors on the S3 identity and the bucket, prefixed with `FATAL:` |

Collect a wider window than you think you need, at least 2 hours before the incident, because Temporal workflows can have long delays between task scheduling and execution. The following commands gather the logs of every service over the last 24 hours, the container state, and the versions, into one folder:

```bash
mkdir thehive-flow-diagnose-$(date -u +%Y%m%dT%H%M%SZ) && cd $_
docker compose -f ../docker-compose.yml logs --since 24h --no-color --timestamps > compose-logs.txt 2>&1
docker compose -f ../docker-compose.yml ps -a > compose-ps.txt
docker compose -f ../docker-compose.yml images > compose-images.txt
curl -sS http://127.0.0.1:9090/readyz > readyz.json
grep _image_version ../.env > versions.txt
cp ../thehive-flow/config/thehive-flow.yml .
```

The application logs don't carry secrets, but review `thehive-flow.yml` before sharing the folder, and never include `.env`, the files of `thehive-flow/secret/`, or the rendered Temporal configuration, which hold the secrets of the stack. Attach the folder, as an archive, to every support ticket.

## Configure Docker log rotation

Configure the Docker daemon to prevent log files from filling the disk. The configuration below caps each container at 300 MB of logs, three files of 100 MB. Apply it before starting the stack on a new host, because it only takes effect for newly created containers.

1. Create or edit `/etc/docker/daemon.json`:

    ```json
    {
      "log-driver": "json-file",
      "log-opts": {
        "max-size": "100m",
        "max-file": "3"
      }
    }
    ```

2. Restart Docker. Restarting the Docker daemon restarts every container of the stack, so schedule it like any other maintenance operation:

    ```bash
    systemctl restart docker
    ```

3. Verify that rotation is active:

    ```bash
    docker inspect thehive-flow \
      | jq '.[0].HostConfig.LogConfig'
    ```

    Rotation is active when the output shows the configured limits:

    ```json
    {
      "Type": "json-file",
      "Config": {
        "max-file": "3",
        "max-size": "100m"
      }
    }
    ```

    An empty `Config` object means the container was created before the daemon configuration: recreate it with `docker compose up -d` so the setting applies.

## Retain and archive the logs

The [rotation configured above](#configure-docker-log-rotation) deletes the oldest log lines once a container reaches its cap, so the host only ever holds the recent history. The minimum recommended retention for incident investigation is 30 days. A busy deployment can fill its 300 MB cap in far less time. To keep the full window, archive the logs off the host.

The Docker daemon log files are on the host filesystem under `/var/lib/docker/containers/<container_id>/`. For long-term retention or centralized log management, ship them to your SIEM or log aggregator, such as Loki, Elastic, or Splunk. Use a log shipper such as Promtail, Filebeat, or Fluentd.

<h2>Next steps</h2>

* [Monitor TheHive Flow](monitoring.md)
* [Troubleshoot TheHive Flow](troubleshooting.md)
* [TheHive Flow System Requirements](../installation/system-requirements.md)
