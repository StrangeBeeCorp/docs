# Configure the RunResponder Notifier

<!-- md:permission `manageConfig` --> <!-- md:license Platinum -->

Configure the *RunResponder* [notifier](../about-notifications.md#notifiers) in TheHive to automatically execute [Cortex responders](../../../../../administration/cortex/about-cortex.md) when specific triggers occur.

!!! note "Notifier availability"
    The *RunResponder* notifier is available only when you turn off the **Send notification to every user in the organization** toggle and use one of the following triggers:

    * *FilteredEvent*  
    * *ActionFinished*  
    * *CaseClosed*  
    * *CaseCreated*  
    * *CaseFlagged*  
    * *CaseShared*  
    * *AlertClosed*  
    * *AlertCreated*  
    * *AlertImported*  
    * *AlertObservableCreated*  
    * *CaseObservableCreated*  
    * *ObservableCreated*  
    * *TaskClosed*  
    * *TaskMandatory*

{% include-markdown "includes/cortex-integration-required.md" %}

<h2>Procedure</h2>

1. When [creating a new notification](../create-a-notification.md) or editing an existing one, select the **RunResponder** notifier.

2. Select the responders you want to run.

3. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)