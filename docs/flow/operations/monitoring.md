# Monitor TheHive Flow

<!-- md:version 6.0 --> <!-- md:license One -->

[TheHive Flow](../user-guides/about-flow.md) exposes health endpoints and Prometheus metrics, and its Docker Compose stack ships built-in health checks plus an optional observability profile with a preconfigured Grafana dashboard and alert rules.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Health endpoints

The `orchestrator` service exposes its health on port 9090, published on loopback only: `127.0.0.1:9090`. There's no application-level authentication on this listener, so protect it with a host firewall if needed.

| Endpoint | What it checks | Expected response |
| -------- | -------------- | ----------------- |
| `GET /livez` | HTTP server is up | `200` with an empty body |
| `GET /readyz` | Internal modules, database connection, and Temporal client | `200`, or `503` with a JSON body naming each failing check |
| `GET /metrics` | Prometheus metrics exposition | `200` with text metric lines |

```bash
curl -fsS http://127.0.0.1:9090/livez
curl -fsS http://127.0.0.1:9090/readyz
```

A failing `/readyz` indicates that either PostgreSQL or the Temporal frontend is unreachable. The response body reports each check, `db`, `modules`, and `temporal`, with a coarse status such as `unreachable` or `timeout`, and deliberately leaves out the underlying error. Check `docker compose logs orchestrator` for the specific error, and see [Troubleshoot TheHive Flow](troubleshooting.md#health-and-readiness) for the common failure signatures.

The blob store isn't part of `/readyz`: it's checked once at startup with a `HeadBucket` request that aborts the boot if it fails. Object storage that breaks later shows up as failing runs rather than as a failing probe, so watch the `s3-store` container health and its disk instead.

### Disk alerting for the blob volume

The blob store has no garbage collection, so the `orchestrator-s3-data` volume [only grows](../installation/system-requirements.md#blob-store-volume-sizing). Nothing in the stack alerts on it, and when the volume fills, blob writes fail mid-run. Add a host-level disk alert on the Docker volume filesystem, the same one you would use for `orchestrator-postgres-data`:

```bash
docker system df -v | grep -E 'orchestrator-(postgres|s3)-data'
```

## Docker health checks

Docker monitors PostgreSQL, Temporal, and the object storage automatically. These health checks gate service startup: the `orchestrator` service doesn't start until PostgreSQL and Temporal are healthy and the object storage has been provisioned.

| Service | Check command | Interval | Retries | Start period |
| ------- | ------------- | -------- | ------- | ------------ |
| `postgresql` | `pg_isready -U postgres -d postgres` | 5 s | 12 | 30 s |
| `temporal` | `nc -z 127.0.0.1 7233` | 10 s | 30 | 60 s |
| `s3-store` | `curl -sf http://localhost:8333/healthz` | 5 s | 10 | 10 s |
| `init-s3-store` | None. One-shot container, gated on its exit code | — | — | — |
| `orchestrator` | None. Distroless image without a shell | — | — | — |

The object storage is gated differently from the other services: the `orchestrator` service waits for `init-s3-store` to complete successfully, not for `s3-store` to merely be healthy. A healthy `s3-store` service whose bucket doesn't exist isn't enough, because the blob store performs a `HeadBucket` request at startup and fails fast. The `init-s3-store` container runs to completion and exits, so `Exited (0)` is its normal steady state, not a failure.

View the current health status:

```bash
docker compose ps
```

## Prometheus scraping

Add the following job to your Prometheus configuration:

```yaml
scrape_configs:
  - job_name: orchestrator
    scrape_interval: 30s
    static_configs:
      - targets: ["<flow_host>:9090"]
```

Port 9090 is loopback-only by default. If it isn't reachable from your Prometheus server, publish it by adding the following to `docker-compose.override.yml`:

```yaml
services:
  orchestrator:
    ports:
      - "<host_ip>:9090:9090"
```

Apply the change:

```bash
docker compose up -d orchestrator
```

### Application metrics

Besides standard instrumentation for the REST server, the PostgreSQL connection pool, and the Temporal SDK client, the `/metrics` endpoint exposes the following application metrics:

| Metric | Type | Labels | Purpose |
| ------ | ---- | ------ | ------- |
| `beeflow_activity_calls_total` | Counter | `activity_type`, `outcome` | Workflow step executions. `outcome` is `success`, `error`, or `canceled`: alert on the `error` rate to catch failing steps |
| `beeflow_activity_duration_seconds` | Histogram | `activity_type`, `outcome` | Duration of workflow step executions |
| `beeflow_cache_hits_total`, `beeflow_cache_misses_total`, `beeflow_cache_evictions_total` | Counter | `cache_name` | In-process cache behavior |

Labels are bounded by design: metrics never carry run, workflow, or organization identifiers. To follow an individual run, use the [execution logs](../user-guides/display-execution-logs.md) instead. The [bundled dashboard](#bundled-observability-stack) covers Temporal only, so alerts on these metrics are yours to define.

As a starting point, the following Prometheus rule fires when more than 5% of workflow step executions fail, with the same threshold and pending period as the [bundled alert rules](#alert-rules):

```yaml
groups:
  - name: thehive-flow
    rules:
      - alert: FlowActivityErrorRateHigh
        expr: >
          sum(rate(beeflow_activity_calls_total{outcome="error"}[5m]))
          /
          sum(rate(beeflow_activity_calls_total[5m]))
          > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: More than 5% of TheHive Flow step executions are failing
```

To alert per step type instead of on the overall rate, aggregate with `sum by (activity_type)` in both halves of the expression.

## Temporal metrics

The `temporal` service exposes its own Prometheus metrics on port 8000. They cover the internals of the workflow engine, such as persistence latency and task backlog, and feed the [bundled dashboard](#bundled-observability-stack). The port is internal to the Docker network and isn't published on the host.

Publishing the port is only needed to scrape Temporal with your own Prometheus. With the bundled observability stack, the bundled Collector already reaches `temporal:8000` from inside the Docker network.

Publish the port in `docker-compose.override.yml`, binding it to an address your Prometheus server can reach. Use `127.0.0.1` if Prometheus runs on the same host.

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

## Bundled observability stack

A reference Grafana dashboard and alerting stack for Temporal ships under `observability/`, gated behind the `observability` Compose profile. It's off by default, the same way `temporal-admin` is gated behind `--profile admin`.

```bash
docker compose --profile observability up -d
```

If you already run your own Prometheus and Grafana, you don't need this profile: point your own OpenTelemetry Collector at `temporal:8000` instead. The bundled pipeline is designed as a drop-in you either use as is or swap pieces out of.

Adding the profile to an already-running deployment: pull the updated bundle, then run `bash ./scripts/init.sh` again before the command above. The script never touches an existing `.env` wholesale, but it backfills [`GRAFANA_ADMIN_PASSWORD`](../configuration/environment-variables.md) specifically if that key is missing or empty, which it is in any `.env` created before the profile existed. Skipping this step surfaces as Compose refusing to start with `GRAFANA_ADMIN_PASSWORD must be set in .env to use the observability profile`.

### Pipeline

```text
temporal:8000/metrics --(scrape)--> otel-collector --(re-expose :8889)--> prometheus --(query)--> grafana
```

The OpenTelemetry Collector, under `observability/otel-collector/`, is the only component that talks to Temporal Server directly. It never leaves the internal Docker network, and `temporal:8000` is never published to the host. The bundled Prometheus, under `observability/prometheus/`, only ever scrapes the Collector. To feed an existing stack instead of the bundled one, swap the Collector's `prometheus` exporter for your own back end's exporter, such as `otlphttp` or `prometheusremotewrite`.

### Access Grafana

Grafana is published on `http://127.0.0.1:3000`, loopback-only, following the same convention as the health listener on port 9090. Sign in with `admin` and the value of `GRAFANA_ADMIN_PASSWORD`, generated by `init.sh` into [`.env`](../configuration/environment-variables.md) like the other secrets. To rotate it, see [TheHive Flow Security](security.md#grafana-admin-password).

The dashboard lives in the **Temporal** folder and is provisioned from `observability/grafana/dashboards/temporal.json`. UI edits aren't persisted, because the dashboard is provisioned with `allowUiUpdates: false`: edit the file, not the UI, so changes survive a restart.

Grafana has no nginx or TLS front door: it's intentionally loopback-only, a second gate on top of the Grafana login. On a remote host, reach it by tunneling over SSH instead of publishing the port further:

```bash
ssh -L 3000:127.0.0.1:3000 <user>@<flow_host>
```

Then browse to `http://127.0.0.1:3000` on your own machine, and close the tunnel when done. Nothing in the stack expects Grafana to be reachable from anywhere but the host itself.

!!! note "Metric names differ from the raw Temporal names"
    The OpenTelemetry Collector's Prometheus receiver and exporter round-trip renames metrics per the OpenTelemetry and Prometheus conventions: counters gain a `_total` suffix, so `persistence_requests` becomes `persistence_requests_total`, and the relayed target's `job` and `instance` labels become `exported_job` and `exported_instance`. Every query in the bundled stack already accounts for this. It only matters if you query the bundled Prometheus directly.

### Dashboard panels

| Panel | Purpose |
| ----- | ------- |
| Service Availability | Server-wide gRPC success rate: the single health signal for Temporal that alerts can act on |
| Persistence Service Success % | Persistence errors are the most likely real-world failure mode on a single-node stack with a co-tenanted PostgreSQL |
| Persistence Requests Latency (p95, by operation) | Companion to the success panel: slow persistence shows up here before it shows up as errors |
| Task Schedule-to-Start Latency (p95, by task type) | Primary signal that workers can't keep up and a backlog is building, split by Workflow versus Activity task type |
| Available Worker Task Slots (avg) - Workflow | Capacity headroom explaining why schedule-to-start latency might be trending up, for Workflow-task workers |
| Available Worker Task Slots (avg) - Activity | Same signal for Activity-task workers. The built-in actions block on outbound calls, so these workers starve at least as easily |
| Shard Lock Latency (p99) | Shard-info lock contention in the history service, an early precursor to persistence slowdowns |
| Shard Distribution | Shards owned by this instance, pinned to 16 and immutable for the cluster's life. Flat on a single node |
| Service Calls (by service) | Request rate per internal Temporal service, read alongside the errors panel below |
| Service Errors (by service) (timeout/unavailable/internal/resource-exhausted) | Server-side gRPC error rate per internal service, with known-benign error types excluded |
| Target Health (Temporal Server & OTEL Collector) | Direct `up` for both scrape targets, plotted separately. Without it, a dead Collector and a dead Temporal Server look identical |

The two latency panels carry no color thresholds, and the matching alert thresholds below, 1 s and 5 s, are provisional defaults: a meaningful latency objective depends on your workload and expectations. Tune both the dashboard and the alert rules to your deployment.

### Alert rules

The following alerts are provisioned from `observability/grafana/provisioning/alerting/rules.yml` and evaluated by Grafana. Each maps to a dashboard panel above, though some panels are context-only and carry no alert. The pending period, the `for` field in `rules.yml`, is how long the condition must hold before the alert fires. No notification channel is configured: alerts are visible in the Grafana **Alerting** view via the built-in default contact point, but nothing notifies anyone until you wire a contact point of your own.

| Alert | Condition | Pending period | Severity |
| ----- | --------- | -------------- | -------- |
| TemporalServerTargetDown | `up{exported_job="temporal"} == 0` | 2 m | Critical |
| TemporalCollectorTargetDown | `up{job="otel-collector", exported_job=""} == 0` | 2 m | Critical |
| TemporalTaskScheduleToStartLatencyHigh | p95 schedule-to-start latency, Workflow or Activity, above 5 s | 5 m | Warning |
| TemporalPersistenceLatencyHigh | p95 persistence latency above 1 s | 5 m | Warning |
| TemporalPersistenceErrorRateHigh | Persistence Service Success % below 99% | 5 m | Critical |
| TemporalShardDistributionChanged | Number of shards owned by this instance changes within a 10-minute window | 1 m | Warning |
| TemporalServiceErrorRateHigh | Server-wide gRPC error rate above 5% of the request rate | 5 m | Warning |

`TemporalShardDistributionChanged` shouldn't fire in normal operation on this single-node stack, restarts included: the sole node always owns all 16 shards, so there's no transition to detect. If it fires, treat it as unexpected and investigate rather than dismissing it as noise.

!!! tip "Alerting in air-gapped networks"
    Grafana separates evaluating a rule from notifying someone through contact points such as SMTP, webhooks, or messaging APIs. In an air-gapped network, SaaS contact points are unreachable: point the contact point at something that already lives inside the boundary instead, such as an internal SMTP relay or a webhook into the ticketing or SIEM system already running, TheHive itself for example. That internal system then owns whatever happens next, and the alert never needs to leave the network.

### Conditions without bundled alerts

The bundled stack covers Temporal only. The following conditions remain manual to monitor, with your own tooling such as `node-exporter` or `cAdvisor`:

| Condition | How to detect | Severity |
| --------- | ------------- | -------- |
| TheHive Flow not ready | `/readyz` returns non-200 for more than 2 minutes | Critical |
| TheHive Flow not live | `/livez` returns non-200 for more than 30 seconds | Critical |
| PostgreSQL unhealthy | `docker compose ps` shows unhealthy | Critical |
| Disk above 80% on the PostgreSQL volume | `docker system df` | Warning |
| Container terminated by the OOM killer | Docker `oom` event | Critical |

## Check service status

To check all services at once:

```bash
docker compose ps
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
