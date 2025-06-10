# How to Add a Local Mattermost Endpoint

This topic provides step-by-step instructions for adding a local *Mattermost* [endpoint](../manage-endpoints/about-endpoints.md) in TheHive.

{!includes/local-global-endpoints.md!}

{!includes/access-endpoints.md!}

<h2>Procedure</h2>

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/endpoints-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-plus: or **Add a new endpoint**.

    ---

4. In the **Endpoint creation** drawer, select *Mattermost*.

    ---

5. Enter the following information:

    **- Name \***

    The endpoint name, used to identify this Mattermost integration in TheHive. This name must be unique, as two endpoints can't have the same name.

    **- URL \***

    The URL used to connect to your Mattermost instance.

    **- Username**

    The default username used to send messages. If left blank, the default username configured in Mattermost will be used.

    **- Channel**

    The default channel used to send messages. If specified, this overrides the default channel set in the Mattermost webhook configuration.

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

* [Configure the Mattermost Notifier](../manage-notifications/notifiers/mattermost.md)