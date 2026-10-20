# Temporal Runtime Configuration

<!-- md:version 6.0 --> <!-- md:license One -->

Temporal is the workflow engine of [TheHive Flow](../user-guides/about-flow.md). Its runtime knobs live in `temporal/config/dynamicconfig/production.yaml`. Temporal rereads most of this file automatically, so most changes apply without a restart.

The cluster configuration template, `temporal/config/temporal-server.yaml.template`, is rendered into `temporal/config/temporal-server.yaml` by `init.sh`, with the database password filled in. After editing the template, run `bash ./scripts/init.sh` again, then `docker compose restart temporal`. Without a custom certificate, the run also generates a new self-signed certificate: see [TLS certificate renewal](../operations/security.md#tls-certificate-renewal).

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Runtime knobs

| Knob | Value | Purpose |
| ---- | ----- | ------ |
| `limit.maxIDLength` | 255 | Allows long unique identifiers and scoped names in workflow definitions |
| `system.forceSearchAttributesCacheRefreshOnRead` | true | Refreshes the search attribute cache eagerly, avoiding a 60-second stale-read window when new attributes are registered |
| `limit.historyCount.suggestContinueAsNew` | 30 000 | Accommodates long retry chains and fan-out patterns |
| `matching.numTaskqueueReadPartitions` | 1 | Single-node deployment: colocation minimizes latency |
| `matching.numTaskqueueWritePartitions` | 1 | Single-node deployment: colocation minimizes latency |
| `matching.rps` | 4000 | Caps the rate of matching requests, sized from the sizing campaign's measured load |
| `history.transferProcessorMaxPollRPS` | 100 | Per-shard limiter on loading history tasks |
| `history.hostLevelCacheMaxSize` | 33 000 | Upper bound on the workflow-state cache, sized for the 1 GB Temporal [memory limit](../installation/system-requirements.md#memory-limits-per-service) of the *Production environment #1* profile |
| `history.cacheTTL` | 480s | How long an entry stays in the workflow-state cache before it's evicted |
| `history.cacheBackgroundEvict` | enabled, 15s interval, 1024 entries per call | Evicts expired cache entries in the background instead of only on access |

!!! note "The three history cache keys need a restart"
    `history.hostLevelCacheMaxSize`, `history.cacheTTL`, and `history.cacheBackgroundEvict` are read once, when Temporal builds the workflow-state cache, and background eviction can't be turned on live. Changing any of them requires `docker compose restart temporal`. Every other knob applies without a restart.

## Payload size limit

The stack leaves the Temporal per-payload error limit, `limit.blobSize.error`, at its 2 MiB default. TheHive Flow enforces its own budget, slightly under that value, on the variable payloads it evaluates. Those are [exit variables](../user-guides/glossary-flow.md#exit-variable), loop variables such as the ones a [*For each* flow](../user-guides/glossary-flow.md#for-each-flow) produces, and the [input variables](../user-guides/glossary-flow.md#input-variable) passed to another workflow. An evaluation whose combined result would cross 2 MiB fails fast with a clear error instead of stalling the run on a payload the server keeps rejecting.

That budget is fixed. Raising `limit.blobSize.error` to accept larger payloads has no effect on TheHive Flow, which still refuses the runs the higher server limit was meant to allow. The effective ceiling stays about 2 MiB either way, so keep the two aligned and leave `limit.blobSize.error` at its default.

<h2>Next steps</h2>

* [TheHive Flow Configuration Files](configuration-files-overview.md)
* [TheHive Flow Application Configuration](flow-configuration.md)
* [Monitor TheHive Flow](../operations/monitoring.md)
