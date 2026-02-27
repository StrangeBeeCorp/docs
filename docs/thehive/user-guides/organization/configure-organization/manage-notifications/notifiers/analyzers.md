# Configure the RunAnalyzer Notifier

<!-- md:permission `manageConfig` --> <!-- md:license Platinum -->

Configure the *RunAnalyzer* [notifier](../about-notifications.md#notifiers) in TheHive to automatically execute [Cortex analyzers](../../../../../administration/cortex/about-cortex.md) when specific triggers occur.

!!! note "Notifier availability"
    The *RunAnalyzer* notifier is available only when you turn off the **Send notification to every user in the organization** toggle and use one of the following triggers:  

    * *FilteredEvent*
    * *AlertObservableCreated*
    * *CaseObservableCreated*
    * *ObservableCreated*

{% include-markdown "includes/cortex-integration-required.md" %}

<h2>Procedure</h2>

1. When [creating a new notification](../create-a-notification.md) or editing an existing one, select the **RunAnalyzer** notifier.

2. Select the analyzers you want to run.

3. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)
