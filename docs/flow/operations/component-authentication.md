# Authentication Between TheHive Flow Components

<!-- md:version 6.0 --> <!-- md:license One -->

Every channel between [TheHive Flow](../user-guides/about-flow.md), TheHive, and the services of the stack carries its own authentication mechanism.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## Authentication matrix

| Channel | Mechanism | Direction | Where configured |
| ------- | --------- | --------- | ---------------- |
| TheHive → TheHive Flow | JWT HS256, symmetric | TheHive signs, TheHive Flow validates | [`JWT_SIGNING_KEY`](../configuration/environment-variables.md) in `.env` on TheHive Flow side, and [`TH_ORCHESTRATOR_KEY` or `orchestrator.jwt_signing_key`](../installation/docker.md#step-6-configure-thehive-to-reach-thehive-flow) on TheHive side |
| External system → *Webhook* trigger | Per-webhook method: Basic Auth, header key, or JWT | The caller authenticates each request | The [authentication section of the *Webhook* trigger](../user-guides/add-trigger.md#add-a-webhook-trigger) |
| TheHive Flow → TheHive | API key, bearer token | TheHive Flow signs each request | `orchestrator/secret/thehive-api-key` |
| TheHive Flow → PostgreSQL | Username and password | Connects as the `orchestrator` role | Connection string in [`orchestrator/orchestrator.yml`](../configuration/flow-configuration.md) |
| Temporal → PostgreSQL | Username and password | Connects as the `temporal` role | Connection string in `temporal/.resolved.yaml` |
| TheHive Flow → Temporal | None | Trust via network isolation | The [`orchestrator-net` Docker bridge](security.md#network-isolation) |
| Nginx → TheHive Flow | None | Trust via network isolation | The [`orchestrator-net` Docker bridge](security.md#network-isolation) |

## JWT between TheHive and TheHive Flow

Both services use the same algorithm: HS256, an HMAC-SHA256 signature with a symmetric key.

* The `init.sh` script generates the key with `openssl rand -hex 32` and stores it in `.env` as `JWT_SIGNING_KEY`.
* The `orchestrator` service receives it through the `BEEFLOW_SECRET_JWT_SYMMETRIC_KEY` environment variable set in `docker-compose.yml`.
* TheHive must be [configured with the same value](../installation/docker.md#step-6-configure-thehive-to-reach-thehive-flow): through the `TH_ORCHESTRATOR_KEY` environment variable, or through `orchestrator.jwt_signing_key` in the mounted `application.conf` when TheHive runs with `--no-config`.

There's no automated key exchange or rotation protocol. The key is set once at install time and [rotated manually](security.md#jwt-signing-key).

Tokens expire 1 minute after signing, with a 30-second validation leeway on TheHive Flow side. Keep the clocks of both hosts synchronized with NTP: a larger clock skew makes TheHive Flow reject every token as expired.

!!! warning "Common pitfall: Docker Compose environment variable syntax"
    With the list syntax, quotes become part of the value and cause a `token signature is invalid` error:

    ```yaml
    environment:
      - TH_ORCHESTRATOR_KEY="<jwt_signing_key>"
    ```

    Use the mapping syntax instead, where YAML strips the quotes:

    ```yaml
    environment:
      TH_ORCHESTRATOR_KEY: "<jwt_signing_key>"
    ```

    The list syntax also works without quotes:

    ```yaml
    environment:
      - TH_ORCHESTRATOR_KEY=<jwt_signing_key>
    ```

## Direct API calls

The REST API isn't a supported integration surface. To start workflows from your own systems, use [*Webhook* triggers](../user-guides/add-trigger.md#add-a-webhook-trigger) instead: they enter through nginx on port 443 and carry their own authentication method, independent of the JWT.

## TheHive API key

TheHive Flow uses a bearer token to authenticate outbound requests to TheHive. The token is read from the `thehive-api-key` file inside the configured `secret_path`: `/secret` in the container, mapped from `./orchestrator/secret/` on the host.

The file contains the raw token:

```bash
printf '%s' '<thehive_api_key>' > ./orchestrator/secret/thehive-api-key
chmod 644 ./orchestrator/secret/thehive-api-key
```

Mode 644 is required for the container user to read the file: see the [secrets inventory](security.md#secrets-inventory).

!!! note "Whitespace is trimmed from every secret"
    The loader trims leading and trailing whitespace and newlines from all secrets it resolves, whether from a file or a `BEEFLOW_SECRET_*` environment variable. This includes the JWT signing key, TheHive API key, and any Docker registry credentials such as passwords and identity or registry tokens. A trailing newline in a secret file is therefore harmless, and a secret value that must contain leading or trailing whitespace isn't supported.

## PostgreSQL authentication

The `postgres/init-multi-db.sh` script creates each database user at first container start, with passwords sourced from environment variables set in [`.env`](../configuration/environment-variables.md). Passwords are stored only in `.env` and in `temporal/.resolved.yaml`, both covered by `.gitignore`. They're never embedded in tracked configuration files.

## Key rotation

See [Rotate secrets](security.md#rotate-secrets) for the procedure of each key.

<h2>Next steps</h2>

* [TheHive Flow Security](security.md)
* [Deploy TheHive Flow with Docker Compose](../installation/docker.md)
* [Troubleshoot TheHive Flow](troubleshooting.md)
