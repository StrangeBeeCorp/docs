# TheHive Package Repository

TheHive packages are distributed as RPM and DEB files, as well as ZIP binary packages, all available for direct download via tools like `wget` or `curl`, with installation performed manually.

All packages are hosted on an [HTTPS-secured website](https://thehive.download.strangebee.com/){target=_blank} and come with a [SHA256 checksum](https://linux.die.net/man/1/sha256sum){target=_blank} and a [GPG](https://www.gnupg.org/){target=_blank} signature for verification.

For detailed installation instructions, see [Install TheHive on Linux Systems](installation-guide-linux-standalone-server.md).

## Repository structure

```bash
/
├─ <major.minor>/
│ ├─ asc/
│ ├─ deb/
│ ├─ rpm/
│ ├─ sha256/
│ ├─ xml/
│ └─ zip/
└─ manifest.json
```

At the top level, each directory corresponds to a TheHive release branch.

The repository root also contains a `manifest.json` file, which provides package metadata for programmatic version discovery and automated downloads.

Within each version directory, packages are grouped by distribution format:

* `deb/`: Debian and Ubuntu packages
* `rpm/`: Packages for RHEL-compatible and Fedora distributions
* `zip/`: Standalone binary distributions
* `asc/`: GPG signature files used to verify the authenticity of packages
* `sha256/`: SHA256 checksum files used to verify package integrity
* `xml/`: [SBOM](https://github.com/resources/articles/what-is-an-sbom-software-bill-of-materials){target=_blank} files providing a complete inventory of components for security auditing and vulnerability management

## Package naming convention

All TheHive packages follow standard Linux packaging conventions.

* For DEB packages: `<product>_<major.minor.patch>-<packaging_revision>_<architecture>.<package_format>`
* For RPM packages: `<product>-<major.minor.patch>-<packaging_revision>.<architecture>.<package_format>`
* For ZIP packages: `<product>-<major.minor.patch>-<packaging_revision>.<package_format>`

### Understanding packaging revisions

The packaging revision number identifies successive builds of the same TheHive application version. This number increases monotonically and indicates the build sequence. The same version with different packaging revisions contain identical TheHive application code.

Always use the highest packaging revision available for a given version to benefit from packaging improvements.

## Retrieving the latest package and packaging revision

The repository root contains a `manifest.json` file that provides structured metadata about available packages, including versions, formats, and download URLs.

!!! warning "Manifest structure subject to change"
    The manifest structure may change without prior notice. If this occurs, the `jq` queries must be updated accordingly.

To retrieve the latest available DEB package and its associated GPG signature and SHA256 checksum files:

```bash
curl -s https://thehive.download.strangebee.com/manifest.json \
| jq -r '
.products["thehive"].latest.deb.url,
.products["thehive"].latest.deb.signature,
.products["thehive"].latest.deb.checksum
'
```

To get the latest DEB package and its associated GPG signature and SHA256 checksum files for a specific release branch, for example {% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}:

```bash
curl -s https://thehive.download.strangebee.com/manifest.json \
| jq -r '
.products["thehive"].latest_by_version["{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}"].deb.url,
.products["thehive"].latest_by_version["{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}"].deb.signature,
.products["thehive"].latest_by_version["{% include-markdown "includes/thehive-latest-version.md" start="<!--start-shortversion-->" end="<!--end-shortversion-->" %}"].deb.checksum
'
```

Use the same method for RPM and ZIP packages.

<h2>Next steps</h2>

* [Install TheHive on Linux Systems](installation-guide-linux-standalone-server.md)