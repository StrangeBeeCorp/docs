# How to Configure the Slack Notifier

This topic provides step-by-step instructions for configuring the Slack [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The Slack notifier is available only when you turn off the **Send notification to every user in the organization** toggle and use one of the following triggers:
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

{!includes/license-required-notifiers.md!}

{!includes/access-notifications.md!}

<h2>Procedure</h2>

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/notifications-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-ellipsis: and then **Edit**.

    ---

4. Select the *Slack* notifier.

    ---

5. In the **Slack** drawer, enter the following information:

    **- Endpoint**

    Using Slack as a notifier requires at least one endpoint. This endpoint defines how TheHive connects to Slack.

    Select an existing endpoint. Endpoints can be local, defined at the organization level, or [global](../../../../../administration/add-a-global-endpoint.md), defined at the client level for one or more organizations. You can add a new local endpoint by selecting [**Add a new endpoint**](../../manage-endpoints/add-slack-endpoint.md).

    **- Text template**

    The message content to send to the Slack endpoint. Select JSON, Markdown, or plain text.

    **- Channel**

    The Slack channel where you want to send the data. This overrides the default channel set in the endpoint configuration.

    **- Username**

    A username that will appear as the sender of the message in Slack. This overrides the default username set in the endpoint configuration.

    {!includes/notifications-variables.md!}
    
    {!includes/templates-notifications-helpers.md!}

    ---

6. Select the **Advanced settings** checkbox if you want to configure additional options.

    !!! tip "Slack documentation to the rescue"
        - Test your integration [the postMessage page](https://api.slack.com/methods/chat.postMessage/test).  
        - Build your blocks with the [Slack Block Kit Builder](https://app.slack.com/block-kit-builder/).

    !!! example "Example of a blocks template: Send notification about case creation"

        * **Trigger**: *CaseCreated*
        * **Notifier**: *Slack*
        
        ```json
        [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "*New Case created: Case #{{object.number}}*"
            }
          },
          {
            "type": "divider"
          },
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "<{{url}}|{{object.title}}> \n :bee: \n {{object.description}}"
            }
          },
          {
            "type": "section",
            "fields": [
              {
                "type": "mrkdwn",
                "text": "*Created by*\n{{object._createdBy}}\n*Assigned to*\n{{object.assignee}}"
              }
            ]
          }
        ]
        ```

    ---

7. Select **Confirm**.

<h2>Next steps</h2>

* [Edit a Notification](../edit-a-notification.md)
