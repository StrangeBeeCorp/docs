# How to Configure the Mattermost Notifier

This topic provides step-by-step instructions for configuring the Mattermost [notifier](../about-notifications.md#notifiers) in TheHive.

!!! note "Notifier availability"
    The Mattermost notifier is only available if the **Send notification to every user in the organization** toggle is turned off and the trigger is one of the following:  
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

## Next steps

* [Edit a Notification](edit-a-notification.md)

TheHive uses [Handlebars](https://handlebarsjs.com) to let you build templates with input data, and this can be used in most of all fields of the form:

* **Endpoint**: choose the endpoint to use
* **Username**: choose a username. Click on *add variable* if you want to use an information from the input data. This will override the default username configured in the endpoint
* **Channel**: choose the target channel on Mattermost to send data to. Click on *add variable* if you want to use an information from the input data. This will override the default channel configured in the endpoint
* **Template**:
    * Available format are: *JSON*, *Markdown* and *Plain text* 
    * Click *Add variable* to select a variable to insert in the template


Then click **confirm** to register this *Notifier*.