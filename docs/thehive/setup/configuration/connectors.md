# TheHive connectors

Thehive has connectors to integrate with Cortex and MISP. 

By default, they are enabled in the `/etc/thehive/application.conf` configuration file. If you are not using one of them or both they can be disabled by commenting the relevant line: 

```yaml title="/etc/thehive/application.conf"
[..]
scalligraph.modules += org.thp.thehive.connector.cortex.CortexModule
# scalligraph.modules += org.thp.thehive.connector.misp.MispModule  # (1)
```

1. MISP connector is disabled

!!! Warning "Updating this configuration file required the service being restarted"