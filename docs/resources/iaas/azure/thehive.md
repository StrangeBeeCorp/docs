# Usage Instructions for the Official Azure Distribution of TheHive 5 and Cortex 3

[:fontawesome-brands-microsoft: Official Azure image](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/strangebee1595948424730.thehive-5?tab=Overview){ .md-button target=_blank }

Use the image to set up a new TheHive 5 installation, or to launch an instance with existing data and configuration to upgrade, migrate, or restore TheHive. The same image can also launch Cortex 3, either on the same instance as TheHive or on a separate, dedicated instance.

## Introduction

* The image is based on the official Ubuntu 24.04 LTS image from Canonical.
* The image is updated with each new TheHive release. To upgrade, launch a new instance from the latest image, as you would with a container.
* TheHive and Cortex data is stored on two dedicated disks, not in the root filesystem. At launch, attach two persistent data disks: one on LUN 0 for the data and one on LUN 1 for Docker. The recommended minimum size is 32 GB per disk. If you install Cortex on a separate instance, apply the same configuration to that instance.
* The underlying Ubuntu OS is hardened, except for network filtering. The image contains no iptables rules, so it doesn't conflict with security groups.
* You can migrate from TheHive 4 using the migration script included in the image. This script isn't documented yet.

## Run context

* TheHive listens on HTTP port 9000. When deployed alongside it, Cortex listens on HTTP port 9001. These ports use HTTP, not HTTPS. Never open them outside your virtual network. Use a public-facing load balancer or reverse proxy to handle TLS sessions with end users.
* TheHive and Cortex use secure cookies by default, so connecting to their UIs over HTTP fails. To allow HTTP connections, change the configuration, then restart the `thehive` or `cortex` service:
    * For TheHive, set `play.http.session.secure = false` in `/opt/thp_data/nomad/tasks/thehive/application.conf`.
    * For Cortex, set `play.http.session.secure = false` and `play.filters.csrf.cookie.secure = false` in `/opt/thp_data/nomad/tasks/cortex/application.conf`.

## Launching an instance

1. Launch an instance from the image and attach two persistent disks: the data disk on LUN 0 and the Docker disk on LUN 1.
2. Set the admin username to *azureuser*.
3. Provide the following cloud-init bootstrap script to configure the instance. In this example, you must at least update the `application.baseUrl` value for TheHive.

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
        partition: auto
        filesystem: ext4
      - device: /dev/disk/azure/scsi1/lun1
        partition: auto
        filesystem: ext4
    write_files:
        - path: /opt/strangebee/ops/templates/nomad/tasks/thehive/application.conf.d/service.conf
          content: |
              application.baseUrl="https://thehive.mydomain.com/thehive"
              play.http.context="/thehive"
        - path: /opt/strangebee/ops/templates/nomad/tasks/cortex/application.conf.d/service.conf
          content: |
              play.http.context="/cortex"
    runcmd:
        - [ /opt/strangebee/ops/scripts/ops-launch.sh, "-t 1", "-c 0", "-p /dev/sdh", "-d /dev/sdi" ]
    ```

You can customize this script further. The example above:

* Partitions and formats the data disks attached on LUN 0 and LUN 1
* Launches the initialization script with `/dev/sdh` and `/dev/sdi` as arguments, which mounts the LUN 0 disk at `/dev/sdh` and the LUN 1 disk at `/dev/sdi`
* Installs TheHive only, because it calls the `ops-launch.sh` script with `"-t 1", "-c 0"`

!!! Tip

    1. To install both TheHive and Cortex on the same instance, use `"-t 1", "-c 1"`.
    2. To install Cortex only on another instance, use `"-t 0", "-c 1"`.

Depending on the `-t` and `-c` parameters, the instance now runs TheHive on port 9000, Cortex on port 9001, or both, ready for your load balancer or reverse proxy. The default admin account on both applications is `admin` with password `secret`. Change both passwords after the first login.

Access TheHive and Cortex through an internet-facing HTTPS system such as a reverse proxy or load balancer. In the example above, TheHive is available at `https://thehive.mydomain.com/thehive` and Cortex at `https://thehive.mydomain.com/cortex`.

## Deploying with Terraform

You can also provision TheHive and Cortex using Terraform. The StrangeBee [cloud-distrib-resources repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/azure) on GitHub provides ready-to-use deployment code that launches a TheHive instance and a separate Cortex instance from this image. The code also creates a full SecOps virtual network with an HTTPS Application Gateway.
