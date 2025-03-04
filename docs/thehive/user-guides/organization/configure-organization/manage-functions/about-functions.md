# About Functions

A function in TheHive is a custom JavaScript code block that runs within the platform. It accepts inputs from external sources, processes data, and interacts with TheHive's API to integrate external applications into its workflow.

For example, you can use a function to create alerts within TheHive without requiring an additional Python service for data conversion.

!!! note "Available from version 5.1"
    TheHive supports functions starting from version 5.1.

!!! info "Contribute!"
    All function use cases are available in [a dedicated GitHub repository](). You can contribute by sharing functions you’ve written.

This topic provides details on the different types and uses of functions in TheHive.

## Trigger sources

Various sources can trigger functions in TheHive:

* User actions in TheHive: Triggered by specific actions performed within TheHive

* Automation: Triggered to automate manual or repetitive tasks, either on a schedule or based on predefined conditions

* Notifications: Triggered by an event in TheHive that generates a notification

* External systems (push method): Triggered when an external system, such as a detection tool, pushes data to TheHive

* External systems (pull method): Triggered when TheHive retrieves data from an external system using an [alert feeder](../manage-alert-feeders/about-alert-feeders.md)

## Common use cases

You can use functions in TheHive to automate workflows, process data, and enhance case management.

Below are some common use cases, each with a link to the corresponding JavaScript function code:

### User actions

* Detecting whether a case is a false positive and, if so, automatically closing its associated tasks and setting its status to *False positive*: [Code]()

### Automation

* Identifying cold cases by adding a tag based on predefined conditions: [Code]()
* Deleting IPs in observables as part of automated cleanup: [Code]()
* Closing duplicated alerts based on alert titles and observables: [Code]()

### Notifications

* Automatically assigning high/critical severity alerts to a designated user upon creation via a notification: [Code]()

### External systems (push method)

* Processing data from external systems to enrich or transform information: [Code]()
* Creating alerts from detection tools while applying data transformations: [Code]()
* Ingesting Splunk alerts and converting them into TheHive alerts: [Code]()

### External systems (pull method)

* Creating alerts from an Airtable database via an [alert feeder](../manage-alert-feeders/about-alert-feeders.md) while applying data transformations: [Code]()

## Function types

The function type defines the scope in which you can execute the function.

!!! note "Multiple types allowed"
    A function can have one or multiple types.

Below are the different types of functions supported in TheHive:

* **API**: An external service triggers these functions through TheHive's public API, enabling automated workflows from outside the platform. You can find a list of available objects in the [Functions API Objects](functions-api-objects.md) topic. To execute the function, you must first [revoke it via an HTTP call](revoke-a-function.md).

* **Notification**: [These functions act as notifiers](../manage-notifications/notifiers/function.md) and trigger when specific events occur, such as alerts or case updates. They automate the notification process based on predefined conditions.

* **Action: Case**: Users manually trigger these functions within the context of a specific case. To execute the function, they must [run it manually](run-a-function-case-alert.md).

* **Action: Alert**: Users manually trigger these functions within the context of a specific alert. To execute the function, they must [run it manually](run-a-function-case-alert.md).

* **Feeder**: You should not manually create functions of the feeder type. Instead, [create an alert feeder with a function](../manage-alert-feeders/create-an-alert-feeder.md). The function will be automatically added to the list of feeder functions. From there, you can update it, and any changes will be reflected in the alert feeder.

## Function modes

A function in TheHive can operate in one of three modes:

* **Enabled**: The function executes normally when triggered.
* **Disabled**: The function doesn't execute when triggered.
* **Dry-run**: The function runs, but it doesn't create or modify cases, alerts, or other entities in TheHive. Instead, creation attempts return `null`, making this mode ideal for testing integrations before going live.

## Permissions

{!includes/access-functions.md!}

## Next steps

* [Create a Function](create-a-function.md)
* [Edit a Function](edit-a-function.md)
* [Revoke a Function](revoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)
* [Delete a Function](delete-a-function.md)