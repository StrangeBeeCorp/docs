# Configure the Kafka Notifier

<!-- md:permission `manageConfig` --> <!-- md:license Platinum -->

Configure the *Kafka* [notifier](../about-notifications.md#notifiers) in TheHive to publish automated notifications to Kafka topics based on specific triggers.

!!! note "Notifier availability"
    The *Kafka* notifier is available only when you turn off the **Send notification to every user in the organization** toggle and use one of the following triggers:

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

!!! info "No endpoint required"
    An endpoint definition isn't required to send data to a Kafka topic.

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/notifications-tab-go-to.md" %}

3. Select :fontawesome-solid-ellipsis: next to the notification where you want to add the notifier, then select **Edit**.

4. Select the **Kafka** notifier.

5. In the **Kafka** drawer, enter the following information:

    **- Topic**

    The Kafka topic where TheHive will publish messages. This must match an existing topic in your Kafka setup.

    **- Bootstrap servers**

    A comma-separated list of Kafka network addresses with port numbers. These servers act as the entry point for TheHive to connect to your Kafka cluster.

6. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)