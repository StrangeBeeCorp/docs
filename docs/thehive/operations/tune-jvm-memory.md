# Tune JVM Memory

Adjust the Java virtual machine (JVM) heap size for TheHive, Elasticsearch, and Cassandra based on your available system resources.

By default, Java automatically determines heap size from system memory. While suitable for small deployments, this behavior isn't recommended for production environments or when all components run on the same host, as multiple JVM processes compete for memory.

Defining heap sizes explicitly helps prevent resource contention and ensures predictable performance.

{% include-markdown "includes/maintenance-window-required.md" %}

## Inspect JVM flags and container resource limits

Before adjusting heap sizes, inspect the current JVM flags and container resource limits to understand the baseline configuration. Run the following commands against any of the three services: TheHive, Cassandra, and Elasticsearch.

```bash
jcmd <service_pid> VM.flags
jcmd <service_pid> VM.info | grep -A 16 cgroup
```

Replace `<service_pid>` with the process ID of the concerned service.

## Recommended memory allocation when all services share the same host

When multiple services run on the same host, plan heap sizes across all of them before configuring each one individually. Multiple JVM processes competing for memory can cause resource contention or out-of-memory errors.

=== "Without Cortex"

    === "16 GB RAM"

        ```
        Cassandra:     -Xms2g -Xmx4g -Xmn200m
        Elasticsearch: -Xms3000m -Xmx3000m
        TheHive:       -Xms3000m -Xmx3000m -XX:MaxMetaspaceSize=400m -XX:ReservedCodeCacheSize=400m
        ```

    === "32 GB RAM"

        ```
        Cassandra:     -Xms4g -Xmx8g -Xmn400m
        Elasticsearch: -Xms7000m -Xmx7000m
        TheHive:       -Xms7250m -Xmx7250m -XX:MaxMetaspaceSize=400m -XX:ReservedCodeCacheSize=400m
        ```

=== "With Cortex"

    === "16 GB RAM"

        ```
        Cassandra:     -Xms1g -Xmx3g -Xmn200m
        Elasticsearch: -Xms2000m -Xmx2000m
        TheHive:       -Xms2000m -Xmx2000m -XX:MaxMetaspaceSize=400m -XX:ReservedCodeCacheSize=400m
        Cortex:        -Xms3g -Xmx3g
        ```

    === "32 GB RAM"

        ```
        Cassandra:     -Xms3g -Xmx6g -Xmn400m
        Elasticsearch: -Xms5400m -Xmx5400m
        TheHive:       -Xms5400m -Xmx5400m -XX:MaxMetaspaceSize=400m -XX:ReservedCodeCacheSize=400m
        Cortex:        -Xms4g -Xmx4g
        ```

## Configure JVM options for Cassandra

{% include-markdown "includes/jvm-containerized-deployments.md" %}

1. Check if the `/etc/cassandra/jvm-server.options` exists. If it doesn't, create it.

2. Open the `/etc/cassandra/jvm-server.options` file using a text editor.

3. In the `jvm-server.options` file, set the JVM options.

    !!! tip "Heap size guidelines for Cassandra"
        Heap allocation for Cassandra [must not exceed 50% of the available RAM and should not be less than 2 GB](https://cassandra.apache.org/doc/stable/cassandra/managing/operating/hardware.html#memory){target=_blank}. Available RAM refers to the memory remaining after accounting for the operating system and other services running on the same host.

    ```yaml
    -Xms<heap_size>
    -Xmx<heap_size>
    -Xmn<young_gen_size>
    ```

    Replace `<heap_size>` with the desired heap size and `<young_gen_size>` with the desired young generation size. `Xms` sets the initial heap size, `Xmx` sets the maximum, and `Xmn` sets the size of the young generation, where short-lived objects are allocated.

4. Save your modifications in the `jvm-server.options` file.

5. Restart Cassandra service.

    ```bash
    sudo systemctl restart cassandra
    ```

## Configure JVM options for Elasticsearch

{% include-markdown "includes/jvm-containerized-deployments.md" %}

1. Check if the `/etc/elasticsearch/jvm.options.d/jvm.options` exists. If it doesn't, create it.

2. Open the `/etc/elasticsearch/jvm.options.d/jvm.options` file using a text editor.

3. In the `jvm.options` file, set the JVM options.

    !!! tip "Heap size guidelines for Elasticsearch"
        Heap allocation for Elasticsearch [must not exceed 50% of the available RAM](https://www.elastic.co/search-labs/blog/elasticsearch-heap-size-jvm-garbage-collection){target=_blank}. Available RAM refers to the memory remaining after accounting for the operating system and other services running on the same host.

    ```yaml
    -Dlog4j2.formatMsgNoLookups=true
    -Xms<heap_size>
    -Xmx<heap_size>
    ```

    Replace `<heap_size>` with the desired heap size. `Xms` sets the initial heap size, and `Xmx` the maximum heap size.

    {% include-markdown "includes/jvm-options-xms-xmx-same-value.md" %}

4. Save your modifications in the `jvm.options` file.

5. Restart Elasticsearch service.

    ```bash
    sudo systemctl restart elasticsearch
    ```

## Configure JVM options for TheHive

{% include-markdown "includes/jvm-containerized-deployments.md" %}

1. Open the `/etc/default/thehive` file using a text editor.

2. Uncomment the `JAVA_OPTS` variable.

3. Enter `-Xms<heap_size> -Xmx<heap_size> -XX:MaxMetaspaceSize=<metaspace_size> -XX:ReservedCodeCacheSize=<code_cache_size>` as the value.

    !!! tip "Heap size guidelines for TheHive"
        Heap allocation for TheHive service must not exceed 60% of the available RAM. Available RAM refers to the memory remaining after accounting for the operating system and other services running on the same host.

    Replace `<heap_size>` with the desired heap size.

    {% include-markdown "includes/jvm-options-xms-xmx-same-value.md" %}

    Replace `<metaspace_size>` with the desired Metaspace limit.

    Replace `<code_cache_size>` with the desired code cache limit.

4. Save your modifications.

5. Restart TheHive service.

    ``` bash
    sudo systemctl restart thehive
    ```

## Diagnose persistent memory pressure

If memory issues persist after adjusting heap sizes, use the following commands to investigate the root cause.

### Check heap usage and run garbage collection (GC)

```bash
PID=$(ps aux | grep 'thehive' | awk '{print $2}' | head -n1)
jcmd $PID GC.heap_info
jcmd $PID GC.run
jcmd $PID GC.heap_info
```

Compare the used heap before and after GC:

* Heap drops after GC: temporary pressure, not a leak
* Heap stays high after GC and grows over time: possible memory leak, unbounded cache, or processing backlog

### Monitor heap over time

```bash
PID=$(ps aux | grep 'thehive' | awk '{print $2}' | head -n1)
for i in $(seq 1 150); do
  date '+%Y-%m-%d %H:%M:%S' >> heap_info.txt
  sudo jcmd $PID GC.heap_info >> heap_info.txt
  sleep 1
done
```

For a full observability setup, see [Set Up Monitoring for TheHive with Prometheus and Grafana](monitoring.md).

### Check Java process resource usage

```bash
top -c -p $(ps aux | grep 'java' | awk '{print $2}' | paste -sd ',') -n 1
```

If `top` is not available, use `ps aux | grep 'java'` instead. Note that this shows cumulative CPU usage since process start, not instantaneous usage.

<h2>Next steps</h2>

* [Optimize Performance](performance.md)
* [Set Up Monitoring for TheHive with Prometheus and Grafana](monitoring.md)
