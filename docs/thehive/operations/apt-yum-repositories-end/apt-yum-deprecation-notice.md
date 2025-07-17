# APT and YUM Repositories Deprecation Notice

This topic explains the deprecation of APT and YUM repositories for TheHive and Cortex installations and upgrades.

Starting July 31, 2025, TheHive and Cortex are no longer distributed via APT and YUM repositories. Instead, installation and upgrades require manually downloading DEB and RPM packages using tools like cURL or Wget, followed by manual installation.

All packages are hosted on an HTTPS-secured website and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum) and a [GPG](https://www.gnupg.org/) signature for verification.

## Why APT and YUM repositories are being deprecated

Over time, several incidents have affected the availability of packages in the APT and YUM repositories, leading to unexpected downtime for users relying on these installation methods.

To address these issues and enhance reliability, StrangeBee is transitioning to a unified, highly available distribution system. This new system supports all package formats (DEB and RPM) and architectures (AMD64 and ARM64), providing a consistent experience across Linux distributions.

Key benefits include:

* Improved availability: Packages are served directly from the official, highly available download servers, eliminating dependencies on third-party repositories and reducing delays or interruptions.
* Simplified installation: A unified process across all supported Linux distributions streamlines package retrieval and installation.
* Faster updates: Users gain quicker access to new versions and security patches, ensuring their environments remain secure and up to date.

## Who is affected

This change applies to users deploying TheHive On-Prem and Cortex on Linux distributions via package installations. It doesn't affect those using the TheHive Cloud Platform or running TheHive and Cortex through Docker deployments.

## What you should do

If you are a new user, follow the instructions in [TheHive](../../installation/step-by-step-installation-guide.md) and [Cortex](../../../cortex/installation-and-configuration/step-by-step-guide.md) step-by-step installation guides.

If you currently install or update TheHive and Cortex using `apt-get install`, `apt-get upgrade`, `yum install`, or `yum update`, switch to manual package downloads and installations. For detailed instructions, see [Switch to Manual Download and Installation for TheHive](switch-to-manual-download-installation-thehive.md) and [Switch to Manual Download and Installation for Cortex](../../../cortex/operations/switch-to-manual-download-installation-cortex.md). Continuing with the current installation lets the application run but blocks it from receiving updates.

<h2>Next steps</h2>

* [Switch to Manual Download and Installation for TheHive](switch-to-manual-download-installation-thehive.md)
* [Switch to Manual Download and Installation for Cortex](../../../cortex/operations/switch-to-manual-download-installation-cortex.md)