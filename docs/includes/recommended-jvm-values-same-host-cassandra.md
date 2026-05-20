!!! tip "Recommended Cassandra values when all services share the same host"

    === "Without Cortex"

        === "16 GB RAM"

            ```yaml
            -Xms2g
            -Xmx4g
            -Xmn200m
            ```

        === "32 GB RAM"

            ```yaml
            -Xms4g
            -Xmx8g
            -Xmn400m
            ```

    === "With Cortex"

        === "16 GB RAM"

            ```yaml
            -Xms1g
            -Xmx3g
            -Xmn200m
            ```

        === "32 GB RAM"

            ```yaml
            -Xms3g
            -Xmx6g
            -Xmn400m
            ```
    
    For recommended values across all services, see [Tune JVM Memory](/thehive/operations/tune-jvm-memory/).