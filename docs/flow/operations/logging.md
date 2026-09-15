# Manage TheHive Flow Logs

<!-- md:version 6.0 --> <!-- md:license One -->

Every service of [TheHive Flow](../user-guides/about-flow.md) stack logs to its container output, collected by the Docker daemon.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Access the logs

To read the last 200 lines of a specific service:

```bash
docker compose logs --tail=200 orchestrator
docker compose logs --tail=200 temporal
docker compose logs --tail=200 postgresql
docker compose logs --tail=200 nginx
```

To follow a service in real time:

```bash
docker compose logs -f orchestrator
```

To read all services since a point in time, for example `2h` for the last two hours:

```bash
docker compose logs --since <duration>
```

## Interpret each service logs

### The `orchestrator` service

Structured JSON. Every log line has at minimum `time`, `level`, and `msg`.

HTTP request lines add `server_name`, `http_method`, and `url_path`. Error lines add `error.cause`, `error.error`, and `error.stack`.

The access log line closing each request, whose `msg` is `HTTP request handled`, adds `http_status_code` and `duration`. When the request was rejected, it also carries the reason under `error`.

A rejected request is client behavior, so that line is logged at INFO, not ERROR. Filtering on ERROR alone shows server faults and hides every rejection.

Depending on how the error was built, the rejection reason sits under `error.msg` or `error.cause.msg`: read both, as the second recipe below does.

To list server faults with `jq`:

```bash
docker compose logs --no-log-prefix orchestrator 2>&1 \
  | grep '"level":"ERROR"' \
  | jq '{time, msg, error: (.error.error // .error.msg)}'
```

To list rejected requests, with both places the reason can sit:

```bash
docker compose logs --no-log-prefix orchestrator 2>&1 \
  | grep '"msg":"HTTP request handled"' \
  | jq -c 'select(.http_status_code >= 400)
           | {time, http_status_code, url_path,
              reason: .error.msg, cause: .error.cause.msg}'
```

The `--no-log-prefix` flag is required: without it, Compose prefixes every line with the service name followed by `|`, and `jq` fails to parse.

Some rejections carry no `error` field at all, so `reason` is `null`: an unrouted 404, a 405, or the rate limiter's 429.

#### Change the log level

Set the `BEEFLOW_LOG_LEVEL` environment variable on the `orchestrator` service in `docker-compose.override.yml`. The value is a threshold: the service logs every line at that severity and above, so setting `warn` keeps the warning and error lines and drops the rest. The accepted values, from most to least verbose, are:

* `debug`: Adds verbose diagnostic detail, for investigation sessions
* `info`: Default value. Routine operations, including the request lines and rejection reasons described above
* `warn`: Warnings, such as the hourly retention sync warning
* `error`: Server faults only

```yaml
services:
  orchestrator:
    environment:
      BEEFLOW_LOG_LEVEL: "warn"
```

Apply the change by recreating the service, because a plain restart doesn't re-read the override file:

```bash
docker compose up -d orchestrator
```

!!! warning "Raising the log level hides rejection reasons"
    Raising the level above INFO silences the rejection reasons in the container output. Server faults keep their ERROR line, and a configured OTLP logs export still receives everything, because the level applies per destination.

### The `temporal` service

Structured JSON, in Temporal's own schema. Key events to watch for:

* `workflow task timeout`: A workflow is stuck, with no worker polling
* `history size limit exceeded`: A workflow accumulated too many events. See [Troubleshoot TheHive Flow](troubleshooting.md#temporal-and-workflows)
* `shard ownership lost`: Shouldn't happen on a single node and indicates a database issue

### The `postgresql` service

PostgreSQL logs connection errors, authentication failures, and slow queries when configured. Turn on slow query logging by adding the following to `docker-compose.override.yml`:

```yaml
services:
  postgresql:
    command: >
      postgres
      -c log_min_duration_statement=1000
      -c log_connections=on
      -c log_disconnections=on
```

Apply the change. Recreating the database container briefly interrupts the whole stack:

```bash
docker compose up -d postgresql
```

### The `nginx` service

The access log format is `IP - - [timestamp] "METHOD path HTTP/version" status bytes "referer" "user-agent" "x-forwarded-for"`. The error log includes TLS handshake failures and upstream connection errors.

## Collect logs during an incident

Failing to collect these logs is the primary reason post-mortems can't determine a root cause. Collect all four services as soon as an incident is detected.

| Service | Why it matters |
| ------- | -------------- |
| `orchestrator` | Workflow run traces, JWT validation errors, HTTP errors, Temporal client errors |
| `temporal` | Workflow scheduling decisions, retry history, timeouts, task queue depth |
| `postgresql` | Connection errors, slow queries, schema migration status |
| `nginx` | Client IP, URL, HTTP status, TLS errors, upstream 502 and 504 errors |

The `./scripts/diagnose.sh` script does this collection for you: it produces a sanitized tarball named `orchestrator-diagnose-<host>-<timestamp>.tar.gz`, covering versions, sanitized configuration, container state, volume sizes, and the last 24 hours of logs of all services, with secrets redacted.

```bash
./scripts/diagnose.sh
```

Collect a wider window than you think you need, at least 2 hours before the incident, because Temporal workflows can have long delays between task scheduling and execution. The log window is configurable through `DIAGNOSE_LOG_HOURS`.

Run interactively without variables, the script prompts for a ticket id, a description, and reproduction steps. Set the variables on the command line to skip the prompts, and attach the support bundle to every support ticket:

```bash
DIAGNOSE_TICKET=SUP-XXXX \
DIAGNOSE_DESC="<one_line_description>" \
./scripts/diagnose.sh
```

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
    docker inspect orchestrator \
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

The [rotation configured above](#configure-docker-log-rotation) deletes the oldest log lines once a container reaches its cap, so the host only ever holds the recent history. The minimum recommended retention for incident investigation is 30 days, and a busy deployment can fill its 300 MB cap in far less than that: to keep the full window, archive the logs off the host.

The Docker daemon log files are on the host filesystem under `/var/lib/docker/containers/<container_id>/`. For long-term retention or centralized log management, ship them to your SIEM or log aggregator, such as Loki, Elastic, or Splunk, using a log shipper such as Promtail, Filebeat, or Fluentd.

<h2>Next steps</h2>

* [Monitor TheHive Flow](monitoring.md)
* [Troubleshoot TheHive Flow](troubleshooting.md)
* [TheHive Flow System Requirements](../installation/system-requirements.md)
