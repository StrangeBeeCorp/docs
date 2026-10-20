# Back Up and Restore TheHive Flow

<!-- md:version 6.0 --> <!-- md:license One -->

[TheHive Flow](../user-guides/about-flow.md) keeps its state in two directories of the profile directory, mounted into the containers: `postgresql/data`, holding the databases, and `s3-store/data`, holding the blobs. The configuration, the TLS certificates, and the `.env` file sit beside them, so the whole profile directory is the unit to back up.

{% include-markdown "includes/scope-docker-compose-flow.md" %}

## What's backed up

The `backup.sh` script copies the following folders and files of the profile directory:

| Data | Folder | Notes |
| ---- | ------ | ----- |
| The `thehive_flow` database | `postgresql/data` | Workflows, runs, variables, [webhook](../user-guides/add-trigger.md#add-a-webhook-trigger) configuration, run and step execution history |
| Temporal persistence | `postgresql/data` | The `temporal` and `temporal_visibility` databases, holding the in-flight workflow state. Captured with the database above, as one PostgreSQL data directory |
| Blob store contents | `s3-store/data` | Files ingested through webhooks or runs, and promoted activity outputs, in the shipped object storage |
| Application configuration and secrets | `thehive-flow/` | `thehive-flow.yml`, TheHive API key file, and the SMTP password file of an [email server override](../configuration/flow-configuration.md#email-server-override) |
| Temporal configuration | `temporal/` | Including the rendered `temporal-server.yaml`, which holds the Temporal database password |
| Nginx configuration and TLS material | `nginx/`, `certificates/` | The template, the certificate, and the private key |
| Environment file | `.env`, stored as `dot.env` | Every secret of the stack, the image versions, and the runtime parameters. The databases can only be restored together with it |

Two kinds of data fall outside the script:

* An external S3-compatible object storage, configured as described in [S3 back end](../configuration/flow-configuration.md#s3-back-end). Back it up with the tooling of the storage service.
* A blob directory of the [local filesystem back end](../configuration/flow-configuration.md#local-filesystem-back-end) located outside the profile directory. Capture it with your own tooling.

In both cases, capture the blobs and the PostgreSQL data at the same time, for the reason below.

!!! note "The database and the blobs are one unit"
    Rows in the `thehive_flow` database reference blobs by content hash. Restoring the database against a blob store that doesn't hold the referenced content leaves dangling references that TheHive Flow can't detect. A workflow reading such a file fails at run time, not at restore time. The coupling holds in both directions: files are deleted once their runs are purged, so a database older than the blob store references files deleted since. Whichever method you use, capture both together.

!!! warning "Backups carry every secret of the stack"
    A backup holds `.env`, the rendered Temporal configuration, the API key file, the TLS private key, the S3 identity the object storage stores in its data, and the database with the organization [secret variables](../user-guides/manage-global-variables.md) and the [settings pushed by TheHive](security.md#settings-pushed-by-thehive). The script creates each backup folder readable by its owner only. Treat the backup location with the same care as `.env`, and [encrypt the backups before shipping them off-host](#optional-step-3-ship-the-backups-off-host).

## Step 1: Choose a backup method

| Method | When | TheHive Flow downtime | Consistency |
| ------ | ---- | --------------------- | ----------- |
| [Method 1: Instance or volume snapshot](#method-1-instance-or-volume-snapshot) | Single-node host on a platform that offers snapshots, the common case | None: the stack keeps running | Guaranteed by the platform: the whole profile directory is captured at one point in time |
| [Method 2: Cold backup with `backup.sh`](#method-2-cold-backup) | No snapshot facility available, a portable copy restorable on another host, or before a risky operation such as an [upgrade](../installation/upgrade-docker.md) | The whole stack is stopped for the duration of the copy, proportional to the size of the data directories | Guaranteed by the script: everything is stopped before the copy |

## Step 2: Run the backup

Run the method you chose at [Step 1](#step-1-choose-a-backup-method).

### Method 1: Instance or volume snapshot

Use a snapshot when your host runs on a platform that offers snapshots: it's the simplest option and requires no downtime. A snapshot taken while the stack runs captures `postgresql/data`, `s3-store/data`, and `.env` at the same instant, so the database, the Temporal persistence, and the blobs can't drift apart.

Use your platform's own tooling, such as AWS EBS snapshots, hypervisor snapshots, or LVM. Nothing in the stack is needed, and the stack doesn't interfere with it.

Two caveats:

* A snapshot of a running PostgreSQL is a crash-consistent image, not a clean copy: PostgreSQL replays its write-ahead log on restore, which is supported but isn't the same guarantee as a copy taken while the service is stopped. For a guaranteed-clean copy, take a cold backup as well.
* Snapshot size follows the data directories. See [Blob store volume sizing](../installation/system-requirements.md#blob-store-volume-sizing).

### Method 2: Cold backup

{% include-markdown "includes/maintenance-window-required.md" %}

Use a cold backup when no snapshot facility is available, when you want a copy restorable on any host running the same profile, or before a risky operation such as an upgrade.

Run the script from the profile directory, with the path of the profile directory and the root folder of the backups. Without arguments, the script prompts for both, with `.` and `./backup` as defaults. Prefer a dedicated location with enough space, such as a mounted backup volume:

```bash
bash ./scripts/backup.sh . /opt/backups/thehive-flow
```

What the script does:

1/ Creates the backup folder, `<backup_root>/<timestamp>/`, readable by its owner only, and starts a log file next to it, `backup_log_<timestamp>.log`.  

2/ Stops every service of the stack with `docker compose stop`.  

3/ Copies the `postgresql`, `s3-store`, `thehive-flow`, `temporal`, `nginx`, and `certificates` folders with `rsync`, preserving ownership and permissions.  

4/ Copies `.env` as `dot.env`.  

5/ Restarts the stack with `docker compose up -d`. The restart also runs when a copy fails, so a failed backup doesn't leave the stack stopped.  

The backup folder mirrors the profile directory:

```text
/opt/backups/thehive-flow
├── 20260115-0200-0100
│   ├── certificates
│   ├── dot.env
│   ├── nginx
│   ├── postgresql
│   ├── s3-store
│   ├── temporal
│   └── thehive-flow
└── backup_log_20260115-0200-0100.log
```

The stack is unavailable for the whole copy. The duration is proportional to the size of `postgresql/data` and `s3-store/data`: on an installation handling large files, measure it once before scheduling, with `time bash ./scripts/backup.sh . /opt/backups/thehive-flow`.

Runs in flight when the services stop don't fail: Temporal keeps their state in the copied databases and they resume once the stack restarts. TheHive Flow detects a step still executing at that moment as interrupted shortly after. It then re-runs it from the start if it has retries configured, and fails it otherwise.

## (Optional) Step 3: Ship the backups off-host

This step applies to the folders produced by method 2. The platform stores method 1 snapshots.

Ship the backup folders off-host using your existing tooling: the stack doesn't handle this automatically. Ship whole folders: a database directory without its `dot.env` or its blobs can't be restored.

Recommended options:

* Copy the backups to a backup server with rsync:

    ```bash
    rsync -az /opt/backups/thehive-flow/ <backup_server>:/srv/backups/thehive-flow/
    ```

* Upload them to S3:

    ```bash
    aws s3 sync /opt/backups/thehive-flow/<timestamp> s3://<bucket>/thehive-flow/<timestamp>/
    ```

* Encrypt them before shipping, as one archive per backup folder:

    ```bash
    tar czf - -C /opt/backups/thehive-flow <timestamp> \
      | gpg --encrypt --recipient <recipient> -o /opt/backups/thehive-flow-<timestamp>.tar.gz.gpg
    ```

## (Optional) Step 4: Schedule automated backups

The cron example below schedules method 2. For method 1, configure the cadence and retention in your platform's snapshot tooling instead. Because method 2 stops the stack, schedule it when as few workflows as possible run, and account for the downtime in the service expectations of TheHive Flow. Webhook calls arriving during the copy are refused, and TheHive reports the connection as down.

The recommended retention is daily backups for 30 days, with at least one weekly backup shipped to a geographically separate location.

Size the retention against the data directories: a backup is a full copy, and the blob store is usually by far the larger half. Measure one backup before committing to a retention window, and prefer snapshots if the platform offers them.

Example cron entries, running daily at 2 AM and keeping 30 days of backups. Pass both arguments to the script: without them, it prompts and the job hangs.

```cron
0 2 * * * cd <profile_directory> && bash ./scripts/backup.sh . /opt/backups/thehive-flow >> /var/log/thehive-flow-backup.log 2>&1
0 3 * * * find /opt/backups/thehive-flow -mindepth 1 -maxdepth 1 -type d -mtime +30 -exec rm -rf {} +
0 3 * * * find /opt/backups/thehive-flow -maxdepth 1 -name 'backup_log_*.log' -mtime +30 -delete
```

## Step 5: Restore

{% include-markdown "includes/maintenance-window-required.md" %}

The `restore.sh` procedure below restores a backup folder produced by [method 2](#method-2-cold-backup), on a host running the same profile. To restore a method 1 snapshot, use your platform's snapshot tooling instead.

1. Stop the stack. The script refuses to run while any service is up:

    ```bash
    docker compose down
    ```

2. Empty the data directories. Pre-existing files can conflict with the restored ones:

    ```bash
    rm -rf ./postgresql/data/* ./s3-store/data/*
    ```

3. Run the restore, with the path of the profile directory and the backup folder to restore. Without arguments, the script prompts for both:

    ```bash
    bash ./scripts/restore.sh . /opt/backups/thehive-flow/<timestamp>
    ```

What the script does:

1/ Checks that the backup folder exists and holds a `dot.env` file, and that no service is running.  

2/ Copies the `postgresql`, `s3-store`, `thehive-flow`, `temporal`, `nginx`, and `certificates` folders back into the profile directory with `rsync`, overwriting what's there.  

3/ Restores `dot.env` as `.env`. The restored file carries the secrets that match the restored databases and the object storage identity, and the image versions the backup was taken with.  

4/ Starts the stack with `docker compose up -d`, and logs the whole operation in `restore_log_<timestamp>.log` in the current directory.  

Because the Temporal persistence is restored together with the `thehive_flow` database, the two stores are consistent. Runs that were in flight at backup time resume where they were, and nothing that happened after the backup remains.

!!! note "Restoring on another host"
    The restored `.env` carries the user and group identifiers, the Docker socket group, and the server name of the host the backup was taken on, and `restore.sh` starts the stack with them. On another host, fix them right after the restore:

    1. Stop the stack the script started:

        ```bash
        docker compose down
        ```

    2. Make the two data directories owned by the user who runs the stack. This is needed when the restore ran as root, because the directories then keep the ownership of the original host. The `init.sh` script doesn't check these two directories:

        ```bash
        sudo chown -R <uid>:<gid> ./postgresql/data ./s3-store/data
        ```

    3. Run `bash ./scripts/init.sh` to detect the identifiers and the Docker socket group again, and confirm the server name and TheHive settings. The script keeps the restored secrets. Without a custom certificate, it generates a new self-signed certificate for the new host, so a TheHive that trusts the specific certificate needs the new one: see [TLS certificate renewal](security.md#tls-certificate-renewal).

    4. Start the stack:

        ```bash
        docker compose up -d
        ```

## Step 6: Verify the restore

Check that all containers are running and that the [health endpoints](monitoring.md#health-endpoints) respond:

```bash
docker compose ps -a
curl -fsS http://127.0.0.1:9090/readyz
```

Then, in TheHive, go to the **Flow** view and check that the workflows and the run history of the backup are back.

<h2>Next steps</h2>

* [TheHive Flow Security](security.md)
* [TheHive Flow System Requirements](../installation/system-requirements.md)
* [Troubleshoot TheHive Flow](troubleshooting.md)
