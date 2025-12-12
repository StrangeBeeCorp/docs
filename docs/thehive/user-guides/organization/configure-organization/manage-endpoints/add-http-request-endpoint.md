# Add a Local HttpRequest Endpoint

<!-- md:permission `manageConfig` -->

Add a local *HttpRequest* [endpoint](../manage-endpoints/about-endpoints.md) in TheHive to send HTTP requests to external services.

{% include-markdown "includes/local-global-endpoints.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

    ---

2. {% include-markdown "includes/endpoints-tab-go-to.md" %}

    ---

3. Select :fontawesome-solid-plus:.

    ---

4. In the **Endpoint creation** drawer, select *Http*.

    ---

5. Enter the following information:

    **- Name**

    The endpoint name, used to identify this HttpRequest integration in TheHive. This name must be unique, as two endpoints can't have the same name.

    **- Method**

    Select an HTTP method from the dropdown list.

    **- URL**

    The destination URL where the HTTP request should be sent. This must be a valid and accessible endpoint.

    ---

6. {% include-markdown "includes/headers.md" %}

    ---

7. {% include-markdown "includes/authentication-type.md" %}

    ---

8. {% include-markdown "includes/proxy-settings.md" %}

    ---

9. {% include-markdown "includes/certificate-authority.md" %}

    ---

10. {% include-markdown "includes/host-name-verification.md" %}

    ---

11. Select **Confirm**.

<h2>Next steps</h2>

* [Configure the HttpRequest Notifier](../manage-notifications/notifiers/http-request.md)