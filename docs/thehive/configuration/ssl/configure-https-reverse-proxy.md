# Configure HTTPS for TheHive With a Reverse Proxy

Use a reverse proxy like Nginx to handle SSL/TLS encryption for TheHive. This approach simplifies certificate management and improves performance compared to configuring SSL/TLS directly in TheHive.

For detailed instructions on configuring HTTPS servers with Nginx, refer to the [Nginx documentation](https://nginx.org/en/docs/http/configuring_https_servers.html){target=_blank}.

!!! example "Nginx configuration file"

    ```title="/etc/nginx/sites-available/thehive.conf"
    server {
      listen 443 ssl http2;
      server_name thehive;

      ssl on;
      ssl_certificate       /path/to/<thehive_server_chained_cert>.pem;
      ssl_certificate_key   /path/to/<thehive_server_key>.pem;

      proxy_connect_timeout   600;
      proxy_send_timeout      600;
      proxy_read_timeout      600;
      send_timeout            600;
      client_max_body_size    2G;
      proxy_buffering off;
      client_header_buffer_size 8k;

      location / {
        add_header              Strict-Transport-Security "max-age=31536000; includeSubDomains";
        proxy_pass              http://127.0.0.1:9000/;
        proxy_http_version      1.1;
      }
    }
    ```

!!! info "Configure request size limits"
    The `client_max_body_size` parameter in nginx applies to all request data, including both file uploads and text content. Set this value to match or exceed the maximum file size configured in TheHive `application.conf` to prevent upload failures. For more information, see [Limit File Upload Size in NGINX](https://docs.rackspace.com/docs/limit-file-upload-size-in-nginx){target=_blank}.

!!! note "Additional settings"
    TheHive uses JVM proxy settings by default. You can configure specific proxy settings for individual HTTP clients if needed. See [Proxy Settings](../proxy-settings.md) for available parameters.

!!! warning "Required actions"
    After configuring the reverse proxy, you must update TheHive configuration to work correctly with HTTPS:

    * Update the base URL to use HTTPS
    * Set a context path if TheHive runs under a subpath
    * Configure stream refresh intervals to prevent timeout errors

    See [Update TheHive Service Configuration](../update-service-configuration.md) for detailed instructions.

<h2>Next steps</h2>

* [Update TheHive Service Configuration](../update-service-configuration.md)
* [Configure JVM Trust for SSL/TLS Certificates](configure-ssl-jvm.md)