# About Alert Feeders

Alert feeders enable TheHive to retrieve data from external systems on a schedule, eliminating the need for external tools to push data.

This topic provides an overview of the scope and usage of alert feeders in TheHive.

{!includes/alert-feeders-v55.md!}

## How alert feeders work

Alert feeders allow your organization to automate data retrieval at a defined frequency from an external service through an HTTP API call. The retrieved data is then converted into alerts using [a function](../manage-functions/about-functions.md). Each alert feeder supports only one function.

Alert feeders don't perform bi-directional synchronization.

In addition to alerts, alert feeders can also generate cases and tasks

## Feeder functions

!!! tip "Feeder function examples"
    Feeder function examples are available in [a dedicated GitHub repository]().

A feeder function transforms data retrieved from the HTTP API call and converts it into the expected TheHive format to create alerts.

Don't manually create an feeder function as a standalone function, because you can't link it to an alert feeder. Instead, [create it directly within the alert feeder](create-a-feeder.md). Once created, the function is automatically added to the [functions list](../manage-functions/about-functions.md) with the type *feeder*. 

You can then modify it either [from the functions list](../manage-functions/edit-a-function.md) or [the alert feeder configuration](edit-a-feeder.md).

When you delete an alert feeder, the associated function remains. To remove the function, follow the steps in [Delete a Function](../manage-functions/delete-a-function.md).

## Authentication modes

Currently, alert feeders support the following four authentication methods:

* None
* Basic
* Key
* Bearer

## Example integrations

You can use an alert feeder to integrate any external system that exposes a public REST API with [supported authentication modes](#authentication-modes) and supports synchronous data retrieval into TheHive, including:

* Jira
* Airtable

## Permissions

{!includes/license-alert-feeders.md!}

{!includes/access-feeders.md!}

<h2>Next steps</h2>

* [Create an Alert Feeder](create-a-feeder.md)
* [Edit an Alert Feeder](edit-a-feeder.md)
* [Turn Off an Alert Feeder](turn-off-a-feeder.md)
* [Delete an Alert Feeder](delete-a-feeder.md)