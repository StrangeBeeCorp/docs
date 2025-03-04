# About Feeders

!!! note "Available from version 5.5"
    Feeders are available starting from version 5.5.

!!! warning "Platinum license required"
    A Platinum license is required to use feeders. If the license expires or becomes inactive, existing feeders will be automatically deactivated.

Feeders integrate external tools with TheHive without requiring them to push data. Instead, TheHive retrieves data from external systems on a scheduled basis.

The primary goal of feeders is to enhance TheHive’s ingestion capabilities while minimizing reliance on external services for data retrieval.

This topic provides an overview of the scope and usage of feeders in TheHive.

## How feeders work

Feeders allow your organization to automate data retrieval at a defined frequency from an external service through an HTTP API call. The retrieved data is then converted into alerts, cases, or tasks using [functions](../manage-functions/about-functions.md). Each feeder can have only one function.

### Feeder functions

You should not manually create a feeder function as a standalone function, as it cannot be linked to a feeder. Instead, [create it directly within the feeder](create-a-feeder.md). Once created, the function is automatically added to the [functions list](../manage-functions/about-functions.md) with the type *feeder*. You can then modify it either from the functions list or the feeder configuration.

## Usage

Any external system that exposes a public REST API supporting synchronous data retrieval can be integrated into TheHive using a feeder.

### Authentication modes

Currently, feeders support the following three authentication methods:

* None
* Basic
* Key

### Example integrations

Feeders can be used to integrate various external systems, including:

* Jira
* Airtable
* IBM Radar
* Rapid7
* SentinelOne

...and more!

## Permissions

{!includes/access-feeders.md!}

## Next steps

* [Create a Feeder](create-a-feeder.md)
* [Edit a Feeder](edit-a-feeder.md)
* [Turn Off a Feeder](turn-off-a-feeder.md)
* [Delete a Feeder](delete-a-feeder.md)