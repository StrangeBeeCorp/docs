# Temporal Runtime Configuration

<!-- md:version 6.0 --> <!-- md:license One -->

Temporal is the workflow engine of [TheHive Flow](../user-guides/about-flow.md). Its runtime knobs live in `temporal/dynamicconfig/production.yaml`. Temporal reads this file every 10 seconds, so changes apply without a restart.

The cluster configuration template, `temporal/temporal-server.yaml`, is resolved by `init.sh` and rarely needs editing.

## Runtime knobs

| Knob | Value | Purpose |
| ---- | ----- | ------ |
| `limit.maxIDLength` | 255 | Allows long unique identifiers and scoped names in workflow definitions |
| `system.forceSearchAttributesCacheRefreshOnRead` | true | Refreshes the search attribute cache eagerly, avoiding a 60-second stale-read window when new attributes are registered |
| `limit.historyCount.suggestContinueAsNew` | 30 000 | Accommodates long retry chains and fan-out patterns |
| `matching.numTaskqueueReadPartitions` | 1 | Single-node deployment: colocation minimizes latency |
| `matching.numTaskqueueWritePartitions` | 1 | Single-node deployment: colocation minimizes latency |

## Payload size limit

The stack leaves the Temporal per-payload error limit, `limit.blobSize.error`, at its 2 MiB default. TheHive Flow enforces its own budget just under that value on the variable payloads it evaluates: [exit variables](../user-guides/glossary-flow.md#exit-variable), loop variables such as the ones a [*For each* flow](../user-guides/glossary-flow.md#for-each-flow) produces, and the [entry variables](../user-guides/glossary-flow.md#entry-variable) passed to another workflow. An evaluation whose combined result would cross 2 MiB fails fast with a clear error instead of stalling the run on a payload the server keeps rejecting.

That budget is fixed: raising `limit.blobSize.error` to accept larger payloads has no effect on TheHive Flow, which still refuses the very runs the higher server limit was meant to allow. The effective ceiling stays about 2 MiB either way, so keep the two aligned and leave `limit.blobSize.error` at its default.

<h2>Next steps</h2>

* [TheHive Flow Configuration Files](configuration-files-overview.md)
* [TheHive Flow Application Configuration](flow-configuration.md)
* [Monitor TheHive Flow](../operations/monitoring.md)
