# Configure the HttpRequest Notifier

<!-- md:license Platinum -->

This topic provides step-by-step instructions for configuring the *HttpRequest* [notifier](../about-notifications.md#notifiers) in TheHive.

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

{% include-markdown "includes/access-notifications.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

    ---

2. {% include-markdown "includes/notifications-tab-go-to.md" %}

    ---

3. Select :fontawesome-solid-ellipsis: and then **Edit**.

    ---

4. Select the **HttpRequest** notifier.

    ---

5. In the **HttpRequest** drawer, enter the following information:

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
    
    {% include-markdown "includes/templates-notifications-helpers.md" %}

    ---

6. Turn on the **Log errors** toggle if you want to capture and track any errors that occur when sending the HTTP request.

    ---

7. {% include-markdown "includes/headers.md" %}

    ---

8. {% include-markdown "includes/authentication-type.md" %}

    ---

9. {% include-markdown "includes/proxy-settings.md" %}

    ---

10. {% include-markdown "includes/certificate-authority.md" %}

    ---

11. {% include-markdown "includes/host-name-verification.md" %}

    ---

12. Select **Confirm**.

<h2>Next steps</h2>

* [Turn Off a Notification](../turn-off-a-notification.md)
* [Delete a Notification](../delete-a-notification.md)

