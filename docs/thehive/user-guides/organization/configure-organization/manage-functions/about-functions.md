# About Functions

<!-- md:version 5.1 --> <!-- md:license Platinum -->

A function in TheHive is a controlled JavaScript code block that must be written within TheHive’s interface and runs securely within the platform. This code operates on a restricted set of predefined features, ensuring that it can't access the full JavaScript language or execute arbitrary code outside the platform's security boundaries.

It accepts inputs from external sources, processes data, and interacts with TheHive's API to integrate external applications into its workflow.

For example, you can use a function to create alerts within TheHive without requiring an additional Python service for data conversion.

!!! tip "Contribute!"
    Examples of function use cases are available in [a dedicated GitHub repository](https://github.com/StrangeBeeCorp/thehive-templates/tree/main/Functions%20Examples). You can contribute by sharing functions you’ve written.

This topic provides details on the different types and uses of functions in TheHive.

## Function endpoints

Creating a function in TheHive automatically adds a new public endpoint to the TheHive public API, making it easy to call from an external system.

## Trigger sources

Various sources can trigger functions in TheHive:

* User actions in TheHive: Triggered by specific actions performed within TheHive

* Automation: Triggered to automate manual or repetitive tasks, either on a schedule or based on predefined conditions

* Notifications: Triggered by an event in TheHive that generates a notification

* External systems (push method): Triggered when an external system, such as a detection tool, pushes data to TheHive

* <!-- md:version 5.5 --> External systems (pull method): Triggered when TheHive retrieves data from an external system using an [alert feeder](../manage-feeders/about-feeders.md)

## Common use cases

You can use functions in TheHive to automate workflows, process data, and enhance case management.

Below are some common use cases, each with a link to the corresponding JavaScript function:

### User actions

* Deleting observables of type IP from an alert: [Code](https://github.com/StrangeBeeCorp/thehive-templates/blob/main/Functions%20Examples/Action%20Functions/function_Action_deleteIPObsFromAlert.js)
* Changing the assignee of a case and all its associated tasks to the user who runs the function: [Code](https://github.com/StrangeBeeCorp/thehive-templates/blob/main/Functions%20Examples/Action%20Functions/function_Action_assignToMe.js)

### Automation

Identifying *New* and *In progress* cases that haven't been updated in the last month and tagging them with *cold-case*: [Code](https://github.com/StrangeBeeCorp/thehive-templates/blob/main/Functions%20Examples/API%20Functions/function_API_coldCaseAutomation.js)

### Notifications

* Assigning high or critical alerts to a specific user when they're created via a notification: [Code](https://github.com/StrangeBeeCorp/thehive-templates/blob/main/Functions%20Examples/Notifier%20Functions/function_notifier_assignAlert.js)
* Updating the status of alerts merged into a case that was closed via a notification: [Code](https://github.com/StrangeBeeCorp/thehive-templates/blob/main/Functions%20Examples/Notifier%20Functions/function_notifier_changeImportedAlertStatus.js)

### External systems (push method)

Ingesting Splunk alerts and converting them into TheHive alerts: [Code](https://github.com/StrangeBeeCorp/thehive-templates/blob/main/Functions%20Examples/API%20Functions/function_API_createAlertFromSplunk.js)

### External systems (pull method)

<!-- md:version 5.5 --> 

* Creating alerts from an Airtable database via an [alert feeder](../manage-feeders/about-feeders.md) while applying data transformations: [Code](https://github.com/StrangeBeeCorp/thehive-templates/blob/main/Functions%20Examples/Alert%20Feeder%20Functions/function_Feeder_alertFromAirtable.js)
* Creating alerts from Jira via an [alert feeder](../manage-feeders/about-feeders.md) while applying data transformations: [Code](https://github.com/StrangeBeeCorp/thehive-templates/blob/main/Functions%20Examples/Alert%20Feeder%20Functions/function_Feeder_alertFromJIRA.js)

## Function types

The function type defines the scope in which you can execute the function.

!!! note "Multiple types allowed"
    A function can have one or multiple types.

Below are the different types of functions supported in TheHive:

* **API**: An external service triggers these functions through TheHive's public API, enabling automated workflows from outside the platform. You can find a list of available objects in the [Functions Objects](functions-objects.md) topic. To execute the function, you must [revoke it via an HTTP call](revoke-a-function.md).

* **Notification**: [These functions act as notifiers](../manage-notifications/notifiers/function.md) and trigger when specific events occur, such as alerts or case updates. They automate the notification process based on predefined conditions.

* **Action: Case**: Trigger these functions manually within the context of a specific case. To execute the function, you must [run it manually](run-a-function-case-alert.md).

* **Action: Alert**: Trigger these functions manually within the context of a specific alert. To execute the function, you must [run it manually](run-a-function-case-alert.md).

* <!-- md:version 5.5 --> **Feeder**: A feeder function transforms data retrieved from the HTTP API call and converts it into the expected TheHive format to create alerts. You should not manually create functions of the feeder type. Instead, [create an alert feeder with a function](../manage-feeders/create-a-feeder.md). The function will be automatically added to the list of functions. From there, you can update it, and any changes will be reflected in the alert feeder, and vice-versa.

## Function modes

A function in TheHive can operate in one of three modes:

* **Enabled**: The function executes normally when triggered.
* **Disabled**: The function doesn't execute when triggered.
* **Dry-run**: The function runs, but it doesn't create or modify cases, alerts, or other entities in TheHive. Instead, creation attempts return `null`, making this mode ideal for testing integrations before going live.

## Permissions

{!includes/access-functions.md!}

<h2>Next steps</h2>

* [Create a Function](create-a-function.md)
* [Revoke a Function](revoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)
* [Delete a Function](delete-a-function.md)