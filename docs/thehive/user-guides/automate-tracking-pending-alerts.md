# Automate Tracking of Pending Alerts

<!-- md:version 5.5 --> <!-- md:license Platinum -->

This topic provides step-by-step instructions for automating the tracking of pending [alerts](./analyst-corner/alerts/about-alerts.md) in TheHive.

Use this procedure to automatically highlight alerts that remain in the *New* status and unassigned for a specified number of hours after creation, and notify the manager accordingly.

## Step 1: Create a custom alert status named *TOREVIEW* to highlight pending alerts

Follow the steps in [Create a Status](../administration/status/create-a-status.md) to add a new alert status named *TOREVIEW* and associate it with the stage *New*.

## Step 2: Create an email notification to alert managers whenever an alert status changes to *TOREVIEW*

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
    To ensure your notification works correctly, manually change the status of an alert to *TOREVIEW*. This action should trigger an email to the configured recipient.

## Step 3: Create an alert feeder to automatically update the status of pending alerts with *TOREVIEW*

The alert feeder checks periodically alerts that remain in the *New* status and unassigned for a specified number of hours after creation, and change their status to *TOREVIEW*.

Follow the steps in [Create an Alert Feeder](./organization/configure-organization/manage-feeders/create-a-feeder.md).

In the **HTTP request** section, select *GET* as the method, and 