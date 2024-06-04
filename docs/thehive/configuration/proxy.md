# Proxy Settings

## Global Application Proxy

Proxy settings can be configured for the application. By default, the JVM's proxy settings are used, but it's possible to define specific configurations for individual HTTP clients.

&nbsp;

### Configuration Parameters

| Parameter                           | Type    | Description                                                 |
| ----------------------------------- | ------- | ----------------------------------------------------------- |
| `wsConfig.proxy.host`               | string  | Hostname of the proxy server.                                |
| `wsConfig.proxy.port`               | integer | Port of the proxy server.                                    |
| `wsConfig.proxy.protocol`           | string  | Protocol of the proxy server. Use "http" or "https". Defaults to "http" if not specified. |
| `wsConfig.proxy.user`               | string  | Username for proxy server credentials.                       |
| `wsConfig.proxy.password`           | string  | Password for proxy server credentials.                       |
| `wsConfig.proxy.ntlmDomain`         | string  | NTLM domain for proxy authentication.                        |
| `wsConfig.proxy.encoding`           | string  | Charset for the realm.                                       |
| `wsConfig.proxy.nonProxyHosts`      | list    | List of hosts for which the proxy should not be used.        |