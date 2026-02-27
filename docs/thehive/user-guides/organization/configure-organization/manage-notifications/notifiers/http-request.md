# Configure the HttpRequest Notifier

<!-- md:permission `manageConfig` --> <!-- md:license Platinum -->

Configure the *HttpRequest* [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The *HttpRequest* notifier is available only when you turn off the **Send notification to every user in the organization** toggle and use one of the following triggers:

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

1. When [creating a new notification](../create-a-notification.md) or editing an existing one, select the **HttpRequest** notifier.

    ---

2. In the **HttpRequest** drawer, enter the following information:

    **- Endpoint \***

    Using HttpRequest as a notifier requires at least one endpoint.

    Select an existing endpoint. Endpoints can be local, defined at the organization level, or [global](../../../../../administration/add-a-global-endpoint.md), defined at the client level for one or more organizations. You can add a new local endpoint by selecting [**Add a new endpoint**](../../manage-endpoints/add-http-request-endpoint.md).

    **- Method \***

    Select an HTTP method from the dropdown list.

    **- URL \***

    Enter a valid URL.

    **- Template \***

    Enter the payload to be sent to the HTTP endpoint. Select JSON, XML, or plain text based on what your external system requirements.

    {% include-markdown "includes/notifications-variables.md" %}
    
    {% include-markdown "includes/templates-helpers.md" %}

    ---

3. Turn on the **Log errors** toggle if you want to capture and track any errors that occur when sending the HTTP request.

    ---

4. {% include-markdown "includes/headers.md" %}

    ---

5. {% include-markdown "includes/authentication-type.md" %}

    ---

6. {% include-markdown "includes/proxy-settings.md" %}

    ---

7. {% include-markdown "includes/certificate-authority.md" %}

    ---

8. {% include-markdown "includes/host-name-verification.md" %}

    ---

9. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)

