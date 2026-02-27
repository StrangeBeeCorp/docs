# Configure the Redis Notifier

<!-- md:permission `manageConfig` --> <!-- md:license Platinum -->

Configure the *Redis* [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The *Redis* notifier is available only when you turn off the **Send notification to every user in the organization** toggle and use one of the following triggers:

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
    An endpoint definition isn't required to send data to a Redis database.

1. When [creating a new notification](../create-a-notification.md) or editing an existing one, select the **Redis** notifier.

    ---

2. In the **Redis** drawer, enter the following information:

    **- Channel \***

    The Redis channel where you want to publish the data.

    **- Host \***

    The Redis server address. This is where TheHive will send data.

    **- Port \***

    The port number Redis is listening on.

    **- Username**

    The username for authentication if Redis Access Control Lists (ACLs) are enabled.

    **- Password**

    The password for authentication if Redis requires authentication.

    **- Database**

    The Redis database index to use. Redis allows multiple logical databases, and this field lets you specify which one to use.
    
    {% include-markdown "includes/notifications-variables.md" %}
    
    {% include-markdown "includes/templates-helpers.md" %}

    ---

3. Turn on the **Enable SSL** toggle to encrypt the connection and secure data transmission between TheHive and the Redis server.

    {% include-markdown "includes/certificate-authority.md" %}

    {% include-markdown "includes/host-name-verification.md" %}

    ---

4. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)