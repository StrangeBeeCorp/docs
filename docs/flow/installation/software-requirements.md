# TheHive Flow Software Requirements

<!-- md:version 6.0 --> <!-- md:license One -->

Deploying [TheHive Flow](../user-guides/about-flow.md) requires specific software components at specific versions, depending on the deployment method: [Docker Compose](docker.md) or [Kubernetes](kubernetes.md).

{% include-markdown "includes/flow-no-packages.md" %}

## Software prerequisites

=== "Docker Compose deployment"

    | Component | Minimum version | Notes |
    | --------- | --------------- | ----- |
    | Docker Engine | v23.0.15 | The `docker` daemon must be running, and the user deploying the stack must be able to run Docker commands |
    | Docker Compose | v2.20.2 plugin | The legacy Python `docker-compose`, end of life since 2023, isn't supported |
    | openssl | 1.1.1 | Used by `init.sh` to generate random secrets and the self-signed certificate |
    | rsync | Any | Used by `backup.sh` and `restore.sh` |
    | jq | Any | Used by several [log](../operations/logging.md) and [maintenance](../operations/maintenance.md) commands |

=== "Kubernetes deployment with Helm"

    | Component | Minimum version | Notes |
    | --------- | --------------- | ----- |
    | Kubernetes | 1.29 | Any conformant distribution, with a default storage class for the deployment scenarios |
    | Helm | 3.8.0 | Installs the chart from the [StrangeBee Helm repository](kubernetes.md#step-2-add-the-helm-repository-and-get-the-scenario-files) |
    | kubectl | Any | Matching the cluster version |
    | openssl | Any | Used to generate the JWT signing key |
    | CloudNativePG | 0.29.1 chart, installed by the `cnpg` deployment scenario | Runs the PostgreSQL cluster of the scenario, from its own `cnpg-system` namespace. Not needed when the chart points at an external PostgreSQL |

## Images pulled at first start

=== "Docker Compose deployment"

    All images are pinned by tag in `versions.env`, at the root of the repository, and `init.sh` copies the pins into `.env`. The host must be able to reach Docker Hub at first start, directly or through a private registry mirror. Subsequent starts use the local cache.

    | Image | Variable in `versions.env` | Approximate size |
    | ----- | -------------------------- | ---------------- |
    | `docker.io/strangebee/thehive-flow` | `thehive_flow_image_version` | ~100 MB |
    | `docker.io/library/postgres` | `postgresql_image_version` | ~400 MB |
    | `docker.io/temporalio/server` | `temporal_image_version` | ~200 MB |
    | `docker.io/temporalio/admin-tools` | `temporal_image_version` | ~300 MB |
    | `docker.io/library/nginx` | `nginx_image_version` | ~60 MB |
    | `docker.io/chrislusf/seaweedfs` | `seaweedfs_image_version` | ~90 MB |

    The total pull is approximately 1 GB. The `init.sh` script pulls the nginx image before anything else, to read the group of the Docker socket from a throwaway container.

    The two [code transformation](../user-guides/configure-transformation-node.md) language images are also pulled at the first start of the `thehive-flow` service, which refuses to start if a pull fails:

    | Image | Approximate size |
    | ----- | ---------------- |
    | `gcr.io/distroless/python3-debian12` | ~20 MB |
    | `gcr.io/distroless/nodejs24-debian12` | ~60 MB |

    Both are pinned by immutable digest in the application itself rather than in `versions.env`. On a host that can't reach `gcr.io`, they must be mirrored to an internal registry and their references overridden through `modules.codex.languages` in [`thehive-flow/config/thehive-flow.yml`](../configuration/flow-configuration.md#code-transformation-images).

    The `thehive-flow` service also pulls `docker.io/testcontainers/ryuk`, approximately 10 MB, pinned by immutable digest in the application too. It runs the reaper container that removes orphaned code transformation containers after a crash. A failed pull doesn't stop the service: the reaper is then unavailable, and orphaned containers are removed at the next start only.

=== "Kubernetes deployment with Helm"

    The cluster must be able to reach the following registries at install time and first start, directly or through a private registry mirror.

    | Image | Version | Purpose |
    | ----- | ------- | ------- |
    | `docker.io/strangebee/thehive-flow` | The chart `appVersion`, which is the released version | TheHive Flow application image |
    | `docker.io/strangebee/thehive-flow-assistant` | The chart `appVersion`, which is the released version | Helper containers of the [code transformation](../user-guides/configure-transformation-node.md) jobs |
    | `docker.io/temporalio/server` | 1.32.0, set by the Temporal subchart | Temporal Server subchart |
    | `docker.io/temporalio/admin-tools` | 1.32.0 by the Temporal subchart, 1.32.1 for the readiness wait | Temporal schema migrations and namespace creation, and the `wait-temporal` init container of the application pod |
    | `docker.io/library/busybox` | 1.38.0 | The `wait-postgres` init container of the application pod and of the database migrations Job |
    | `docker.io/curlimages/curl` | 8.22.0 | The `helm test` probe pod only |
    | `ghcr.io/cloudnative-pg/postgresql` | The default of the CloudNativePG operator 0.29.1 | PostgreSQL deployed by the `cnpg` deployment scenario |
    | `docker.io/chrislusf/seaweedfs` | Set by the SeaweedFS chart 4.48.0 | Object storage deployed by the `seaweedfs` deployment scenario |

    The versions come from the chart and the deployment scenarios, which pin the following releases:

    | Component | Pinned version | Set by |
    | --------- | -------------- | ------ |
    | Temporal subchart | 1.7.0, shipping Temporal Server 1.32.0 | The chart `dependencies` |
    | CloudNativePG operator chart | 0.29.1 | The `helm upgrade --install cnpg` command of the `cnpg` scenario |
    | SeaweedFS chart | 4.48.0 | The `helm upgrade --install seaweedfs` command of the `seaweedfs` scenario |

    The code transformation language images are pulled from `gcr.io` on demand. On an air-gapped cluster, they must be mirrored to an internal registry and referenced through `codex.languageImages`.

<h2>Next steps</h2>

* [TheHive Flow System Requirements](system-requirements.md)
* [Deploy TheHive Flow with Docker Compose](docker.md)
* [Deploy TheHive Flow on Kubernetes](kubernetes.md)
