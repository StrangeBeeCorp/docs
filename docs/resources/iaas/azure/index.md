## TheHive Azure images

### Easy to use and deploy

The Azure images were built with operations and automation in mind. We wanted DevSecOps-friendly products that would fit in most organizations, no matter how simple or complex their infrastructure.

### Always up-to-date

The images are updated whenever a new TheHive version is released. No need to bother updating TheHive anymore, just launch a new instance as if it were a container!

### Production-ready

+ **Dedicated data disks**: TheHive data is stored on dedicated disks, not in the root filesystem.
+ **Ubuntu-based**: The images are based on the official Ubuntu 20.04 LTS distribution from Canonical.
+ **Hardened OS**: The underlying Ubuntu OS is hardened to comply with CSL1 (that's Common Sense Level 1!) minus the network filtering. There are no iptables surprises inside the image to avoid conflicting behavior with security groups.
+ **Application only**: The images include the applications only. They are not meant to be public-facing on their own and should be deployed within your virtual network and exposed with the public facing system of your choice (load balancer, reverse proxy).


## Cortex Azure images

### Easy to use and deploy

The image was built with operations and automation in mind. We wanted a DevSecOps-friendly product that would fit in most organizations, no matter how simple or complex their infrastructure.

### Always up-to-date

The image is updated whenever a new Cortex version is released. No need to bother updating Cortex anymore, just launch a new instance as if it were a container!

### Production-ready

+ **Dedicated data disks**: Cortex data is stored on dedicated disks, not in the root filesystem. With that in mind, you must attach two persistent data disks on LUN 0 and LUN 1 at launch (30 GB each recommended).
+ **Ubuntu-based**: The image is based on the official Ubuntu 20.04 LTS distribution from Canonical.
+ **Hardened OS**: The underlying Ubuntu OS is hardened to comply with CSL1 (that's Common Sense Level 1!) minus the network filtering. There are no iptables surprises inside the image to avoid conflicting behavior with security groups.
+ **Application only**: The image includes Cortex application only. It is not meant to be public-facing on its own and should be deployed within your virtual network and exposed with the public facing system of your choice (load balancer, reverse proxy).