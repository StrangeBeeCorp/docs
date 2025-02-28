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

!!! warning "Migrating to Power Automate workflows for Microsoft Teams integration"
    With the 5.4.3 release, TheHive has updated the Microsoft Teams notifier in response to Microsoft's deprecation of the incoming webhook workflow. Users [must now migrate from the legacy Teams webhook setup to a new configuration using Power Automate workflows](#migrate-to-the-microsoft-teams-notifier).

{!includes/access-notifications.md!}

## Configure the Microsoft Teams notifier (for new users)

1. Go to the [Power Automate website](https://make.powerautomate.com/) and sign in with your Microsoft account.

  ![](../../../images/user-guides/organization/notifications/msteams-1.png)

2. Select **Create** and then **Instant cloud flow**.

3. Enter a name for your flow.

4. In the **Choose how to trigger this flow** section, select **When a Teams webhook is received**.

5. Select :fontawesome-solid-plus: to add an action.

6. In the **Add an action** drawer, select **Post card in a chat or channel** for Microsoft Teams.

7. Select your action card and enter the following values in corresponding fields:

  **Post as**

  Select *  *.

  **Post in**

  **Team**

  **Channel**


1. {!includes/organization-view-go-to.md!}

2. {!includes/notifications-tab-go-to.md!}

3. Select :fontawesome-solid-ellipsis-h: and then **Edit**.

4. Select the *Teams* notifier.

5. In the **Teams** drawer, enter the following information:

  **Endpoint**

  Using Teams as a notifier requires at least one endpoint. This endpoint defines how TheHive connects to Teams.

  Select an existing endpoint. You can add a new endpoint by selecting [**Add a new endpoint**](../../manage-endpoints/add-teams-endpoint.md).

  **Text template**

  The message content to be sent to the Teams endpoint. Select JSON or plain text. Select **Add Variable** to dynamically insert values using available variables.

6. Select **Confirm**.

## Next steps

* [Edit a Notification](edit-a-notification.md)




### Step 1: Create a New Power Automate Flow

  1. **Navigate to Power Automate**:

    - Go to [Power Automate](https://make.powerautomate.com/) and sign in with your Microsoft account.

      ![](../../../images/user-guides/organization/notifications/msteams-1.png)

  2. **Create a Flow**:

    - Click on **Create** and select **Instant cloud flow**.

  3. **Select Template**:

    - Choose the template **"Post to a channel when a HTTP request is received"**.

      ![](../../../images/user-guides/organization/notifications/msteams-2.png)

  4. **Configure Flow Details**:
    
    - Name your flow and select the Microsoft Teams channel where notifications should be sent.
    - Confirm the necessary permissions for Power Automate to post messages on your behalf.

      ![](../../../images/user-guides/organization/notifications/msteams-3.png)

  5. **Save the Flow**:

    - Click **Save** to complete the flow setup.
    - After saving, the flow will generate a unique HTTP POST URL. **Copy this URL** for use in TheHive configuration.

&nbsp;

### Step 2: Create a New Endpoint
In the *Organization* configuration view, go to the *Endpoints* tab. Click the :fontawesome-regular-square-plus: button to add a new *Connector*.

<figure markdown>
  ![Endpoints list](../../../images/user-guides/organization/notifications/organization-endpoints.png)
</figure>

&nbsp;

### Step 3: Enter the Required Information
Select *Teams* as the connector type and complete the necessary details.

<figure markdown>
  ![Teams endpoint configuration](../../../images/user-guides/organization/notifications/organization-endpoints-teams-configuration.png)
</figure>

- **Name**: Provide a unique name for the endpoint.
- **URL**: Enter the URL for connecting to Microsoft Teams. This URL should be the one copied from Power Automate when setting up the new workflow.
- **Auth Type**: Select an authentication method — *Basic Authentication*, *Key*, or *Bearer*.
- **Proxy settings**: Optionally, enable a web proxy to connect to this endpoint.
- **Certificate Authorities**: If required, add custom Certificate Authorities in PEM format.
- **SSL settings**: Optionally, disable Certificate Authority validation or hostname checks.

Once all fields are completed, click **Confirm** to create the endpoint.

---

## Migrate to the latest Microsoft Teams notifier (for existing users)

If you are currently using the legacy Teams webhook, follow these steps to migrate:

1. Complete the **Create a New Power Automate Flow** steps above to obtain the new HTTP POST URL.
2. Go to **TheHive > Organization Admin > Endpoint > Connector Teams**.
3. In the **Teams webhook URL** field, replace the existing webhook URL with the new HTTP POST URL from your Power Automate flow.
4. Click **Save** to apply the update.

---

## Notification Configuration
When creating a *Notification* select *Teams/ENDPOINT* (with ENDPOINT the name of the endpoint created) as *Connector* and complete the form.

<figure markdown>
  ![Choose Teams](../../../images/user-guides/organization/notifications/organization-notifications-teams-1.png)
</figure>

TheHive uses [Handlebars](https://handlebarsjs.com) to let you build templates with input data, and this can be used in most of all fields of the form:

* **Endpoint**: choose the endpoint to use
* **Text template**: If an adaptive card template is not provided, a plain text template is required. In version 5.4.3, plain text will automatically convert into an adaptive card format.
* **Adaptive card template**:
    * Available format are: *JSON*, *Markdown* and *Plain text* 
    * Click *Add variable* to select a variable to insert in the template


!!! Example "Example: template used to display notification when a new Case is created"

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

Used with the trigger _Case created_, this template will create a card like this in Microsoft Teams:

<figure markdown>
  ![MS Teams card](../../../images/user-guides/organization/notifications/organization-notifications-teams-2.png)
</figure>


!!! Tip "Tips"
    
    #### Write MS Teams active Cards
    Use [https://adaptivecards.io/designer/](https://adaptivecards.io/designer/) as a starting point to design your adaptive card
    
  
    #### Format dates 

    * TheHive uses [handlerbars string helpers](https://github.com/jknack/handlebars.java/blob/master/handlebars/src/main/java/com/github/jknack/handlebars/helper/StringHelpers.java#L507-L543) to read dates
    * Formatting date and time in notifications requires using dedicated [Java patterns](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/SimpleDateFormat.html)

    #### Format other custom data from TheHive

    Few data custom to TheHive can be properly displayed using custom string handlers together with `object` data in notifications: 

    * `tlpLabel` to display the TLP value (example: `{{tlpLabel object.tlp}}`)
    * `papLabel` to display the PAP value (example: `{{papLabel object.pap}}`)
    * `severityLabel` to display the severity value (example: `{{severityLabel object.severity}}`)

---

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