# Optimize Performance

Optimize TheHive performance by adjusting configuration settings to reduce unnecessary load and improve response times.

## Shorten the Elasticsearch refresh interval

Reduce the Elasticsearch refresh interval to make new documents searchable faster.

See [Shorten the Elasticsearch Refresh Interval](shorten-elasticsearch-refresh-interval.md) for instructions.

## Adjust the stream long-polling refresh interval

TheHive uses long-polling to stream events to clients. Adjusting this interval lets you balance event delivery speed against server load.

See [Update TheHive Service Configuration](../configuration/update-service-configuration.md#adjust-the-stream-long-polling-refresh-interval) for instructions.

## Tune JVM memory allocation

By default, Java determines heap size based on available system memory. While suitable for small deployments, this can lead to inefficient memory usage in production.

Explicitly configuring Java virtual machine (JVM) heap size for TheHive, Elasticsearch, and Cassandra helps control memory distribution across services and prevent resource contention, especially when they run on the same host.

See [Tune JVM Memory](tune-jvm-memory.md) for instructions.

## Tune dashboard settings

### Turn off dashboard autorefresh

By default, dashboards in TheHive periodically refresh their data, generating recurring queries to the database. Turning off this option reduces background load on busy systems.

See [Pause Dashboard Refresh](../user-guides/organization/configure-organization/manage-ui-configuration/pause-dashboard-refresh.md) for instructions.

### Remove the All Periods option in dashboards

The **All Periods** option in dashboards triggers queries across the entire dataset with no time boundary, which can be expensive on large instances. Removing this option prevents users from running unbounded queries and reduces database load.

See [Remove the All Periods Option in a Dashboard](../user-guides/organization/configure-organization/manage-ui-configuration/remove-all-periods-option.md) for instructions.

<h2>Next steps</h2>

* [Set Up Monitoring for TheHive with Prometheus and Grafana](monitoring.md)
* [Enable Trace Logging for Troubleshooting](troubleshooting.md)
