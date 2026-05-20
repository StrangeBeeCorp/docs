!!! tip "Recommended TheHive values when all services share the same host"

    === "Without Cortex"

        === "16 GB RAM"

            ```yaml
            -Xms3000m
            -Xmx3000m
            -XX:MaxMetaspaceSize=400m
            -XX:ReservedCodeCacheSize=400m
            ```

        === "32 GB RAM"

            ```yaml
            -Xms7250m
            -Xmx7250m
            -XX:MaxMetaspaceSize=400m
            -XX:ReservedCodeCacheSize=400m
            ```

    === "With Cortex"

        === "16 GB RAM"

            ```yaml
            -Xms2000m
            -Xmx2000m
            -XX:MaxMetaspaceSize=400m
            -XX:ReservedCodeCacheSize=400m
            ```

        === "32 GB RAM"

            ```yaml
            -Xms5400m
            -Xmx5400m
            -XX:MaxMetaspaceSize=400m
            -XX:ReservedCodeCacheSize=400m
            ```
    
    For recommended values across all services, see [Tune JVM Memory](/thehive/operations/tune-jvm-memory/).