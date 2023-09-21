# Usage instructions for the official AMI version of Cortex

[:fontawesome-brands-aws: Official AMI](https://aws.amazon.com/marketplace/pp/prodview-6mcx44ljm4qla){ .md-button target=_blank } This is the official Cortex v3 release for the AWS Marketplace.

The AMI can be used to set up a shiny-new Cortex install or to launch an instance with existing data and configuration (for update / migration / restore purposes).

## Introduction
* Based on the official Ubuntu 20.04 AMI from Canonical
* The AMI is updated whenever a new Cortex version is released - no need to bother updating Cortex anymore, just launch a new instance as if it were a container!
* Cortex data and Docker images (for analyzers and responders) are stored on two dedicated EBS volumes, not in the root filesystem. With that in mind, the AMI will create two persistent EBS data volume at launch that will not be deleted when the instance is terminated so that your data isn't accidentally lost. The volumes will be encrypted with your default KMS key.
    * The Cortex data volume (/dev/sdh) is sized at 30GB by default
    * The Docker volume (/dev/sdi) is sized at 20GB by default
* The underlying Ubuntu OS is hardened to comply with CSL1 (that's Common Sense Level 1!) minus the network filtering. There are no iptables surprises inside the image to avoid conflicting behavior with security groups.

## Run context
* The Cortex app runs as unprivileged user *cortex* and is available on port http 9001 (that's *http* and NOT *https*). Needless to say we encourage you never to open that port outside your VPC and use a public-facing load balancer and / or reverse proxy to handle the TLS sessions with end-users. Since many Cortex users also run TheHive and MISP instances alongside and since the right load balancer / reverse proxy is obviously the one you know best, we elected not to include yet another one in this AMI. We provide more information on using the AWS Application Load Balancer or reverse proxies in our [detailed Cortex AMI user guide](https://link.to.user.guide.request.form).
* The default sudoer user is *ubuntu* and the ssh service listens on port 22.
* The Cortex configuration is set to look for custom analyzers under `/opt/cortexneurons/analyzers` and for custom responders under `/opt/cortexneurons/responders`.
* A cronjob for user *cortex* runs every night (@daily) to backup the application configuration and custom analyzers / custom responders to the data volume (/var/lib/elasticsearch/cortex/). If you wish to launch a new instance from existing data, this job must have run at least once after the initial install in order to restore the application's configuration  and custom analyzers / responders as well. 

## Launching an instance with no existing data (new Cortex install)
1. Launch an instance from the AMI.
2. SSH into the instance with the *ubuntu* user.
3. Initialize and format the additional EBS volumes (/dev/sdh and /dev/sdi). Note that in Nitro-based instances, /dev/sdh and /dev/sdi might be available as something like /dev/nvme1n1 and /dev/nvme2n1. More information is available in [Amazon EBS and NVMe on Linux Instances documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html#identify-nvme-ebs-device).
4. Launch the application initialization script with the EBS data volume block device names as arguments, which is /dev/sdh and /dev/sdi if you are using a default AMI setup. If you are using a Nitro-based instance, **do not** use the nvme names (like /dev/nvme1n1). Example: `/opt/cortex/ops/scripts/ops-cortex-init.sh /dev/sdh /dev/sdi`
5. That's it! Cortex is now available on port 9001. You can create the admin account on the first connection to the app.

Alternatively, you can easily perform steps 3 and 4 by providing cloud-init user data to the AMI at launch. In the following example using an m5 instance (Nitro-based), we:

* launch a script that will expose the external volumes, seen by the instance as /dev/nvme1n1 and /dev/nvme2n1, with their block device mapping names (/dev/sdh, /dev/sdi)
* partition and format the EBS volumes using their block device mapping names (/dev/sdh, /dev/sdi)
* launch the initialisation script with the EBS block mapping names as arguments (/dev/sdh and /dev/sdi - **not** /dev/nvme0n1 and /dev/nvme1n1)

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

You can also provision the whole thing using Terraform; check our [GitHub repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/aws) for detailed sample code.

## Launching an instance with existing data (Cortex update, migration, restore)

1. Launch an instance from the AMI and base the additional EBS volumes (/dev/sdh and /dev/sdi by default) on existing Cortex data and Docker volume snapshots.
2. SSH into the instance with the *ubuntu* user.
3. Launch the Cortex restore script with the EBS data volume block device names as arguments, which are /dev/sdh and /dev/sdi if you are using a default AMI setup. If you are using a Nitro-based instance, **do not** use the nvme names (like /dev/nvme1n1). Example: `/opt/cortex/ops/scripts/ops-cortex-restore.sh /dev/sdh /dev/sdi`.
4. That's it! Cortex is now available on port 9001 (or on the custom port you had configured) with all your existing configuration, users and data. Custom analyzers and responders stored under /opt/cortexneurons are also automatically restored and their pip requirements reinstalled.

Alternatively, you can easily perform step 3 by providing cloud-init user data to the AMI at launch. In the following example using an m5 instance (Nitro-based), we:

!!! Example  "launch the restore script with the EBS block mapping names as arguments (/dev/sdh and /dev/sdi - **not** /dev/nvme1n1 and /dev/nvme2n1)"

    ```yaml
    #cloud-config 
    runcmd:
        - [ /opt/cortex/ops/scripts/ops-cortex-restore.sh, /dev/sdh, /dev/sdi ]
    ```

You can also provision the whole thing using Terraform; check our [GitHub repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/aws) for detailed sample code.