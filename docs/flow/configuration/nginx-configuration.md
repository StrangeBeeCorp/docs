# Nginx Reverse Proxy Configuration

<!-- md:version 6.0 --> <!-- md:license One -->

Nginx is the HTTPS entry point of [TheHive Flow](../user-guides/about-flow.md) stack. Its configuration comes from the `nginx/templates/default.conf.template` file. After changing the template, restart the service:

```bash
docker compose restart nginx
```

## Template variables

The nginx Docker image injects the following variables at container start, from the `environment:` block in `docker-compose.yml`.

| Variable | Value |
| -------- | ----- |
| `${SERVER_NAME}` | The value of [`nginx_server_name`](environment-variables.md) from `.env` |
| `${NGINX_SSL_TRUSTED_CERTIFICATE}` | `ssl_trusted_certificate /etc/nginx/certs/ca.pem;` when a [custom certificate authority is provided](../installation/docker.md#optional-step-2-provide-custom-tls-certificates), an empty string otherwise |

## Service name and published port

The `nginx` service in `docker-compose.yml` runs as a container named `nginx` and publishes port 443 on the host. TheHive Docker Compose profiles use the same container name and the same host port, so running both stacks on a single host means changing them on TheHive Flow side. Use any unused container name and any free host port:

```yaml
nginx:
  container_name: <container_name>
  ports:
    - '<host_port>:443'
```

Keep the container port set to 443: it's the port the template listens on.

Make the change in `docker-compose.yml` rather than in `docker-compose.override.yml`: Compose adds the ports of an override file to those of the base file instead of replacing them, so port 443 would stay published.

Publishing another host port changes the address TheHive Flow answers on, `https://<flow_host>:<host_port>/`. Use that address in [TheHive configuration](../installation/docker.md#step-6-configure-thehive-to-reach-thehive-flow).

## Listener

The template configures a single listener on port 443, with HTTP/2 enabled. It terminates TLS, then proxies requests to `orchestrator:8081` on the internal Docker network.

The listener sets the `Host`, `X-Real-IP`, `X-Forwarded-For`, and `X-Forwarded-Proto` headers on proxied requests, adds a `Strict-Transport-Security` response header, and applies the following limits:

| Setting | Value |
| ------- | ----- |
| `client_max_body_size` | 2 GB |
| Proxy timeouts | 600 s |

A request that exceeds the proxy timeout returns `504 Gateway Timeout`: see [Troubleshoot TheHive Flow](../operations/troubleshooting.md#nginx-and-connectivity) before raising the limit.

The listener also turns response buffering off with `proxy_buffering off`: nginx streams each response to the client as the application produces it, instead of buffering it first. Request bodies remain buffered, a behavior described in [Troubleshoot TheHive Flow](../operations/troubleshooting.md#nginx-and-connectivity).

To restrict which sources can reach the webhook paths, see [Webhook exposure](../operations/security.md#webhook-exposure).

<h2>Next steps</h2>

* [TheHive Flow Configuration Files](configuration-files-overview.md)
* [TheHive Flow Application Configuration](flow-configuration.md)
* [Troubleshoot TheHive Flow](../operations/troubleshooting.md)
