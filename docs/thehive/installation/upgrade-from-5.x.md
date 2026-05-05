# Upgrade from TheHive 5.x

Upgrade your existing TheHive On-prem instance from one 5.x version to another.

The upgrade preserves all your data. Even so, performing a [full database backup](../operations/backup-restore/cold-hot-backup-restore.md) before you start is strongly recommended.

!!! note "Guide scope"
    Applies to standalone and cluster deployments installed using packages or Docker Compose. For [upgrades from TheHive 4.x](upgrade-from-4.x.md) or [Kubernetes deployments](kubernetes.md), refer to the dedicated guides.

!!! warning "Before you begin"
    To ensure a smooth upgrade, make sure you have:

    * A full database backup. See [Backup and Restore](../operations/backup-restore/cold-hot-backup-restore.md) for instructions.
    * Deactivated any external health checks on TheHive HTTP interface. Otherwise, the supervising system may kill TheHive during the upgrade.
    * A scheduled maintenance window. The upgrade requires stopping TheHive. Depending on the target version, the first launch may also trigger a database evolution—schema and data updates whose duration scales with your database size.
    * Migrated off the Lucene index backend, if applicable. Lucene isn't supported since version 5.1. See [Change Index from Lucene to Elasticsearch](../operations/change-index.md).
    * Confirmed that your Java, Cassandra, Elasticsearch, and Cortex versions are compatible with your target version of TheHive. See [TheHive Installation Software Requirements](software-requirements.md).
    * Reviewed the release notes for the target version to identify changes that may affect your deployment.

!!! danger "Downgrade limitation"
    Once upgraded, your instance can't be downgraded. Reverting to a previous version of TheHive 5 requires restoring your data from the backup.

---

## Step 1: Stop TheHive

Stop TheHive before installing the new version.

!!! note "Cluster deployments"
    For cluster deployments, stop all nodes before continuing. Each node must be updated individually before any node is restarted.

=== "Package installation"

    ```bash
    sudo systemctl stop thehive
    ```

=== "Docker Compose deployment"

    ```bash
    docker compose down
    ```

---

## Step 2: Install the new version

Download RPM, DEB, and ZIP packages directly with tools like `wget` or `curl` and install them manually. For Docker, redeploy with the [StrangeBee Docker Compose profiles](https://github.com/StrangeBeeCorp/docker){target=_blank} or pull an updated image tag.

All packages are hosted on an [HTTPS-secured website](https://thehive.download.strangebee.com/){target=_blank} and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum){target=_blank} and a [GPG](https://www.gnupg.org/){target=_blank} signature for verification.

!!! note "Cluster deployments"
    For cluster deployments, install the new version on each node.

{% include-markdown "includes/manual-download-installation-thehive.md" %}

{% include-markdown "includes/zip-binaries-installation-thehive.md" %}

=== "Docker Compose deployment"

    If you deployed using the [StrangeBee Docker Compose profiles](https://github.com/StrangeBeeCorp/docker){target=_blank}, pull the latest version of the repository before redeploying. The `docker-compose.yml`, configuration templates, and helper scripts may have changed between 5.x versions. The version is set in the `versions.env` file at the root of the repository, with the `thehive_image_version` variable.

    If you used the public image directly, update the image tag to `strangebee/thehive:5.7`, or to a specific version if you don't want the latest.

    !!! warning "Don't use the `latest` tag"
        The `strangebee/thehive:latest` tag is deprecated and remains pinned to TheHive 5.0.x.

---

## (Optional) Step 3: Update the web framework

Skip this step if you're upgrading from version 5.4 or later.

!!! note "Cluster deployments"
    For cluster deployments, update the configuration file on each node.

Starting with version 5.4, TheHive uses Play3/Pekko as the web framework. Depending on your installation and configuration, you may need to update your configuration file. See the [Pekko configuration guide](../configuration/pekko.md) for details.

---

## Step 4: Start TheHive

!!! note "Cluster deployments"
    For cluster deployments, start one node first and wait for TheHive to be fully up and running. Then start the remaining nodes one by one.

1. Start TheHive.

    === "Package installation"

        ```bash
        sudo systemctl start thehive
        ```

    === "Docker Compose deployment"

        ```bash
        docker compose up -d
        ```

    !!! info "First-launch database evolution"
        Depending on the target version, the first launch may trigger a database evolution—schema and data updates whose duration scales with your database size.

2. Verify that TheHive is running.

    === "Package installation"

        ```bash
        sudo systemctl status thehive
        ```

        If TheHive is running, the output shows an active status in green.

    === "Docker Compose deployment"

        ```bash
        docker compose ps
        ```

        If TheHive is running, the container shows as `Up`.

!!! bug "Troubleshooting TheHive"
    If you run into issues, see the [Troubleshooting](../operations/troubleshooting.md) page.

---

## Step 5: Verify the upgrade

Open TheHive in your web browser. Confirm that the version in the bottom-left corner matches the version you installed.

<h2>Next steps</h2>

* [Backup and Restore](../operations/backup-restore/cold-hot-backup-restore.md)
* [Update Log Configuration](../configuration/update-log-configuration.md)
* [Set Up Monitoring for TheHive with Prometheus and Grafana](../operations/monitoring.md)
* [Troubleshooting](../operations/troubleshooting.md)
