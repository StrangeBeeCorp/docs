Configure how the node connects to external services when a proxy is required.

Nodes support three modes:

* Disabled: No proxy is applied. All requests are sent directly.

* Default: Uses the global proxy settings defined in TheHive `application.conf`. See [proxy configuration in TheHive](/thehive/configuration/proxy-settings/).

* Enabled: Defines a custom proxy for this node, overriding the global configuration.

| Field    | Example |
| -------- | ------- |
| Protocol | `https` |
| Address * | `proxy.example.com` |
| Port | `8080` |
| Proxy username | `$global.proxy_user` |
| Proxy password | `$secret.proxy_password` |

Protocol defaults to `https`, and Port defaults to `8080`.
