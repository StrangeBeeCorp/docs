# Notifications


## Definition

A notification is a described by:

1. A *Trigger*
2. One or more *Notifiers*

<figure markdown>
  ![Notification](../../../images/user-guides/organization/notifications/organization-notifications-introduction.png){ width="450" }
</figure>


### Triggers

Each notification is associated to *only* one trigger. TheHive comes with several predefined triggers on *Cases*, *Alerts*, *Tasks*, *Observables* and *Jobs*. Custom triggers can also be defined with *FilteredEvent*.

Another trigger let you run notifications on **any** event when selecting *AnyEvents*.


##### Triggers on Cases

* **CaseClosed**: Run an action when closing a *Case*
* **CaseCreated**: Run an action when a *Case* is created
* **CaseShared**: Run an action when a *Case* is shared


##### Triggers on Alerts

* **AlertCreated**: Run an action when an *Alert* is created
* **AlertImported**: Run an action when an *Alert* in imported (*a Case is created from an Alert or an Alert is attached to an existing Case*)


##### Triggers on Jobs

* **JobFinished**: Run an action when a *Job* is terminated, with *success* or *failure*


##### Triggers on Observables

* **ObservableCreated**: Run an action when an *Observable* is created


##### Triggers on Tasks

* **LoginMyTask**: Run an action when a *Task* gain a new *Log*
* **TaskAssigned**: Run an action when a *Task* is assigned, or the assignee is updated
* **TaskClosed**: Run an action when a *Task* is closed


##### Filtered Event

When selecting *FilteredEvent*, TheHive lets you write a structured JSON filter. This filter aims to match particular events in the application that will trigger one or more actions described by *notifiers*.

<figure markdown>
  ![Filtered Event](../../../images/user-guides/organization/notifications/organization-notifications-filteredevent.png){ width="500" }
  <figcaption>Filtered event example: "Case severity has been updated to Hight or Critical</figcaption>
</figure>

Learn how to write filtered events and find more example in the [dedicated page](./filteredevents.md).


### Notifiers

Several types of *Notifiers* are available in TheHive:

* **EmailToUser**: send an email to *all* [users in the current organization](./email-to-users.md)
* **EmailToAddr**: send an email to [a specific email address](./email-to-addr.md)
* **HTTP Request**: send data to a chosen [HTTP endpoint](./http-request.md)
* **Mattermost**: send data to a chosen [Mattermost endoint](./mattermost.md)
* **Slack**: send data to a chosen [Slack endpoint](./slack.md)
* **MS Teams**: send data to a chosen [Microsoft Teams endpoint](./teams.md)
* **Webhook**: send data to a chosen [webhook endpoint](./webhook.md)
* **Kafka**: send data to a chosen [Kafka queue](./kafka.md)
* **Redis**: send data to a chosen [Redis endpoint](./redis.md)

Two of them are dedicated to run Cortex Analyzers and Responders:

* **RunAnalyzer**: run [selected Analyzers](./analyzers.md)
* **RunResponder**: run [selected Responders](./responders.md)

!!! Info "Some *Notifiers* require configuring *Endpoints*"
    Some *Notifiers* require at least one *endpoint* to be defined. Refer to the page dedicated to each *Notifier* to learn how to create related endpoints.


## Create a *Notification*
Access to the Notifications list by opening the *Organization* menu, and the *Notifications* tab.

<figure markdown>
  ![Notifications list](../../../images/user-guides/organization/notifications/organization-notifications.png){ width="500" }
</figure>

Click the :fontawesome-regular-square-plus: button to add a notification.

<figure markdown>
  ![Create a notification](../../../images/user-guides/organization/notifications/organization-notifications-create.png){ width="500" }
</figure>


1. Give a unique name to the notification
2. Select a trigger
3. Select a notifier and configure it

Then click **confirm** to register the notification.


## Operations on *Notifications*

### Delete a *Notification*

In the list of notification, click on the **delete** option:

<figure markdown>
  ![Delete a notification](../../../images/user-guides/organization/notifications/organization-notifications-delete.png){ width="500" }
</figure>

### Disable a *Notificaiton*

* In the list of *Notifications*, edit the one to disable: 

<figure markdown>
  ![Disable a notification](../../../images/user-guides/organization/notifications/organization-notifications-delete.png){ width="500" }
</figure>

* Verify the result in the list of *Notifications*

<figure markdown>
  ![Disabled notification](../../../images/user-guides/organization/notifications/organization-notifications-disabled.png){ width="500" }
</figure>