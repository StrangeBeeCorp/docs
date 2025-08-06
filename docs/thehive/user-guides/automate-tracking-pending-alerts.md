# Tutorial: Automate Tracking of Pending Alerts

<!-- md:version 5.5 --> <!-- md:license Platinum -->

In this tutorial, we're going to set up an automation in TheHive to monitor [alerts](./analyst-corner/alerts/about-alerts.md) that stay in the *New* status and remain unassigned for too long.

By the end, you'll have a working configuration that:

* Detects alerts that remain unassigned and in *New* status for more than four hours
* Flags them with a custom status to indicate they need review
* Sends an email notification to the manager

This helps ensure no alert gets left behind without action.

!!! tip "Customize criteria for your needs"
    The status and wait time criteria used in this tutorial are just a starting point. Feel free to adjust them based on your team’s triage and escalation practices.

## Step 1: Create a custom alert status to flag pending alerts

To highlight alerts needing review, start by creating a new alert status in TheHive.

Follow the steps in [Create a Status](../administration/status/create-a-status.md), using the following values:

!!! tip "Values to use for the new *TOREVIEW* status"
    | Field    | Value  |
    | -------- | ------- |
    | `Visibility` | *Display*     |
    | `Stage` | *New*     |
    | `Value`  | *TOREVIEW* |

## Step 2: Set up an email notification for *TOREVIEW* alerts

Next, configure TheHive to send an email notification to the manager when an alert status changes to *TOREVIEW*.

Follow the steps in [Create a Notification](../user-guides/organization/configure-organization/manage-notifications/create-a-notification.md), using the following values:

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

To verify that your notification works as expected, manually change the status of an alert to *TOREVIEW*. This action should trigger an email to the configured recipient. If the email arrives, you're all set to move on to the final step!

## Step 3: Automate status updates using an alert feeder

Create an alert feeder that automatically updates the status of unassigned new alerts older than four hours.

This alert feeder will periodically:

* Search for alerts that meet the criteria
* Update their status to *TOREVIEW*

Follow the steps in [Create an Alert Feeder](./organization/configure-organization/manage-feeders/create-a-feeder.md), using the following values:

!!! tip "Values to use for the ChangePendingAlertStatus alert feeder"
    | Field    | Value  |
    | -------- | ------- |
    | `Method` | *GET*     |
    | `URL` | *https://<thehive-url>/api/v1/status/public/*   |
    | `Authentication`  | *None* |

    Use this function definition:

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