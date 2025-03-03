# How to Configure the EmailerToAddr Notifier

This topic provides step-by-step instructions for configuring the EmailerToAddr [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The EmailerToAddr notifier is only available if the **Send notification to every user in the organization** toggle is turned off and the trigger is one of the following:  
    - *AnyEvent*  
    - *FilteredEvent*  
    - *CaseClosed*  
    - *CaseCreated*  
    - *CaseFlagged*  
    - *CaseShared*  
    - *AlertClosed*  
    - *AlertCreated*  
    - *AlertImported*  
    - *TaskClosed*  
    - *TaskMandatory*

{!includes/access-notifications.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

2. {!includes/notifications-tab-go-to.md!}

3. Select :fontawesome-solid-ellipsis-h: and then **Edit**.

4. Select the *EmailerToAddr* notifier.

5. In the **EmailerToAddr** drawer, enter the following information:

    !!! note "Available variables"
        You can use variables in each field by selecting **Add variable**. 

    **- Subject**

    The email subject line.

    **- From**

    The sender's email address.

    **- Template**

    The email template used for the message. If you select the HTML format, you must write the full HTML syntax.

6. Select **Confirm**.

## Next steps

* [Edit a Notification](../edit-a-notification.md)