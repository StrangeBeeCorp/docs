# TheHive Flow System Requirements

<!-- md:version 6.0 --> <!-- md:license One -->

[TheHive Flow](../user-guides/about-flow.md) requires sufficient hardware resources and data storage to ensure stable and efficient operation, depending on the deployment method: a [Docker Compose stack](docker.md) on a single Linux host, separate from the host running TheHive, or a [Helm chart on a Kubernetes cluster](kubernetes.md).

## Hardware requirements

=== "Docker Compose deployment"

    ### Host sizing

    | Resource | Minimum | Recommended |
    | -------- | ------- | ----------- |
    | RAM | 7 GB | 8-16 GB |
    | CPU | 2 vCPUs | 4 vCPUs |
    | Disk | 20 GB | 50-100 GB |

    These figures are what the stack itself needs. They come on top of the operating system and any other services running on the same host.

    ### Memory limits per service

    The `docker-compose.yml` file defines a memory limit for each service. These are hard limits enforced by the Docker runtime. A container that exceeds its limit is terminated by the out-of-memory (OOM) killer.

    | Service | Memory limit | Notes |
    | ------- | ----------- | ----- |
    | `postgresql` | 1 GB | Hosts three databases: `orchestrator`, `temporal`, and `temporal_visibility` |
    | `temporal` | 1 GB | Workflow engine |
    | `orchestrator` | 1 GB | Stateless API server with low RAM usage—the limit is a safety cap. Also carries `GOMEMLIMIT`, see below |
    | `nginx` | 512 MB | Reverse proxy that typically uses under 50 MB |
    | `s3-store` | 512 MB | SeaweedFS S3-compatible object storage holding the blobs |
    | `temporal-admin` | 256 MB | Only active during admin operations such as schema migrations and namespace creation |
    | `init-s3-store` | 256 MB | One-shot container that provisions the S3 bucket at startup, then exits |
    | **Stack total** | **~4.5 GB** | **On top of the operating system and any other services on the host** |

    Adjust limits in `docker-compose.yml` based on observed usage with `docker stats`. For the `orchestrator` service, `mem_limit`, `memswap_limit`, and `GOMEMLIMIT` move together.

    ### Go memory limit of the `orchestrator` service

    The `orchestrator` container carries a second ceiling: the `GOMEMLIMIT` environment variable, set in `docker-compose.yml` to `870MiB`, 85% of its 1 GB `mem_limit`. The Go garbage collector doesn't read the container limit on its own and would otherwise let the heap grow into a kill by the out-of-memory (OOM) killer—and because the REST API and the Temporal worker run in the same process, that kill restarts the whole application rather than a single step.

    When raising the `orchestrator` memory limit, raise `mem_limit`, `memswap_limit`, and `GOMEMLIMIT` together, keeping at least 128 MiB between `GOMEMLIMIT` and `mem_limit`. Only Go's binary suffixes are valid, such as `870MiB`: with a malformed value such as `870MB`, the container exits immediately.

    ### Code transformation containers

    TheHive Flow runs [Python and JavaScript code transformations](../user-guides/configure-transformation-node.md) in disposable containers launched on the host Docker daemon, outside the stack and its memory limits. Three properties matter for host sizing:

    * No resource limits: The containers run without a memory or CPU cap, so a memory-hungry script competes with the stack and the operating system for host RAM.
    * No fixed concurrency ceiling: One container runs per executing transformation step, so the count follows how many runs execute transformations at the same time.
    * Short-lived: Each container is removed as soon as its script exits.

    The recommended host sizing above covers typical transformation workloads. For workflows running many concurrent transformations, or scripts processing large inputs in memory, budget extra RAM on top of the stack total. The [transformation language images](software-requirements.md#images-pulled-at-first-start) add approximately 80 MB to the Docker image cache.

=== "Kubernetes deployment with Helm"

    ### Chart sizing defaults

    The chart and the bootstrap manifests ship the following defaults. The [data storage](#data-storage) growth drivers apply unchanged: approximately 1 MB per workflow run in the `orchestrator` database, 2 to 5 times that for the Temporal history depending on retention, and a blob store that [only grows](#blob-store-volume-sizing).

    | Component | Default | Tuning |
    | --------- | ------- | ------ |
    | TheHive Flow pod | Requests 250m CPU and 512 MiB of memory, limited to 1 GiB of memory | The `resources.*` values. The Go memory limit is derived as 85% of the memory limit through `goMemLimitPercent`, so raising `resources.limits.memory` raises it too. The chart refuses to render when the derived margin falls under 128 MiB |
    | Database migrations job | Requests 100m CPU and 128 MiB of memory, limited to 256 MiB of memory | The `orchestratorMigrations.resources.*` values |
    | PostgreSQL cluster | One instance, 10 GiB of storage, requests 100m CPU and 256 MiB of memory, limited to 1 GiB of memory | The `postgres-cluster.yaml` bootstrap manifest: set `storageClass` and grow the storage for production, following the [PostgreSQL volume sizing baseline](#postgresql-volume-sizing) |
    | Temporal | Upstream Temporal chart defaults. History shards: 512, immutable for the cluster's life | The `temporal.*` values, passed through to the upstream chart |
    | Object storage | Upstream SeaweedFS chart defaults for the single pod and its volume | The SeaweedFS release values. The volume follows the blob store growth: plan for the total volume of files your workflows will ever handle |
    | Code transformation jobs | No CPU or memory constraints | `codex.kubernetes.resources` for requests and limits, `codex.kubernetes.ephemeralStorage` to cap the work directory, and `codex.kubernetes.activeDeadlineSeconds` to cap a job's run time |

## Data storage

The following table lists the locations where the stack stores data and what drives their growth.

| Location | Content | Growth driver |
| -------- | ------- | ------------- |
| `orchestrator-postgres-data` Docker volume | All PostgreSQL data: the `orchestrator` database, Temporal history, and Temporal visibility index | Number of workflow runs and history retention period |
| `orchestrator-s3-data` Docker volume | Blob store contents: files ingested through [webhooks](../user-guides/add-trigger.md#add-a-webhook-trigger) or runs, and activity outputs promoted out of the database | Volume and size of the files your workflows handle. The volume only grows—see [Blob store volume sizing](#blob-store-volume-sizing) |
| `orchestrator-observability-prometheus-data` Docker volume | Metrics stored by the bundled Prometheus, only with the optional [observability profile](../operations/monitoring.md#bundled-observability-stack) | Self-capped: Prometheus deletes its oldest data past 15 days or 2 GB, whichever comes first |
| Docker image cache | [Pinned images for all services](software-requirements.md#images-pulled-at-first-start) | Static after the initial pull, approximately 1 GB total |
| `./backups/` | [Backup pairs](../operations/backup-restore.md) produced by `backup.sh`: a `pg_dump` archive and a gzip-compressed tar archive of the blob volume | Operator retention policy multiplied by the blob volume size—the blob archive is normally the larger half by far |
| Docker daemon log files | Container stdout and stderr in JSON format | [Log rotation configuration](../operations/logging.md#configure-docker-log-rotation) |

### PostgreSQL volume sizing

Use the following planning baseline:

* Plan for approximately 1 MB per workflow run in the `orchestrator` database. This covers definitions, run state, variables, and the audit trail.
* Temporal history is typically 2 to 5 times the size of the `orchestrator` database, depending on workflow complexity and the configured retention period.

For example, 10,000 workflow runs per month over 12 months, at a 3 MB average, results in approximately 360 MB for the `orchestrator` database and approximately 1 GB for Temporal. Adjust for your workload.

To check the actual volume and database sizes, see [Monitor TheHive Flow](../operations/monitoring.md#check-service-status).

### Blob store volume sizing

The blob store holds whole files, so its growth is driven by what your workflows carry rather than by how many times they run. Content is deduplicated within an organization: two runs in the same organization handling the same file store it once, because blobs are addressed by organization and SHA-256 hash. The same file handled by two different organizations is stored twice, by design. The organization boundary is a tenancy boundary, not a caching one.

!!! warning "The blob store volume only grows"
    Blobs are never deleted. There's no garbage collection, so a blob whose run has long been purged still occupies space, and the size of your instance snapshots grows with it. Plan for the total volume of files your workflows will ever handle, not for a steady state.

Watch the volume size and add a host-level disk alert, as described in [Monitor TheHive Flow](../operations/monitoring.md#disk-alerting-for-the-blob-volume). If the volume approaches your disk budget, the only available lever is to provision more disk.

The `s3-store` container itself is capped at 512 MB of RAM, which is unrelated to how much data it stores: the store keeps an on-disk index rather than an in-memory catalog, so memory tracks concurrent request volume, not object count. The single-node profile of the stack has one client, TheHive Flow, so the cap is sized for that. If the container is terminated by the OOM killer, see [Troubleshoot TheHive Flow](../operations/troubleshooting.md#disk-and-resources).

## Recommended operating systems

The Docker Compose host is officially supported on the following distributions:

* Debian 12
* Ubuntu 22.04
* RHEL 9

<h2>Next steps</h2>

* [TheHive Flow Software Requirements](software-requirements.md)
* [Deploy TheHive Flow with Docker Compose](docker.md)
* [Deploy TheHive Flow on Kubernetes](kubernetes.md)
* [Monitor TheHive Flow](../operations/monitoring.md)
