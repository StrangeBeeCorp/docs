# Configure SLA Notifications

<!-- md:version 5.8 --> <!-- md:license Platinum --> <!-- md:permission `manageConfig` -->

Notify users when a [service level agreement (SLA) rule's](about-sla-management.md) warning threshold is reached or its deadline is exceeded. SLA notifications use TheHive standard [notification system](../organization/configure-organization/manage-notifications/about-notifications.md).

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

    ---

2. {% include-markdown "includes/notifications-tab-go-to.md" %}

    ---

3. Select :fontawesome-solid-plus:.

    ---

4. In the **Add notification** drawer, enter the name of your notification.

    !!! warning "Unique name"
        This name must be unique, as two notifications can't have the same name.

    ---

5. Optional: Turn on the **Send notification to every user in the organization** toggle to be able to send an email to all users in the organization.

    !!! note "Available trigger"
        If enabled, the *AnyEvent* trigger is no longer available, and only the *EmailerToUser* notifier is selectable.

    ---

6. Select one of the available SLA triggers:

    | Entity | Warning threshold reached | Deadline exceeded |
    |---|---|---|
    | Alert | *AlertSlaAtRisk* | *AlertSlaOverdue* |
    | Case | *CaseSlaAtRisk* | *CaseSlaOverdue* |
    | Task | *TaskSlaAtRisk* | *TaskSlaOverdue* |

    Each SLA rule that matches an entity triggers these events independently. If two SLA rules cover the same entity, each rule can fire its own notification.

    ---

7. Turn on the **Enable notification** toggle to activate the notification.

    ---

8. Select one or more [notifiers](../organization/configure-organization/manage-notifications/about-notifications.md#notifiers).

    ---

9. Enter the required information for each selected notifier, following its specific configuration instructions:

    * [*EmailerToUser*](../organization/configure-organization/manage-notifications/notifiers/email-to-users.md)
    * [*EmailerToAddr*](../organization/configure-organization/manage-notifications/notifiers/email-to-addr.md)
    * [*HttpRequest*](../organization/configure-organization/manage-notifications/notifiers/http-request.md)
    * [*Mattermost*](../organization/configure-organization/manage-notifications/notifiers/mattermost.md)
    * [*Slack*](../organization/configure-organization/manage-notifications/notifiers/slack.md)
    * [*Teams*](../organization/configure-organization/manage-notifications/notifiers/teams.md)
    * [*Webhook*](../organization/configure-organization/manage-notifications/notifiers/webhook.md)
    * [*Kafka*](../organization/configure-organization/manage-notifications/notifiers/kafka.md)
    * [*Redis*](../organization/configure-organization/manage-notifications/notifiers/redis.md)
    * [*RunAnalyzer*](../organization/configure-organization/manage-notifications/notifiers/analyzers.md)
    * [*RunResponder*](../organization/configure-organization/manage-notifications/notifiers/responders.md)
    * [*Function*](../organization/configure-organization/manage-notifications/notifiers/function.md)

    !!! example "Slack notifier template example"

        ```
        An SLA deadline has been exceeded.

        See details below:

        Title: {{object.title}}

        Direct link: {{url}}
        ```

    ---

10. Select **Confirm**.

<h2>Next steps</h2>

* [About SLA Management](about-sla-management.md)
* [Configure SLA Rules](../organization/configure-organization/manage-sla/configure-sla-rules.md)
* [Monitor SLA](monitor-sla.md)
