# Cortex Package Repository

Cortex packages are distributed as RPM and DEB files, as well as ZIP binary packages, all available for direct download via tools like `wget` or `curl`, with installation performed manually.

All packages are hosted on an [HTTPS-secured website](https://cortex.download.strangebee.com/){target=_blank} and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum){target=_blank} and a [GPG](https://www.gnupg.org/){target=_blank} signature for verification.

For detailed installation instructions, see [Step-by-Step Installation Guide](step-by-step-guide.md).

## Repository structure

```bash
/
├─ <major.minor>/
│ ├─ asc/
│ ├─ deb/
│ ├─ rpm/
│ ├─ sha256/
│ └─ zip/
```

At the top level, each directory corresponds to a Cortex release branch.

Within each version directory, packages are grouped by distribution format:

* `deb/`: Debian and Ubuntu packages
* `rpm/`: Packages for RHEL-compatible and Fedora distributions
* `zip/`: Standalone binary distributions
* `asc/`: GPG signature files used to verify the authenticity of packages
* `sha256/`: SHA256 checksum files used to verify package integrity

## Package naming convention

All Cortex packages follow standard Linux packaging conventions.

* For DEB packages: `<product>_<major.minor.patch>-<packaging_revision>_<architecture>.<package_format>`
* For RPM packages: `<product>-<major.minor.patch>-<packaging_revision>.<architecture>.<package_format>`
* For ZIP packages: `<product>-<major.minor.patch>-<packaging_revision>.<package_format>`

### Understanding packaging revisions

The packaging revision number identifies successive builds of the same Cortex application version. This number increases monotonically and indicates the build sequence. The same version with different packaging revisions contain identical Cortex application code.

Always use the highest packaging revision available for a given version to benefit from packaging improvements.

<h2>Next steps</h2>

* [Step-by-Step Installation Guide](step-by-step-guide.md)