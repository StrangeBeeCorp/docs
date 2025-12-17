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

To highlight alerts needing review, start by [creating a new alert status](../administration/status/create-a-status.md) in TheHive.

1. {% include-markdown "includes/entities-management-view-go-to.md" %}

2. {% include-markdown "includes/status-tab-go-to.md" %}

3. Select :fontawesome-solid-plus:.

4. In the **Add a custom status** drawer, enter the following information:

    **- Visibility**: *Display*

    **- Stage**: *New*

    **- Value**: *TOREVIEW*

    **- Color**: Enter a hex color code in the format #RRGGBB, or select :fontawesome-solid-fill-drip: to open the color picker.

5. Verify that the preview looks correct.

6. Select **Confirm custom status creation**.

## Step 2: Set up an email notification for *TOREVIEW* alerts

Next, configure TheHive to [send an email notification](../user-guides/organization/configure-organization/manage-notifications/create-a-notification.md) to the manager when an alert status changes to *TOREVIEW*.

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/notifications-tab-go-to.md" %}

3. Select :fontawesome-solid-plus:.

4. In the **Add notification** drawer, enter the name of your notification.

    !!! warning "Unique name"
        This name must be unique, as two notifications can't have the same name.

5. Select the *FilteredEvent* trigger.

6. Enter the following custom filter:

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

7. Select the *EmailerToAddr* notifier.

8. In the **EmailerToAddr** drawer, enter the required email information.

    {% include-markdown "includes/notifications-variables.md" %}

    {% include-markdown "includes/templates-helpers.md" %}

    Email template example:

    ```
    Hello,

    The following alert has been pending for a while and requires your priority review:

    * ID: {{audit.objectId}}
    * Title: {{audit.object.title}}

    You can access the full alert details here: https://<thehive_url>/alerts/{{audit.objectId}}/details
    ```
    
    Replace `<thehive_url>` with your actual TheHive URL.

9. Select **Confirm**.

10. Select **Confirm** again to save the notification.

To verify that your notification works as expected, manually change the status of an alert to *TOREVIEW*. This action should trigger an email to the configured recipient. If the email arrives, you're all set to move on to the final step!

## Step 3: Automate status updates using an alert feeder

[Create an alert feeder](./organization/configure-organization/manage-feeders/create-a-feeder.md) that automatically updates the status of unassigned new alerts older than four hours.

This alert feeder will periodically search for alerts that meet the criteria and update their status to *TOREVIEW*

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/connectors-tab-organization-go-to.md" %}

3. In the **General settings** section, enter the following information:

    **- Name**: A unique name for the alert feeder. You can’t change this name later.

    **- Interval**: How often the alert feeder sends requests to the external system.

    !!! warning "Define the interval carefully based on your reactivity requirements"
        Make sure the interval is shorter than the processing time to avoid potential issues, but not too short to prevent excessive requests to the API.

    **- Request timeout time**: The maximum time, in seconds, the alert feeder waits for a response before timing out.

    **- Request response max size**: The maximum response size, in megabytes, that the alert feeder accepts from the external system.

    **- Description**: A description to provide additional context or notes about the alert feeder configuration.

4. In the **HTTP request** section, enter the following information:

    **- Method**: *GET*

    **- URL**: *https://<thehive_url>/api/v1/status/public/*

    Replace `<thehive_url>` with your actual TheHive URL.

5. Select **Test connection** to verify the connection to the external system.

6. In the **Create function** section, enter the following information:

    !!! info "Feeder function"
        Once created, the function is automatically added to the [functions list](../manage-functions/about-functions.md) with the type *feeder*.

    **- Function name**: *ChangePendingAlertStatus*

    **- Description**: *This function retrieves all alerts with status New that are unassigned and were created more than four hours ago, then updates their status to TOREVIEW*

    **- Definition**

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

7. {% include-markdown "includes/test-function.md" %}

8. Select **Confirm**.

That’s it—your automation is now fully set up and ready to ensure no pending alert goes unnoticed.

<h2>Next steps</h2>

* [Create a Dashboard](./analyst-corner/dashboard/create-a-dashboard.md)