# Shorten the Elasticsearch Refresh Interval

By default, Elasticsearch refreshes its index every second (`1000ms`). Reducing this interval makes new documents searchable faster, at the cost of slightly higher I/O, CPU load, and segment count.

!!! info "No restart required"
    This change takes effect immediately and can be reverted at any time.

## Update the refresh interval

Run the following command on your Elasticsearch instance:

```bash
curl -XPUT 'http://<elasticsearch_host>/thehive/_settings' \
  -H 'Content-Type: application/json' \
  -d '{"index.refresh_interval": "1000ms"}'
```

Replace `<elasticsearch_host>` with:

* `localhost:9200` for a standalone server deployment.
* The IP address or hostname of any node for a cluster deployment. The setting replicates automatically across all nodes.

Replace `1000ms` with the new interval. We recommend starting at `500ms` and tuning down toward `100ms` based on observed performance.

## Monitor after each change

After each adjustment, allow 10 minutes for the cluster to stabilize, then check the following metrics:

* Indexing rate and latency: Sustained increases may indicate the interval is too aggressive.
* Search latency: Should improve. A spike may signal resource contention.
* CPU usage: Acceptable increases are workload-dependent. Investigate sharp jumps.
* [Java virtual machine (JVM) heap pressure](tune-jvm-memory.md): Sustained usage above 75% warrants scaling back the interval.
* Segment count: Rapid growth increases merge overhead. Monitor merge rate alongside.
* Indexing throughput: A sustained drop may indicate the cluster is struggling to keep up with merge and refresh overhead.

For a full observability setup, see [Set Up Monitoring for TheHive with Prometheus and Grafana](monitoring.md).

<h2>Next steps</h2>

* [Optimize Performance](performance.md)
* [Tune JVM Memory](tune-jvm-memory.md)