# How to Add a Local HttpRequest Endpoint

This topic provides step-by-step instructions for adding a local HttpRequest [endpoint](../manage-endpoints/about-endpoints.md) in TheHive.

{!includes/access-endpoints.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/endpoints-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-plus: or **Add a new endpoint**.

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

6. {!includes/headers.md!}

    ---

7. {!includes/authentication-type.md!}

    ---

8. {!includes/proxy-settings.md!}

    ---

9. {!includes/certificate-authority.md!}

    ---

10. {!includes/host-name-verification.md!}

    ---

11. Select **Confirm**.

## Next steps

* [Configure the HttpRequest Notifier](../manage-notifications/notifiers/http-request.md)