# Resources

Use these resources to test TheHive and Cortex in a demo environment or to deploy them on your own cloud infrastructure.

## Demo environment

[Deploy a demo Docker environment](./docker-demo.md) to test TheHive and Cortex with sample data on a Linux host using Docker Compose.

## IaaS environment

To run TheHive and Cortex on your own cloud infrastructure, deploy the official images:

* :fontawesome-brands-aws: Amazon AWS
    * [Deploy TheHive AMI](./iaas/aws/thehive.md)
    * [Deploy Cortex AMI](./iaas/aws/cortex.md)
    * [AWS sample code](./iaas/aws/infra-as-code/README.md)
* :fontawesome-brands-microsoft: Microsoft Azure
    * [Deploy TheHive and Cortex Azure image](./iaas/azure/thehive.md)
    * [Azure sample code](./iaas/azure/infra-as-code/README.md)

!!! Note "Resources for the official cloud distributions of TheHive and Cortex"

    The IaaS guides include sample Terraform and cloud-init code to launch and upgrade TheHive and Cortex instances.

    ### Main features of the cloud distributions of TheHive and Cortex

    #### Easy to use and deploy

    The cloud distributions are built for operations and automation. They're designed for DevSecOps teams and fit most organizations, whatever the complexity of their infrastructure.

    #### Always up to date

    The images are updated with each new TheHive or Cortex release. To upgrade, launch a new instance from the latest image, as you would with a container.

    #### Production-ready

    * All persistent data is stored on dedicated volumes, not in the root filesystem.
    * Resizing a data volume requires no action at the operating system level inside the instance.
    * The images are based on the official Ubuntu 24.04 LTS distribution from Canonical.
    * The underlying Ubuntu OS is hardened to be as secure as possible by default while remaining usable in most contexts. The images contain no iptables rules, so they don't conflict with security groups or firewalls.
    * The images include TheHive and Cortex only. They aren't meant to be public-facing on their own. Deploy them within your VPC or virtual network, and expose them through a public-facing system such as a load balancer or reverse proxy. Each cloud distribution guide describes the recommended reference architecture.
