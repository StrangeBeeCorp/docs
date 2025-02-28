# About Notifications

A notification is a mechanism that allows automated actions to be triggered when specific events occur.

This topic explains the different notification capabilities in TheHive.

## Key components

A notification consists of two key components:

* [Trigger](#triggers): Defines the event that activates the notification (for example, case creation, task assignment, alert import).
* [Notifier](#notifiers): Specifies the action taken when the notification is triggered (for example, sending an email, making an HTTP request, posting to Slack or Mattermost).

!!! warning "One trigger, multiple notifiers"
    A notification can have only one trigger but multiple notifiers.

### Triggers

Each notification is associated with only one trigger.

TheHive provides several predefined triggers for [cases](../../../analyst-corner/cases/about-cases.md), [alerts](../../../analyst-corner/alerts/about-alerts.md), [tasks](../../../analyst-corner/tasks/about-tasks.md), [observables](../../../analyst-corner/alerts/alerts-description/view-observables.md), [actions](../../../analyst-corner/cases/cases-description/run-responders.md), and [jobs](../../../analyst-corner/cases/cases-description/run-analyzers.md). Additionally, custom triggers can be created using *FilteredEvent*.

The *AnyEvent* trigger allows notifications to be executed for any event in TheHive.

#### Triggers on cases

* *CaseClosed*: Triggered when [a case is closed](../../../analyst-corner/cases/cases-description/actions.md#close)
* *CaseCreated*: Triggered when [a new case is created](../../../analyst-corner/cases/create-a-new-case.md)
* *CaseFlagged*: Triggered when [a case is flagged](../../../analyst-corner/cases/cases-description/actions.md#flagunflag)
* *CaseShared*: Triggered when [a case is shared](../../../analyst-corner/cases/share-a-case.md)

#### Triggers on alerts

* *AlertAssigned*: Triggered when an alert is assigned to a user
* *AlertClosed*: Triggered when [an alert is closed](../../../analyst-corner/alerts/alerts-description/actions.md#close)
* *AlertCreated*: Triggered when [a new alert is created](../../../analyst-corner/alerts/about-alerts.md#sources)
* *AlertImported*: Triggered when an alert is imported, meaning [a case is created from an alert](../../../analyst-corner/cases/create-a-new-case.md#create-a-case-from-an-alert) or [an alert is merged into an existing case](../../../analyst-corner/alerts/alerts-description/merge-alerts.md)

#### Triggers on observables

* *AlertObservableCreated*: Triggered when an observable is created within an alert
* *CaseObservableCreated*: Triggered when an observable is created within a case
* *ObservableCreated*: Triggered when an observable is created, regardless of whether it belongs to an alert or a case

#### Triggers on tasks

* *LoginMyTask*: Triggered when [a new log is added to a task](../../../analyst-corner/tasks/preview-task-details/create-a-task-log.md)
* *TaskAssigned*: Triggered when a task is assigned to a user or the assignee is updated
* *TaskClosed*: Triggered when a task is closed
* *TaskMandatory*: Triggered when a task is made mandatory

#### Triggers on jobs

* **JobFinished**: Triggered when an analyzer job is completed, whether it succeeds or fails

#### Triggers on actions

* **ActionFinished**: Triggered when a responder action is completed, whether it succeeds or fails

#### FilteredEvent

When you select *FilteredEvent*, TheHive allows you to define a structured JSON filter. This filter is used to match specific events in TheHive.

Learn how to create filtered events and explore examples in the [How to Write a Filtered Event Trigger](./filtered-event-trigger.md) topic.

### Notifiers

Several types of notifiers are available in TheHive:

* *EmailerToUser*: Sends an email to all [users in the current organization](./email-to-users.md)
* *EmailerToAddr*: Sends an email to [a specific email address](./email-to-addr.md)
* *HttpRequest*: Sends data to a specified [HTTP endpoint](./http-request.md)
* *Mattermost*: Sends data to a selected [Mattermost endpoint](./mattermost.md)
* *Slack*: Sends data to a selected [Slack endpoint](./slack.md)
* *Teams*: Sends data to a selected [Microsoft Teams endpoint](./teams.md)
* *Webhook*: Sends data to a chosen [webhook endpoint](./webhook.md)
* *Kafka*: Sends data to a specified [Kafka queue](./kafka.md)
* *Redis*: Sends data to a selected [Redis endpoint](./redis.md)
* *RunAnalyzer*: Executes a selected [analyzer](./analyzers.md)
* *RunResponder*: Executes a selected [responder](./responders.md)
* *Function*: Run a specified [function](../manage-functions/about-functions.md)

!!! warning "Endpoints required"
    Some notifiers require at least one defined endpoint. Refer to the dedicated page for each notifier to learn how to create the necessary endpoints.

## Permissions

{!includes/access-notifications.md!}

## Next steps* [Turn Off a Notification](turn-off-a-notification.md)

* [Create a Notification](create-a-notification.md)
* [Edit a Notification](edit-a-notification.md)
* [Turn Off a Notification](turn-off-a-notification.md)
* [Delete a Notification](delete-a-notification.md)