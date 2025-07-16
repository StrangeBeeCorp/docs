# Parameters for Docker

This topic lists the configuration keys available in Cortex’s `application.conf` file that control Docker-related behavior. These settings are usually set indirectly by [providing command-line parameters or environment variables when running the Cortex Docker container](run-cortex-with-docker.md#customizing-cortex-docker-image-behavior). The container entrypoint translates those inputs into this configuration file.

Use this reference to understand and fine-tune the internal configuration options that govern how Cortex interacts with Docker containers, resource limits, networking, and registry authentication.

## Docker container configuration options

* `docker.container.capAdd` (array of strings): Add Linux capabilities to the container.
* `docker.container.capDrop` (array of strings): Remove Linux capabilities from the container.
* `docker.container.cgroupParent` (string): Specify the cgroup under which the container runs.
* `docker.container.cpuPeriod` (integer): Limit the CPU CFS (Completely Fair Scheduler) period.
* `docker.container.cpuQuota` (integer): Limit the CPU CFS quota.
* `docker.container.dns` (array of strings): Custom DNS servers for the container.
* `docker.container.dnsSearch` (array of strings): DNS search domains for host name lookup.
* `docker.container.extraHosts` (array of strings): Add extra entries to `/etc/hosts` (format: `host:IP`)
* `docker.container.kernelMemory` (integer): Kernel memory limit.
* `docker.container.memoryReservation` (integer): Soft memory limit.
* `docker.container.memory` (integer): Hard memory limit.
* `docker.container.memorySwap` (integer): Total memory limit (memory + swap).
* `docker.container.memorySwappiness` (integer, 0-100): Adjust container’s memory swappiness behavior.
* `docker.container.networkMode` (string): Network mode for the container.
* `docker.container.privileged` (boolean): Grant extended privileges to the container.
* `docker.host` (string): Docker socket URL by Cortex to launch job containers.
* `docker.tlsVerify` (boolean): Turn on or turn off TLS certificate verification for the Docker socket.
* `docker.certPath` (string): Path to the TLS certificate for verifying the Docker socket.
* `docker.registry.user` (string): Username for Docker registry authentication.
* `docker.registry.password` (string): Password for Docker registry authentication.
* `docker.registry.email` (string): Email address used for Docker registry authentication
* `docker.registry.url` (string): URL of the Docker registry to authenticate with.
* `job.directory` (string): Directory inside the container where Cortex shares input/output data with analyzers and responders.
* `job.dockerDirectory` (string): Corresponding host directory for sharing job data with analyzers and responders.

## Using dockerized analyzers and responders

To run analyzers and responders as Docker containers, register them using the [StrangeBee official catalogs](https://github.com/TheHive-Project/Cortex/tree/master/docker/cortex).

In the Cortex configuration file, update `analyzer.urls` and `responder.urls` to specify where Cortex should find analyzers and responders. 

These settings accept:

* A path to a directory containing worker definitions
* A path or URL (http/https) to a JSON file containing all worker definitions merged in one array

Available URLs for dockerized analyzers:

* [analyzers-stable.json](https://catalogs.download.strangebee.com/json/analyzers-stable.json): Stable analyzers (no updates once used).
* [analyzers.json](https://catalogs.download.strangebee.com/json/analyzers.json): Updated with each new release.
* [analyzers-devel.json](https://catalogs.download.strangebee.com/json/analyzers-devel.json): Updated on every commit (development builds).

Available URLs for dockerized responders:

* [responders-stable.json](https://catalogs.download.strangebee.com/json/responders-stable.json): Stable responders (no updates once used).
* [responders.json](https://catalogs.download.strangebee.com/json/responders.json): Updated with each new release.
* [responders-devel.json](https://catalogs.download.strangebee.com/json/responders-devel.json): Updated on every commit (development builds).

<h2>Next steps</h2>

* [How to Run Cortex with Docker](run-cortex-with-docker.md)