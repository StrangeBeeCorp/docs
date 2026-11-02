## TheHive and Cortex Azure image

A single Azure image can run TheHive, Cortex, or both, either on the same instance or on separate instances.

### Easy to use and deploy

The Azure image is built for operations and automation. It's designed for DevSecOps teams and fits most organizations, whatever the complexity of their infrastructure.

### Always up to date

The image is updated with each new TheHive release. To upgrade, launch a new instance from the latest image, as you would with a container.

### Production-ready

* TheHive and Cortex data is stored on dedicated disks, not in the root filesystem.
* The image is based on the official Ubuntu 24.04 LTS distribution from Canonical.
* The underlying Ubuntu OS is hardened, except for network filtering. The image contains no iptables rules, so it doesn't conflict with security groups.
* The image includes TheHive and Cortex only. It isn't meant to be public-facing on its own. Deploy it within your virtual network, and expose it through a public-facing system such as a load balancer or reverse proxy.
