# TheHive Flow Security Maintenance

<!-- md:version 6.0 --> <!-- md:license One -->

Keeping a [TheHive Flow](../user-guides/about-flow.md) deployment patched relies on updating each component independently.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Component update independence

Each component can be updated independently, with the constraints noted below. The detailed procedures live in [Maintain TheHive Flow](maintenance.md).

| Component | Update path | Constraint |
| --------- | ----------- | ---------- |
| TheHive Flow | Edit `FLOW_VERSION` in `.env`, then run [`./scripts/update.sh`](maintenance.md#update-thehive-flow) | Forward-compatible migrations are the intended contract but aren't yet enforced: verify schema compatibility before rolling back across a migration boundary |
| Nginx | Edit the image tag in `docker-compose.yml`, then run `docker compose up -d nginx` | No schema and no state, so fully independent |
| PostgreSQL, minor patch | Edit the image tag in `docker-compose.yml`, then run `docker compose up -d postgresql` | Data is preserved in the named volume. Minor patches are safe |
| PostgreSQL, major version | `pg_upgrade` or a dump and restore procedure | Breaking change requiring a coordinated procedure outside the stack |
| Temporal, minor patch | Edit the `temporalio/server` and `temporalio/admin-tools` image tags in `docker-compose.yml`, always to the same version, then run `docker compose up -d temporal` | Verify schema compatibility before upgrading. `upgrade-temporal.sh` refuses a mismatched image pair |
| Temporal, minor version with schema change | [`./scripts/upgrade-temporal.sh`](maintenance.md#update-the-other-services), a dry run by default, with `--apply` to execute | Runs schema migrations before recreating the server, and steps automatically through every intermediate minor version recorded in the bundled version manifest |
| SeaweedFS object storage | Edit the image tag and digest on both `s3-store` and `init-s3-store` in `docker-compose.yml`, then run `docker compose up -d init-s3-store` | Both services must be bumped together: they run the same image, and a drifted pair fails the bundle's own tests. Data is preserved in the `orchestrator-s3-data` volume. Stop the `orchestrator` service first, because recreating the store under a running instance surfaces as workflow steps failing on blob reads |

### Version coupling between Temporal and TheHive Flow

The Temporal Server version must be compatible with the Temporal SDK version embedded in TheHive Flow binary. Check TheHive Flow release notes before bumping Temporal Server. Upgrading Temporal independently is safe as long as the server stays within the SDK supported range, typically within two minor versions.

## Respond to a CVE

### CVE in TheHive Flow binary

Edit `.env` and set `FLOW_VERSION` to the patched tag, then pull and redeploy:

```bash
./scripts/update.sh
```

Downtime is under 30 seconds, with no database changes required.

### CVE in nginx

Edit `docker-compose.yml` to bump the nginx image tag and digest, then redeploy nginx only:

```bash
docker compose up -d nginx
```

The other services see no downtime. The nginx reload is graceful: in-flight requests complete before the old worker exits.

### CVE in the object storage

Edit `docker-compose.yml` to bump the tag and digest on both `s3-store` and `init-s3-store`, keeping the two image references identical. Then stop the `orchestrator` service, recreate the store, and provision it again:

```bash
docker compose stop orchestrator
docker compose up -d init-s3-store
docker compose up -d orchestrator
```

Blobs survive: they live in the `orchestrator-s3-data` volume, not in the image. Downtime lasts as long as the store restart plus provisioning. The `init-s3-store` container asserts that the identity and the bucket exist before exiting 0, so a failed provisioning shows up as a non-zero exit rather than as an `orchestrator` service that crash-loops later:

```bash
docker compose logs --tail=50 init-s3-store
```

### CVE in PostgreSQL

For a minor patch, edit `docker-compose.yml` to bump the PostgreSQL image tag and digest, then restart:

```bash
docker compose up -d postgresql
```

The `orchestrator-postgres-data` volume is preserved. Expect 10 to 30 seconds of downtime while TheHive Flow and Temporal reconnect.

### CVE in Temporal

For a minor patch without a schema change, edit `docker-compose.yml` to bump the `temporalio/server` and `temporalio/admin-tools` image tags and digests to the same version, then restart:

```bash
docker compose up -d temporal
```

In-flight workflow tasks are retried automatically after the restart.

### CVE in a base OS image

The PostgreSQL, Temporal, and nginx images are rebuilt by their maintainers with OS patches. When a new digest is published for the same tag, update `docker-compose.yml` with the new digest and redeploy the service.

## Version pinning policy

Every image in `docker-compose.yml` is pinned by both tag and immutable digest, in the form `image: name:tag@sha256:…`, except TheHive Flow image, which `FLOW_VERSION` pins by tag only. The `latest` tag is never used.

* `FLOW_VERSION` in `.env` is the only operator-tunable pin. It must always be a released tag, never `latest` or a branch name.
* The other image versions are maintained in the deployment bundle by StrangeBee. Operators update them by deploying a refreshed bundle, not by editing image references directly.

Verify that no image is missing its digest:

```bash
grep 'image:' docker-compose.yml | grep -v '@sha256:'
```

The only expected output is the `orchestrator` image, which is pinned by tag through `FLOW_VERSION`.

## TLS certificate expiry

Self-signed certificates generated by `init.sh` are valid for 365 days. Monitor the expiry:

```bash
openssl x509 -in ./nginx/certs/server.crt -noout -dates
```

Renew before expiry: see [TLS certificate renewal](security.md#tls-certificate-renewal).

For production deployments, use certificates signed by a trusted certificate authority (CA) and integrate with your certificate lifecycle management tooling, such as certbot or Vault PKI.

## Audit checklist

Run the following checks periodically. Monthly is recommended.

* All image digests in `docker-compose.yml` match the current published digests
* `FLOW_VERSION` is set to the latest stable release
* The `nginx/certs/server.crt` expiry is more than 60 days away
* The `.env` permissions are 600: `ls -la .env`
* The `orchestrator/secret/thehive-api-key` permissions are 644
* No secrets appear in the `docker compose logs` output
* The Temporal namespace retention matches [`modules.runs.retention`](maintenance.md#temporal-workflow-history-retention): `temporal operator namespace describe -n default`
* [Docker log rotation](logging.md#configure-docker-log-rotation) is configured: `docker inspect orchestrator | jq '.[0].HostConfig.LogConfig'`
* [Backup files](backup-restore.md) exist and are recent: `ls -lht ./backups/ | head -5`

<h2>Next steps</h2>

* [Maintain TheHive Flow](maintenance.md)
* [TheHive Flow Security](security.md)
* [Back Up and Restore TheHive Flow](backup-restore.md)
