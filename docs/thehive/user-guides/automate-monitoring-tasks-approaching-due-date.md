# Tutorial: Automate Monitoring of Tasks Approaching Their Due Date

<!-- md:version 5.5 --> <!-- md:permission `manageConfig` --> <!-- md:license Platinum -->

In this tutorial, we're going to set up an automation in TheHive to monitor [tasks](./analyst-corner/tasks/about-tasks.md) that are approaching their due date.

By the end, you'll have a working configuration that:

* Identifies tasks due within the next six hours
* Flags those tasks
* Sends a notification by email, Slack, or Microsoft Teams containing a list of flagged tasks

This helps teams stay ahead of deadlines and reduce the risk of overdue tasks.

## Step 1: Periodically identify and flag tasks approaching their due date using an alert feeder

[Create an alert feeder](./organization/configure-organization/manage-feeders/create-a-feeder.md) that regularly scans the list of tasks, identifies those due within the next six hours, and flags them.

!!! tip "Customize the time window to fit your needs"
    The six-hour time window used in this tutorial is provided as an example. You can adjust the `amount` and `unit` values in the query to align with your team’s operational timelines and escalation practices.

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/connectors-tab-organization-go-to.md" %}

3. In the **General settings** section, enter the following information:

    **- Name**: `FlagTasksApproachingDueDateFeeder`

    **- Interval**: `30 minutes`

    **- Request timeout time**: `10 seconds`

    **- Request response max size**: `10`

    **- Description**: `This alert feeder periodically scans tasks and flags those due within the next six hours to help prevent overdue work.`

4. In the **HTTP request** section, enter the following information:

    **- Method**: `POST`

    **- URL**: `https://<thehive_url>/api/v1/query?name=get-global-tasks`

    Replace `<thehive_url>` with your actual TheHive URL.

    **- Body**:

    ```json
    {
        "query": [
            { "_name": "listTask" },
            { "_name": "filter",
                "_and": [
                    { "_lt": { "_field": "dueDate",
                                "_value": { "amount": 6,
                                            "unit": "hours",
                                            "look": "ahead" } } },
                    { "_gt": { "_field": "dueDate",
                                "_value": { "amount": 1,
                                            "unit": "seconds",
                                            "look": "ahead" } } }
                ]
            }
        ]
    }
    ```

5. In the **Header** section, select :fontawesome-solid-plus: and configure the following headers:

    | Key    | Value | Description |
    | -------- | ------- | ------- |
    | `Content-Type` | `application/json` | Specifies that the request payload is formatted as JSON. |
    | `X-organisation` | `<organization_name>`     | Optional. Specifies the organization to use for the request when you belong to multiple organizations. If omitted, the default organization is used. Replace `<organization_name>` with the name of the organization in which you want the HTTP request to be executed.|

6. In the **Authentication** section, enter the following information:

    **- Auth type**: `Bearer`

    **- Key**: Your API key. For guidance on finding it, see [Manage your API key](manage-user-settings.md#manage-your-api-key).

7. Select **Test connection** to verify the connection to the TheHive API.

8. In the **Create function** section, enter the following information:

    **- Function name**: `FlagTasksApproachingDueDate`

    **- Description**: `Flags tasks approaching their due date`

    **- Definition**

    Use this function definition:

    ```javascript
    // Name: FlagTasksApproachingDueDate 
    // Type: Feeder
    // Desc: Flags tasks approaching their due date.
        
    function extractTasks(input) {
        if (!input) return [];
        // If input itself is already an array of tasks
        if (Array.isArray(input)) return input;
        // Common payload shapes
        const candidates = [
            input.tasks,
            input.data,
            input.results,
            input.items,
            input.task,
            input.body,            // sometimes integrations wrap it
            input.response,        // sometimes integrations wrap it
            input?.tasks?.items,
            input?.data?.items,
            input?.results?.items
        ];
        for (const c of candidates) {
            if (Array.isArray(c)) return c;
            if (c && Array.isArray(c.items)) return c.items;
        }
        return [];
    }
    function taskId(t) {
        if (!t) return null;
        if (typeof t === "string") return t;
        return t._id || t.id || null;
    }
    function normStatus(s) {
        return (s ?? "").toString().trim().toLowerCase();
    }
    function handle(input, context) {
        const FLAG_FIELD = input?.flagField || "flag";
        const EXCLUDE_CANCELLED = input?.excludeCancelled !== false; // default true
        const CANCELLED_VALUE = normStatus(input?.cancelledValue || "Cancel");
        const tasks = extractTasks(input);
        if (!tasks || tasks.length === 0) {
            // Helpful debug: show what keys exist in input so you can align mapping
            const keys = input && typeof input === "object" ? Object.keys(input) : [];
            print(`[Function_task flagger] [INFO] No tasks found in input payload. input keys: ${JSON.stringify(keys)}`);
            return;
        }
        let ok = 0;
        let skipped = 0;
        let failed = 0;
        tasks.forEach(t => {
            // Optional skip cancelled
            if (EXCLUDE_CANCELLED) {
                const st = normStatus(t.status || t.state);
                if (st && st === CANCELLED_VALUE) {
                    skipped++;
                    return;
                }
            }
        // Skip already flagged
        if (t[FLAG_FIELD] === true) {
            skipped++;
            return;
        }
        const id = taskId(t);
        if (!id) {
            failed++;
            print("[ERROR] Task without _id/id in payload");
            return;
        }
        try {
            context.task.update(id, { [FLAG_FIELD]: true });
            ok++;
        } catch (err) {
            failed++;
            print(`[ERROR] Failed to flag task ${id}: ${err}`);
            }
        });
    print(`[END] Received: ${tasks.length} | Flagged: ${ok} | Skipped: ${skipped} | Failed: ${failed}`);
    }
    ```

9. {% include-markdown "includes/test-function.md" %}

10. Select **Confirm**.

## Step 2: Configure a notification to inform managers about flagged tasks

Next, configure TheHive to [send a notification](../user-guides/organization/configure-organization/manage-notifications/create-a-notification.md) to the manager about flagged tasks. You can send notifications by email, Slack, or Microsoft Teams.

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/notifications-tab-go-to.md" %}

3. Select :fontawesome-solid-plus:.

4. In the **Add notification** drawer, enter the name of the notification: `TasksDueSoonNotification`

5. Select the *FilteredEvent* trigger.

6. Enter the following custom filter:

    ```json
    {
        "_and": [
            {
                "_is": {
                    "objectType": "Task"
                }
            },
            {
                "_is": {
                    "action": "update"
                }
            },
            {
                "_is": {
                    "details.flag": true
                }
            }
        ]
    }
    ```

7. Depending on where you want to send the notification, configure one of the following notifiers:

    === "Email"

        !!! warning "SMTP server required"
            This step requires an SMTP server to be configured. If it's not already set up, follow the instructions in [Configure an SMTP Server](../administration/smtp/configure-smtp-server.md).

        a. Select the [*EmailerToAddr* notifier](./organization/configure-organization/manage-notifications/notifiers/email-to-addr.md).

        b. In the **EmailerToAddr** drawer, enter the required email information.

        Email template example:

        ```
        Subject: Task due soon [Case #{{context.number}} - {{object.title}}]
        To: {{object.assignee}}

        Hello,

        A task is approaching its due date.
        
        See details below:

        Task title: {{object.title}}
        Case number: {{context.number}}
        Case title: {{context.title}}

        Direct link to the task: {{url}}
        ```
            
        c. Select **Confirm**.

    === "Slack"

        a. Select the [*Slack* notifier](./organization/configure-organization/manage-notifications/notifiers/slack.md).

        b. In the **Slack** drawer, enter the following information:
        
        **- Endpoint**
    
        Using Slack as a notifier requires at least one endpoint. This endpoint defines how TheHive connects to Slack.
    
        Select an existing endpoint. Endpoints can be local, defined at the organization level, or [global](../administration/add-a-global-endpoint.md), defined at the client level for one or more organizations. You can add a new local endpoint by selecting [**Add a new endpoint**](../user-guides/organization/configure-organization/manage-endpoints/add-slack-endpoint.md).
    
        **- Text template**
    
        The message content to send to the Slack endpoint. Select JSON, Markdown, or plain text.

        Plain text message example:

        ```
        A task is approaching its due date.
        
        See details below:
        
        Task title: {{object.title}}
        Case number: {{context.number}}
        Case title: {{context.title}}

        Direct link to the task: {{url}}
        ```
    
        **- Channel**
    
        The Slack channel where you want to send the data. This overrides the default channel set in the endpoint configuration.
    
        **- Username**
    
        A username that will appear as the sender of the message in Slack. This overrides the default username set in the endpoint configuration.

        c. Select **Confirm**.

    === "Microsoft Teams"

        a. Select the [*Teams* notifier](./organization/configure-organization/manage-notifications/notifiers/teams.md).

        b. In the **Teams** drawer, enter the following information:
        
        **- Endpoint**
    
        Using Microsoft Teams as a notifier requires at least one endpoint. This endpoint defines how TheHive connects to Microsoft Teams.
    
        Endpoints can be local, defined at the organization level, or [global](../administration/add-a-global-endpoint.md), defined at the client level for one or more organizations. You can add a new local endpoint by selecting [**Add a new endpoint**](../user-guides/organization/configure-organization/manage-endpoints/add-teams-endpoint.md).
    
        **- Text template**
    
        The message content to send to the Microsoft Teams endpoint.
    
        If an [Adaptive Card](https://adaptivecards.io/){target=_blank} template isn't provided, you must use a plain text template. Starting version 5.4.3, TheHive automatically converts plain text into an Adaptive Card format structured with JSON.
    
        !!! tips "Tips to write text templates"
            
            #### Use the Adaptive Cards Designer
            Use [the Adaptive Cards Designer](https://adaptivecards.io/designer/){target=_blank} as a starting point to design your Adaptive Cards.
            
            #### Format dates
            * TheHive uses [Handlebars string helpers](https://github.com/jknack/handlebars.java/blob/master/handlebars/src/main/java/com/github/jknack/handlebars/helper/StringHelpers.java#L507-L543){target=_blank} to read dates.
            * Formatting date and time in notifications requires using dedicated [Java patterns](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/SimpleDateFormat.html){target=_blank}.
    
            #### Format other custom data from TheHive
            Few data custom to TheHive can be properly displayed using custom string handlers together with `object` data in notifications:
    
            * `tlpLabel` to display the TLP value (example: `{{tlpLabel object.tlp}}`)
            * `papLabel` to display the PAP value (example: `{{papLabel object.pap}}`)
            * `severityLabel` to display the severity value (example: `{{severityLabel object.severity}}`)
        
        c. Select **Confirm**.

8. Select **Confirm** again to save the notification.

That’s it—your automation is now fully set up and ready to monitor tasks approaching their due date.

<h2>Next steps</h2>

* [Create a Dashboard](./analyst-corner/dashboard/create-a-dashboard.md)