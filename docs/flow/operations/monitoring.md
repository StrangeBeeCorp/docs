# Monitor TheHive Flow

<!-- md:version 6.0 --> <!-- md:license One -->

[TheHive Flow](../user-guides/about-flow.md) exposes health endpoints and Prometheus metrics. The Docker Compose stack ships built-in Docker health checks for its services. Dashboards and alerts come from your own monitoring platform, fed by these metrics.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Health endpoints

The `thehive-flow` service exposes its health on port 9090, published on loopback only: `127.0.0.1:9090`. There's no application-level authentication on this listener, so protect it with a host firewall if needed.

| Endpoint | What it checks | Expected response |
| -------- | -------------- | ----------------- |
| `GET /livez` | HTTP server is up | `200` with an empty body |
| `GET /readyz` | Internal modules, database connection, and Temporal client | `200`, or `503` with a JSON body naming each failing check |
| `GET /metrics` | Prometheus metrics exposition | `200` with text metric lines |

```bash
curl -fsS http://127.0.0.1:9090/livez
curl -fsS http://127.0.0.1:9090/readyz
```

A failing `/readyz` indicates that TheHive Flow is still starting or is shutting down, or that PostgreSQL or the Temporal frontend is unreachable. Startup can keep `/readyz` at `503` for several minutes. The first start pulls the [code transformation images](../installation/software-requirements.md#images-pulled-at-first-start) before the service reports ready, and any start can wait on the rebuild of the variable reference index. The response body reports a coarse status for each of the `db`, `modules`, and `temporal` checks, and deliberately leaves out the underlying error:

* `modules` reports `not ready` until startup completes, and again once shutdown begins.
* `db` and `temporal` report a status such as `unreachable`, `timeout`, or `error`.

Check `docker compose logs thehive-flow` for the specific error, and see [Troubleshoot TheHive Flow](troubleshooting.md#health-and-readiness) for the common failure signatures.

The blob store isn't part of `/readyz`. It's checked once at startup, with a `HeadBucket` request on the `s3` back end and a real write test on the [`local` back end](../configuration/flow-configuration.md#local-filesystem-back-end). A failed check aborts the boot. Storage that breaks later shows up as failing runs rather than as a failing probe. Watch the `s3-store` container health and its disk instead, or the disk holding the local blob directory.

### Disk alerting for the blob store

Files are deleted once the runs that use them are purged, but the blob store can still fill up. Causes include a burst of large files, a long `modules.runs.retention`, or deletions that keep failing. Nothing in the stack alerts on its size: TheHive Flow exposes no metric for the space left, and a full disk surfaces as blob writes failing mid-run. Whichever [back end](../configuration/flow-configuration.md#blob-store) holds the blobs, a host-level disk alert is the only signal, so treat it as mandatory rather than as a hardening step.

With the default `s3` back end, put the alert on the filesystem holding the `./s3-store/data` directory, the same one you'd use for `./postgresql/data`. Check their current size with:

```bash
du -sh ./postgresql/data ./s3-store/data
```

With the [local filesystem back end](../configuration/flow-configuration.md#local-filesystem-back-end), put it on the filesystem holding the `blobstore.local.path` directory.

Also alert on the deletion job's error lines in the `thehive-flow` logs. A pass that fails to delete files logs `blob-drain: could not delete file` at the `error` level, once per kind of failure, with a hint when the storage refused the permission. A database failure stops the pass with `blob-drain: could not process queued file deletions`, at the `error` level too. The summary line of each pass, `blob-drain: processed queued file deletions`, carries the `files_deleted`, `files_kept`, `files_skipped`, `files_recent`, `files_failed`, and `files_pending` counters.

## Docker health checks

Docker monitors PostgreSQL, Temporal, and the object storage automatically. These health checks gate service startup: the `thehive-flow` service doesn't start until PostgreSQL and Temporal are healthy and the object storage has been provisioned.

| Service | Check command | Interval | Retries | Start period |
| ------- | ------------- | -------- | ------- | ------------ |
| `postgresql` | `pg_isready -U postgres -d postgres` | 5 s | 12 | 30 s |
| `temporal` | `nc -z 127.0.0.1 7233` | 10 s | 30 | 60 s |
| `s3-store` | `curl -sf http://localhost:8333/healthz` | 5 s | 10 | 10 s |
| `init-s3-store` | None. One-shot container, gated on its exit code | — | — | — |
| `thehive-flow` | None. Distroless image without a shell | — | — | — |
| `nginx` | None | — | — | — |

The object storage is gated differently from the other services: the `thehive-flow` service waits for `init-s3-store` to complete successfully, not only for `s3-store` to be healthy. A healthy `s3-store` service whose bucket doesn't exist isn't enough, because the blob store performs a `HeadBucket` request at startup and fails fast. The `init-s3-store` container runs to completion and exits, so `Exited (0)` is its normal steady state, not a failure.

View the current health status:

```bash
docker compose ps -a
```

## Prometheus scraping

Add the following job to your Prometheus configuration:

```yaml
scrape_configs:
  - job_name: thehive-flow
    scrape_interval: 30s
    static_configs:
      - targets: ["<flow_host>:9090"]
```

Port 9090 is loopback-only by default. If it isn't reachable from your Prometheus server, publish it on an address your Prometheus server can reach, by changing the `ports:` entry of the `thehive-flow` service in `docker-compose.yml`:

```yaml
services:
  thehive-flow:
    ports:
      - "<host_ip>:9090:9090"
```

Apply the change:

```bash
docker compose up -d thehive-flow
```

Make the change in `docker-compose.yml` rather than in a `docker-compose.override.yml` file: Compose adds the ports of an override file to those of the base file instead of replacing them.

### Application metrics

Besides standard instrumentation for the REST server, the PostgreSQL connection pool, and the Temporal SDK client, the `/metrics` endpoint exposes the following application metrics:

| Metric | Type | Labels | Purpose |
| ------ | ---- | ------ | ------- |
| `thehive_flow_activity_calls_total` | Counter | `activity_type`, `outcome` | Workflow step executions. `outcome` is `success`, `error`, or `canceled`: alert on the `error` rate to catch failing steps |
| `thehive_flow_activity_duration_seconds` | Histogram | `activity_type`, `outcome` | Duration of workflow step executions |
| `thehive_flow_cache_hits_total`, `thehive_flow_cache_misses_total`, `thehive_flow_cache_evictions_total` | Counter | `cache_name` | In-process cache behavior |

Labels are bounded by design: metrics never carry run, workflow, or organization identifiers. To follow an individual run, use the [execution logs](../user-guides/display-execution-logs.md) instead. No dashboard or alert rule ships with the stack, so alerts on these metrics are yours to define.

As a starting point, the following Prometheus rule fires when more than 5% of workflow step executions fail:

```yaml
groups:
  - name: thehive-flow
    rules:
      - alert: FlowActivityErrorRateHigh
        expr: >
          sum(rate(thehive_flow_activity_calls_total{outcome="error"}[5m]))
          /
          sum(rate(thehive_flow_activity_calls_total[5m]))
          > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: More than 5% of TheHive Flow step executions are failing
```

To alert per step type instead of on the overall rate, aggregate with `sum by (activity_type)` in both halves of the expression.

## Temporal metrics

The `temporal` service exposes its own Prometheus metrics on port 8000, configured in `temporal/config/temporal-server.yaml.template`. They cover the internals of the workflow engine, such as persistence latency and task backlog. The port is internal to the Docker network and isn't published on the host.

To scrape Temporal with your Prometheus, publish the port by adding a `ports:` entry to the `temporal` service in `docker-compose.yml`, binding it to an address your Prometheus server can reach. Use `127.0.0.1` if Prometheus runs on the same host.

```yaml
services:
  temporal:
    ports:
      - "<host_ip>:8000:8000"
```

Apply the change:

```bash
docker compose up -d temporal
```

Then add the scrape target to your Prometheus configuration:

```yaml
- job_name: temporal
  static_configs:
    - targets: ["<flow_host>:8000"]
```

The following Temporal signals are worth a dashboard panel or an alert on a single-node stack:

| Signal | Why it matters |
| ------ | -------------- |
| Server-wide gRPC success rate | The single health signal for Temporal that alerts can act on |
| Persistence request success rate and latency | Persistence errors are the most likely failure mode with a co-tenanted PostgreSQL, and slow persistence shows up in latency before it shows up as errors |
| Task schedule-to-start latency, by task type | Primary signal that TheHive Flow workers can't keep up and a backlog is building, split by Workflow versus Activity task type |
| Available worker task slots | Capacity headroom explaining why schedule-to-start latency trends up |
| Shard lock latency | Shard-info lock contention in the history service, an early precursor to persistence slowdowns |

## Conditions to alert on

Nothing in the stack sends notifications. The following conditions are worth an alert in your monitoring platform, with tooling such as `node-exporter` or `cAdvisor` for the host and container signals:

| Condition | How to detect | Severity |
| --------- | ------------- | -------- |
| TheHive Flow not ready | `/readyz` returns non-200 for more than 5 minutes, the time a [startup](#health-endpoints) can take | Critical |
| TheHive Flow not live | `/livez` returns non-200 for more than 30 seconds | Critical |
| Workflow steps failing | More than 5% of `thehive_flow_activity_calls_total` with `outcome="error"` over 5 minutes, as in the [rule above](#application-metrics) | Warning |
| PostgreSQL, Temporal, or the object storage unhealthy | `docker compose ps` shows unhealthy | Critical |
| Disk above 80% on the filesystem holding `./postgresql/data` or `./s3-store/data` | `df -h` on the filesystem | Warning |
| Container terminated by the OOM killer | Docker `oom` event | Critical |
| Temporal persistence error rate above 1%, or persistence latency above 1 s | Temporal metrics on port 8000 | Critical, Warning |

!!! tip "Alerting in air-gapped networks"
    In an air-gapped network, SaaS notification channels are unreachable. Point the notification channel of your monitoring platform at something that already lives inside the boundary instead, such as an internal SMTP relay or a webhook into a ticketing or SIEM system already running, for example TheHive itself. That internal system then owns whatever happens next, and the alert never needs to leave the network.

## Check service status

To check all services at once:

```bash
docker compose ps -a
```

To check detailed resource usage:

```bash
docker stats --no-stream
```

To check the PostgreSQL connectivity from the host:

```bash
docker compose exec postgresql pg_isready -U postgres
```

To check the database sizes:

```bash
docker compose exec postgresql psql -U postgres -c "\l+"
```

To check the Temporal connectivity:

```bash
docker compose --profile admin run --rm temporal-admin \
  temporal operator cluster health --address temporal:7233
```

<h2>Next steps</h2>

* [Troubleshoot TheHive Flow](troubleshooting.md)
* [Manage TheHive Flow Logs](logging.md)
* [TheHive Flow System Requirements](../installation/system-requirements.md)
* [TheHive Flow Environment Variables](../configuration/environment-variables.md)
* [Deploy TheHive Flow with Docker Compose](../installation/docker.md)
