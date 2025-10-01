# Configure the EmailerToUser Notifier

This topic provides step-by-step instructions for configuring the *EmailerToUser* [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The *EmailerToUser* notifier is available only when you enable the **Send notification to every user in the organization** toggle.

{% include-markdown "includes/requirements-email-notifiers.md" %}

{% include-markdown "includes/access-notifications.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/notifications-tab-go-to.md" %}

3. Select :fontawesome-solid-ellipsis: and then **Edit**.

4. Select the **EmailerToUser** notifier.

5. In the **EmailerToUser** drawer, enter the following information:

    **- Subject**

    The email subject line.

    **- From**

    The sender's email address.

    **- Template**

    The email template used for the message. If you select the HTML format, you must write the full HTML syntax.

    {% include-markdown "includes/notifications-variables.md" %}

    {% include-markdown "includes/templates-notifications-helpers.md" %}

6. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)