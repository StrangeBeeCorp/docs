# How to Configure the Webhook Notifier

This topic provides step-by-step instructions for configuring the webhook [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The webhook notifier is only available if the **Send notification to every user in the organization** toggle is turned off and the trigger is one of the following:  
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

4. Select the *Webhook* notifier.

5. In the **Webhook** drawer, select an existing endpoint.

    Using a webhook as a notifier requires at least one endpoint. This endpoint defines how TheHive connects to the webhook.

    You can add a new endpoint by selecting [**Add a new endpoint**](../../manage-endpoints/add-webhook-endpoint.md).

6. Select **Confirm**.

## Next steps

* [Edit a Notification](../edit-a-notification.md)