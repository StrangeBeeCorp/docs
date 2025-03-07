# How to Add a Local Slack Endpoint

This topic provides step-by-step instructions for adding a local Slack [endpoint](../manage-endpoints/about-endpoints.md) in TheHive.

{!includes/access-endpoints.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/endpoints-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-plus: or **Add a new endpoint**.

    ---

4. In the **Endpoint creation** drawer, select *Slack*.

    ---

5. Enter the following information:

    **- Name**

    The endpoint name, used to identify this Slack integration in TheHive. This name must be unique, as two endpoints can't have the same name.

    **- Token**

    The authentication token required to connect to Slack.

    ---

6. {!includes/proxy-settings.md!}

    ---

7. Add a certificate authority.

    For more information about configuring SSL, refer to the [Configure SSL](../../../../administration/authentication/ssl.md) topic.

    Use certificates only from trusted, predefined authorities for secure connections. Custom certificate authorities are not allowed.

    You can turn off the **Don't check certificate authority** toggle to bypass certificate validation, but this isn't recommended as it may compromise connection security.

    ---

8. {!includes/host-name-verification.md!}

    ---

9. Select **Confirm**.

## Next steps

* [Configure the Slack Notifier](../manage-notifications/notifiers/slack.md)