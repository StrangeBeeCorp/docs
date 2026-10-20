# TheHive Flow Security Maintenance

<!-- md:version 6.0 --> <!-- md:license One -->

Keeping a [TheHive Flow](../user-guides/about-flow.md) deployment patched relies on the image versions StrangeBee pins in `versions.env`, at the root of the [StrangeBee Docker Compose repository](https://github.com/StrangeBeeCorp/docker/tree/main){target=_blank}, and on the upgrade route of each component.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Component upgrade route

Every image of the stack is pinned by tag in `versions.env`. StrangeBee moves the pins, and the [upgrade procedure](../installation/upgrade-docker.md) applies them: `git pull`, then `bash ./scripts/init.sh` to copy the new versions into `.env`, then `docker compose up -d`. The constraints below decide what else the upgrade of a component involves.

| Component | Variable in `versions.env` | Constraint |
| --------- | -------------------------- | ---------- |
| TheHive Flow | `thehive_flow_image_version` | Database migrations run at startup and are forward-only. Rolling back doesn't revert the schema: undoing a schema change requires restoring the backup taken before the upgrade |
| Nginx | `nginx_image_version` | No schema and no state, so fully independent |
| PostgreSQL, minor or patch version | `postgresql_image_version` | Data is preserved in `./postgresql/data`. Minor and patch versions are safe |
| PostgreSQL, major version | `postgresql_image_version` | Breaking change requiring `pg_upgrade` or a dump and restore procedure outside the stack, before the pin moves |
| Temporal, patch version | `temporal_image_version` | The `temporalio/server` and `temporalio/admin-tools` images share the pin and always move together |
| Temporal, minor version | `temporal_image_version` | Requires the [Temporal schema upgrade](../installation/upgrade-docker.md#optional-step-4-upgrade-the-temporal-schema) before the new server starts, one minor version at a time |
| SeaweedFS object storage | `seaweedfs_image_version` | The `s3-store` and `init-s3-store` services share the pin. Data is preserved in `./s3-store/data`. Stop the `thehive-flow` service before recreating the store, because recreating it under a running instance makes workflow steps fail on blob reads |

### Version coupling between Temporal and TheHive Flow

The Temporal Server version must be compatible with the Temporal SDK version embedded in TheHive Flow binary. Check TheHive Flow release notes before moving the Temporal pin yourself. Upgrading Temporal independently is safe as long as the server stays within the SDK supported range, typically within two minor versions.

## Respond to a CVE

The patched version of an image usually reaches `versions.env` with the next release: run the [upgrade procedure](../installation/upgrade-docker.md) to apply it. To apply a patch before StrangeBee publishes the pin, move the pin yourself in `versions.env`, run `bash ./scripts/init.sh` to copy it into `.env`, then recreate the affected service as described below. Without a custom certificate, each run of `init.sh` also generates a new self-signed certificate: see [TLS certificate renewal](security.md#tls-certificate-renewal). The next `git pull` then reports a conflict on `versions.env`: discard your local change with `git checkout -- ../versions.env` before pulling, since the upstream pin is at least as recent.

### CVE in TheHive Flow binary

Move `thehive_flow_image_version`, run `init.sh`, then recreate the service:

```bash
docker compose up -d thehive-flow
```

Downtime is brief. Database migrations, if the new version carries any, run at startup.

### CVE in nginx

Move `nginx_image_version`, run `init.sh`, then recreate nginx only:

```bash
docker compose up -d nginx
```

Docker recreates the nginx container, which is the only entry point of the stack. TheHive requests and webhook calls are refused for a few seconds, and long-running requests still in progress are cut. The other services keep running.

### CVE in the object storage

Move `seaweedfs_image_version`, run `init.sh`, then stop the `thehive-flow` service, recreate the store, and provision it again:

```bash
docker compose stop thehive-flow
docker compose up -d init-s3-store
docker compose up -d thehive-flow
```

Blobs survive: they live in `./s3-store/data`, not in the image. Downtime lasts as long as the store restart plus provisioning. The `init-s3-store` container asserts that the identity and the bucket exist before exiting 0. A failed provisioning therefore shows up as a non-zero exit rather than as a `thehive-flow` service that crash-loops later. To check the result, read the container logs:

```bash
docker compose logs --tail=50 init-s3-store
```

### CVE in PostgreSQL

For a minor or patch version, move `postgresql_image_version`, run `init.sh`, then recreate the service:

```bash
docker compose up -d postgresql
```

The `./postgresql/data` directory is preserved. Expect a brief downtime while TheHive Flow and Temporal reconnect.

### CVE in Temporal

For a patch version, move `temporal_image_version`, run `init.sh`, then recreate the server:

```bash
docker compose up -d temporal
```

Temporal retries in-flight workflow tasks automatically after the restart. For a new minor version, follow the [Temporal schema upgrade](../installation/upgrade-docker.md#optional-step-4-upgrade-the-temporal-schema) first.

### CVE in a base OS image

The maintainers of the PostgreSQL, Temporal, nginx, and SeaweedFS images rebuild them with OS patches under the same tag. Because the pins are tags, pulling the image again fetches the rebuilt one:

```bash
docker compose pull <service>
docker compose up -d <service>
```

## Version pinning policy

Every image of the stack is pinned by tag in `versions.env`, and `init.sh` copies the pins into `.env`, which `docker-compose.yml` reads. The `latest` tag is never used.

* StrangeBee maintains the pins. Operators move them by pulling the repository, not by editing image references in `docker-compose.yml`.
* The image of TheHive Flow follows TheHive releases: TheHive and TheHive Flow are released together and carry the same version number.
* A pin moved by hand, as described in [Respond to a CVE](#respond-to-a-cve), is a temporary measure until the next release.

Check that the running stack matches the pins:

```bash
grep _image_version ../versions.env
grep _image_version .env
docker compose images
```

## TLS certificate expiry

Self-signed certificates generated by `init.sh` are valid for 365 days. Monitor the expiry:

```bash
openssl x509 -in ./nginx/certs/server.crt -noout -dates
```

Renew the certificate before it expires, as described in [TLS certificate renewal](security.md#tls-certificate-renewal).

For production deployments, use certificates signed by a trusted certificate authority (CA) and integrate with your certificate lifecycle management tooling, such as certbot or Vault PKI.

## Audit checklist

Run the following checks periodically. Monthly is recommended.

* The pins in `.env` match the ones in `versions.env`, and the repository clone is up to date with the latest release
* The `nginx/certs/server.crt` expiry is more than 60 days away
* The `.env` permissions are 600: `ls -la .env`
* The `thehive-flow/secret/thehive-api-key` and `nginx/certs/server.key` permissions are 600, and `bash ./scripts/check_permissions.sh` reports no deviation
* [`nginx_thehive_addresses`](../configuration/environment-variables.md) in `.env` lists only the addresses TheHive currently calls from, and the `40-thehive-allow.sh` lines of `docker compose logs --no-log-prefix nginx` show what nginx allows and skips
* No secrets appear in the `docker compose logs` output
* The Temporal namespace retention matches [`modules.runs.retention`](maintenance.md#temporal-workflow-history-retention): `docker compose --profile admin run --rm temporal-admin temporal operator namespace describe -n default --address temporal:7233`
* [Docker log rotation](logging.md#configure-docker-log-rotation) is configured: `docker inspect thehive-flow | jq '.[0].HostConfig.LogConfig'`
* [Backup folders](backup-restore.md) exist and are recent: `ls -lt /opt/backups/thehive-flow | head -5`

<h2>Next steps</h2>

* [Maintain TheHive Flow](maintenance.md)
* [TheHive Flow Security](security.md)
* [Back Up and Restore TheHive Flow](backup-restore.md)
