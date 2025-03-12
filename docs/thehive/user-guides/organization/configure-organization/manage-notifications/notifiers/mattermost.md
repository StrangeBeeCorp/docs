# How to Configure the Mattermost Notifier

This topic provides step-by-step instructions for configuring the Mattermost [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The Mattermost notifier is available only when you turn off the **Send notification to every user in the organization** toggle and use one of the following triggers: 
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

3. Select :fontawesome-solid-ellipsis: and then **Edit**.

4. Select the *Mattermost* notifier.

5. In the **Mattermost** drawer, enter the following information:

    {!includes/notifications-variables.md!}
    
    {!includes/templates-notifications-helpers.md!}

    **- Endpoint**

    Using Mattermost as a notifier requires at least one endpoint. This endpoint defines how TheHive connects to Mattermost.

    Select an existing endpoint. Endpoints can be local, defined at the organization level, or [global](../../../../../administration/add-a-global-endpoint.md), defined at the client level for one or more organizations. You can add a new local endpoint by selecting [**Add a new endpoint**](../../manage-endpoints/add-mattermost-endpoint.md).

    **- Channel**

    The Mattermost channel where you want to send the data. This overrides the default channel set in the endpoint configuration.

    **- Username**

    The username that will appear as the sender of the message in Mattermost. This overrides the default username set in the endpoint configuration.

    **- Template**

    The message content to send to the Mattermost endpoint. Select JSON, Markdown, or plain text.

    {!includes/handlebars-templates.md!}

6. Select **Confirm**.

## Next steps

* [Edit a Notification](../edit-a-notification.md)