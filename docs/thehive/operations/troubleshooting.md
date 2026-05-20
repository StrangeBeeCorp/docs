# Enable Trace Logging for Troubleshooting

If you need additional log information to identify the root cause of an issue, you can enable trace logging in TheHive.

!!! danger "Not for production servers"
    Enabling trace logging has a significant impact on performance. Don't enable it on production servers.

{% include-markdown "includes/maintenance-window-required.md" %}

{% include-markdown "includes/docker-logs.md" %}

## Step 1: Stop TheHive service

Stop TheHive service.

{% include-markdown "includes/service-commands.md" %}

## Step 2: Back up the `application.log` file

Move your existing `application.log` file to a backup location. This ensures the new log file created on restart contains only trace logs from your current session.

```bash
mv /var/log/thehive/application.log /var/log/thehive/application.log.bak
```

## Step 3: Enable trace logging

!!! info "Log levels reference"
    For a full description of available log levels and general log configuration, see [Update Log Configuration](../configuration/update-log-configuration.md).

1. Open the `logback.xml` file using a text editor and locate the following line:

    ```xml
    <logger name="org.thp" level="INFO"/>
    ```

2. Replace it with:

    ```xml
    <logger name="org.thp" level="TRACE"/>
    ```

3. Save the file.

## Step 4: Restart TheHive service

Restart TheHive service.

TheHive creates a new `/var/log/thehive/application.log` file with extensive logging information.

## Step 5: Reproduce the issue and save the log

Wait for the issue to occur or for the application to stop, then copy the log file to a safe location:

```bash
cp /var/log/thehive/application.log /root
```

## Step 6: Revert trace logging

After collecting the logs, revert your log configuration:

1. Stop TheHive service.

2. Edit `logback.xml` and restore the original line:

    ```xml
    <logger name="org.thp" level="INFO"/>
    ```

3. Restart TheHive service.

## (Optional) Step 7: Report the issue

If the logs reveal an issue you want to report:

* Gold or Platinum license: open a ticket with the StrangeBee Support team
* Community license: open an issue on the [`TheHive-feedback` GitHub repository](https://github.com/StrangeBeeCorp/TheHive-feedback/issues){target=_blank}

In both cases, include the following information:

* Context: your instance type (single node/cluster, backend type, index engine), operating system, RAM, and CPU count per server and node
* Symptoms: the actions you took, how the issue occurred, and what happened
* Log file: attach your log file with trace information

<h2>Next steps</h2>
  
* [Update Log Configuration](../configuration/update-log-configuration.md)
* [Optimize Performance](performance.md)
* [Set Up Monitoring for TheHive with Prometheus and Grafana](monitoring.md)