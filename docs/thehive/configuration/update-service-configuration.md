# Update TheHive Service Configuration

Modify TheHive service configuration to fit your requirements.

{% include-markdown "includes/maintenance-window-required.md" %}

## Update the listen address and port

By default, TheHive listens on `all network interfaces (0.0.0.0)` on `port 9000`. You can change these settings to control how TheHive listens internally on the host.

!!! note "Difference from the base URL"
    The listen address and port are independent of the public URL defined in [`application.baseUrl`](#update-the-base-url).

    * Use `http.address` and `http.port` to control how the service listens on the host.
    * Use `application.baseUrl` to define the public URL that TheHive communicates to clients.

1. Stop TheHive service.

    {% include-markdown "includes/service-commands.md" %}

2. Open the `application.conf` file using a text editor.

3. Add the following configuration:

    ```yaml
    http.address=127.0.0.1
    http.port=9000
    ```

4. Modify the values  according to your requirements.

5. Save your modifications in the `application.conf` file.

6. Restart TheHive service.

## Update the base URL

The base URL defines the public address that users access to reach TheHive. This setting tells TheHive how to generate URLs for clients.

!!! note "Role of the base URL"
    The public URL defined in [`application.baseUrl`](#update-the-base-url) is independent of the service’s listening address and port.

    * Use `http.address` and `http.port` to control how the service listens on the host.
    * Use `application.baseUrl` to define the public URL that TheHive communicates to clients.

1. Stop TheHive service.

    {% include-markdown "includes/service-commands.md" %}

2. Open the `application.conf` file using a text editor.

3. Update the following line:

    ```yaml
    [..]
    # Service configuration
    application.baseUrl = "http://localhost:9000"
    [..]
    ```
    
    Replace `http://localhost:9000` with the actual public URL that users will use to access TheHive.
    
    #### Mandatory elements
    
     * Protocol: Either `http` or `https`, depending on whether you [configured HTTPS using a reverse proxy](./ssl/configure-https-reverse-proxy.md).
     * Host name: The DNS name or IP address that users enter in their browser.
    
    #### Optional elements

    * Port: The network port where TheHive is exposed. Include a port only when the public URL uses a non-standard port. Standard ports are `80` for HTTP and `443` for HTTPS.
    * Path segments: Needed if TheHive runs behind a reverse proxy under a subpath.

    {% include-markdown "includes/example-configuration-service.md" %}

4. Save your modifications in the `application.conf` file.

5. Restart TheHive service.

## Set a context path

Configure a context path when [TheHive runs behind a reverse proxy](./ssl/configure-https-reverse-proxy.md) under a specific URL path.

1. Stop TheHive service.

    {% include-markdown "includes/service-commands.md" %}

2. Open the `application.conf` file using a text editor.

3. Update the following line:

    ```yaml
    [..]
    # Service configuration
    play.http.context = "/"
    [..]
    ```

    Replace `/` with your desired context path.

    For example:

    ```yaml
    play.http.context: "/thehive"
    ```

    {% include-markdown "includes/example-configuration-service.md" %}

4. Save your modifications in the `application.conf` file.

5. Restart TheHive service.

## Adjust the stream long-polling refresh interval

TheHive uses long-polling to stream events to clients, with a default refresh interval of `1 minute`.

Adjusting the `stream.longPolling.refresh` setting is useful in two situations:

* Reverse proxy timeouts: Proxies such as Nginx can return `504 Gateway Time-Out` errors on long-polling requests. Reducing this interval keeps requests within the proxy's timeout threshold.
* Performance: Adjusting this interval lets you balance event delivery speed against server load.

To update these settings, follow the steps below.

1. Stop TheHive service.

    {% include-markdown "includes/service-commands.md" %}

2. Open the `application.conf` file using a text editor.

3. Add the following configuration, adjusting the value to your requirements:

    ```yaml
    stream.longPolling.refresh: 1 minute
    ```

4. Save your modifications in the `application.conf` file.

5. Restart TheHive service.

## Adjust attachment and request size limits

TheHive enforces size limits on uploaded attachments and HTTP requests.

Two settings control these limits independently:

| Setting | Controls | Default |
|-----------------|------|-----------|
| `play.http.parser.maxDiskBuffer` | Maximum attachment size | `1GB` |
| `play.http.parser.maxMemoryBuffer` | Maximum HTTP request size (excluding attachments) | `10M` |

To update these settings, follow the steps below.

1. Stop TheHive service.

    {% include-markdown "includes/service-commands.md" %}

2. Open the `application.conf` file using a text editor.

3. Add the following configuration, adjusting the values to your requirements:

    ```yaml
    play.http.parser.maxDiskBuffer = 1GB
    play.http.parser.maxMemoryBuffer = 10M
    ```

4. Save your modifications in the `application.conf` file.

5. Restart TheHive service.

<h2>Next steps</h2>

* [Perform Initial Login and Setup as an Admin](../administration/perform-initial-setup-as-admin.md)
* [Configure HTTPS for TheHive With a Reverse Proxy](./ssl/configure-https-reverse-proxy.md)