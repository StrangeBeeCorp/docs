# About Functions

<!-- md:version 5.1 --> <!-- md:license Platinum -->

A function in TheHive is a controlled JavaScript code block that must be written within TheHive interface and runs securely within the platform. This code operates on a restricted set of predefined features, ensuring that it can't access the full JavaScript language or execute arbitrary code outside the platform's security boundaries.

It accepts inputs from external sources, processes data, and interacts with TheHive API to integrate external applications into its workflow.

For example, use a function to create alerts within TheHive without requiring an additional Python service for data conversion.

!!! tip "Contribute!"
    Examples of function use cases are available in [a dedicated GitHub repository](https://github.com/StrangeBeeCorp/integrations/tree/main/.generated/docs/functions){target=_blank}. Contributions are welcome!

## Function endpoints

Creating a function in TheHive automatically adds a new public endpoint to TheHive public API, making it easy to call from an external system.

## Function objects

Functions have access to a set of predefined objects that expose methods for interacting with cases, alerts, tasks, observables, and other entities.

Examples include:

* `alert.create(input: InputCreateAlert): OutputAlert`: Creates a new alert.
* `alert.update(alertId: string, input: InputUpdateAlert): OutputAlert`: Updates an alert.
* `observable.createInCase(caseId: string, input: InputObservable): OutputObservable`: Creates an observable within a case.
* `log.create(taskId: string, input: InputCreateLog): OutputLog`: Creates a log entry for a task.

For a complete list of available objects and their methods, see [Functions Objects](functions-objects.md).

## Trigger sources

Various sources can trigger functions in TheHive:

* User actions in TheHive: Triggered by specific actions performed within TheHive

* Automation: Triggered to automate manual or repetitive tasks, either on a schedule or based on predefined conditions

* Notifications: Triggered by an event in TheHive that generates a notification

* External systems (push method): Triggered when an external system, such as a detection tool, pushes data to TheHive

* <!-- md:version 5.5 --> External systems (pull method): Triggered when TheHive retrieves data from an external system using an [alert feeder](../manage-feeders/about-feeders.md)

## Common use cases

Functions in TheHive automate workflows, process data, and enhance case management.

Below are some common use cases, each with a link to the corresponding JavaScript function:

### User actions

* Deleting observables of type IP from an alert: [Code](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/deleteipobsfromalert.md){target=_blank}
* Changing the assignee of a case and all its associated tasks to the user who runs the function: [Code](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/assigntome.md){target=_blank}

### Automation

Identifying *New* and *In progress* cases that haven't been updated in the last month and tagging them with *cold-case*: [Code](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/coldcaseautomation.md){target=_blank}

### Notifications

* Assigning high or critical alerts to a specific user when they're created via a notification: [Code](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/assignalert.md){target=_blank}
* Updating the status of alerts merged into a case that was closed via a notification: [Code](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/changeimportedalertstatus.md){target=_blank}

### External systems (push method)

Ingesting Splunk alerts and converting them into TheHive alerts: [Code](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/splunk-createalertfromsplunk.md){target=_blank}

### External systems (pull method)

<!-- md:version 5.5 --> 

* Creating alerts from an Airtable database via an [alert feeder](../manage-feeders/about-feeders.md) while applying data transformations: [Code](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/airtable-alertfromairtable.md){target=_blank}
* Creating alerts from Jira via an [alert feeder](../manage-feeders/about-feeders.md) while applying data transformations: [Code](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/jira-alertfromjira.md){target=_blank}

## Function types

The function type defines the scope in which the function can execute.

!!! note "Multiple types allowed"
    A function can have one or multiple types.

Below are the different types of functions supported in TheHive:

* **API**: An external service triggers these functions through TheHive public API, enabling automated workflows from outside the platform. Execute the function by [invoking it via an HTTP call](invoke-a-function.md).

* **Notification**: [These functions act as notifiers](../manage-notifications/notifiers/function.md) and trigger when specific events occur, such as alerts or case updates. They automate the notification process based on predefined conditions.

* **Action: Case**: Trigger these functions manually within the context of a specific case. Execute the function by [running it manually](run-a-function-case-alert.md).

* **Action: Alert**: Trigger these functions manually within the context of a specific alert. Execute the function by [running it manually](run-a-function-case-alert.md).

* <!-- md:version 5.5 --> **Feeder**: A feeder function transforms data retrieved from the HTTP API call and converts it into the expected TheHive format to create alerts. Avoid manually creating functions of the *feeder* type. Instead, [create an alert feeder with a function](../manage-feeders/create-a-feeder.md). The function automatically appears in the functions list. Updates to the function reflect in the alert feeder, and changes in the alert feeder update the function accordingly.

## Function modes

A function in TheHive can operate in one of three modes:

* **Enabled**: The function executes normally when triggered.
* **Disabled**: The function doesn't execute when triggered.
* **Dry-run**: The function runs, but it doesn't create or modify cases, alerts, or other entities in TheHive. Instead, creation attempts return `null`, making this mode ideal for testing integrations before going live.

## Permissions

* Only users with the `manageFunction/create` permission can create a function in TheHive.
* Only users with the `manageFunction/invoke` permission can invoke a function in TheHive.
* Only users with the `manageAction` permission can run a function in TheHive.

<h2>Next steps</h2>

* [Create a Function](create-a-function.md)
* [Invoke a Function](invoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)
* [Delete a Function](delete-a-function.md)