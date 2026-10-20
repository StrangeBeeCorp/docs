# Nginx Reverse Proxy Configuration

<!-- md:version 6.0 --> <!-- md:license One -->

In a [TheHive Flow](../user-guides/about-flow.md) Docker Compose deployment, nginx is the HTTPS entry point. Its configuration comes from the `nginx/templates/default.conf.template` file. After changing the template, restart the service:

```bash
docker compose restart nginx
```

On a Kubernetes deployment, nginx isn't deployed. An Ingress applies the equivalent body size and timeout limits through annotations, as described in [Expose TheHive Flow outside the cluster](../installation/kubernetes.md#optional-step-8-expose-thehive-flow-outside-the-cluster).

## Template variables

The nginx Docker image injects the following variables at container start, from the `environment:` block in `docker-compose.yml`.

| Variable | Value |
| -------- | ----- |
| `${SERVER_NAME}` | The value of [`nginx_server_name`](environment-variables.md) from `.env` |
| `${NGINX_SSL_TRUSTED_CERTIFICATE}` | `ssl_trusted_certificate /etc/nginx/certs/ca.pem;` when a [custom certificate authority is provided](../installation/docker.md#optional-step-6-provide-custom-tls-certificates), an empty string otherwise |
| `NGINX_THEHIVE_ADDRESSES` | The value of [`nginx_thehive_addresses`](environment-variables.md) from `.env`. It isn't a template variable. Before nginx starts, the `nginx/docker-entrypoint.d/40-thehive-allow.sh` script turns it into the `allow` lines of `/etc/nginx/thehive-allow.conf`. The script skips any entry that isn't an IPv4 address or a Classless Inter-Domain Routing (CIDR) range, or that covers the Docker network gateway |

Apply a change to `nginx_thehive_addresses` with `docker compose up -d --no-deps nginx`. The entrypoint script runs again and logs the addresses it allows and skips.

## Service name and published port

!!! warning "TheHive in a container on the same host"
    Changing the name or port doesn't let a TheHive running in a container on the same host reach TheHive Flow.

The `nginx` service in `docker-compose.yml` runs as a container named `nginx` and publishes port 443 on the host. When another container or service on the host already uses that name or port, change them for TheHive Flow, using any unused container name and any free host port:

```yaml
nginx:
  container_name: <container_name>
  ports:
    - '<host_port>:443'
```

Keep the container port set to 443, the port the template listens on.

Make the change in `docker-compose.yml` rather than in a `docker-compose.override.yml` file: Compose adds the ports of an override file to those of the base file instead of replacing them, so port 443 would stay published.

Publishing another host port changes the address TheHive Flow answers on, `https://<flow_host>:<host_port>/`. Use that address in [TheHive configuration](../installation/docker.md#step-10-configure-thehive-to-reach-thehive-flow), and set [`flow_public_url`](environment-variables.md#public-url) to it so that webhook URLs include the port.

## Listener

The template configures a single listener on port 443, with HTTP/2 enabled. It terminates TLS and routes requests by path to `thehive-flow:8081` on the internal Docker network:

* `/webhook/` is proxied for any caller
* `/api/` is proxied only for the addresses listed in [`nginx_thehive_addresses`](environment-variables.md), and answers `403 Forbidden` to anyone else
* Every other path answers `404 Not Found`

Nginx resolves the `thehive-flow` service name through the Docker embedded DNS server at `127.0.0.11`, and resolves it again every 10 seconds. Recreating the `thehive-flow` service, for example with `docker compose up -d thehive-flow` after a configuration change, gives it a new IP address that nginx picks up without a restart. If nginx can't resolve the name, it still starts, returns `502 Bad Gateway`, and logs `thehive-flow could not be resolved`.

The listener sets the `Host`, `X-Real-IP`, `X-Forwarded-For`, and `X-Forwarded-Proto` headers on proxied requests, adds a `Strict-Transport-Security` response header, and applies the following limits:

| Setting | Value |
| ------- | ----- |
| `client_max_body_size` | 2 GB |
| Proxy timeouts | 600 s |

A request that exceeds the proxy timeout returns `504 Gateway Timeout`. Before raising the limit, see [Troubleshoot TheHive Flow](../operations/troubleshooting.md#nginx-and-connectivity).

The listener also turns response buffering off with `proxy_buffering off`: nginx streams each response to the client as the application produces it, instead of buffering it first. Request bodies remain buffered, a behavior described in [Troubleshoot TheHive Flow](../operations/troubleshooting.md#nginx-and-connectivity).

To restrict which sources can reach the webhook paths, see [Webhook exposure](../operations/security.md#webhook-exposure).

<h2>Next steps</h2>

* [TheHive Flow Configuration Files](configuration-files-overview.md)
* [TheHive Flow Application Configuration](flow-configuration.md)
* [Troubleshoot TheHive Flow](../operations/troubleshooting.md)
