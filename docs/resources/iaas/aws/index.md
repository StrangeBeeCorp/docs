# :fontawesome-brands-aws: AWS IaaS images

## TheHive main feature

### Easy to use and deploy

The AMI was built with operations and automation in mind. We wanted a DevSecOps-friendly product that would fit in most organizations, no matter how simple or complex their infrastructure.

### Always up-to-date

The AMI is updated whenever a new Cortex version is released. No need to bother updating Cortex anymore, just launch a new instance as if it were a container!

### Production-ready

+ **Dedicated data and Docker volumes**: Cortex data is stored on a dedicated EBS volume, not in the root filesystem. With that in mind, the AMI will create a persistent 30GB EBS volume at launch that will not be deleted when the instance is terminated so that your Cortex data isn't accidentally lost. Docker images for analyzers and responders are also stored on a dedicated volume so you can adjust its size to your needs, the AMI will create a 20GB volume by default. Both volumes will be encrypted with your default KMS key. You can of course change the default volume size and encryption key.
+ **Ubuntu-based**: The AMI is based on the official Ubuntu 20.04 LTS AMI from Canonical.
+ **Hardened OS**: The underlying Ubuntu OS is hardened to comply with *CSL1* - that's *Common Sense Level 1*. Ok that's not a real thing (yet) but the OS really was carefully configured to be as secured as possible by default while remaining usable in most contexts. Note that there are no iptables surprises inside the image to avoid conflicting behavior with security groups.
+ **Application only**: The AMI includes Cortex application only. It is not meant to be public-facing on its own and should be deployed within your VPC and exposed with the public facing system of your choice (load balancer, reverse proxy). More information on the recommended reference architecture is provided in this user guide.


## Cortex main Features

### Easy to use and deploy

The AMI was built with operations and automation in mind. We wanted a DevSecOps-friendly product that would fit in most organizations, no matter how simple or complex their infrastructure.

### Always up-to-date

The AMI is updated whenever a new Cortex version is released. No need to bother updating Cortex anymore, just launch a new instance as if it were a container!

### Production-ready

+ **Dedicated data and Docker volumes**: Cortex data is stored on a dedicated EBS volume, not in the root filesystem. With that in mind, the AMI will create a persistent 30GB EBS volume at launch that will not be deleted when the instance is terminated so that your Cortex data isn't accidentally lost. Docker images for analyzers and responders are also stored on a dedicated volume so you can adjust its size to your needs, the AMI will create a 20GB volume by default. Both volumes will be encrypted with your default KMS key. You can of course change the default volume size and encryption key.
+ **Ubuntu-based**: The AMI is based on the official Ubuntu 20.04 LTS AMI from Canonical.
+ **Hardened OS**: The underlying Ubuntu OS is hardened to comply with *CSL1* - that's *Common Sense Level 1*. Ok that's not a real thing (yet) but the OS really was carefully configured to be as secured as possible by default while remaining usable in most contexts. Note that there are no iptables surprises inside the image to avoid conflicting behavior with security groups.
+ **Application only**: The AMI includes Cortex application only. It is not meant to be public-facing on its own and should be deployed within your VPC and exposed with the public facing system of your choice (load balancer, reverse proxy). More information on the recommended reference architecture is provided in this user guide.