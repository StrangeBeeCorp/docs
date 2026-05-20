!!! tip "Recommended Elasticsearch values when all services share the same host"

    === "Without Cortex"

        === "16 GB RAM"

            ```yaml
            -Xms3000m
            -Xmx3000m
            ```

        === "32 GB RAM"

            ```yaml
            -Xms7000m
            -Xmx7000m
            ```

    === "With Cortex"

        === "16 GB RAM"

            ```yaml
            -Xms2000m
            -Xmx2000m
            ```

        === "32 GB RAM"

            ```yaml
            -Xms5400m
            -Xmx5400m
            ```
    
    For recommended values across all services, see [Tune JVM Memory](/thehive/operations/tune-jvm-memory/).