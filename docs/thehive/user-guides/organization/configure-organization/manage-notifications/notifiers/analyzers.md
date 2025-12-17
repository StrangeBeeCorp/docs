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

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/notifications-tab-go-to.md" %}

3. Select :fontawesome-solid-ellipsis: next to the notification where you want to add the notifier, then select **Edit**.

4. Select the **RunAnalyzer** notifier.

5. Select the analyzers you want to run.

6. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)
