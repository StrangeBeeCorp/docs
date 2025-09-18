# Proxy Settings

TheHive can route [HTTP connections through proxy servers](./ssl/configure-https-reverse-proxy.md) for external communications. By default, TheHive inherits Java virtual machine (JVM) proxy settings, but you can configure specific proxy parameters in the application configuration.

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

<h2>Next steps</h2>

* [Update TheHive Service Configuration](update-service-configuration.md)