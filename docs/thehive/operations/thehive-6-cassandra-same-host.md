# Run TheHive 6 and Cassandra on the Same Host

<!-- md:version 6.0 -->

TheHive 6.x requires Java 17, while Apache Cassandra 4.0.x to 4.1.x requires Java 11 and doesn't support Java 17. On a package installation where TheHive and Cassandra share a host, which is the standard standalone architecture, the two Java versions must be installed side by side, each service pinned to its own.

The safe approach is to keep Java 11 as the system default, so Cassandra runs untouched, and point only TheHive at Java 17 through the `JAVA_HOME` variable of its service.

{% include-markdown "includes/maintenance-window-required.md" %}

!!! note "Docker and Kubernetes deployments aren't affected"
    Each image ships its own Java runtime, so containerized deployments need none of the steps below.

## Step 1: Install Corretto 11 and 17

For security and long-term support, use [Amazon Corretto](https://aws.amazon.com/corretto/){target=_blank}, which provides OpenJDK builds maintained by Amazon. On a host set up by following [Install TheHive with Packages](../installation/installation-guide-linux-standalone-server.md) for TheHive 5.x, Corretto 11 is already present and set as the system default: the commands below then only add Corretto 17.

=== "DEB"

    ```bash
    wget -qO- https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto.gpg
    echo "deb [signed-by=/usr/share/keyrings/corretto.gpg] https://apt.corretto.aws stable main" | sudo tee -a /etc/apt/sources.list.d/corretto.sources.list
    sudo apt update
    sudo apt install java-common java-11-amazon-corretto-jdk java-17-amazon-corretto-jdk
    ```

=== "RPM"

    ```bash
    sudo rpm --import https://yum.corretto.aws/corretto.key
    wget -qO- https://yum.corretto.aws/corretto.repo | sudo tee -a /etc/yum.repos.d/corretto.repo
    sudo yum install -y java-11-amazon-corretto-devel java-17-amazon-corretto-devel
    ```

=== "Other"

    TheHive requires Java 17 and Cassandra 4.0.x to 4.1.x requires Java 11, so refer to your system documentation to install both side by side.

## Step 2: Verify the install paths

Confirm the exact paths on your system before configuring the services:

```bash
ls -1 /usr/lib/jvm/
```

The output should include entries like the following. Paths may vary slightly depending on your Linux distribution: use the exact paths from this output in the next steps.

```text
java-11-amazon-corretto
java-17-amazon-corretto
```

## Step 3: Keep the system default on Java 11

Cassandra uses the system default Java version, so that default must stay on Java 11:

```bash
java -version
```

The output should report version 11. If it reports another version, and `JAVA_HOME` is set to a Java 11 path in `/etc/environment` from an earlier TheHive installation, leave that line as it is: it's what keeps Cassandra on Java 11. Never point the system default or `/etc/environment` at Java 17 on a host running Cassandra.

## Step 4: Configure TheHive to use Java 17

Set `JAVA_HOME` for TheHive service only, using the path confirmed at [Step 2](#step-2-verify-the-install-paths):

```bash
echo 'JAVA_HOME="/usr/lib/jvm/java-17-amazon-corretto"' | sudo tee -a /etc/default/thehive
```

## Step 5: Restart the services

Restart TheHive to apply the `JAVA_HOME` change. Cassandra needs no restart when the system default was already on Java 11:

```bash
sudo systemctl restart thehive
sudo systemctl status thehive --no-pager
```

!!! tip "Cortex on the same host"
    Cortex runs on Java 11, like Cassandra, so a Cortex instance sharing the host needs no change: it keeps using the system default.

<h2>Next steps</h2>

* [Install TheHive on Linux Systems](../installation/installation-guide-linux-standalone-server.md)
* [Upgrade from TheHive 5.x](../installation/upgrade-from-5.x.md)
