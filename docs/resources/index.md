# Resources

In this section, you can find a collection of valuable resources regarding the applications. 

## Demo virtual machine 
Learn how to [download](./demo.md) and [use](./howto-vm-demo.md) our demo virtual Machine

## IaaS environment
Your have your own cloud infrastruture and wish to manage and include TheHive and Cortex ; learn how to deploy our dedicated images by reading our usage instructions:

* Amazon AWS environment:
    * for [TheHive](./iaas/aws/thehive.md) and [Cortex](./iaas/aws/cortex.md)
    *  or [Infra as Code](./iaas/aws/infra-as-code/README.md) deployment
* Microsoft Azure environment:
    *  for [TheHive](./iaas/azure/thehive.md) and [Cortex](./iaas/azure/cortex.md)
    *  or [Infra as Code](./iaas/azure/infra-as-code/README.md) deployment

!!! Note "Resources for the official cloud distributions of TheHive and Cortex"

    This documentation contains sample Terraform and cloud-init code to easily launch and update TheHive and Cortex instances.

    ## Main features of the cloud distributions of TheHive and Cortex

    ### Easy to use and deploy
    The cloud distributions were built with operations and automation in mind. We wanted DevSecOps-friendly products that would fit in most organisations, no matter how simple or complex their infrastructure.

    ### Always up-to-date
    The images are updated whenever a new TheHive or Cortex version is released. No need to bother updating your instances anymore, just launch a new one with a fresh image as if it were a container!

    ### Production-ready
    + **Dedicated data volumes**: All persistent data is stored on dedicated volumes, not in the root filesystem. 
    + **Easy-resizing**: Resizing independent data volumes is a lot easier as no action is required within the instance at the operating system level.
    + **Ubuntu-based**: Our images are based on the official Ubuntu 20.04 LTS distributions from Canonical.
    + **Hardened OS**: The underlying Ubuntu OS is hardened to comply with *CSL1* - that's *Common Sense Level 1*. Ok that's not a real thing (yet) but the OS really was carefully configured to be as secured as possible by default while remaining usable in most contexts. Note that there are no iptables surprises inside the image to avoid conflicting behaviour with security groups of firewalls.
    + **Application only**: The images include either the TheHive or Cortex application only. They are not meant to be public-facing on their own and should be deployed within your VPC and exposed with the public facing system of your choice (load balancer, reverse proxy). More information on the recommended reference architecture is provided in each cloud distribution user guide.