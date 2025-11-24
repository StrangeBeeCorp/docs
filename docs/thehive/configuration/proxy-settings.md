# Outbound Proxy Settings

TheHive can route outbound HTTP/HTTPS connections through proxy servers for external communications. By default, TheHive inherits Java virtual machine (JVM) proxy settings. You can configure global proxy parameters in the application configuration and, for some HTTP clients, override them with dedicated proxy settings.

## Global application proxy parameters

Configure these parameters in the `application.conf` file to define proxy settings for all HTTP clients in TheHive.

| Parameter                           | Type    | Description                                                 |
| ----------------------------------- | ------- | ----------------------------------------------------------- |
| `wsConfig.proxy.host`               | string  | Host name or IP address of the proxy server.                                |
| `wsConfig.proxy.port`               | integer | Port number of the proxy server.                                    |
| `wsConfig.proxy.protocol`           | string  | Protocol for proxy connection (`http` or `https`). Default: `http`. |
| `wsConfig.proxy.user`               | string  | Username for proxy authentication.                       |
| `wsConfig.proxy.password`           | string  | Password for proxy authentication.                       |
| `wsConfig.proxy.ntlmDomain`         | string  | Domain name for NTLM proxy authentication.                        |
| `wsConfig.proxy.encoding`           | string  | Character encoding for authentication realm.                                       |
| `wsConfig.proxy.nonProxyHosts`      | list    | Host names or patterns that bypass the proxy.        |

## Per-client proxy overrides

Some HTTP clients in TheHive can use dedicated proxy settings that override the global configuration defined in `wsConfig.proxy.*`.

### Email intake connectors

Configure these parameters in the `application.conf` file to define the proxy settings used specifically by an [email intake connector](../administration/email-intake-connector/about-email-intake-connectors.md).

| Parameter                                           | Type    | Description                                      |
| --------------------------------------------------- | ------- | ------------------------------------------------ |
| `msGraph.client.proxy.host`            | string  | Host name or IP address of the proxy server.      |
| `msGraph.client.proxy.port`            | integer | Port number of the proxy server.                 |
| `msGraph.client.proxy.principal`       | string  | Username for proxy authentication.    |
| `msGraph.client.proxy.password`        | string  | Password for proxy authentication.    |

<h2>Next steps</h2>

* [Update TheHive Service Configuration](update-service-configuration.md)
