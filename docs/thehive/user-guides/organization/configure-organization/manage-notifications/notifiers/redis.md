# How to Configure the Redis Notifier

This topic provides step-by-step instructions for configuring the Redis [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The Redis notifier is available only when you turn off the **Send notification to every user in the organization** toggle and use one of the following triggers:  
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
    An endpoint definition isn't required to send data to a Redis database.

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/notifications-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-ellipsis: and then **Edit**.

    ---

4. Select the *Redis* notifier.

    ---

5. In the **Redis** drawer, enter the following information:

    **- Channel \***

    The Redis channel where you want to publish the data. Select **Add Variable** to dynamically insert values using available variables.

    **- Host \***

    The Redis server address. This is where TheHive will send data. Select **Add Variable** to dynamically insert values using available variables.

    **- Port \***

    The port number Redis is listening on.

    **- Username**

    The username for authentication if Redis Access Control Lists (ACLs) are enabled. Select **Add Variable** to dynamically insert values using available variables.

    **- Password**

    The password for authentication if Redis requires authentication.

    **- Database**

    The Redis database index to use. Redis allows multiple logical databases, and this field lets you specify which one to use.

    ---

6. Turn on the **Enable SSL** toggle to encrypt the connection and secure data transmission between TheHive and the Redis server.

    {!includes/certificate-authority.md!}

    {!includes/host-name-verification.md!}

    ---

7. Select **Confirm**.

## Next steps

* [Edit a Notification](../edit-a-notification.md)