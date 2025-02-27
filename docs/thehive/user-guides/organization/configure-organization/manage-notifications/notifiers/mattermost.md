# How to Configure the Mattermost Notifier

This topic provides step-by-step instructions for configuring the Mattermost [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The Mattermost notifier is only available if the **Send notification to every user in the organization** toggle is turned off and the trigger is one of the following:  
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

1. {!includes/organization-view-go-to.md!}

2. {!includes/notifications-tab-go-to.md!}

3. Select :fontawesome-solid-ellipsis-h: and then **Edit**.

4. Select the *Mattermost* notifier.

5. In the **Mattermost** drawer, enter the following information:

  **Endpoint**

  Select an existing endpoint. You can add a new endpoint by selecting [**Add a new endpoint**](../../manage-endpoints/add-mattermost-endpoint.md).

  **Channel**

  The Mattermost channel where the data should be sent. This will override the default channel set in the endpoint configuration. Select **Add Variable** to dynamically insert values using available variables.

  **Username**

  A username that will appear as the sender of the message in Mattermost. This will override the default username set in the endpoint configuration. Select **Add Variable** to dynamically insert values using available variables.

  **Template**

  The message content to be sent to the Mattermost endpoint. Select JSON, Markdown, or plain text. Select **Add Variable** to dynamically insert values using available variables.

## Next steps

* [Edit a Notification](edit-a-notification.md)