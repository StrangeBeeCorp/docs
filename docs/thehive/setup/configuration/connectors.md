# TheHive Connectors

TheHive comes with built-in connectors to seamlessly integrate with Cortex and MISP. 

By default, these connectors are enabled in the /etc/thehive/application.conf configuration file. However, if you are not using one or both of these integrations, you can easily disable them by commenting out the relevant line(s):

```yaml title="/etc/thehive/application.conf"
[..]
scalligraph.modules += org.thp.thehive.connector.cortex.CortexModule
# scalligraph.modules += org.thp.thehive.connector.misp.MispModule  # (1)
```

1. The line for the MISP connector has been commented out, indicating that it is disabled.

!!! Warning "Updating this configuration file requires restarting TheHive service for the changes to take effect."