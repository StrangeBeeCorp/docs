# How to Configure the Microsoft Teams Notifier

This topic provides step-by-step instructions for configuring the Microsoft Teams [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The Microsoft Teams notifier is only available if the **Send notification to every user in the organization** toggle is turned off and the trigger is one of the following:  
    - *AnyEvent*  
    - *FilteredEvent*  
    - *ActionFinished*  
    - *CaseClosed*  
    - *CaseCreated*  
    - *CaseFlagged*  
    - *CaseShared*  
    - *AlertClosed*  
    - *AlertCreated*  
    - *AlertImported*  
    - *JobFinished*  
    - *AlertObservableCreated*  
    - *CaseObservableCreated*  
    - *ObservableCreated*  
    - *TaskClosed*  
    - *TaskMandatory*

{!includes/access-notifications.md!}

## Procedure

### Step 1: Create a flow in the Workflows application

1. Go to your Microsoft Teams application.

2. Select :fontawesome-solid-ellipsis-h:.

  ![Microsoft select app](../../images/user-guides/organization/notifications/microsoft-teams.png)

3. Select the **Workflows** application.

  ![Workflows app](../../images/user-guides/organization/notifications/workflows-app.png)

4. In the **Workflows** application, select **New flow**.

5. Search for a template named *Post to a channel when a webhook request is received*.

6. Select the template **Post to a channel when a webhook request is received**.

7. Enter your flow name.

8. Select **Next**.

9. Select a Microsoft Teams team and channel.

10. Select **Create flow**.

11. Copy the HTTP POST URL.

### Step 2: Create a Microsoft Teams endpoint

Refer to the [Add a Microsoft Teams endpoint](../../manage-endpoints/add-teams-endpoint.md) topic.

### Step 3: Configure the Microsoft Teams notifier

1. {!includes/organization-view-go-to.md!}

2. {!includes/notifications-tab-go-to.md!}

3. Select :fontawesome-solid-ellipsis-h: and then **Edit**.

4. Select the *Teams* notifier.

5. In the **Teams** drawer, enter the following information:

  **Endpoint**

  Using Microsoft Teams as a notifier requires at least one endpoint. This endpoint defines how TheHive connects to Microsoft Teams.

  Select [the endpoint you created]((../../manage-endpoints/add-teams-endpoint.md)).

  **Text template**

  The message content to be sent to the Microsoft Teams endpoint.

  If an [adaptive card](https://adaptivecards.io/) template is not provided, a plain text template is required. In version 5.4.3, plain text will automatically convert into an adaptive card format, which is structured using JSON.

  !!! tips "Tips to write text templates"
    
      #### Adaptive cards designer
      Use [https://adaptivecards.io/designer/](https://adaptivecards.io/designer/) as a starting point to design your adaptive cards.
    
      #### Format dates
      * TheHive uses [handlerbars string helpers](https://github.com/jknack/handlebars.java/blob/master/handlebars/src/main/java/com/github/jknack/handlebars/helper/StringHelpers.java#L507-L543) to read dates
      * Formatting date and time in notifications requires using dedicated [Java patterns](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/SimpleDateFormat.html)

      #### Format other custom data from TheHive
      Few data custom to TheHive can be properly displayed using custom string handlers together with `object` data in notifications: 

      * `tlpLabel` to display the TLP value (example: `{{tlpLabel object.tlp}}`)
      * `papLabel` to display the PAP value (example: `{{papLabel object.pap}}`)
      * `severityLabel` to display the severity value (example: `{{severityLabel object.severity}}`)
  
  Select **Add Variable** to dynamically insert values using available variables.

  !!! example "Adaptive card template used to display notifications when a new case is created"

    ```json
    {
    "type": "AdaptiveCard",
    "body": [
        {
        "type": "TextBlock",
        "size": "Medium",
        "weight": "Bolder",
        "text": "#{{object.number}}: {{object.title}}",
        "horizontalAlignment": "Left",
        "spacing": "None",
        "wrap": true
        },
        {
        "type": "ColumnSet",
        "columns": [
            {
            "type": "Column",
            "items": [
                {
                "type": "TextBlock",
                "weight": "Bolder",
                "text": "{{object._createdBy}}",
                "fontType": "Default",
                "color": "Accent",
                "spacing": "None"
                },
                {
                "type": "TextBlock",
                "spacing": "None",
                "text": "Created {{dateFormat object._createdAt 'EEEE d MMMM, k:m Z' locale='en' tz='Europe/Paris'}}",
                "isSubtle": true,
                "wrap": true,
                "fontType": "Default",
                "weight": "Default",
                "size": "Default"
                }
            ]
            }
        ]
        },
        {
        "type": "FactSet",
        "facts": [
            {
            "title": "severity",
            "weight": "Bolder",
            "value": "{{ severityLabel object.severity}}"
            },
            {
            "title": "TLP",
            "weight": "Bolder",
            "value": "{{ tlpLabel object.tlp}}"
            }
        ]
        },
        {
        "type": "TextBlock",
        "weight": "Bolder",
        "text": "Description",
        "spacing": "Large",
        "wrap": true,
        "horizontalAlignment": "Left"
        },
        {
        "type": "TextBlock",
        "text": "{{object.description}}",
        "spacing": "None",
        "wrap": true,
        "horizontalAlignment": "Left",
        "maxLines": 3
        }
    ],
    "actions": [
        {
        "type": "Action.OpenUrl",
        "title": "Open Case in TheHive",
        "iconUrl": "https://docs.strangebee.com/images/thehive.png",
        "url": "{{url}}",
        "style": "positive"
        }
    ],
    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
    "version": "1.5"
    }
    ```
  
  Used with the trigger *Case created*, this template will create a card like this in Microsoft Teams:

  ![MS Teams card](../../../images/user-guides/organization/notifications/organization-notifications-teams-2.png)

6. Select **Confirm**.

## Next steps

* [Edit a Notification](edit-a-notification.md)

## Older TheHive Versions

For TheHive versions prior to 5.4.3, users can still send notifications to Microsoft Teams through incoming webhooks. This simpler method involves creating a Teams webhook and using its URL within TheHive's settings.

Although straightforward, this legacy method lacks the customization and enhanced security features available with the newer Power Automate setup. Additionally, with Microsoft’s deprecation of incoming webhooks, continued use may lead to limited functionality in the future.

### Legacy Setup Steps:

1. Set Up Microsoft Teams:

    - Follow the video tutorial to create an incoming webhook and copy the provided URL

      <video controls>
        <source id=mp4 src="../../../images/user-guides/organization/notifications/organization-endpoints-msteams-configuration.mp4" type="video/mp4">
      </video>

2. Configure TheHive:

    - Navigate to **TheHive** > **Organization Admin** > **Endpoint** > **Connector Teams**.
  
    - Paste the webhook URL and complete the configuration as needed.

&nbsp;

!!! Info "Note: As communicated by Microsoft on [their official blog](https://devblogs.microsoft.com/microsoft365dev/retirement-of-office-365-connectors-within-microsoft-teams/), connector owners must update their webhook URLs by January 31, 2025 to comply with the new structure. This update is essential to ensure seamless integration and continued functionality of connectors within Microsoft Teams."

&nbsp;