# Usage instructions for the official TheHive v5 AMI

[:fontawesome-brands-aws: Official AMI](https://aws.amazon.com/marketplace/pp/prodview-gcjij3iscupae){ .md-button target=_blank }

The AMI can be used to set up a shiny-new TheHive v5 install or to launch an instance with existing data and configuration (for update / migration / restore purposes).

## Introduction

* You can easily initialise a new instance or restore a previous TheHive v5 instance using scripts included in the image.
* Data is stored on three dedicated volumes: one for the Cassandra database (/var/lib/cassandra), another one for storage attachments (/opt/thp_data/files) and a final one for indexes (/opt/thp_data/index).
* The AMI is based on the official Ubuntu 20.04 LTS AMI from Canonical .
* The default OS hardening has been further improved compared to our previous Ubuntu 18.04 based AMIs.
* The AMI is updated whenever a new TheHive version is released - no need to bother updating TheHive anymore, just launch a new instance as if it were a container!
* Migration from TheHive v3 is a manual operation detailed at length in the documentation: [https://docs.strangebee.com/thehive/setup/installation/migration/](https://docs.strangebee.com/thehive/setup/installation/migration/).
* Upgrading from TheHive v4 AMI is not yet automated or documented (it will be very soon in a coming AMI update). If you are in a hurry, the overall upgrade process is documented here: [https://docs.strangebee.com/thehive/setup/installation/upgrade-from-4.x/](https://docs.strangebee.com/thehive/setup/installation/upgrade-from-4.x/)

## Run context

* TheHive app runs as an unprivileged user named _thehive_ and is available on port http 9000 (that's _http_ and NOT _https_). Needless to say we encourage you never to open that port outside your VPC and use a public-facing load balancer and / or reverse proxy to handle the TLS sessions with end-users. Since many TheHive users also run Cortex and MISP instances alongside and since the right load balancer / reverse proxy is obviously the one you know best, we elected not to include yet another one in this AMI.
* As an incentive to use https, TheHive is configured to use secure cookies by default. Connecting to the UI in http will fail. An override to this remains possible in the configuration: set `play.http.session.secure = false` in `/etc/thehive/application.conf`. You must restart the `thehive` service for the change to be effective.
* The default sudoer user is _ubuntu_ and the ssh service listens on port 22.
* A cronjob for user _thehive_ runs every night (@daily) to backup the application configuration to the data volume (/var/lib/cassandra/thehive/). If you wish to launch a new instance from existing data, this job must have run at least once after the initial install in order to restore the application's configuration as well.

## Launching an instance with no existing data (new TheHive install)

1. Launch an instance from the AMI.
2. SSH into the instance with the _ubuntu_ user.
3. Initialize and format the additional EBS volumes (`/dev/sdh`, `/dev/sdi` and `/dev/sdj`). Note that in Nitro-based instances, `/dev/sdh` might be available as something like `/dev/nvme1n1`. More information is available in [Amazon EBS and NVMe on Linux Instances documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html#identify-nvme-ebs-device).
4. Launch the application initialization script with the EBS data volumes block device names as arguments, which are `/dev/sdh`, `/dev/sdi` and `/dev/sdj` if you are using a default AMI setup. If you are using a Nitro-based instance, **do not** use the nvme names (like /dev/nvme0n1). Example: `/opt/thehive/ops/scripts/ops-thehive-init.sh /dev/sdh /dev/sdi /dev/sdj`
5. That's it! TheHive is now available on port 9000. The default admin account is "admin@thehive.local" with password "secret" (change it!).

Alternately, you can easily perform steps 3 and 4 by providing cloud-init user data to the AMI at launch. In the following example using an m5 instance (Nitro-based), we:
* launch a script that will expose the external volumes, seen by the instance as /dev/nvme1n1 and /dev/nvme2n1, with their block device mapping names (/dev/sdh, /dev/sdi)
* partition and format the EBS volumes using their block device mapping names (/dev/sdh, /dev/sdi)
*  launch the initialisation script with the EBS block mapping names as argument (`/dev/sdh`, `/dev/sdi` and `/dev/sdj`)


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

You can also provision the whole thing using Terraform; check our [GitHub repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/aws) for detailed sample code.

## Launching an instance with existing data (TheHive update, migration, restore)

1. Launch an instance from the AMI and base the additional EBS volumes (`/dev/sdh`, `/dev/sdi` and `/dev/sdj` by default) on existing TheHive EBS volume snapshots for the Cassandra database (`/dev/sdh`), the storage attachments (`/dev/sdi`) and the database index (`/dev/sdj`).
2. SSH into the instance with the _ubuntu_ user.
3. Launch the TheHive restore script with the EBS data volumes block device names as arguments, which are `/dev/sdh`, `/dev/sdi` and `/dev/sdj` if you are using a default AMI setup. If you are using a Nitro-based instance, **do not** use the nvme names (like /dev/nvme1n1). Example: `/opt/thehive/ops/scripts/ops-thehive-restore.sh /dev/sdh /dev/sdi /dev/sdj`.
4. That's it! TheHive is now available on port 9000 (or on the custom port you had configured) with all your existing configuration, users and data.

Alternately, you can easily perform step 3 by providing cloud-init user data to the AMI at launch. In the following example using an m5 instance (Nitro-based), we:

*  launch the restore script with the EBS block mapping names as arguments (`/dev/sdh`, `/dev/sdi` and `/dev/sdj`)

!!! Example ""

    ```yaml
    #cloud-config
    runcmd:
        - [ /opt/thehive/ops/scripts/ops-thehive-restore.sh, /dev/sdh, /dev/sdi, /dev/sdj ]
    ```

You can also provision the whole thing using Terraform; check our [GitHub repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/aws) for detailed sample code.