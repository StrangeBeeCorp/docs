# APT and YUM Repositories Deprecation Notice

This topic explains the deprecation of APT and YUM repositories for TheHive and Cortex installations and upgrades.

Starting August 1, 2025, TheHive and Cortex will no longer be distributed via APT and YUM packages. Instead, installation and upgrades will be performed through direct downloads using tools like cURL or Wget followed by manual installation.

## Why APT and YUM repositories are being deprecated

Over time, several incidents have affected the availability of packages in our APT and YUM repositories, leading to unexpected downtime for users relying on these installation methods.

To address these issues and enhance reliability, we are transitioning to a unified, highly available distribution system. This new system supports all package formats (.deb and .rpm) and architectures (AMD64 and ARM64), providing a consistent experience across Linux distributions. Our site uses HTTPS, and every package comes with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum) and [GPG](https://www.gnupg.org/) signature.

Key benefits include:

* Improved availability: Packages are served directly from our official, highly available download servers, eliminating dependencies on third-party repositories and reducing delays or interruptions.
* Simplified installation: A unified process across all supported Linux distributions streamlines package retrieval and installation.
* Faster updates: Users gain quicker access to new versions and security patches, ensuring their environments remain secure and up to date.

## Who is affected

This change applies to users deploying TheHive and Cortex on-premises on Linux distributions via package installations. It doesn't affect those using the SaaS solution or running TheHive and Cortex through Docker deployments.

## Timeline

* Manual download and installation become available starting July 10, 2025.
* APT and YUM repositories become unavailable starting July 31, 2025.

## What you should do

If you are a new user, follow the updated instructions in [TheHive](../../installation/step-by-step-installation-guide.md) and [Cortex](../../../cortex/installation-and-configuration/step-by-step-guide.md) step-by-step installation guides.

If you currently install or update TheHive and Cortex using `apt-get install`, `apt-get upgrade`, `yum install`, or `yum update`, switch to manual package downloads and installations. See [Switch to Manual Download and Installation](switch-to-manual-download-installation.md) for detailed instructions. Continuing with the current installation will allow the application to run but will prevent it from receiving updates.

<h2>Next steps</h2>

* [Switch to Manual Download and Installation](switch-to-manual-download-installation.md)