# Deploy TheHive Flow with Docker Compose

<!-- md:version 6.0 --> <!-- md:license One -->

[TheHive Flow](../user-guides/about-flow.md) ships as a set of Docker Compose files, delivered in a deployment bundle, that you deploy on a single Linux host and connect to TheHive. In production, TheHive and TheHive Flow should run on separate hosts.

!!! warning "Before you begin"
    To ensure a smooth deployment process, make sure you have:

    * A host that meets TheHive Flow [system requirements](system-requirements.md) and [software requirements](software-requirements.md)
    * At least `sudo` permissions on TheHive Flow host
    * A maintenance window for TheHive: upgrading it at [step 4](#step-4-deploy-or-upgrade-thehive) stops the service, and a later step requires editing TheHive configuration and restarting TheHive

!!! note "Running TheHive and TheHive Flow on the same host for testing"
    Production deployments should keep TheHive and TheHive Flow on separate hosts. A single host works for a test phase though, once the two collisions between the stacks are resolved: each defines an nginx service with the container name `nginx`, and each publishes host port 443. The second stack to start fails otherwise.

    Rename the container and publish nginx on a free port on TheHive Flow side, as described in the [service name and published port section](../configuration/nginx-configuration.md#service-name-and-published-port), before [starting the stack](#step-7-start-the-stack).

    Publishing another host port changes the address TheHive Flow answers on, `https://<flow_host>:<host_port>/`. Use that address in [TheHive configuration](#step-6-configure-thehive-to-reach-thehive-flow).

## Step 1: Copy the deployment files onto the target host

Download the deployment bundle from the distribution link provided by StrangeBee. It holds three directories:

* `install/`: The Docker Compose files used by this procedure
* `images/`: The image archives, including TheHive Flow image `thehive-flow-<version>.tar` and TheHive 6.0 image `thehive-<version>.tar`
* `k8s/`: The Helm chart for the [Kubernetes deployment method](kubernetes.md)

This procedure needs the `install/` directory and the `thehive-flow-<version>.tar` archive. The `thehive-flow-assistant-<version>.tar` archive in `images/` is used by the Kubernetes deployment only, and TheHive 6.0 image `thehive-<version>.tar` goes to TheHive host at [step 4](#step-4-deploy-or-upgrade-thehive).

1. Copy the Docker Compose directory to `/opt/orchestrator` on the target host, then the image archive into it. The `/opt/orchestrator` directory must not exist before the first command: `scp` then creates it with the contents of `install/`.

    ```bash
    scp -r install <user>@<flow_host>:/opt/orchestrator
    scp images/thehive-flow-<version>.tar <user>@<flow_host>:/opt/orchestrator/
    ssh <user>@<flow_host>
    cd /opt/orchestrator
    ```

2. Load TheHive Flow image:

    ```bash
    docker load -i thehive-flow-<version>.tar
    ```

    The archive loads the image as `ghcr.io/strangebee/thehive-flow:<version>`. The `FLOW_VERSION` variable in `.env`, created at [step 3](#step-3-run-the-bootstrap-script), must match this tag.

## (Optional) Step 2: Provide custom TLS certificates

If you have certificates signed by your own certificate authority (CA), place them in the `certificates` directory before running `init.sh`. The script matches on the exact file names `server.crt`, `server.key`, and `ca.pem`, so rename your files as you copy them:

```bash
cp /path/to/<certificate>    ./certificates/server.crt
cp /path/to/<private_key>    ./certificates/server.key
cp /path/to/<ca_certificate> ./certificates/ca.pem
```

* `server.crt` and `server.key` work as a pair: with both present, `init.sh` uses your certificate. With only one of the two present, the script prints a warning, ignores the file, and generates a self-signed certificate instead.
* `ca.pem` is optional: providing it enables the `ssl_trusted_certificate` directive in the [nginx configuration](../configuration/nginx-configuration.md).
* With no files present, `init.sh` generates a self-signed certificate for the server name set at [step 3](#step-3-run-the-bootstrap-script), valid for 365 days.

## Step 3: Run the bootstrap script

The `init.sh` script automates the following setup tasks:

1/ Checks that the [required software](software-requirements.md) is installed: Docker Engine, the Docker Compose v2 plugin, and openssl.  

2/ Detects the Docker endpoint, Unix socket or TCP, used to run code transformations. See [Docker engine access](../configuration/environment-variables.md#docker-engine-access).  

3/ Creates `.env` from `.env.example`, filling random 256-bit secrets with `openssl rand`.  

4/ Prompts for the server name, used as the nginx host name and in the TLS certificate. The default is the system host name. In non-interactive runs, set the `SERVICE_HOSTNAME` environment variable instead.  

5/ Generates `docker-compose.override.yml` for Docker engine access, with a socket mount or a TCP endpoint.  

6/ Creates the named Docker volumes `orchestrator-postgres-data` and `orchestrator-s3-data`.  

7/ Creates the `orchestrator/secret/` directory with mode 755.  

8/ Generates `temporal/.resolved.yaml`, the Temporal configuration with passwords resolved.  

9/ Starts PostgreSQL temporarily, runs `temporal-sql-tool` to initialize the schema, and creates the `default` namespace.  

10/ Prints next steps.  

1. Run the script a first time:

    ```bash
    bash ./scripts/init.sh
    ```

    The run performs tasks 1 to 8, then stops with an error similar to the following. That's expected: `.env` now exists and holds every generated value, except TheHive URL.

    ```text
    error while interpolating services.orchestrator.environment.ORCHESTRATOR_THEHIVE_URL: required variable ORCHESTRATOR_THEHIVE_URL is missing a value: ORCHESTRATOR_THEHIVE_URL must be set in .env
    ```

2. Edit `.env` and set `ORCHESTRATOR_THEHIVE_URL` to the address of TheHive host as reachable from the `orchestrator` container:

    ```ini
    ORCHESTRATOR_THEHIVE_URL=http://<thehive_host>:9000
    ```

    TheHive doesn't need to be running yet: set the address it will be reachable at. TheHive itself is deployed at [step 4](#step-4-deploy-or-upgrade-thehive).

    For an `https://` address whose certificate is signed by an internal CA, see [TLS toward TheHive](../operations/security.md#tls-toward-thehive).

3. Run the script again to complete tasks 9 and 10:

    ```bash
    bash ./scripts/init.sh
    ```

!!! tip "Safe to run again"
    The `init.sh` script is idempotent and never overwrites an existing `.env`. If it fails partway for any other reason, fix the cause and run it again.

!!! example "Expected output"

    The transcripts below are trimmed: version numbers, the certificate details, and the full next-steps text vary.

    The first run, up to the expected stop:

    ```text
    Checking prerequisites
    [*] docker: Docker version ...
    [*] docker compose: ...

    Detecting Docker engine endpoint
    [*] Unix socket: /var/run/docker.sock (GID 988)

    Bootstrapping .env
    [*] Copied .env.example -> .env
    [*] Generated random secrets for JWT_SIGNING_KEY, POSTGRES_PASSWORD,
    [*]   ORCHESTRATOR_DB_PASSWORD, TEMPORAL_DB_PASSWORD, GRAFANA_ADMIN_PASSWORD,
    [*]   BEEFLOW_SECRET_S3_SECRET_ACCESS_KEY.
    Server Name (default: flow-host ): flow.example.com
    [✔] Generating self-signed certificate...
    [✔] Self-signed certificate generated for flow.example.com.
    [*] Set .env permissions to 600 (owner-only).

    Generating docker-compose.override.yml
    [*] Generated override: unix socket mount + group_add.

    Creating named volumes
    [*] Created volume: orchestrator-postgres-data
    [*] Created volume: orchestrator-s3-data

    Preparing secret/ directory
    [*] orchestrator/secret/ directory ready (mode 755).
    [!] orchestrator/secret/thehive-api-key is missing — you MUST create it before starting.

    Setting up Temporal database schema
    [*] Generating resolved Temporal config...
    [*] Written temporal/.resolved.yaml (mode 644).
    [*] Starting PostgreSQL...
    error while interpolating services.orchestrator.environment.ORCHESTRATOR_THEHIVE_URL: ...
    ```

    The second run, after `ORCHESTRATOR_THEHIVE_URL` is set:

    ```text
    Bootstrapping .env
    [!] .env already exists — not overwriting. Skipping secret generation.

    Generating docker-compose.override.yml
    [!] docker-compose.override.yml already exists — not overwriting.

    ...

    Setting up Temporal database schema
    [*] Starting PostgreSQL...
    [*] PostgreSQL is healthy.
    [*] Initializing Temporal schemas via temporal-sql-tool...
    [*] Temporal schemas initialized.

    Creating Temporal 'default' namespace
    [*] Temporal server is healthy.
    [*] Namespace 'default' created.
    [*] Stopping services (will start with 'docker compose up -d').

    Next steps
    ...
    ```

    * The `[!]` warning about `orchestrator/secret/thehive-api-key` is expected at this point: the key is provisioned at [step 5](#step-5-provision-thehive-api-key).
    * With custom certificates provided at [step 2](#optional-step-2-provide-custom-tls-certificates), the two certificate lines are replaced by a single `Using custom certificates found in ./certificates.` line.
    * A line starting with `/!\` is an error: the script stops, and running it again after fixing the cause is safe.

## Step 4: Deploy or upgrade TheHive

The following steps require TheHive 6.x running and reachable from TheHive Flow stack. TheHive 6.0 image ships as the `thehive-<version>.tar` Docker archive in the `images/` directory of the deployment bundle. Copy it to TheHive host and load it there:

```bash
docker load -i thehive-<version>.tar
```

The archive loads the image as `ghcr.io/strangebee/thehive:<version>`.

* For a new deployment, see [Deploy TheHive with Docker Compose](../../thehive/installation/docker.md).
* To upgrade an existing TheHive 5.x instance, see [Upgrade from TheHive 5.x](../../thehive/installation/upgrade-from-5.x.md).

!!! warning "Point the Docker Compose profile at the loaded image"
    Whichever procedure you follow, TheHive Flow requires the image loaded above. The StrangeBee Docker Compose profiles, `testing`, `prod1-thehive`, and `prod2-thehive`, reference TheHive image on Docker Hub.

    In the profile directory, edit the `image` line of the `thehive` service in `docker-compose.yml`:

    ```yaml
    thehive:
      image: "ghcr.io/strangebee/thehive:${thehive_image_version}"
    ```

    Then set the tag printed by `docker load` in the `.env` file located next to `docker-compose.yml`:

    ```ini
    thehive_image_version=<version>
    ```

    Left unchanged, the profile pulls a TheHive 5.x image from Docker Hub instead of using the image loaded from the archive.

## Step 5: Provision TheHive API key

1. Sign in to TheHive with an account that has the predefined Org-Admin profile.

2. Generate a dedicated API key for an account whose profile includes all available permissions: TheHive Flow uses the key for every action workflows perform in TheHive, such as creating cases or updating alerts. Any account type works, but a [service account](../../thehive/user-guides/organization/configure-organization/manage-user-accounts/about-user-accounts.md#types) is recommended: it can't sign in to the UI and isn't tied to a person. See [Create a User Account](../../thehive/user-guides/organization/configure-organization/manage-user-accounts/create-a-user-account.md) and [Manage a User Account API Key](../../thehive/user-guides/organization/configure-organization/manage-user-accounts/manage-user-accounts.md#manage-a-user-account-api-key).

3. Add the API key to `.env` on TheHive Flow host:

    ```ini
    BEEFLOW_SECRET_THEHIVE_API_KEY=<thehive_api_key>
    ```

    Alternatively, store it in a secret file:

    ```bash
    printf '%s' '<thehive_api_key>' > ./orchestrator/secret/thehive-api-key
    chmod 644 ./orchestrator/secret/thehive-api-key
    ```

    Mode 644 is required: the container process runs as the unprivileged UID 65532 and reads the host-owned file through the world-readable bit. See the [secrets inventory](../operations/security.md#secrets-inventory).

## Step 6: Configure TheHive to reach TheHive Flow

TheHive must know the public URL of TheHive Flow host and the [JWT signing key](../configuration/environment-variables.md) generated by `init.sh`. Where that configuration goes depends on how TheHive container starts: check the `thehive` service in TheHive `docker-compose.yml` file for `--no-config` in its `command`, or `TH_NO_CONFIG=1` in its environment. The StrangeBee Docker Compose profiles, `testing`, `prod1-thehive`, and `prod2-thehive`, all ship `command: '--no-config --no-config-secret'`.

1. On TheHive Flow host, read the key from the `.env` file at the root of the Docker Compose directory:

    ```bash
    grep JWT_SIGNING_KEY /opt/orchestrator/.env
    ```

2. On TheHive host, declare the connection and activate the feature, using the key from the previous command.

    === "TheHive started with `--no-config`"

        With `command: '--no-config'` or `TH_NO_CONFIG=1`, TheHive ignores the `TH_*` environment variables that generate configuration. All configuration goes in the `application.conf` file TheHive reads at `/etc/thehive/application.conf`.

        The StrangeBee Docker Compose profiles ship that file as `thehive/config/application.conf` and mount the directory at `/etc/thehive` in TheHive container. Add the following to it, next to the connector lines it already holds:

        ```yaml
        orchestrator.url             = "https://<flow_host>/"
        orchestrator.jwt_signing_key = "<jwt_signing_key>"
        features.Orchestrator.enabled = true
        scalligraph.modules += "org.thp.thehive.connector.orchestrator.OrchestratorModule"
        ```

        On a deployment that provides no such file, create it and mount it in `docker-compose.yml`:

        ```yaml
        volumes:
          - /path/to/application.conf:/etc/thehive/application.conf:ro
        ```

    === "TheHive started without `--no-config`"

        TheHive [Docker entrypoint](../../thehive/configuration/thehive-docker-entrypoint-settings.md) reads `TH_*` environment variables. Declare the connection in TheHive `docker-compose.yml` file:

        ```yaml
        environment:
          TH_ORCHESTRATOR_KEY: "<jwt_signing_key>"
          TH_ORCHESTRATOR_URL: "https://<flow_host>/"
        ```

        The two variables declare the connection but don't turn it on: add the feature flag and the connector module to an `application.conf` file mounted at `/etc/thehive/application.conf` in TheHive container. The entrypoint includes that file automatically in the configuration it generates.

        ```yaml
        features.Orchestrator.enabled = true
        scalligraph.modules += "org.thp.thehive.connector.orchestrator.OrchestratorModule"
        ```

        Mount the file in `docker-compose.yml`:

        ```yaml
        volumes:
          - /path/to/application.conf:/etc/thehive/application.conf:ro
        ```

3. Recreate TheHive container. A plain `docker compose restart` applies neither the environment variables nor the new volume mount:

    ```bash
    docker compose up -d thehive
    ```

### TLS with a self-signed certificate

When `init.sh` generated a self-signed certificate because no custom certificate was provided at step 2, TheHive Java Virtual Machine (JVM) rejects the connection by default. Two options are available.

#### Option A: Turn off certificate verification

With this option, TheHive accepts any certificate without verifying it. It's the quickest to set up, but TheHive can no longer detect a server impersonating TheHive Flow host: reserve it for trusted internal networks.

Add the following line to TheHive `application.conf` file:

```yaml
play.ws.ssl.loose.acceptAnyCertificate = true
```

#### Option B: Trust the specific certificate

With this option, certificate verification stays on and TheHive trusts the specific TheHive Flow certificate. It's the more secure choice.

1. Copy `nginx/certs/server.crt` from TheHive Flow host to TheHive host.

2. Mount it into TheHive container at `/etc/thehive/orchestrator-nginx.crt` in `docker-compose.yml`:

    ```yaml
    volumes:
      - /path/to/orchestrator-nginx.crt:/etc/thehive/orchestrator-nginx.crt:ro
    ```

3. Declare it as trusted in TheHive `application.conf` file:

    ```yaml
    play.ws.ssl {
      trustManager {
        stores = [
          { type: "PEM", path: "/etc/thehive/orchestrator-nginx.crt" }
        ]
      }
    }
    ```

4. Recreate TheHive container. A plain `docker compose restart` doesn't apply the new volume mount:

    ```bash
    docker compose up -d thehive
    ```

## Step 7: Start the stack

Back on TheHive Flow host, start all services with Docker Compose:

```bash
docker compose up -d
```

## Step 8: Verify the deployment

On TheHive Flow host, check that all containers are running and that the [health endpoints](../operations/monitoring.md#health-endpoints) respond:

```bash
docker compose ps
curl -fsS http://127.0.0.1:9090/livez
curl -fsS http://127.0.0.1:9090/readyz
```

`/livez` confirms the HTTP server is up. `/readyz` confirms TheHive Flow can reach its database and the Temporal workflow engine, and returns `503` naming the failing check otherwise.

!!! example "Expected output"

    The `docker compose ps` listing, trimmed to the relevant columns:

    ```text
    NAME                         SERVICE         STATUS
    nginx                        nginx           Up 2 minutes
    orchestrator                 orchestrator    Up 2 minutes
    orchestrator-init-s3-store   init-s3-store   Exited (0)
    orchestrator-postgres        postgresql      Up 2 minutes (healthy)
    orchestrator-s3-store        s3-store        Up 2 minutes (healthy)
    orchestrator-temporal        temporal        Up 2 minutes (healthy)
    ```

    The `orchestrator` and `nginx` containers define no Docker health check, so their status carries no `(healthy)` suffix: the two `curl` probes cover TheHive Flow health instead.

    A healthy `/livez` returns `200` with an empty body. A healthy `/readyz` reports each check:

    ```json
    {"status":"ok","checks":{"db":"ok","modules":"ok","temporal":"ok"}}
    ```

In `docker compose ps`, `init-s3-store` shows `Exited (0)` and that's the expected steady state: it's a one-shot container that provisions the object storage identity and bucket, verifies both, then exits. Everything else should show a `running` or `healthy` status. Only a non-zero exit code on `init-s3-store` indicates a problem: see [Troubleshoot TheHive Flow](../operations/troubleshooting.md#startup-and-initialization).

## Step 9: Check the connection in TheHive

Sign in to TheHive with an account that has the predefined Org-Admin profile, which includes the TheHive Flow permissions automatically.

The health indicator at the bottom of the sidebar menu reports the connection from any view. It covers every configured connector, TheHive Flow along with Cortex, MISP, and Email Intake, so its color answers for all of them at once:

* Green: every configured connector is healthy.
* Red: at least one configured connector is in error.
* Faded: no connector is configured.

Select the indicator to see the details. Its **Flow** section shows TheHive Flow URL and its own status, `OK` or `ERROR`. TheHive probes TheHive Flow every minute by default, so allow that long for the status to reflect a fix. Changing `orchestrator.url` or `orchestrator.jwt_signing_key` triggers an immediate check.

Then go to the **Flow** view from the sidebar menu.

* If the view displays the workflow list, empty on a fresh deployment but with the **Import workflow** button visible, TheHive and TheHive Flow are connected.
* If the view is missing from the sidebar, review the configuration from [step 6](#step-6-configure-thehive-to-reach-thehive-flow) and restart TheHive.
* If the view displays an error notification over an empty workflow list, TheHive can't reach TheHive Flow: see [Troubleshoot TheHive Flow](../operations/troubleshooting.md#authentication-and-jwt).

## Step 10: Grant users access to TheHive Flow

Users who don't have one of the predefined Org-Admin and Analyst profiles need the TheHive Flow permissions through a custom profile: see [Perform TheHive Flow Initial Setup as an Admin](perform-initial-setup-as-admin.md).

<h2>Next steps</h2>

* [TheHive Flow Configuration Files](../configuration/configuration-files-overview.md)
* [TheHive Flow Environment Variables](../configuration/environment-variables.md)
* [TheHive Flow Application Configuration](../configuration/flow-configuration.md)
* [Authentication Between TheHive Flow Components](../operations/component-authentication.md)
* [Monitor TheHive Flow](../operations/monitoring.md)
* [Troubleshoot TheHive Flow](../operations/troubleshooting.md)
