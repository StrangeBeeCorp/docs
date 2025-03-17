# About Alert Feeders

!!! note "Available from version 5.5"
    Alert feeders are available starting from version 5.5.

Alert feeders integrate external tools with TheHive without requiring them to push data. Instead, TheHive retrieves data from external systems on a scheduled basis.

The primary goal of alert feeders is to enhance TheHive’s ingestion capabilities while minimizing reliance on external services for data retrieval.

This topic provides an overview of the scope and usage of alert feeders in TheHive.

## How alert feeders work

Alert feeders allow your organization to automate data retrieval at a defined frequency from an external service through an HTTP API call. The retrieved data is then converted into alerts using [a function](../manage-functions/about-functions.md). Each alert feeder supports only one function.

Alert feeders don't perform bi-directional synchronization.

Alert feeders can also generate cases and tasks beyond alerts.

### Alert feeder functions

!!! tip "Feeder function examples"
    Feeder function examples are available in [a dedicated GitHub repository](). You can contribute by sharing feeder functions you’ve written.

Don't manually create an alert feeder function as a standalone function, because you can't link it to an alert feeder. Instead, [create it directly within the alert feeder](create-a-feeder.md). Once created, the function is automatically added to the [functions list](../manage-functions/about-functions.md) with the type *feeder*. 

You can then modify it either [from the functions list](../manage-functions/edit-a-function.md) or [the alert feeder configuration](edit-a-feeder.md).

When you delete an alert feeder, the associated function remains. To remove the function, follow the instructions in [Delete a Function](../manage-functions/delete-a-function.md).

## Usage

You can use an alert feeder to integrate any external system that exposes a public REST API supporting synchronous data retrieval into TheHive.

### Authentication modes

Currently, alert feeders support the following four authentication methods:

* None
* Basic
* Key
* Bearer

### Example integrations

You can use alert feeders to integrate various external systems, including:

* Jira
* Airtable
* IBM Radar
* Rapid7
* SentinelOne

And more!

## Permissions

{!includes/license-alert-feeders.md!}

{!includes/access-feeders.md!}

## Next steps

* [Create an Alert Feeder](create-a-feeder.md)
* [Edit an Alert Feeder](edit-a-feeder.md)
* [Turn Off an Alert Feeder](turn-off-a-feeder.md)
* [Delete an Alert Feeder](delete-a-feeder.md)