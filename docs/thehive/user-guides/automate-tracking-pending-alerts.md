# Automate Tracking of Pending Alerts

<!-- md:license Gold --> <!-- md:license Platinum -->

This topic provides step-by-step instructions for automating the tracking of pending [alerts](./analyst-corner/alerts/about-alerts.md) in TheHive.

Use this procedure to automatically highlight and notify managers about all pending alerts that remain in a status *New* and are still unassigned after a specified number of hours.

## Step 1: Create a custom status for alerts

Follow the steps in [Create a Status](../administration/status/create-a-status.md) to add a new alert status named *TOREVIEW* and associate it with the stage *New*.

## Step 2: Create an email notification

Follow the steps in [Create a Notification](../user-guides/organization/configure-organization/manage-notifications/create-a-notification.md) to set up a new notification.

### Trigger

As the trigger, select [*FilteredEvent*](../user-guides/organization/configure-organization/manage-notifications/write-filtered-event-trigger.md) and enter the following custom filter:

```json
{
    "_and": [
        {
            "_is": {
                "objectType": "Alert"
            }
        },
        {
            "_is": {
                "action": "update"
            }
        },
        {
            "_contains": {
                "_field": "details.status",
                "_value": "TOREVIEW"
            }
        }
    ]
}
```

### Notifier

As the notifier, select [*EmailerToAddr*](../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-addr.md).

!!! example "Email template example"
    Hello,

    The following alert has been pending for a while and requires your priority review:

    * ID: {{audit.objectId}}
    * Title: {{audit.object.title}}

    You can access the full alert details here: https://<your-thehive-url>/alerts/{{audit.objectId}}/details

!!! tip "Test your notification"
    Validate your notification works by manually changing the status of an alert to *TOREVIEW*. It should send an email to the configured receiver.