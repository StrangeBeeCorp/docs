# How to Add a Mattermost Endpoint

This topic provides step-by-step instructions for adding a Mattermost [endpoint](../manage-endpoints/about-endpoints.md) in TheHive.

{!includes/access-endpoints.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

2. {!includes/endpoints-tab-go-to.md!}

3. Select :fontawesome-solid-plus: or **Add a new endpoint**.

4. In the **Endpoint creation** drawer, select *Mattermost*.

5. Enter the following information:

    **Name \***

    The endpoint name, used to identify this Mattermost integration in TheHive.

    **URL \***

    The Mattermost webhook URL where notifications will be sent. This should be a valid and accessible Mattermost incoming webhook.

    **Username**

    The username that will appear as the sender of the message in Mattermost. If left blank, the default username configured in Mattermost will be used.

    **Channel**

    The Mattermost channel where the message should be sent. If specified, this overrides the default channel set in the Mattermost webhook configuration.

6. {!includes/authentication-type.md!}

7. {!includes/proxy-settings.md!}

8. {!includes/certificate-authority.md!}

9. {!includes/host-name-verification.md!}

10. Select **Confirm**.

## Next steps

* [Configure the HttpRequest Notifier](../manage-notifications/notifiers/http-request.md)