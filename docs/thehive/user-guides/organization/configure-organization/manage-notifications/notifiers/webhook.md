# Configure the Webhook Notifier

This topic provides step-by-step instructions for configuring the *Webhook* [notifier](../about-notifications.md#notifiers) in TheHive.

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

{% include-markdown "includes/access-notifications.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/notifications-tab-go-to.md" %}

3. Select :fontawesome-solid-ellipsis: and then **Edit**.

4. Select the **Webhook** notifier.

5. In the **Webhook** drawer, select an existing endpoint.

    Using a webhook as a notifier requires at least one endpoint. This endpoint defines how TheHive connects to the webhook.

    Endpoints can be local, defined at the organization level, or [global](../../../../../administration/add-a-global-endpoint.md), defined at the client level for one or more organizations.

    You can add a new local endpoint by selecting [**Add a new endpoint**](../../manage-endpoints/add-webhook-endpoint.md).

6. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)