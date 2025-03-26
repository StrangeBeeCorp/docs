# How to Edit a Notification

This topic provides step-by-step instructions for editing a [notification](about-notifications.md) in TheHive.

{!includes/access-notifications.md!}

<h2>Procedure</h2>

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/notifications-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-ellipsis: and then **Edit**.

    ---

4. In the **Edit notification** drawer, enter the name of your notification.

    !!! warning "Unique name"
        This name must be unique, as two notifications can't have the same name.

    ---

5. Turn on the **Send notification to every user in the organization** toggle to be able to send an email to all users in the organization.

    !!! note "Available trigger"
        If enabled, the *AnyEvent* trigger will no longer be available, and only the *EmailerToUser* notifier will be selectable.

    ---

6. Select the [trigger](about-notifications.md#triggers) you want to use.

    ---

7. Turn on the **Enable notification** toggle to activate the notification.

    ---

8. Select one or more [notifiers](about-notifications.md#notifiers).

    ---

9. Enter the required information for each selected notifier, following its specific configuration instructions:

    * [*EmailerToUser*](notifiers/email-to-users.md)
    * [*EmailerToAddr*](notifiers/email-to-addr.md)
    * [*HttpRequest*](notifiers/http-request.md)
    * [*Mattermost*](notifiers/mattermost.md)
    * [*Slack*](notifiers/slack.md)
    * [*Teams*](notifiers/teams.md)
    * [*Webhook*](notifiers/webhook.md)
    * [*Kafka*](notifiers/kafka.md)
    * [*Redis*](notifiers/redis.md)
    * [*RunAnalyzer*](notifiers/analyzers.md)
    * [*RunResponder*](notifiers/responders.md)
    * [*Function*](notifiers/function.md)

    ---

10. Select **Confirm**.

<h2>Next steps</h2>

* [Create a Notification](create-a-notification.md)
* [Turn Off a Notification](turn-off-a-notification.md)
* [Delete a Notification](delete-a-notification.md)