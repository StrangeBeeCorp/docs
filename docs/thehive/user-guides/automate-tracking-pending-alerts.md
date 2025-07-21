# Automate Tracking of Pending Alerts

<!-- md:version 5.5 --> <!-- md:license Platinum -->

This topic provides step-by-step instructions for automating the tracking of pending [alerts](./analyst-corner/alerts/about-alerts.md) in TheHive.

Use this procedure to automatically highlight alerts that remain in the *New* status and unassigned for over four hours after creation, and notify the manager accordingly.

!!! tip "Customize criteria for your needs"
    The status and wait time criteria used to highlight pending alerts are examples. Adjust them as needed to fit your requirements.

## Step 1: Create a custom alert status named *TOREVIEW* to highlight pending alerts

Follow the steps in [Create a Status](../administration/status/create-a-status.md).

!!! tip "Values to use for the TOREVIEW status"
    | Field    | Value  |
    | -------- | ------- |
    | `Visibility` | *Display*     |
    | `Stage` | *New*     |
    | `Value`  | *TOREVIEW* |

## Step 2: Create an email notification to alert managers whenever an alert status changes to *TOREVIEW*

Follow the steps in [Create a Notification](../user-guides/organization/configure-organization/manage-notifications/create-a-notification.md).

!!! tip "Values to use for the email notification"
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

    Email template example:

    ```
    Hello,

    The following alert has been pending for a while and requires your priority review:

    * ID: {{audit.objectId}}
    * Title: {{audit.object.title}}

    You can access the full alert details here: https://<your-thehive-url>/alerts/{{audit.objectId}}/details
    ```

!!! note "Test your notification"
    To ensure your notification works correctly, manually change the status of an alert to *TOREVIEW*. This action should trigger an email to the configured recipient.

## Step 3: Create an alert feeder to automatically update the status of pending alerts with *TOREVIEW*

The alert feeder checks periodically alerts that remain in the *New* status and unassigned for over four hours after creation, and change their status to *TOREVIEW*.

Follow the steps in [Create an Alert Feeder](./organization/configure-organization/manage-feeders/create-a-feeder.md).

!!! tip "Values to use for the ChangePendingAlertStatus alert feeder"
    | Field    | Value  |
    | -------- | ------- |
    | `Method` | *GET*     |
    | `URL` | *https://<your-thehive-url>/api/v1/status/public/*   |
    | `Authentication`  | *None* |

    And use this function definition:

    ```javascript
    // Name: ChangePendingAlertStatus 
    // Type: Feeder
    // Desc: This function retrieves all alerts with status New that are unassigned and were created more than four hours ago, then updates their status to TOREVIEW.

    function handle(input, context) {
        
        // Retrieve all alerts where status is New, assignee is empty, and creation date is older than four hours
        const query = [
            {
                "_name":"listAlert",
            },
            {
                "_name":"filter",
                "_eq":
                    { 
                "_field":"status", 
                "_value":"New" 
                    }
            },
            {
                "_name":"filter",
                "_not":
                {
                    "_has":
                    {
                        "_field":"assignee"
                    }
                }
            },
            {
                "_name":"filter",
                "_lte":
                {
                    "_field": "_createdAt",
                    "_value": 
                    {
                        "amount": 4,
                        "unit": "hours",
                        "look": "behind" 
                    }
                } 
            }
        ];

        // Execute the search to get the targeted alerts
        const alertList = context.query.execute(query);
        
        // Update the status to TOREVIEW for all matching alerts
        alertList.map((alrt) => {
            context.alert.update(alrt._id, {status: "TOREVIEW"});
        });
    }
    ```

<h2>Next steps</h2>

* [Create a Dashboard](./analyst-corner/dashboard/create-a-dashboard.md)