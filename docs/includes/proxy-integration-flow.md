Configure how the node connects to the external service when a proxy is required.

Select a **Proxy mode**:

* *disabled*: No proxy is applied. All requests are sent directly. This is the default.

* *default*: Uses the global proxy settings defined in TheHive `application.conf`. See [proxy configuration in TheHive](/thehive/configuration/proxy-settings/).

* *enabled*: Defines a custom proxy for this node, overriding the global configuration.

When **Proxy mode** is *enabled*, provide the following information:

| Field | Example |
| -------- | ------- |
| Protocol | `https` |
| Address * | `proxy.example.com` |
| Port | `8080` |
| Username | `$global.proxy_user` |
| Password | `$secret.proxy_password` |
