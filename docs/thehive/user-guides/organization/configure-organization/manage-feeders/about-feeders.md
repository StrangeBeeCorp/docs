# About Alert Feeders

<!-- md:version 5.5 --> <!-- md:license Platinum -->

Alert feeders enable TheHive to retrieve data from external systems on a schedule, eliminating the need for external tools to push data.

## How alert feeders work

Alert feeders allow an organization to automate data retrieval at a defined frequency from an external service through an HTTP API call. The retrieved data is then converted into alerts using [a function](#feeder-functions). Each alert feeder supports only one function.

Alert feeders don't perform bi-directional synchronization.

In addition to alerts, alert feeders can also generate cases and tasks

## Feeder functions

!!! tip "Feeder function examples"
    Feeder function examples are available in [a dedicated GitHub repository](https://github.com/StrangeBeeCorp/thehive-templates/tree/main/Functions%20Examples/Alert%20Feeder%20Functions){target=_blank}.

A feeder function transforms data retrieved from the HTTP API call and converts it into the expected TheHive format to create alerts.

Avoid creating a feeder function as a standalone function, as it can't link to an alert feeder. Instead, [create it directly within the alert feeder](create-a-feeder.md). After creation, the function automatically appears in the [functions list](../manage-functions/about-functions.md) with the type *feeder*. 

Modify the function either [from the functions list](../manage-functions/about-functions.md) or within the alert feeder configuration.

Deleting an alert feeder doesn't remove its associated function. To remove the function, follow the steps in [Delete a Function](../manage-functions/delete-a-function.md).

## Authentication modes

Currently, alert feeders support the following four authentication methods:

* None
* Basic
* Key
* Bearer

## Example integrations

Use an alert feeder to integrate any external system that exposes a public REST API with [supported authentication modes](#authentication-modes) and supports synchronous data retrieval into TheHive, including:

* Jira
* Airtable

## Permissions

Only users with the `manageConfig` permission can manage alert feeders in TheHive.

<h2>Next steps</h2>

* [Create an Alert Feeder](create-a-feeder.md)
* [Turn Off an Alert Feeder](turn-off-a-feeder.md)
* [Delete an Alert Feeder](delete-a-feeder.md)