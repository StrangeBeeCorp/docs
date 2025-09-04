# Service Configuration

## Listen Address & Port

By default, the application listens on `all network interfaces (0.0.0.0)` on `port 9000`. You can customize the listen address and port by editing the `application.conf` file as follows:

```
http.address=127.0.0.1
http.port=9000
```

Specify the desired IP address and port based on your requirements.

---

## Setting a Context Path

If you are using a reverse proxy and need to define a specific context path (e.g., `/thehive`), you must update TheHive configuration accordingly:

!!! Example
    ```
    play.http.context: "/thehive"
    ```

This sets the base context path for accessing TheHive via the reverse proxy.

---

## Configuring Streams for Reverse Proxies

When using a reverse proxy like Nginx, you may encounter `504 Gateway Time-Out` errors related to long polling. Adjust the `stream.longPolling.refresh` setting to resolve this issue:

!!! Example
    ```
    stream.longPolling.refresh: 45 seconds
    ```

This setting controls the refresh interval for long-polling requests.

---

## Using Web Proxy 

If you are employing an NGINX reverse proxy in front of TheHive, note that NGINX does not differentiate between text data and file uploads. To ensure proper handling, set the `client_max_body_size` parameter in your NGINX configuration file to accommodate the larger value between the file upload size and the text size defined in TheHive application.conf

To configure `client_max_body_size`, follow these steps:

1. Edit your NGINX configuration file. This file is typically located at `/etc/nginx/nginx.conf` or within a specific server block configuration file.

2. Locate the `http` block in the NGINX configuration file.

3. Add or modify the `client_max_body_size` directive within the `http` block to specify the maximum allowable size for incoming requests. For example:
   
   ```nginx
   http {
       ...
       client_max_body_size 100M;  # Adjust to your desired value
       ...
   }
   ```

For more detailed information, please refer to the article [Limit File Upload Size in NGINX](https://docs.rackspace.com/docs/limit-file-upload-size-in-nginx).

&nbsp;