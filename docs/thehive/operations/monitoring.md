# Monitoring TheHive

Monitoring your TheHive instance enables you to gather essential metrics regarding its performance, including request times, CPU usage, and memory utilization.

TheHive leverages the [Kamon](https://kamon.io/) library for monitoring purposes, which is **disabled** by default.

TheHive includes integration with the Prometheus reporter out-of-the-box. Other reporters are **not** included. If you wish to have a specific reporter included by default in TheHive, please contact us.

---

## Configuring Metrics with Prometheus and Grafana

![Grafana Dashboard](../images/operations/grafana-dashboard.jpg)

To configure TheHive for metrics reporting, add the following section to your `application.conf` file:

```
kamon {
    # Activate Kamon module - disabled by default
    enabled = true

    # Enable the Prometheus reporter
    modules {
      prometheus-reporter.enabled = yes
    }

    environment.tags {
        # Configure additional tags to be sent to Prometheus 
        # See https://kamon.io/docs/latest/reporters/prometheus/#sending-environment-tags-to-prometheus
        # Example: env = prod
    }

    # Reference: https://kamon.io/docs/latest/reporters/prometheus/#configuration
    prometheus {
      include-environment-tags = true
      # Start an embedded server on the specified port. 
      # If using Docker, ensure this port is accessible
      embedded-server {
        hostname = 0.0.0.0
        port = 9095
      }
    }
}
```

You will need to restart TheHive for the configuration changes to take effect.

To verify that the Prometheus reporter is functioning correctly, navigate to <http://THEHIVE:9095/metrics>. You should see a list of metrics reported by TheHive.

&nbsp;

### Prometheus configuration

Add the [scrape configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) to prometheus configuration `prometheus.yml`

```yaml
scrape_configs:
  # ...  other scrape configs 

  - job_name: 'thehive'
    scrape_interval: 30s
    static_configs:
      - targets: ['THEHIVE:9095'] # set the ip or hostname for TheHive
```

In a dynamic environment like kubernetes, the TheHive service can be automatically discovered by prometheus. You can enable this with labels on your pod or by adding a `PodMonitor` resource. See the adaquate documentation: Prometheus [configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kubernetes_sd_config) or Prometheus [operator](https://prometheus-operator.dev/docs/user-guides/getting-started/)

&nbsp;

### Grafana configuration

- Make sure that prometheus is setup as a Datasource inside Grafana
- Import dashboards or create your own. We recommend the following dashboards (these dashboards were not created by Strangebee):
    - [Kamon 2.x - API dashboard](https://grafana.com/grafana/dashboards/12317-api-dashboard/): see API metrics like throughoutput, latency, % of error status. *Note that TheHive frontend uses long polling, some requests take 60 seconds and they will appear as outliers in this dashboard*
    - [Kamon 2.x - System metrics dashboard](https://grafana.com/grafana/dashboards/12315-system-metrics-dashboard/): see info about CPU or memory usage, JVM metrics like Heap usage or GC
    - [Kamon 2.x - Akka](https://grafana.com/grafana/dashboards/10776-kamon-akka-marcelo/): info about Akka system, actors, processing time

    To make these dashboards work, you may need to edit the dashboard variables 