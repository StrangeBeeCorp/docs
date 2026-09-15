# Maintain TheHive Flow

<!-- md:version 6.0 --> <!-- md:license One -->

Routine maintenance of a [TheHive Flow](../user-guides/about-flow.md) deployment covers updating the services, tuning the run retention, and keeping the disk under control.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Update TheHive Flow

Updating the `orchestrator` binary is the most common maintenance operation. Only the `orchestrator` container is affected: PostgreSQL and Temporal remain running.

1. Edit `.env` and set [`FLOW_VERSION`](../configuration/environment-variables.md) to the new released tag. Never use `latest`.

2. Run the update script:

    ```bash
    ./scripts/update.sh
    ```

The script pulls the new image, stops the `orchestrator` container, verifies that the object storage is up and provisioned, recreates the container, and waits up to 120 seconds for `/readyz` to return 200. Expected downtime is under 30 seconds.

The script never touches [`orchestrator/orchestrator.yml`](../configuration/flow-configuration.md): that file is yours, so configuration blocks introduced by a newer version aren't added to an existing installation by updating. After an update, compare your file with the shipped `orchestrator/orchestrator.yml` from the new deployment bundle and add what's missing. `modules.runs.sync_temporal_retention` is one such block, and without it the run list and the Temporal history expire on different clocks. See [Temporal workflow history retention](#temporal-workflow-history-retention).

To roll back, revert `FLOW_VERSION` in `.env` and run `./scripts/update.sh` again. Forward-compatible database migrations are the intended contract but aren't yet enforced: verify schema compatibility before rolling back the binary across a migration boundary.

## Update the other services

These updates restart the affected service. Nginx reloads gracefully, but a PostgreSQL restart interrupts the whole stack for 10 to 30 seconds, and a Temporal upgrade with schema migrations takes longer: schedule those two in a maintenance window.

Edit the image tag and digest in `docker-compose.yml`, then recreate the affected service.

For nginx, which holds no state:

```bash
docker compose up -d nginx
```

For a PostgreSQL minor patch, with the data preserved in the named volume:

```bash
docker compose up -d postgresql
```

For a Temporal minor patch, with the state preserved in PostgreSQL, bump `temporalio/server` and `temporalio/admin-tools` to the same version, because `upgrade-temporal.sh` refuses a mismatched pair:

```bash
docker compose up -d temporal
```

Temporal Server upgrades, image and schema migrations together, are handled by `./scripts/upgrade-temporal.sh`. Without flags it's a dry run: it prints the current and target versions, the step plan, and the pending schema migrations, and changes nothing. Pass `--apply` to execute: the script then stops the `orchestrator` service for the whole upgrade window, asks for confirmation unless `--yes` is passed, and first dumps the `temporal`, `temporal_visibility`, and `orchestrator` databases under `./backups/temporal-preupgrade-<timestamp>/`. An exit code of `2` means the upgrade applied but the final shard verification was skipped. When the running server is more than one minor version behind, the script steps through the intermediate minor versions one at a time, landing on the latest recorded patch of each, using the version manifest shipped in the bundle, `temporal-version-history.json`. It refuses to step through any intermediate version missing from the manifest, and refuses a target absent from it whenever the running version is recorded there: only versions vetted and pinned by StrangeBee appear in it.

The stepping path supports Temporal images 1.30 or later. Earlier server releases don't honor the configuration file path the stack relies on and crash-loop, and earlier `admin-tools` images hang on the schema tool. This isn't a practical limitation, because the stack has never shipped anything older than 1.30.4.

PostgreSQL major-version upgrades aren't covered by the stack. Refer to [Upgrading a PostgreSQL Cluster](https://www.postgresql.org/docs/current/upgrading.html){target=_blank} in the PostgreSQL documentation.

## Log rotation

Log rotation is configured once at the Docker daemon level. See [Docker log rotation](logging.md#configure-docker-log-rotation).

Check that rotation is active after installing or reinstalling Docker on a host:

```bash
docker inspect orchestrator | jq '.[0].HostConfig.LogConfig'
```

## PostgreSQL routine maintenance

PostgreSQL runs `autovacuum` by default, so no manual table maintenance is required for normal operation.

Monitor table bloat periodically:

```bash
docker compose exec postgresql psql -U postgres -d orchestrator -c "
  SELECT schemaname, tablename, n_dead_tup, n_live_tup,
         round(n_dead_tup::numeric / nullif(n_live_tup,0) * 100, 1) AS dead_pct
  FROM pg_stat_user_tables
  ORDER BY n_dead_tup DESC
  LIMIT 10;"
```

A `dead_pct` above 20% on a large table may indicate that autovacuum isn't keeping up. Force a manual vacuum if needed:

```bash
docker compose exec postgresql psql -U postgres -d orchestrator \
  -c "VACUUM ANALYZE;"
```

## Temporal workflow history retention

Run retention has one knob: [`modules.runs.retention`](../configuration/flow-configuration.md#run-retention) in `orchestrator/orchestrator.yml`, with a default of 30 days. It governs both stores at once, how long a run stays in the run list and how long Temporal keeps its execution history, because the stack enables `modules.runs.sync_temporal_retention`. TheHive Flow applies the value to the `default` namespace at startup and checks it again hourly.

A change takes effect for executions that complete after it's applied. It isn't retroactive in either direction: raising the retention doesn't bring back history Temporal has already deleted, and those runs stay in the run list, with details that can no longer be displayed, until `modules.runs.retention` expires their rows. There's no way to remove them earlier.

The key is absent from the shipped file, so the first change means adding it under `modules.runs`, then restarting. A value of `168h` is seven days. Omit the key entirely to keep the 30-day default.

```yaml
modules:
  runs:
    retention: 168h
```

```bash
docker compose restart orchestrator
```

!!! warning "Before shortening the retention"
    This includes the first restart after adding `sync_temporal_retention`. The sync is symmetric: it aligns the namespace down as readily as up, and shortening a namespace retention deletes the history beyond the new window. If your namespace currently holds more than `modules.runs.retention`, set `modules.runs.retention` to that longer value first, then restart. Check what the namespace holds today with the `namespace describe` command below.

The minimum accepted value is `24h`. Below that, the run-list purge would delete runs whose Temporal history is still live, so TheHive Flow refuses to start rather than let the two stores diverge. That floor belongs to TheHive Flow, not to Temporal. Setting `0` turns retention off entirely: no purge, and no namespace sync.

Setting the retention on the namespace directly with `temporal operator namespace update --retention` isn't the supported path: TheHive Flow converges the namespace back to `modules.runs.retention` within the hour. Two stores holding two different retentions is the state to avoid, because whichever one purges first leaves the other serving runs it can no longer describe.

Raising the retention keeps proportionally more Temporal history in PostgreSQL: a 30-day window holds roughly ten times the history of a 72-hour one. Size the volume accordingly, per [PostgreSQL volume sizing](../installation/system-requirements.md#postgresql-volume-sizing), or lower `modules.runs.retention`.

Check the current setting:

```bash
docker compose --profile admin run --rm temporal-admin \
  temporal operator namespace describe -n default --address temporal:7233
```

## Docker image and volume cleanup

To remove dangling images after updates:

```bash
docker image prune -f
```

To show disk usage by Docker objects:

```bash
docker system df -v
```

Never run `docker volume prune` without verifying that neither `orchestrator-postgres-data` nor `orchestrator-s3-data` is included. Both hold durable client state: the first is the database, the second is the blob store with the ingested files and promoted activity outputs. Losing either is unrecoverable except from a [backup](backup-restore.md). Verify with:

```bash
docker volume ls | grep orchestrator
```

## Backup rotation

Delete backup artifacts older than 30 days, matching both halves of each pair:

```bash
find ./backups \( -name "*.pgdump" -o -name "*.tar.gz" \) -mtime +30 -delete
```

The pattern must match both extensions: the blob archive is by far the larger half, so purging only `*.pgdump` files would leave the archives accumulating forever. Schedule this alongside the backup cron. See [Schedule automated backups](backup-restore.md#optional-step-4-schedule-automated-backups).

## Health check cadence

Run these checks after every maintenance operation, and verify that all services are healthy, that TheHive Flow is live and ready, and that the logs show no unexpected errors:

```bash
docker compose ps
curl -fsS http://127.0.0.1:9090/livez
curl -fsS http://127.0.0.1:9090/readyz
docker compose logs --tail=50 orchestrator
```

<h2>Next steps</h2>

* [TheHive Flow Security Maintenance](security-maintenance.md)
* [Back Up and Restore TheHive Flow](backup-restore.md)
* [Monitor TheHive Flow](monitoring.md)
* [TheHive Flow Application Configuration](../configuration/flow-configuration.md)
