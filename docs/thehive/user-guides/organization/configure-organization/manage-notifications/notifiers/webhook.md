# Configure the Webhook Notifier

<!-- md:permission `manageConfig` -->

Configure the *Webhook* [notifier](../about-notifications.md#notifiers) in TheHive to send automated notifications to external systems via HTTP requests based on specific triggers.

!!! note "Notifier availability"
    The *Webhook* notifier is available only when you turn off the **Send notification to every user in the organization** toggle and use one of the following triggers:

    * *AnyEvent*  
    * *FilteredEvent*  
    * *ActionFinished*  
    * *CaseClosed*  
    * *CaseCreated*  
    * *CaseFlagged*  
    * *CaseShared*  
    * *AlertClosed*  
    * *AlertCreated*  
    * *AlertImported*  
    * *JobFinished*  
    * *AlertObservableCreated*  
    * *CaseObservableCreated*  
    * *ObservableCreated*  
    * *TaskClosed*  
    * *TaskMandatory*

<h2>Procedure</h2>

1. When [creating a new notification](../create-a-notification.md) or editing an existing one, select the **Webhook** notifier.

2. In the **Webhook** drawer, select an existing endpoint.

    Using a webhook as a notifier requires at least one endpoint. This endpoint defines how TheHive connects to the webhook.

    Endpoints can be local, defined at the organization level, or [global](../../../../../administration/add-a-global-endpoint.md), defined at the client level for one or more organizations.

    You can add a new local endpoint by selecting [**Add a new endpoint**](../../manage-endpoints/add-webhook-endpoint.md).

3. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)