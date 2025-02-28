# How to Configure the Kafka Notifier

This topic provides step-by-step instructions for configuring the Kafka [notifier](../about-notifications.md#notifiers) in TheHive.

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

!!! info "No endpoint required"
    An endpoint definition is not required to send data to a Kafka topic.

1. {!includes/organization-view-go-to.md!}

2. {!includes/notifications-tab-go-to.md!}

3. Select :fontawesome-solid-ellipsis-h: and then **Edit**.

4. Select the *Kafka* notifier.

5. In the **Kafka** drawer, enter the following information:

  **Topic**

  The Kafka topic where TheHive will publish messages. This must match an existing topic in your Kafka setup.

  **Bootstrap servers**

  A comma-separated list of Kafka network addresses with port numbers. These servers act as the entry point for TheHive to connect to your Kafka cluster.

6. Select **Confirm**.

## Next steps

* [Edit a Notification](edit-a-notification.md)