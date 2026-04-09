# About Alert Feeders

<!-- md:version 5.5 --> <!-- md:license Platinum -->

Alert feeders enable TheHive to retrieve data from external systems on a schedule, eliminating the need for external tools to push data.

## How alert feeders work

Alert feeders automate data retrieval at defined frequencies from external services through HTTP API calls. The retrieved data is converted into alerts using [feeder functions](#feeder-functions). Each alert feeder supports only one function.

Alert feeders perform unidirectional data retrieval only. In addition to alerts, alert feeders can generate cases and tasks.

## Feeder functions

!!! tip "Feeder function examples"
    Feeder function examples are available in [a dedicated GitHub repository](https://github.com/StrangeBeeCorp/integrations/tree/main/.generated/docs/functions){target=_blank}.

Feeder functions transform data retrieved from HTTP API calls into the expected TheHive format for alert creation.

Feeder functions must be [created directly within the alert feeder](create-a-feeder.md) rather than as standalone functions, as standalone functions can't link to alert feeders. After creation, the function automatically appears in the [functions list](../manage-functions/about-functions.md) with the type *feeder*.

Functions can be modified either [from the functions list](../manage-functions/about-functions.md) or within the alert feeder configuration.

Deleting an alert feeder doesn't remove its associated function. Function removal requires following the steps in [Delete a Function](../manage-functions/delete-a-function.md).

## Authentication modes

Alert feeders currently support five authentication methods:

* None – No authentication is applied.
* Basic – Uses HTTP Basic authentication (username and password) in the `Authorization` header.
* Key – Uses an API key included in the request.
* Bearer – Uses a bearer token in the `Authorization` header.
* <!-- md:version 5.7 --> OAuth 2.0 (client credentials) – Uses OAuth 2.0 with the client credentials grant type.

## Example integrations

Use an alert feeder to integrate any external system that exposes a public REST API with [supported authentication modes](#authentication-modes) and supports synchronous data retrieval into TheHive, including:

* [Jira](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/jira-alertfromjira.md){target=_blank}
* [Airtable](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/airtable-alertfromairtable.md){target=_blank}

## Permissions

Only users with the `manageConfig` permission can manage alert feeders in TheHive.

<h2>Next steps</h2>

* [Create an Alert Feeder](create-a-feeder.md)
* [Turn Off an Alert Feeder](turn-off-a-feeder.md)
* [Delete an Alert Feeder](delete-a-feeder.md)