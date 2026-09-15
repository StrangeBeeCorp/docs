# TheHive Flow Software Requirements

<!-- md:version 6.0 --> <!-- md:license One -->

Deploying [TheHive Flow](../user-guides/about-flow.md) requires specific software components at specific versions, depending on the deployment method: [Docker Compose](docker.md) or [Kubernetes](kubernetes.md).

## Software prerequisites

=== "Docker Compose deployment"

    | Component | Minimum version | Notes |
    | --------- | --------------- | ----- |
    | Docker Engine | 24.0 | The `docker` daemon must be running |
    | Docker Compose | v2 plugin | The legacy Python `docker-compose`, end of life since 2023, isn't supported |
    | openssl | 1.1.1 | Used by `init.sh` to generate random secrets |
    | jq | Any | Used by `upgrade-temporal.sh` to read the Temporal version manifest, and by several [log](../operations/logging.md) and [maintenance](../operations/maintenance.md) commands |
    | TheHive | 6.0.0 | Must already be [installed](../../thehive/installation/installation-methods.md), running, and reachable over the network from TheHive Flow host |

=== "Kubernetes deployment with Helm"

    | Component | Minimum version | Notes |
    | --------- | --------------- | ----- |
    | Kubernetes | 1.29 | Any conformant distribution |
    | Helm | 3.16 | Installs the chart shipped in the deployment bundle |
    | kubectl | Any | Matching the cluster version |
    | CloudNativePG | 0.29.0 chart, installed by the bootstrap script | Runs the bundled PostgreSQL 18.4, from its own `cnpg-system` namespace. Not needed when the chart points at a PostgreSQL of your own |
    | TheHive | 6.0.0 | Must already be [installed](../../thehive/installation/installation-methods.md), running, and reachable over the network from the cluster |

## Images pulled at first start

=== "Docker Compose deployment"

    All images are pinned by tag and immutable digest in `docker-compose.yml`. The host must be able to reach the listed registries at first start, directly or through a private registry mirror; subsequent starts use the local cache.

    | Image | Approximate size |
    | ----- | ---------------- |
    | `docker.io/library/postgres:18.x` | ~400 MB |
    | `docker.io/temporalio/server:1.31.x` | ~200 MB |
    | `docker.io/temporalio/admin-tools:1.31.x` | ~300 MB |
    | `docker.io/library/nginx:1.31.x` | ~60 MB |
    | `docker.io/chrislusf/seaweedfs:4.x` | ~90 MB |

    The total pull is approximately 1 GB. TheHive Flow's own image, `ghcr.io/strangebee/orchestrator`, isn't pulled: it ships as a Docker archive in the `images/` directory of the deployment bundle.

    The optional [observability profile](../operations/monitoring.md#bundled-observability-stack) pulls three more images at its first start: `docker.io/otel/opentelemetry-collector-contrib:0.160.x`, `docker.io/prom/prometheus:v3.14.x`, and `docker.io/grafana/grafana:13.2.x`.

    The two [code transformation](../user-guides/configure-transformation-node.md) language images are also pulled at the first start of the `orchestrator` service, which refuses to start if a pull fails:

    | Image | Approximate size |
    | ----- | ---------------- |
    | `gcr.io/distroless/python3-debian12` | ~20 MB |
    | `gcr.io/distroless/nodejs24-debian12` | ~60 MB |

    Both are pinned by immutable digest in the application itself rather than in `docker-compose.yml`. On a host that can't reach `gcr.io`, mirror them to an internal registry and override the image references through `modules.codex.languages` in [`orchestrator/orchestrator.yml`](../configuration/flow-configuration.md#code-transformation-images).

=== "Kubernetes deployment with Helm"

    The two TheHive Flow images, the application image and the code transformation assistant image, ship as Docker archives in the `images/` directory of the deployment bundle: push them to a registry the cluster can reach, as described in [Deploy TheHive Flow on Kubernetes](kubernetes.md#step-5-install-the-chart).

    The cluster must also be able to reach the following registries at first start, directly or through a private registry mirror.

    | Image | Version | Purpose |
    | ----- | ------- | ------- |
    | `ghcr.io/cloudnative-pg/postgresql` | 18.4 | Bundled PostgreSQL, deployed by the CloudNativePG operator |
    | `docker.io/temporalio/server` | 1.31.2 | Bundled Temporal Server |
    | `docker.io/temporalio/admin-tools` | 1.31.2 | Temporal schema migrations, namespace creation, and the readiness wait |
    | `docker.io/chrislusf/seaweedfs` | 4.37, set by the SeaweedFS chart | Bundled object storage |
    | `docker.io/curlimages/curl` | 8.22.0 | The `helm test` probe pod only |

    The versions come from the chart and the bootstrap manifests, which pin the following releases:

    | Component | Pinned version | Set by |
    | --------- | -------------- | ------ |
    | PostgreSQL | 18.4 | The `imageName` field of the `postgres-cluster.yaml` bootstrap manifest |
    | Temporal subchart | 1.6.0, shipping Temporal Server 1.31.2 | The chart `dependencies` |
    | SeaweedFS chart | 4.37.0 | The `S3_VERSION` variable of the object storage installer |
    | CloudNativePG operator chart | 0.29.0 | The `DB_OPERATOR_VERSION` variable of the operator installer |

    The code transformation language images are pulled from `gcr.io` on demand. On an air-gapped cluster, mirror them to an internal registry and set `codex.languageImages`.

<h2>Next steps</h2>

* [TheHive Flow System Requirements](system-requirements.md)
* [Deploy TheHive Flow with Docker Compose](docker.md)
* [Deploy TheHive Flow on Kubernetes](kubernetes.md)
