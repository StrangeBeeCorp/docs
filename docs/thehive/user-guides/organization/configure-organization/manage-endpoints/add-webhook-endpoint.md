# Add a Local Webhook Endpoint

This topic provides step-by-step instructions for adding a local *Webhook* [endpoint](../manage-endpoints/about-endpoints.md) in TheHive.

{% include-markdown "includes/local-global-endpoints.md" %}

{% include-markdown "includes/access-endpoints.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

    ---

2. {% include-markdown "includes/endpoints-tab-go-to.md" %}

    ---

3. Select :fontawesome-solid-plus:.

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

6. {% include-markdown "includes/authentication-type.md" %}

    ---

7. {% include-markdown "includes/proxy-settings.md" %}

    ---

8. {% include-markdown "includes/certificate-authority.md" %}

    ---

9. {% include-markdown "includes/host-name-verification.md" %}

    ---

10. Select **Confirm**.

<h2>Next steps</h2>

* [Configure the Webhook Notifier](../manage-notifications/notifiers/webhook.md)