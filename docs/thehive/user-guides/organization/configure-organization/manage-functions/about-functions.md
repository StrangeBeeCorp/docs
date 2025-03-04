# About Functions

A function in TheHive is a custom JavaScript code block that runs within the platform. It accepts inputs from external sources, processes data, and interacts with TheHive's APIs to integrate external applications into its workflow.

For example, you can use a function to create alerts within TheHive without requiring an additional Python service for data conversion.

!!! note "Available from version 5.1"
    Functions are supported in TheHive starting from version 5.1.

!!! info "Contribute!"
    All function use cases are available in [a dedicated GitHub repository](). You can contribute by sharing functions you’ve written.

This topic provides details on the different types and uses of functions in TheHive.

## Trigger sources

Functions in TheHive can be triggered from various sources:

* User actions in TheHive: Triggered by specific actions performed within TheHive

* Automation: Triggered to automate manual or repetitive tasks, either on a schedule or based on predefined conditions

* Notifications: Triggered by an event in TheHive that generates a notification

* External systems (push method): Triggered when an external system, such as a detection tool, pushes data to TheHive

* External systems (pull method): Triggered when TheHive retrieves data from an external system using the Alert Feeder

## Common use cases

Functions in TheHive can be used for various purposes to automate workflows, process data, and enhance case management.

Below are some common use cases, each with a link to the corresponding JavaScript function code:

### User actions

* Detecting whether a case is a false positive and, if so, automatically closing its associated tasks and setting its status to *False positive*: [Code]()

### Automation

* Identifying cold cases by addind a tag based on predefined conditions: [Code]()
* Deleting IPs in observables as part of automated cleanup: [Code]()
* Closing duplicated alerts based on alert titles and observables: [Code]()

### Notifications

* Automatically assigning high/critical severity alerts to a designated user upon creation via a notification: [Code]()

### External systems (push method)

* Processing data from external systems to enrich or transform information: [Code]()
* Creating alerts from detection tools while applying data transformations: [Code]()
* Ingesting Splunk alerts and converting them into TheHive alerts: [Code]()

### External systems (pull method)

* Creating alerts from an Airtable database via the Alert Feeder while applying data transformations: [Code]()

## Function types

The function type determines the scope in which the function can be executed.

!!! note "Multiple types allowed"
    A function can have one or multiple types.

Below are the different types of functions supported in TheHive:

* **API**: These functions are triggered by an external service through TheHive's public API, allowing automated workflows initiated from outside the platform. You can find a list of available objects in the [Functions API Objects](functions-api-objects.md) topic. To be executed, the function must be [revoked via an HTTP call](revoke-a-function.md).

* **Notification**: [These functions act as notifiers](../manage-notifications/notifiers/function.md) and are triggered when certain events occur, such as alerts or case updates, automating the notification process based on predefined conditions.

* **Action: Case**: These functions are manually triggered within the context of a specific case, allowing users to perform actions related to case management. To be executed, the function must be [manually run by users](run-a-function-case-alert.md).

* **Action: Alert**: These functions are manually triggered within the context of an alert, enabling users to process and act on alerts within TheHive. To be executed, the function must be [manually run by users](run-a-function-case-alert.md).

## Function modes

A function in TheHive can operate in one of three modes:

* **Enabled**: The function executes normally when triggered.
* **Disabled**: The function does not execute when triggered.
* **Dry-run**: The function runs, but it does not create or modify cases, alerts, or other entities in TheHive. Instead, creation attempts return `null`, making this mode ideal for testing integrations before going live.

## Permissions

{!includes/access-functions.md!}

## Next steps

* [Create a Function](create-a-function.md)
* [Edit a Function](edit-a-function.md)
* [Revoke a Function](revoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)
* [Delete a Function](delete-a-function.md)