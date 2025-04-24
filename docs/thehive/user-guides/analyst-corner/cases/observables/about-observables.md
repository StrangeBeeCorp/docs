# About Observables

Observables are data points that represent specific events or properties within a system, monitored for signs of suspicious activity. These can include stateful properties like IP addresses, domain names, file MD5 hashes, or system behaviors, as well as measurable events such as the creation or deletion of files, registry keys, and other activities crucial to system and network operations.

This topic provides an overview of the main characteristics of observables in TheHive.

## Type

An observable type defines the category or classification of an observable in TheHive. While TheHive includes a predefined set of types, this list can be [expanded with custom types](../../../../administration/observable-types/create-an-observable-type.md) to meet specific needs.

The available [analyzers](../../../../../cortex/api/how-to-create-an-analyzer.md) for an observable are based on its type.

## Data

A piece of data can be:

* For types that don't require attachments: values entered into a text area.
* For types that require attachments: a file, which is hashed.

Users can add one or more values to a single observable in TheHive, but they can only add one file at a time.

## Statuses

### Indicator of compromise (IOC)

An observable can be marked as an indicator of compromise (IOC) once it is identified as being linked to suspicious or malicious activity.

### Sighted

An observable can be marked as sighted once it has been detected or observed in the environment.

## Similar alerts and cases

Similar alerts and cases are detected based on shared observables.

You can choose to [ignore similarity for contextual observables](update-status-of-an-observable.md), such as the company domain name, or for observables that aren't related to any potential threat.

<h2>Next steps</h2>

* [Add an Observable](add-an-observable.md)
* [Remove an Observable](remove-an-observable.md)
* [Update the Status of an Observable](update-status-of-an-observable.md)
* [Edit Multiple Observables](edit-multiple-observables.md)
* [Pin an Observable](pin-an-observable.md)
* [Export Data from Observables](export-data-observables.md)
* [Run Analyzers on an Observable](run-analyzers-on-observables.md)
* [Run Responders on an Observable](run-responders-on-an-observable.md)
* [Import Observables from Analyzer Reports](import-observables-from-analyzer-reports.md)