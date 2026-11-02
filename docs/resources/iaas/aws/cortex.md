# Usage Instructions for the Official AMI Version of Cortex

[:fontawesome-brands-aws: Official AMI](https://aws.amazon.com/marketplace/pp/prodview-6mcx44ljm4qla){ .md-button target=_blank } This AMI is the official Cortex 3 release on AWS Marketplace.

Use the AMI to set up a new Cortex installation, or to launch an instance with existing data and configuration to upgrade, migrate, or restore Cortex.

## Introduction

* The AMI is based on the official Ubuntu 24.04 LTS AMI from Canonical.
* The AMI is updated with each new Cortex release. To upgrade, launch a new instance from the latest AMI, as you would with a container.
* Cortex data and the Docker images for analyzers and responders are stored on two dedicated EBS volumes, not in the root filesystem. At launch, the AMI creates two persistent EBS volumes that aren't deleted when the instance is terminated, so your data isn't lost by accident. The volumes are encrypted with your default KMS key.
    * The volume for Cortex data, `/dev/sdh`, is 30 GB by default.
    * The Docker volume, `/dev/sdi`, is 20 GB by default.
* The underlying Ubuntu OS is hardened, except for network filtering. The image contains no iptables rules, so it doesn't conflict with security groups.

## Run context

* Cortex runs as the unprivileged user *cortex* and listens on HTTP port 9001. This port uses HTTP, not HTTPS. Never open it outside your VPC. Use a public-facing load balancer or reverse proxy to handle TLS sessions with end users. The AMI doesn't include a load balancer or reverse proxy. Many Cortex users also run TheHive and Malware Information Sharing Platform & Threat Sharing (MISP) instances alongside it and already have one they prefer.
* The default sudoer user is *ubuntu*, and the SSH service listens on port 22.
* Cortex looks for custom analyzers in `/opt/cortexneurons/analyzers` and for custom responders in `/opt/cortexneurons/responders`.
* A cron job for the *cortex* user runs every night with the `@daily` schedule. It backs up the application configuration and the custom analyzers and responders to the data volume at `/var/lib/elasticsearch/cortex/`. To restore the configuration and the custom analyzers and responders when launching a new instance from existing data, this job must have run at least once after the initial installation.

## Launching an instance for a new Cortex installation

1. Launch an instance from the AMI.
2. SSH into the instance with the *ubuntu* user.
3. Initialize and format the additional EBS volumes: `/dev/sdh` and `/dev/sdi`. On Nitro-based instances, `/dev/sdh` and `/dev/sdi` might appear under names such as `/dev/nvme1n1` and `/dev/nvme2n1`. For more information, see [Amazon EBS and NVMe on Linux instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html#identify-nvme-ebs-device).
4. Launch the application initialization script with the block device names of the EBS data volumes as arguments. With a default AMI setup, these are `/dev/sdh` and `/dev/sdi`. On Nitro-based instances, don't use the NVMe names such as `/dev/nvme1n1`. Example: `/opt/cortex/ops/scripts/ops-cortex-init.sh /dev/sdh /dev/sdi`
5. Cortex is now available on port 9001. Create the admin account the first time you connect to Cortex.

Alternatively, perform steps 3 and 4 by providing cloud-init user data to the AMI at launch. In the following example, which uses a Nitro-based m5 instance, the user data:

* Runs a script that exposes the external volumes, which the instance sees as `/dev/nvme1n1` and `/dev/nvme2n1`, under their block device mapping names, `/dev/sdh` and `/dev/sdi`
* Partitions and formats the EBS volumes using their block device mapping names
* Launches the initialization script with the EBS block mapping names as arguments, `/dev/sdh` and `/dev/sdi`, not `/dev/nvme0n1` and `/dev/nvme1n1`

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
    runcmd:
        - [ /opt/cortex/ops/scripts/ops-cortex-init.sh, /dev/sdh, /dev/sdi ]
    ```

You can also provision Cortex using Terraform. The StrangeBee [cloud-distrib-resources repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/aws) on GitHub provides detailed sample code.

## Launching an instance with existing data to upgrade, migrate, or restore Cortex

1. Launch an instance from the AMI. Base the additional EBS volumes, `/dev/sdh` and `/dev/sdi` by default, on existing snapshots of the data and Docker volumes from a previous Cortex instance.
2. SSH into the instance with the *ubuntu* user.
3. Launch the restore script with the block device names of the EBS data volumes as arguments. With a default AMI setup, these are `/dev/sdh` and `/dev/sdi`. On Nitro-based instances, don't use the NVMe names such as `/dev/nvme1n1`. Example: `/opt/cortex/ops/scripts/ops-cortex-restore.sh /dev/sdh /dev/sdi`
4. Cortex is now available on port 9001, or on the custom port you configured, with all your existing configuration, users, and data. Custom analyzers and responders stored under `/opt/cortexneurons` are also restored, and their pip requirements are reinstalled.

Alternatively, perform step 3 by providing cloud-init user data to the AMI at launch. The following example, which uses a Nitro-based m5 instance, launches the restore script with the EBS block mapping names as arguments, `/dev/sdh` and `/dev/sdi`, not `/dev/nvme1n1` and `/dev/nvme2n1`.

!!! Example ""

    ```yaml
    #cloud-config 
    runcmd:
        - [ /opt/cortex/ops/scripts/ops-cortex-restore.sh, /dev/sdh, /dev/sdi ]
    ```

You can also provision Cortex using Terraform. The StrangeBee [cloud-distrib-resources repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/aws) on GitHub provides detailed sample code.
