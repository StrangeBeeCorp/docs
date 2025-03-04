# How to Configure the HttpRequest Notifier

This topic provides step-by-step instructions for configuring the HttpRequest [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The HttpRequest notifier is only available if the **Send notification to every user in the organization** toggle is turned off and the trigger is one of the following:  
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

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/notifications-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-ellipsis: and then **Edit**.

    ---

4. Select the *HttpRequest* notifier.

    ---

5. In the **HttpRequest** drawer, enter the following information:

    **- Endpoint \***

    Using HttpRequest as a notifier requires at least one endpoint.

    Select an existing endpoint. You can add a new endpoint by selecting [**Add a new endpoint**](../../manage-endpoints/add-http-request-endpoint.md).

    **- Method \***

    Select an HTTP method from the dropdown list.

    **- URL \***

    Enter a valid URL. Select **Add Variable** to dynamically insert values using available variables.

    **- Template \***

    Enter the payload to be sent to the HTTP endpoint. Select JSON, XML, or plain text based on what your external system requirements. Select **Add Variable** to dynamically insert values using available variables.

    ---

6. Turn on the **Log errors** toggle if you want to capture and track any errors that occur when sending the HTTP request.

    ---

7. Select :fontawesome-solid-plus: in the **Headers** section to add headers.

    Enter a header key and its corresponding value to include in the HTTP request. Headers can be used to send authentication tokens, content types, or other metadata required by the external system. Select **Add Variable** to dynamically insert values using available variables.

    ---

8. {!includes/authentication-type.md!}

    ---

9. {!includes/proxy-settings.md!}

    ---

10. Add a certificate authority.

    For more information about configuring SSL, refer to the [Configure SSL](../../../../../administration/authentication/ssl.md) topic.

    Only use certificates from trusted, predefined authorities for secure connections; you can't use custom certificate authorities.

    You can turn off the **Don't check certificate authority** toggle to bypass certificate validation, but this isn't recommended as it may compromise connection security.

    ---

11. {!includes/host-name-verification.md!}

    ---

12. Select **Confirm**.

## Next steps

* [Edit a Notification](../edit-a-notification.md)

