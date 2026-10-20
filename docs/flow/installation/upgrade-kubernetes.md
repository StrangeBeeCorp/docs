# Upgrade TheHive Flow on Kubernetes

<!-- md:version 6.0 --> <!-- md:license One -->

Upgrade an existing [TheHive Flow](../user-guides/about-flow.md) Helm release to a new version. TheHive Flow is released with TheHive and carries the same version number: upgrade both to that version in the same maintenance window. Upgrade TheHive Flow first, while TheHive is stopped. The upgrade preserves all your data.

!!! warning "Before you begin"
    To ensure a smooth upgrade, make sure you have:

    * A backup of PostgreSQL and of the object storage, captured together, because the database references files by content hash. See [Configuration and operations on Kubernetes](kubernetes.md#configuration-and-operations-on-kubernetes).
    * A scheduled maintenance window. The upgrade stops TheHive and TheHive Flow.
    * A time when as few workflows as possible are running. The upgrade doesn't wait for running workflows to finish: the new version resumes them from their recorded execution history.
    * TheHive [release notes](../../thehive/release-notes/release-notes-6.0.md) of the target version, to identify changes that may affect your deployment.

The examples below use the `thehive-flow` namespace and the `thehive-flow` release name, which are the names the deployment scenarios use. Adapt them to your cluster conventions.

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

## Step 2: Get the chart of the new version

Each version of the chart is published in the StrangeBee Helm repository added at [installation time](kubernetes.md#step-2-add-the-helm-repository-and-get-the-scenario-files). Its `appVersion` is the released TheHive Flow version, and the image tags default to it, so upgrading with the new chart moves the images.

1. Refresh the repository index and list the chart versions, with the version of TheHive Flow each one ships in its `APP VERSION` column:

    ```bash
    helm repo update
    helm search repo strangebee/thehive-flow --versions
    ```

2. Note the chart version whose `APP VERSION` is the target TheHive Flow version. The commands below refer to it as `<chart_version>`.

If you installed with the deployment scenarios, also refresh the clone of the GitHub repository with `git pull`, from the chart directory. A new version can change the scenario values files you pass to the chart.

## Step 3: Review the values file

Reuse the values files passed at [installation time](kubernetes.md#step-6-install-the-chart): a `helm upgrade` renders the chart from the values passed on its command line, not from the ones stored in the release. Check the following before upgrading:

* `config.api.public.url` must still be set: the chart refuses to render without it.
* On a cluster that pulls from a private mirror, mirror the new `docker.io/strangebee/thehive-flow` and `docker.io/strangebee/thehive-flow-assistant` images at the new version. When their pinned versions changed, also mirror the [code transformation images](../configuration/flow-configuration.md#code-transformation-images) and the other [images the chart pulls](software-requirements.md#images-pulled-at-first-start).
* If your values file pins `image.tag` or `codex.kubernetes.assistantImage.tag`, set them to the new version: a pinned tag doesn't follow the chart `appVersion`. Left empty, both follow it.
* Compare your values with the defaults of the new chart for keys introduced by the new version, with `helm show values strangebee/thehive-flow --version <chart_version>`. The application configuration lives in the `config.*` values, so there's no configuration file to reconcile on the cluster.

The Secrets provisioned at [installation time](kubernetes.md#step-5-provision-the-secrets) stay in place. Keep the JWT signing key stable: changing it invalidates every token already issued.

## Step 4: Render the chart

Render the chart before upgrading. This catches a missing `config.api.public.url` and any PostgreSQL address mismatch between TheHive Flow and the Temporal subchart, without touching the cluster:

```bash
helm template thehive-flow strangebee/thehive-flow --version <chart_version> \
  --namespace thehive-flow --values <values_file> > /dev/null && echo OK
```

With the deployment scenarios, replace `--values <values_file>` with the three `-f scenarios/...` files passed at installation time.

## Step 5: Upgrade the release

Upgrade the release with the new chart:

```bash
helm upgrade thehive-flow strangebee/thehive-flow --version <chart_version> \
  --namespace thehive-flow \
  --values <values_file> \
  --wait --timeout 10m
```

The upgrade runs the following, in order:

1/ A pre-upgrade Job runs TheHive Flow database migrations, so the schema is current before the application rolls. The Job pulls TheHive Flow image at the new version, so the cluster must be able to pull it. On a private mirror, the pull secret must already exist.  

2/ The Temporal subchart runs its schema upgrade as a pre-upgrade hook, so the Temporal Server schema is current before the new server starts. The Temporal Server version is pinned in the chart and moves with it.  

3/ The `thehive-flow` Deployment rolls: the current pod stops, then the new pod starts and verifies that the schema is current. The startup probe holds the liveness and readiness probes until the application first answers on `/livez`.  

The `--wait` flag makes the command return once the Deployment is available again. If either pre-upgrade Job fails, the upgrade stops before the Deployment rolls and the previous version keeps running. When TheHive Flow migration Job fails, Helm prints its logs, and the Job stays in place for 10 minutes, for inspection with `kubectl -n thehive-flow logs job/thehive-flow-migrations`. When the Temporal schema Job fails, TheHive Flow database migrations have already been applied, and the previous pod isn't restarted. That state isn't supported: the pod only checks at startup that the schema isn't behind its own migrations, so it can't tell that the schema is now ahead. The previous version then runs against a database it doesn't know. Restore the `thehive_flow` database from the backup taken before the upgrade, then fix the cause and run the upgrade again.

## Step 6: Upgrade TheHive

Once TheHive Flow runs the new version, upgrade TheHive to the same version.

* For a package or Docker Compose installation: follow [Upgrade from TheHive 6.x](../../thehive/installation/upgrade-from-6.x.md#step-3-install-the-new-version).
* For a Kubernetes release, upgrade the release as described in [Deploy TheHive on Kubernetes](../../thehive/installation/kubernetes.md). The `helm upgrade` command restores the replica count set in your values. When `thehive.autoscaling.enabled` is `true`, the chart doesn't set the replica count, so scale the Deployment back up with `kubectl scale`.

## Step 7: Verify the upgrade

Run the chart test, which probes the version endpoint from a throwaway pod:

```bash
helm test thehive-flow -n thehive-flow --logs
```

Then check that the pods are running and that the application logs show no unexpected errors:

```bash
kubectl -n thehive-flow get pods
kubectl -n thehive-flow logs deploy/thehive-flow --tail=50
```

To check the [health endpoints](../operations/monitoring.md#health-endpoints) directly, forward the observability port and query it. `/readyz` confirms TheHive Flow can reach its database and the Temporal workflow engine, and returns `503` naming the failing check otherwise:

```bash
kubectl -n thehive-flow port-forward deploy/thehive-flow 9090:9090
curl -fsS http://127.0.0.1:9090/readyz
```

Then, in TheHive, sign in with an account that has the predefined Org-Admin profile and select the health indicator at the bottom of the sidebar menu. It covers every configured connector: TheHive Flow, Cortex, Malware Information Sharing Platform & Threat Sharing (MISP), and Email Intake. Its color reflects all of them at once. It turns green when every configured connector is healthy, and red when at least one is in error. Its **Flow** section shows TheHive Flow URL and its own status, `OK` or `ERROR`. TheHive probes TheHive Flow every minute by default, so allow that long for the status to reflect the restart.

Finally, go to the **Flow** view from the sidebar menu and check that it displays the workflow list. An error notification over an empty workflow list means TheHive can't reach TheHive Flow: see [Troubleshoot TheHive Flow](../operations/troubleshooting.md#authentication-and-jwt).

## Roll back

A rollback restores the databases first, then redeploys the previous chart. `helm rollback` alone isn't a supported rollback: it reverts neither TheHive Flow database schema nor the Temporal Server schema, and the previous pod starts anyway. Its startup check only detects a schema that's behind its own migrations, not one that's ahead. TheHive Flow database migrations are forward-only, and Temporal schema migrations are never reverted, so the previous version can't be trusted on a database migrated by the new one.

1. Scale TheHive Flow down, so that nothing writes to the databases during the restore:

    ```bash
    kubectl -n thehive-flow scale deployment thehive-flow --replicas=0
    ```

2. Restore the `thehive_flow`, `temporal`, and `temporal_visibility` databases and the object storage from the backup taken before the upgrade, with the tooling described in [Configuration and operations on Kubernetes](kubernetes.md#configuration-and-operations-on-kubernetes). Restore the databases and the object storage together: the database references files by content hash.

3. List the revisions of the release and roll back to the one before the upgrade. Helm keeps the history of the release, and the rollback redeploys the previous chart and images:

    ```bash
    helm history thehive-flow -n thehive-flow
    helm rollback thehive-flow <revision> -n thehive-flow --wait
    ```

Workflow runs started under the new version are lost with the restore, and runs started under the previous version resume from the backup state.

<h2>Next steps</h2>

* [Deploy TheHive Flow on Kubernetes](kubernetes.md)
* [TheHive Flow Application Configuration](../configuration/flow-configuration.md)
* [Monitor TheHive Flow](../operations/monitoring.md)
* [Troubleshoot TheHive Flow](../operations/troubleshooting.md)
