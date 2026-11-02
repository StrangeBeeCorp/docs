# Usage Instructions for the Official TheHive 5 AMI

[:fontawesome-brands-aws: Official AMI](https://aws.amazon.com/marketplace/pp/prodview-gcjij3iscupae){ .md-button target=_blank }

Use the AMI to set up a new TheHive 5 installation, or to launch an instance with existing data and configuration to upgrade, migrate, or restore TheHive.

## Introduction

* Scripts included in the image initialize a new instance or restore a previous TheHive 5 instance.
* Data is stored on three dedicated volumes: one for the Cassandra database at `/var/lib/cassandra`, one for storage attachments at `/opt/thp_data/files`, and one for indexes at `/opt/thp_data/index`.
* The AMI is based on the official Ubuntu 24.04 LTS AMI from Canonical.
* The AMI is updated with each new TheHive release. To upgrade, launch a new instance from the latest AMI, as you would with a container.
* Migration from TheHive 3 is a manual operation. See [Migration from TheHive 3.x](../../../thehive/installation/migration.md).
* Upgrading from a TheHive 4 AMI isn't automated or documented yet. For the general upgrade process, see [Upgrade from TheHive 4.x](../../../thehive/installation/upgrade-from-4.x.md).

## Run context

* TheHive runs as an unprivileged user named *thehive* and listens on HTTP port 9000. This port uses HTTP, not HTTPS. Never open it outside your VPC. Use a public-facing load balancer or reverse proxy to handle TLS sessions with end users. The AMI doesn't include a load balancer or reverse proxy. Many TheHive users also run Cortex and Malware Information Sharing Platform & Threat Sharing (MISP) instances alongside it and already have one they prefer.
* TheHive uses secure cookies by default, so connecting to the UI over HTTP fails. To allow HTTP connections, set `play.http.session.secure = false` in `/etc/thehive/application.conf`, then restart the `thehive` service.
* The default sudoer user is *ubuntu*, and the SSH service listens on port 22.
* A cron job for the *thehive* user runs every night with the `@daily` schedule. It backs up the application configuration to the data volume at `/var/lib/cassandra/thehive/`. To restore the configuration when launching a new instance from existing data, this job must have run at least once after the initial installation.

## Launching an instance for a new TheHive installation

1. Launch an instance from the AMI.
2. SSH into the instance with the *ubuntu* user.
3. Initialize and format the additional EBS volumes: `/dev/sdh`, `/dev/sdi`, and `/dev/sdj`. On Nitro-based instances, `/dev/sdh` might appear under a name such as `/dev/nvme1n1`. For more information, see [Amazon EBS and NVMe on Linux instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html#identify-nvme-ebs-device).
4. Launch the application initialization script with the block device names of the EBS data volumes as arguments. With a default AMI setup, these are `/dev/sdh`, `/dev/sdi`, and `/dev/sdj`. On Nitro-based instances, don't use the NVMe names such as `/dev/nvme0n1`. Example: `/opt/thehive/ops/scripts/ops-thehive-init.sh /dev/sdh /dev/sdi /dev/sdj`
5. TheHive is now available on port 9000. The default admin account is `admin@thehive.local` with password `secret`. Change the password after the first login.

Alternatively, perform steps 3 and 4 by providing cloud-init user data to the AMI at launch. In the following example, which uses a Nitro-based m5 instance, the user data:

* Runs a script that exposes the external volumes, which the instance sees as `/dev/nvme1n1` and `/dev/nvme2n1`, under their block device mapping names, `/dev/sdh` and `/dev/sdi`
* Partitions and formats the EBS volumes using their block device mapping names
* Launches the initialization script with the EBS block mapping names as arguments: `/dev/sdh`, `/dev/sdi`, and `/dev/sdj`

!!! Example ""

    ```yaml
    #cloud-config
    bootcmd:
        - [ /usr/sbin/nvme-to-block-mapping ]
    fs_setup:
        - filesystem: ext4
          device: '/dev/sdh'
          partition: auto
          overwrite: false
        - filesystem: ext4
          device: '/dev/sdi'
          partition: auto
          overwrite: false
        - filesystem: ext4
          device: '/dev/sdj'
          partition: auto
          overwrite: false
    runcmd:
        - [ /opt/thehive/ops/scripts/ops-thehive-init.sh, /dev/sdh, /dev/sdi, /dev/sdj ]
    ```

You can also provision TheHive using Terraform. The StrangeBee [cloud-distrib-resources repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/aws) on GitHub provides detailed sample code.

## Launching an instance with existing data to upgrade, migrate, or restore TheHive

1. Launch an instance from the AMI. Base the additional EBS volumes on existing TheHive EBS volume snapshots: `/dev/sdh` for the Cassandra database, `/dev/sdi` for the storage attachments, and `/dev/sdj` for the database index. These are the default device names.
2. SSH into the instance with the *ubuntu* user.
3. Launch the restore script with the block device names of the EBS data volumes as arguments. With a default AMI setup, these are `/dev/sdh`, `/dev/sdi`, and `/dev/sdj`. On Nitro-based instances, don't use the NVMe names such as `/dev/nvme1n1`. Example: `/opt/thehive/ops/scripts/ops-thehive-restore.sh /dev/sdh /dev/sdi /dev/sdj`
4. TheHive is now available on port 9000, or on the custom port you configured, with all your existing configuration, users, and data.

Alternatively, perform step 3 by providing cloud-init user data to the AMI at launch. The following example, which uses a Nitro-based m5 instance, launches the restore script with the EBS block mapping names as arguments: `/dev/sdh`, `/dev/sdi`, and `/dev/sdj`.

!!! Example ""

    ```yaml
    #cloud-config
    runcmd:
        - [ /opt/thehive/ops/scripts/ops-thehive-restore.sh, /dev/sdh, /dev/sdi, /dev/sdj ]
    ```

You can also provision TheHive using Terraform. The StrangeBee [cloud-distrib-resources repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/aws) on GitHub provides detailed sample code.
