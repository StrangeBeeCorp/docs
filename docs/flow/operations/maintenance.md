# Maintain TheHive Flow

<!-- md:version 6.0 --> <!-- md:license One -->

Routine maintenance of a [TheHive Flow](../user-guides/about-flow.md) deployment covers tuning the run retention, keeping the disk under control, and upgrading the services.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Upgrade TheHive Flow

To upgrade TheHive Flow and the other services of the stack, see [Upgrade TheHive Flow with Docker Compose](../installation/upgrade-docker.md). The other services are PostgreSQL, Temporal, the object storage, and nginx. Their versions are pinned together in `versions.env`, at the root of the repository clone.

After an upgrade, check that your `thehive-flow/config/thehive-flow.yml` carries the blocks of the shipped one at the new version. `modules.runs.sync_temporal_retention` is one such block, and without it the run list and the Temporal history expire on different clocks. See [Temporal workflow history retention](#temporal-workflow-history-retention).

## Log rotation

Log rotation is configured once at the Docker daemon level. See [Docker log rotation](logging.md#configure-docker-log-rotation).

Check that rotation is active after installing or reinstalling Docker on a host:

```bash
docker inspect thehive-flow | jq '.[0].HostConfig.LogConfig'
```

## PostgreSQL routine maintenance

PostgreSQL runs `autovacuum` by default, so no manual table maintenance is required for normal operation.

Monitor table bloat periodically:

```bash
docker compose exec postgresql psql -U postgres -d thehive_flow -c "
  SELECT schemaname, tablename, n_dead_tup, n_live_tup,
         round(n_dead_tup::numeric / nullif(n_live_tup,0) * 100, 1) AS dead_pct
  FROM pg_stat_user_tables
  ORDER BY n_dead_tup DESC
  LIMIT 10;"
```

A `dead_pct` above 20% on a large table may indicate that autovacuum isn't keeping up. Force a manual vacuum if needed:

```bash
docker compose exec postgresql psql -U postgres -d thehive_flow \
  -c "VACUUM ANALYZE;"
```

## Temporal workflow history retention

Run retention has one knob: [`modules.runs.retention`](../configuration/flow-configuration.md#run-retention) in `thehive-flow/config/thehive-flow.yml`, with a default of 30 days. It governs three things at once:

* How long a run stays in the run list
* How long the [blob store](../configuration/flow-configuration.md#blob-store) keeps the files those runs reference
* How long Temporal keeps its execution history, because the stack enables `modules.runs.sync_temporal_retention`

TheHive Flow applies the value to the `default` namespace at startup and checks it again periodically. It also purges the runs older than the retention at every startup, then periodically, so frequent restarts don't postpone the purge.

A change takes effect for executions that complete after it's applied. It isn't retroactive in either direction. Raising the retention doesn't bring back history Temporal has already deleted. Those runs stay in the run list until `modules.runs.retention` expires their rows, with their details replaced by the message *This execution log is not available anymore*. There's no way to remove them earlier.

The key is absent from the shipped file. For the first change, add it under `modules.runs`, then recreate the `thehive-flow` service. A value of `168h` is 7 days. Omit the key entirely to keep the 30-day default.

```yaml
modules:
  runs:
    retention: 168h
```

```bash
docker compose up -d --force-recreate thehive-flow
```

!!! warning "Before shortening the retention"
    This includes the first restart after adding `sync_temporal_retention`. The sync is symmetric: it aligns the namespace down as readily as up, and shortening a namespace retention deletes the history beyond the new window. If your namespace currently holds more than `modules.runs.retention`, set `modules.runs.retention` to that longer value first, then recreate the service. Check what the namespace holds today with the `namespace describe` command below.

The minimum accepted value is `24h`. Below that, the run-list purge would delete runs whose Temporal history is still live, so TheHive Flow refuses to start rather than let the two stores diverge. TheHive Flow enforces that floor, which matches the minimum retention Temporal accepts for a namespace. Setting `0` turns retention off entirely, with no purge and no namespace sync.

Setting the retention on the namespace directly with `temporal operator namespace update --retention` isn't supported. TheHive Flow periodically converges the namespace back to `modules.runs.retention`. Two stores holding two different retentions is the state to avoid, because whichever one purges first leaves the other serving runs it can no longer describe.

Raising the retention keeps proportionally more Temporal history in PostgreSQL: a 30-day window holds roughly 10 times the history of a 72-hour one. Size the disk accordingly, per [PostgreSQL volume sizing](../installation/system-requirements.md#postgresql-volume-sizing), or lower `modules.runs.retention`. It also keeps more files in the blob store. See [Blob store volume sizing](../installation/system-requirements.md#blob-store-volume-sizing).

Check the current setting:

```bash
docker compose --profile admin run --rm temporal-admin \
  temporal operator namespace describe -n default --address temporal:7233
```

## Docker image cleanup

To remove dangling images after upgrades:

```bash
docker image prune -f
```

To show disk usage by Docker objects:

```bash
docker system df -v
```

The data of the stack lives in the `./postgresql/data` and `./s3-store/data` directories of the profile directory, mounted into the containers, not in Docker volumes. `docker volume prune` and `docker compose down -v` therefore don't touch it. Check the size of the two directories with:

```bash
du -sh ./postgresql/data ./s3-store/data
```

!!! danger "The reset script deletes everything"
    `bash ./scripts/reset.sh` stops the stack and deletes the two data directories, the rendered Temporal configuration, TheHive API key file, the TLS certificates, and `.env` with every secret. It asks for confirmation, and nothing it deletes is recoverable except from a [backup](backup-restore.md). Use it to start over on a test host only.

## Backup rotation

Delete backup folders older than 30 days, along with their log files:

```bash
find /opt/backups/thehive-flow -mindepth 1 -maxdepth 1 -type d -mtime +30 -exec rm -rf {} +
find /opt/backups/thehive-flow -maxdepth 1 -name 'backup_log_*.log' -mtime +30 -delete
```

Schedule this alongside the backup cron. See [Schedule automated backups](backup-restore.md#optional-step-4-schedule-automated-backups).

## Health check cadence

Run these checks after every maintenance operation, and verify that all services are healthy, that TheHive Flow is live and ready, and that the logs show no unexpected errors:

```bash
docker compose ps -a
curl -fsS http://127.0.0.1:9090/livez
curl -fsS http://127.0.0.1:9090/readyz
docker compose logs --tail=50 thehive-flow
```

<h2>Next steps</h2>

* [Upgrade TheHive Flow with Docker Compose](../installation/upgrade-docker.md)
* [TheHive Flow Security Maintenance](security-maintenance.md)
* [Back Up and Restore TheHive Flow](backup-restore.md)
* [Monitor TheHive Flow](monitoring.md)
* [TheHive Flow Application Configuration](../configuration/flow-configuration.md)
