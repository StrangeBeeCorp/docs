# How to Add a Local Webhook Endpoint

This topic provides step-by-step instructions for adding a local webhook [endpoint](../manage-endpoints/about-endpoints.md) in TheHive.

{!includes/access-endpoints.md!}

<h2>Procedure</h2>

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/endpoints-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-plus: or **Add a new endpoint**.

    ---

4. In the **Endpoint creation** drawer, select *Webhook*.

    ---

5. Enter the following information:

    **- Name**

    The endpoint name, used to identify this webhook integration in TheHive. This name must be unique, as two endpoints can't have the same name.

    **- URL**

    The URL to which TheHive will send webhook requests.

    **- Version**

    Enter the webhook version supported by your external system. This determines the payload format and request structure that TheHive will use when sending data.

    ---

6. {!includes/authentication-type.md!}

    ---

7. {!includes/proxy-settings.md!}

    ---

8. {!includes/certificate-authority.md!}

    ---

9. {!includes/host-name-verification.md!}

    ---

10. Select **Confirm**.

<h2>Next steps</h2>

* [Configure the Webhook Notifier](../manage-notifications/notifiers/webhook.md)