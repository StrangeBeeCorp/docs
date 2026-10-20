# Upgrade from TheHive 6.x

Upgrade your existing TheHive On-prem instance from one 6.x version to another.

The upgrade preserves all your data. Even so, performing a [full database backup](../operations/backup-restore/cold-hot-backup-restore.md) before you start is strongly recommended.

!!! note "Guide scope"
    Applies to standalone and cluster deployments installed using packages or Docker Compose. For [upgrades from TheHive 5.x](upgrade-from-5.x.md) or [Kubernetes deployments](kubernetes.md), refer to the dedicated guides.

!!! warning "Before you begin"
    To ensure a smooth upgrade, make sure you have:

    * A full database backup. See [Backup and Restore](../operations/backup-restore/cold-hot-backup-restore.md) for instructions.
    * Deactivated any external health checks on TheHive HTTP interface. Otherwise, the supervising system may kill TheHive during the upgrade.
    * A scheduled maintenance window. The upgrade requires stopping TheHive. Depending on the target version, the first launch may also trigger a database evolution, schema and data updates whose duration scales with your database size. If TheHive Flow is deployed, plan its upgrade in the same window: see [Step 2](#optional-step-2-upgrade-thehive-flow).
    * Confirmed that your Java, Cassandra, Elasticsearch, and Cortex versions are compatible with your target version of TheHive. See [TheHive Installation Software Requirements](software-requirements.md).
    * Reviewed the release notes for the target version to identify changes that may affect your deployment.

!!! danger "Downgrade limitation"
    Once upgraded, your instance can't be downgraded. Reverting to a previous version of TheHive 6 requires restoring your data from the backup.

---

## Step 1: Stop TheHive

Stop TheHive before installing the new version.

!!! note "Cluster deployments"
    For cluster deployments, stop all nodes before continuing. Each node must be upgraded individually before any node is restarted.

=== "Package installation"

    ```bash
    sudo systemctl stop thehive
    ```

=== "Docker Compose deployment"

    ```bash
    docker compose down
    ```

---

## (Optional) Step 2: Upgrade TheHive Flow

This step applies to deployments that run [TheHive Flow](../../flow/user-guides/about-flow.md) only.

TheHive and TheHive Flow are released together and carry the same version number. While TheHive is stopped, upgrade TheHive Flow to the target version with the guide matching its deployment method:

* [Upgrade TheHive Flow with Docker Compose](../../flow/installation/upgrade-docker.md#step-2-get-the-new-deployment-files)
* [Upgrade TheHive Flow on Kubernetes](../../flow/installation/upgrade-kubernetes.md#step-2-get-the-chart-of-the-new-version)

---

## Step 3: Install the new version

Download RPM, DEB, and ZIP packages directly with tools like `wget` or `curl` and install them manually. For Docker, redeploy with the [StrangeBee Docker Compose profiles](https://github.com/StrangeBeeCorp/docker){target=_blank} or pull an updated image tag.

All packages are hosted on an [HTTPS-secured website](https://thehive.download.strangebee.com/){target=_blank} and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum){target=_blank} and a [GPG](https://www.gnupg.org/){target=_blank} signature for verification.

!!! note "Cluster deployments"
    For cluster deployments, install the new version on each node.

{% include-markdown "includes/manual-download-upgrade-thehive.md" %}

{% include-markdown "includes/zip-binaries-installation-thehive.md" %}

=== "Docker Compose deployment"

    If you deployed using the [StrangeBee Docker Compose profiles](https://github.com/StrangeBeeCorp/docker){target=_blank}, pull the latest version of the repository before redeploying. The `docker-compose.yml`, configuration templates, and helper scripts may have changed between 6.x versions.

    Then update the `thehive_image_version` variable in the `.env` file, located in the same folder as your `docker-compose.yml`. Check [TheHive Docker Hub](https://hub.docker.com/r/strangebee/thehive){target=_blank} for the available version tags.

    If you used the public image directly, update the image tag to the `strangebee/thehive:<major.minor>` tag of the target version, or to a specific version if you don't want the latest patch of that minor version.

    !!! warning "Don't use the `latest` tag"
        The `strangebee/thehive:latest` tag is deprecated and remains pinned to TheHive 5.0.x.

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
        Depending on the target version, the first launch may trigger a database evolution, schema and data updates whose duration scales with your database size.

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

If TheHive Flow is deployed, also check its connection to TheHive:

1. Sign in with an account that has the predefined Org-Admin profile and select the health indicator at the bottom of the sidebar menu. Its **Flow** section shows TheHive Flow URL and its status, `OK` or `ERROR`. TheHive probes TheHive Flow every minute by default, so allow that long for the status to reflect the restart.

2. Go to the **Flow** view from the sidebar menu and check that it displays the workflow list. An error notification over an empty workflow list means TheHive can't reach TheHive Flow: see [Troubleshoot TheHive Flow](../../flow/operations/troubleshooting.md#authentication-and-jwt).

<h2>Next steps</h2>

* [Backup and Restore](../operations/backup-restore/cold-hot-backup-restore.md)
* [Update Log Configuration](../configuration/update-log-configuration.md)
* [Set Up Monitoring for TheHive with Prometheus and Grafana](../operations/monitoring.md)
* [Troubleshooting](../operations/troubleshooting.md)
