# :fontawesome-brands-aws: AWS IaaS Images

## TheHive main features

### Easy to use and deploy

The AMI is built for operations and automation. It's designed for DevSecOps teams and fits most organizations, whatever the complexity of their infrastructure.

### Always up to date

The AMI is updated with each new TheHive release. To upgrade, launch a new instance from the latest AMI, as you would with a container.

### Production-ready

* TheHive data is stored on three dedicated volumes, not in the root filesystem: one for the Cassandra database, one for storage attachments, and one for indexes.
* The AMI is based on the official Ubuntu 24.04 LTS AMI from Canonical.
* The underlying Ubuntu OS is hardened to be as secure as possible by default while remaining usable in most contexts. The image contains no iptables rules, so it doesn't conflict with security groups.
* The AMI includes TheHive only. It isn't meant to be public-facing on its own. Deploy it within your VPC, and expose it through a public-facing system such as a load balancer or reverse proxy. The user guide provides more information on the recommended reference architecture.

## Cortex main features

### Easy to use and deploy

The AMI is built for operations and automation. It's designed for DevSecOps teams and fits most organizations, whatever the complexity of their infrastructure.

### Always up to date

The AMI is updated with each new Cortex release. To upgrade, launch a new instance from the latest AMI, as you would with a container.

### Production-ready

* Cortex data is stored on a dedicated EBS volume, not in the root filesystem. At launch, the AMI creates a persistent 30 GB EBS volume that isn't deleted when the instance is terminated, so Cortex data isn't lost by accident. Docker images for analyzers and responders are stored on a separate dedicated volume, 20 GB by default, that you can resize as needed. Both volumes are encrypted with your default KMS key. You can change the default volume sizes and encryption key.
* The AMI is based on the official Ubuntu 24.04 LTS AMI from Canonical.
* The underlying Ubuntu OS is hardened to be as secure as possible by default while remaining usable in most contexts. The image contains no iptables rules, so it doesn't conflict with security groups.
* The AMI includes Cortex only. It isn't meant to be public-facing on its own. Deploy it within your VPC, and expose it through a public-facing system such as a load balancer or reverse proxy. The user guide provides more information on the recommended reference architecture.
