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

2. {!includes/notifications-tab-go-to.md!}

3. Select :fontawesome-solid-ellipsis-h: and then **Edit**.

4. Select the *HttpRequest* notifier.

5. In the **HttpRequest** drawer, enter the following information:

    Endpoint

    Method

    URL

    Template

    Log errors

    Headers

    Authentication type

    Proxy settings

    Do not check Certificate Authority

    Add a certificate

    Disable hostname verification

6. Select **Confirm**.

## Next steps

* [Edit a Notification](edit-a-notification.md)

