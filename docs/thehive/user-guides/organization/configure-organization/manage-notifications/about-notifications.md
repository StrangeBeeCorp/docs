# About Notifications

A notification triggers automated actions when specific events occur within an organization.

This topic explains the different notification capabilities in TheHive.

## Key components

A notification consists of two key components:

!!! warning "One trigger, multiple notifiers"
    A notification can have only one trigger but multiple notifiers.

* A [trigger](#triggers): Defines the event that activates the notification, such as case creation, task assignment, or alert import.
* One or more [notifiers](#notifiers): Specify the action taken when the notification is triggered, such as sending an email, making an HTTP request, or posting to Slack or Mattermost.

### Triggers

Associate each notification with only one trigger.

TheHive provides several predefined triggers for [cases](#triggers-on-cases), [alerts](#triggers-on-alerts), [tasks](#triggers-on-tasks), [observables](#triggers-on-observables), [jobs](#triggers-on-jobs), and [actions](#triggers-on-actions). Additionally, create custom triggers using [*FilteredEvent*](write-filtered-event-trigger.md).

Use the *AnyEvent* trigger to execute notifications for any event in TheHive.

#### Triggers on cases

* *CaseClosed*: Triggered when a case is closed
* *CaseCreated*: Triggered when a new case is created
* *CaseFlagged*: Triggered when a case is flagged
* *CaseShared*: Triggered when a case is shared

#### Triggers on alerts

* *AlertAssigned*: Triggered when an alert is assigned to a user
* *AlertClosed*: Triggered when an alert is closed
* *AlertCreated*: Triggered when a new alert is created
* *AlertImported*: Triggered when an alert is imported—either by merging it into a new case or into an existing one

#### Triggers on observables

* *AlertObservableCreated*: Triggered when an observable is created within an alert
* *CaseObservableCreated*: Triggered when an observable is created within a case
* *ObservableCreated*: Triggered when an observable is created, regardless of whether it belongs to an alert or a case

#### Triggers on tasks

* *LoginMyTask*: Triggered when a new log is added to a task
* *TaskAssigned*: Triggered when a task is assigned to a user or the assignee is updated
* *TaskClosed*: Triggered when a task is closed
* *TaskMandatory*: Triggered when a task is made mandatory

#### Triggers on jobs

* *JobFinished*: Triggered when an analyzer job is completed, whether it succeeds or fails

#### Triggers on actions

* *ActionFinished*: Triggered when a responder action is completed, whether it succeeds or fails

#### FilteredEvent

When you select *FilteredEvent*, TheHive allows you to define a structured JSON filter. This filter is used to match specific events in TheHive.

Learn how to create filtered events and explore examples in the [Write a Filtered Event Trigger](./write-filtered-event-trigger.md) topic.

### Notifiers

Several types of notifiers are available in TheHive:

* *EmailerToUser*: Sends an email to all [users in the current organization](./notifiers/email-to-users.md)
* *EmailerToAddr*: Sends an email to [a specific email address](./notifiers/email-to-addr.md)
* *HttpRequest*: Sends data to a specified [HTTP endpoint](./notifiers/http-request.md)
* *Mattermost*: Sends data to a selected [Mattermost endpoint](./notifiers/mattermost.md)
* *Slack*: Sends data to a selected [Slack endpoint](./notifiers/slack.md)
* *Teams*: Sends data to a selected [Microsoft Teams endpoint](./notifiers/teams.md)
* *Webhook*: Sends data to a chosen [webhook endpoint](./notifiers/webhook.md)
* *Kafka*: Sends data to a specified [Kafka queue](./notifiers/kafka.md)
* *Redis*: Sends data to a selected [Redis channel](./notifiers/redis.md)
* *RunAnalyzer*: Executes a selected [analyzer](./notifiers/analyzers.md)
* *RunResponder*: Executes a selected [responder](./notifiers/responders.md)
* *Function*: Run a specified [function](./notifiers/function.md)

!!! warning "Endpoints required"
    Some notifiers require at least one defined endpoint. Endpoints can be local, defined at the organization level, or [global](../../../../administration/add-a-global-endpoint.md), defined at the client level for one or more organizations. Refer to the dedicated page for each notifier to learn how to create the necessary local endpoints.

## Permissions

{!includes/access-notifications.md!}

<h2>Next steps</h2>

* [Create a Notification](create-a-notification.md)
* [Turn Off a Notification](turn-off-a-notification.md)
* [Delete a Notification](delete-a-notification.md)