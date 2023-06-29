# Usage instructions for the official Azure distribution of TheHive v5

The image can be used to set up a shiny-new TheHive v5 install or to launch an instance with existing data and configuration (for update / migration / restore purposes). The same image can also be used to launch Cortex on the same instance or on a separate, dedicated instance.

## Introduction

+ Based on the official Ubuntu 20.04 LTS image from Canonical
+ The image is updated whenever a new TheHive version is released - no need to bother updating TheHive anymore, just launch a new instance as if it were a container!
+ TheHive / Cortex data is stored on two dedicated disks, not in the root filesystem. **For that purpose, you must attach two persistent data disks at launch on LUN 0 (for the data) and LUN 1 (for Docker). The recommended minimal volume size are 32 GB per volume**. If you install Cortex on a separate instance, simply apply the same configuration on the second instance.
+ The underlying Ubuntu OS is hardened to comply with CSL1 (that's Common Sense Level 1!) minus the network filtering. There are no iptables surprises inside the image to avoid conflicting behaviour with security groups.
+ Migration from TheHive v4 is possible using our migration script baked in the image (*to be documented soon*).

## Run context

+ TheHive is available on port http 9000 and Cortex, when deployed alongside, is available on port http 9001 (that's *http* and NOT *https*). Needless to say we encourage you never to open these ports outside your virtual network and use a public-facing load balancer and / or reverse proxy to handle the TLS sessions with end-users. 
+ As an incentive to use https, both TheHive and Cortex are configured to use secure cookies by default. Connecting to their respective UIs in http will fail. An override to this remains possible in the configuration (for TheHive, set `play.http.session.secure = false` in `/opt/thp_data/nomad/tasks/thehive/application.conf` - for Cortex, set `play.http.session.secure = false` and `play.filters.csrf.cookie.secure = false` in `/opt/thp_data/nomad/tasks/cortex/application.conf`). You must restart the `thehive` and/or `cortex` service(s) for the change to be effective.

## Launching an instance

1. Launch an instance from the image and attach two persistent disks: the data disk on LUN 0 and the docker disk LUN 1
2. Set the admin username to be *azureuser*
3. Provide the following cloud-init bootstrap script to configure the instance (you must update at least the `application.baseUrl` value for TheHive in this example):

```
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

You can further customize this script as needed. In the example above we:
+ partition and format the data disks attached on LUN 0 and LUN 1 
+ launch the initialisation script with the target data disk mapping names as argument (/dev/sdh and /dev/sdi) - the script will automatically mount the LUN 0 disk at /dev/sdh and the LUN 1 disk at /dev/sdi
+ install TheHive only (because of parameters `"-t 1", "-c 0"` when calling the `ops-launch.sh` script)

>To install both TheHive and Cortex on the same instance, use `"-t 1", "-c 1"`

>To install Cortex only on another instance, use `"-t 0", "-c 1"`

That's it! TheHive is now available (for your load balancer or reverse proxy) on port 9000 and Cortex on port 9001, if also installed. The default admin account on both applications is `admin` with password `secret` (change them!). 

Remember to access the apps through an internet-facing https system such as a reverse proxy or load balancer. In our example, TheHive is available at `https://thehive.mydomain.com/thehive` and Cortex at `https://thehive.mydomain.com/cortex`.

## Even easier using Terraform

You can also provision the whole thing using Terraform.

Check our [GitHub repository](https://github.com/StrangeBeeCorp/cloud-distrib-resources/tree/master/azure) for turnkey deployment code, **including a full SecOps vnet with an https Application Gateway**.