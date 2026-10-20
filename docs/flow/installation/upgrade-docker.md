# Upgrade TheHive Flow with Docker Compose

<!-- md:version 6.0 --> <!-- md:license One -->

Upgrade an existing [TheHive Flow](../user-guides/about-flow.md) Docker Compose deployment to a new version. TheHive Flow is released with TheHive and carries the same version number: upgrade both to that version in the same maintenance window. Upgrade TheHive Flow first, while TheHive is stopped. The upgrade preserves all your data.

!!! warning "Before you begin"
    To ensure a smooth upgrade, make sure you have:

    * A [cold backup](../operations/backup-restore.md) of the stack, taken with `backup.sh`. It captures the databases, the blobs of the shipped object storage, the configuration, and `.env` together, which is what a rollback needs. With an external object storage or the [local filesystem back end](../configuration/flow-configuration.md#local-filesystem-back-end), capture the blobs at the same time with your own tooling.
    * A scheduled maintenance window. The upgrade stops TheHive and TheHive Flow.
    * A time when as few workflows as possible are running. The upgrade doesn't wait for running workflows to finish: the new version resumes them from their recorded execution history.
    * TheHive [release notes](../../thehive/release-notes/release-notes-6.0.md) of the target version, to identify changes that may affect your deployment.

The commands below run from the profile directory, `prod1-thehive-flow` or `prod2-thehive-flow`, inside the clone of the [StrangeBee Docker Compose repository](https://github.com/StrangeBeeCorp/docker/tree/main){target=_blank}.

## Step 1: Stop TheHive

Stop TheHive before touching TheHive Flow, with the command matching how TheHive is deployed. TheHive stays stopped until TheHive Flow runs the new version.

!!! note "Cluster deployments"
    For cluster deployments, stop all TheHive nodes.

=== "Package installation"

    ```bash
    sudo systemctl stop thehive
    ```

=== "Docker Compose deployment"

    ```bash
    docker compose down
    ```

=== "Kubernetes deployment with Helm"

    Scale TheHive Deployment down to zero replicas:

    ```bash
    kubectl -n <thehive_namespace> scale deployment <thehive_deployment> --replicas=0
    ```

## Step 2: Get the new deployment files

StrangeBee releases a new version by moving the image versions pinned in `versions.env`, at the root of the repository. The same change can also touch `docker-compose.yml`, the scripts, the nginx template, the Temporal configuration, and the shipped `thehive-flow/config/thehive-flow.yml`.

1. Pull the new files into the clone:

    ```bash
    git pull
    ```

    The files you own aren't tracked by git and stay in place: `.env`, the data directories, `thehive-flow/secret/`, `certificates/`, `nginx/certs/`, and the rendered `temporal/config/temporal-server.yaml`. If you edited a tracked file, such as `thehive-flow/config/thehive-flow.yml` or `nginx/templates/default.conf.template`, `git pull` refuses to overwrite it: run `git stash`, pull again, then `git stash pop` and resolve any conflict.

2. Compare the new pins with the versions the stack runs, which `init.sh` copied into `.env` at the last initialization:

    ```bash
    grep _image_version ../versions.env
    grep _image_version .env
    ```

    Note which of `temporal_image_version` and `postgresql_image_version` change: they decide whether [Step 4](#optional-step-4-upgrade-the-temporal-schema) applies.

## Step 3: Stop TheHive Flow

Stop the application and nginx. PostgreSQL, Temporal, and the object storage keep running for the next steps:

```bash
docker compose stop thehive-flow nginx
```

## (Optional) Step 4: Upgrade the Temporal schema

Skip this step when `temporal_image_version` keeps the same minor version, such as `1.32.1` to `1.32.2`. A new Temporal minor version requires a database schema upgrade before the new server starts, and Temporal supports moving one minor version at a time only. StrangeBee moves the pin one minor version per release. If you skipped releases and the new pin is more than one minor version ahead of the running server, upgrade through each intermediate minor version, repeating this step and the next with each one.

Run the schema upgrade tool from the admin-tools image of the new version, against both Temporal databases. The version is passed on the command line, because `.env` still carries the old one until [Step 5](#step-5-apply-the-new-versions):

```bash
TEMPORAL_DB_PASSWORD=$(grep '^temporal_db_password=' .env | cut -d= -f2-)

temporal_image_version=<new_temporal_version> docker compose --profile admin run --rm --no-deps \
  -e SQL_PASSWORD="${TEMPORAL_DB_PASSWORD}" temporal-admin \
  temporal-sql-tool --plugin postgres12 --ep postgresql -p 5432 -u temporal --db temporal \
  update-schema -d /etc/temporal/schema/postgresql/v12/temporal/versioned

temporal_image_version=<new_temporal_version> docker compose --profile admin run --rm --no-deps \
  -e SQL_PASSWORD="${TEMPORAL_DB_PASSWORD}" temporal-admin \
  temporal-sql-tool --plugin postgres12 --ep postgresql -p 5432 -u temporal --db temporal_visibility \
  update-schema -d /etc/temporal/schema/postgresql/v12/visibility/versioned
```

Replace `<new_temporal_version>` with the `temporal_image_version` value of `versions.env`. The schema upgrade is backward compatible, so the running Temporal server keeps working until it's recreated at the next step. For the details of the Temporal procedure, see [Upgrade Temporal Server](https://docs.temporal.io/self-hosted-guide/upgrade-server){target=_blank} in the Temporal documentation.

!!! note "PostgreSQL major versions"
    This procedure covers PostgreSQL minor and patch upgrades, which keep the data directory as is. A PostgreSQL major version change isn't covered: it changes the data directory format and requires a `pg_upgrade` or a dump and restore procedure, described in [Upgrading a PostgreSQL Cluster](https://www.postgresql.org/docs/current/upgrading.html){target=_blank}. Run it before applying a pin that moves the major version.

## Step 5: Apply the new versions

Run the initialization script again:

```bash
bash ./scripts/init.sh
```

On an initialized stack, the script keeps every secret in `.env`, offers the current server name, TheHive URL, and TheHive addresses as defaults for its three questions, and performs the following tasks:

1/ Rewrites `.env` from `dot.env.template` with the image versions now pinned in `versions.env`.  

2/ Renders `temporal/config/temporal-server.yaml` again, in case its template changed.  

3/ Installs the custom TLS certificate from `./certificates/`, or generates a new self-signed one.  

4/ Recreates the `postgresql` and `temporal` containers when their image version changed, and waits for both to be healthy. The Temporal schema and namespace already exist, so the script leaves them alone.  

The script rewrites `.env` from the template: a line you added to `.env` by hand, outside the keys the template declares, doesn't survive. Set extra container variables in the `environment:` block of the service instead, as described in [Environment variable overrides](../configuration/flow-configuration.md#environment-variable-overrides).

With a self-signed certificate, the new one replaces the previous, and nginx serves it from [Step 6](#step-6-start-the-stack). If TheHive trusts the specific certificate, as described in [Option B](docker.md#option-b-trust-the-specific-certificate), copy the new `nginx/certs/server.crt` to TheHive host before upgrading TheHive at [Step 8](#step-8-upgrade-thehive). See [TLS certificate renewal](../operations/security.md#tls-certificate-renewal).

## Step 6: Start the stack

Start all services. Docker Compose pulls the images whose version changed and recreates their containers:

```bash
docker compose up -d
```

TheHive Flow applies its database migrations at startup, then becomes ready. The `init-s3-store` container runs again and exits once it has verified the object storage identity and bucket.

## Step 7: Reconcile the configuration

A new version can introduce configuration blocks in the shipped `thehive-flow/config/thehive-flow.yml`. They arrive with `git pull`, unless you stashed your own changes to the file at [Step 2](#step-2-get-the-new-deployment-files): in that case, compare your version with the shipped one and add what's missing. See [TheHive Flow Application Configuration](../configuration/flow-configuration.md).

To apply a change to the file, recreate the `thehive-flow` service:

```bash
docker compose up -d --force-recreate thehive-flow
```

The `--force-recreate` flag is required. The file is mounted into the container, and Docker Compose doesn't detect changes to mounted files, so a plain `docker compose up -d` leaves the container running with the previous configuration.

## Step 8: Upgrade TheHive

Once TheHive Flow runs the new version, upgrade TheHive to the same version.

* For a package or Docker Compose installation: follow [Upgrade from TheHive 6.x](../../thehive/installation/upgrade-from-6.x.md#step-3-install-the-new-version).
* For a Kubernetes release, upgrade the release as described in [Deploy TheHive on Kubernetes](../../thehive/installation/kubernetes.md). The `helm upgrade` command restores the replica count set in your values. When `thehive.autoscaling.enabled` is `true`, the chart doesn't set the replica count, so scale the Deployment back up with `kubectl scale`.

## Step 9: Verify the upgrade

On TheHive Flow host, check that all containers are running and that the [health endpoints](../operations/monitoring.md#health-endpoints) respond:

```bash
docker compose ps -a
curl -fsS http://127.0.0.1:9090/livez
curl -fsS http://127.0.0.1:9090/readyz
docker compose logs --tail=50 thehive-flow
```

Then, in TheHive, sign in with an account that has the predefined Org-Admin profile and select the health indicator at the bottom of the sidebar menu. It covers every configured connector: TheHive Flow, Cortex, Malware Information Sharing Platform & Threat Sharing (MISP), and Email Intake. Its color reflects all of them at once. It turns green when every configured connector is healthy, and red when at least one is in error. Its **Flow** section shows TheHive Flow URL and its own status, `OK` or `ERROR`. TheHive probes TheHive Flow every minute by default, so allow that long for the status to reflect the restart.

Finally, go to the **Flow** view from the sidebar menu and check that it displays the workflow list. An error notification over an empty workflow list means TheHive can't reach TheHive Flow: see [Troubleshoot TheHive Flow](../operations/troubleshooting.md#authentication-and-jwt).

Once everything checks out, remove the images the previous version used:

```bash
docker image prune -f
```

## Roll back

To roll back, return the repository to the previous revision, then restore the cold backup taken before the upgrade. The backup holds the `.env` file of the previous version, so the stack restarts on the previous images:

```bash
git log --oneline -- ../versions.env
git checkout <previous_commit>
docker compose down
bash ./scripts/restore.sh . ./backup/<backup_folder>
```

The data directories must be empty before the restore, as described in [Restore](../operations/backup-restore.md#step-5-restore). Restoring is required, not optional. TheHive Flow database migrations are forward-only, and Temporal schema migrations are never reverted: the previous version can't run on a database migrated by the new one. Workflow runs started under the new version are lost with the restore, and runs started under the previous version resume from the backup state.

To retry the upgrade later, return to the main branch with `git checkout main` and start again from [Step 2](#step-2-get-the-new-deployment-files).

<h2>Next steps</h2>

* [Maintain TheHive Flow](../operations/maintenance.md)
* [TheHive Flow Security Maintenance](../operations/security-maintenance.md)
* [Back Up and Restore TheHive Flow](../operations/backup-restore.md)
* [Troubleshoot TheHive Flow](../operations/troubleshooting.md)
