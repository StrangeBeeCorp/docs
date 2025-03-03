# How to Add a Webhook Endpoint

This topic provides step-by-step instructions for adding a webhook [endpoint](../manage-endpoints/about-endpoints.md) in TheHive.

{!includes/access-endpoints.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

2. {!includes/endpoints-tab-go-to.md!}

3. Select :fontawesome-solid-plus: or **Add a new endpoint**.

4. In the **Endpoint creation** drawer, select **Webhook**.

5. Enter the following information:

    **- Name**

    The endpoint name, used to identify this webhook integration in TheHive. This name must be unique, as two endpoints can't have the same name.

    **- URL**

    The URL to which TheHive will send webhook requests.

    **- Version**

    Enter the webhook version supported by your external system. This determines the payload format and request structure that TheHive will use when sending data.

6. {!includes/authentication-type.md!}

7. {!includes/proxy-settings.md!}

8. Add a certificate authority.

    For more information about configuring SSL, refer to the [Configure SSL](../../../../administration/authentication/ssl.md) topic.

    Only use certificates from trusted, predefined authorities for secure connections; you can't use custom certificate authorities.

    You can turn off the **Don't check certificate authority** toggle to bypass certificate validation, but this isn't recommended as it may compromise connection security.

9. {!includes/host-name-verification.md!}

10. Select **Confirm**.

## Next steps

* [Configure the Webhook Notifier](../manage-notifications/notifiers/webhook.md)