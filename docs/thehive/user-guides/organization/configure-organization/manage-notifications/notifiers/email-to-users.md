# Configure the EmailerToUser Notifier

<!-- md:permission `manageConfig` -->

Configure the *EmailerToUser* [notifier](../about-notifications.md#notifiers) in TheHive to send emails to all users in the organization.

!!! note "Notifier availability"
    The *EmailerToUser* notifier is available only when you enable the **Send notification to every user in the organization** toggle.

{% include-markdown "includes/requirements-email-notifiers.md" %}

<h2>Procedure</h2>

1. When [creating a new notification](../create-a-notification.md) or editing an existing one, select the **EmailerToUser** notifier.

2. In the **EmailerToUser** drawer, enter the following information:

    **- Subject**

    The email subject line.

    **- From**

    The sender's email address.

    **- Template**

    The email template used for the message. If you select the HTML format, you must write the full HTML syntax.

    {% include-markdown "includes/notifications-variables.md" %}

    {% include-markdown "includes/templates-helpers.md" %}

3. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)