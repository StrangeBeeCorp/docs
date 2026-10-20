Configure how the node connects to the external service when a proxy is required.

Select a **Proxy mode**:

* *Do not use a proxy*: No proxy is applied. All requests are sent directly. This is the default.

* *Use the platform default proxy configuration*: Uses the global proxy settings defined in TheHive `application.conf`. See [proxy configuration in TheHive](/thehive/configuration/proxy-settings/).

* *Configure a custom proxy*: Defines a custom proxy for this node, overriding the global configuration.

When **Proxy mode** is *Configure a custom proxy*, provide the following information:

| Field | Example |
| -------- | ------- |
| Protocol | `https` |
| Address * | `proxy.example.com` |
| Port | `8080` |
| Username | `$global.proxy_user` |
| Password | `$secret.proxy_password` |
