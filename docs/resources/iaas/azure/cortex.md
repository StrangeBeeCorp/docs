# Usage instructions for the official Azure distribution of Cortex

[:fontawesome-brands-microsoft: Official Azure image](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/strangebee1595948424730.cortex-3?tab=Overview){ .md-button target=_blank } This is the official Cortex v3 release for the AWS Marketplace.

The image can be used to set up a shiny-new Cortex install or to launch an instance with existing data and configuration (for update / migration / restore purposes).

## Introduction
* Based on the official Ubuntu 18.04 image from Canonical
* The image is updated whenever a new Cortex version is released - no need to bother updating Cortex anymore, just launch a new instance as if it were a container!
* Cortex data is stored on dedicated disks, not in the root filesystem. **With that in mind, you must attach two persistent data disks on LUN 0 (for the database) and LUN 1 (for Docker images) at launch (30 GB each recommended)**.
* The underlying Ubuntu OS is hardened to comply with CSL1 (that's Common Sense Level 1!) minus the network filtering. There are no iptables surprises inside the image to avoid conflicting behavior with security groups.

## Run context
* The Cortex app runs as unprivileged user *cortex* and is available on port http 9001 (that's *http* and NOT *https*). Needless to say we encourage you never to open that port outside your virtual network and use a public-facing load balancer and / or reverse proxy to handle the TLS sessions with end-users. Since many Cortex users also run TheHive and MISP instances alongside and since the right load balancer / reverse proxy is obviously the one you know best, we elected not to include yet another one in this image. 
* The Cortex configuration is set to look for custom analyzers under `/opt/cortexneurons/analyzers` and for custom responders under `/opt/cortexneurons/responders`.
* A cronjob for user *cortex* runs every night (@daily) to backup the application configuration and custom analyzers / custom responders to the data volume (/var/lib/elasticsearch/cortex/). If you wish to launch a new instance from existing data, this job must have run at least once after the initial install in order to restore the application's configuration  and custom analyzers / responders as well.  

## Launching an instance with no existing data (new Cortex install)
1. Launch an instance from the image and attach two data disks on LUN 0 and LUN 1.
2. SSH into the instance with a sudoer user.
3. Initialize and format the additional data disks (LUN O and LUN 1). 
4. Launch the application initialization script with the target data disk names as arguments. Example: `/opt/cortex/ops/scripts/ops-cortex-init.sh /dev/sdh /dev/sdi` (the script will automatically mount the LUN 0 and LUN 1 disks at /dev/sdh and /dev/sdi)
5. That's it! Cortex is now available on port 9001. You can create the admin account on the first connection to the app.

Alternatively, you can easily perform steps 3 and 4 by providing a cloud-init bootstrap script at launch. In the following example, we:

* partition and format the data disks attached on LUN 0 and LUN 1 
* improve the random seed with pollinate (because we will generate a secret key in the initialisation process)
* and finally we launch the initialisation script with the target data disk mapping names as arguments (/dev/sdh and /dev/sdi) - the script will automatically mount the LUN 0 disk at /dev/sdh and LUN 1 at /dev/sdi

!!! Example ""

    ```yaml
    #cloud-config 
    disk_setup:
      /dev/disk/azure/scsi1/lun0:
        table_type: gpt
        layout: True
        overwrite: True
      /dev/disk/azure/scsi1/lun1:
        table_type: gpt
        layout: True
        overwrite: True
    fs_setup:
      - device: /dev/disk/azure/scsi1/lun0
        partition: none
        filesystem: ext4
      - device: /dev/disk/azure/scsi1/lun1
        partition: none
        filesystem: ext4
    random_seed:
        file: /dev/urandom
        command: ["pollinate", "--server=https://entropy.ubuntu.com/"]
        command_required: true
    runcmd:
        - /opt/cortex/ops/scripts/ops-cortex-init.sh /dev/sdh /dev/sdi
    ```

You can also provision the whole thing using Terraform - check our [GitHub repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources) for sample initialisation code.

## Launching an instance with existing data (Cortex update, migration, restore)

1. Launch an instance from the image and attach existing Cortex data disks on LUN 0 and LUN 1 (we recommend you always create disk snapshots first).
2. SSH into the instance with a sudoer user.
3. Launch the Cortex restore script with the data disk names as argument, which are /dev/sdh and /dev/sdi if you are using the default setup. Example: `/opt/cortex/ops/scripts/ops-cortex-restore.sh /dev/sdh /dev/sdi`.
4. That's it! Cortex is now available on port 9001 (or on the custom port you had configured) with all your existing configuration, users and data. Custom analyzers and responders stored under /opt/cortexneurons are also automatically restored and their pip requirements reinstalled.

Alternatively, you can easily perform step 3 by providing a cloud-init bootstrap script at launch. In the following example, we:

!!! Example "launch the restore script with the data disk names as arguments (/dev/sdh and /dev/sdi)"

    ```yaml
    #cloud-config 
    runcmd:
        - /opt/cortex/ops/scripts/ops-cortex-restore.sh /dev/sdh /dev/sdi
    ```

You can also provision the whole thing using Terraform - check our [GitHub repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources) for sample update / migration / restore code.