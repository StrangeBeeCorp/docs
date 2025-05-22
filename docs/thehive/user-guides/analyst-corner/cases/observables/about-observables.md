# About Observables

Observables are data points that can be directly observed and represent specific events or properties within a system. They are monitored for signs of suspicious or malicious activity. 

Observables can include stateful properties like IP addresses, domain names, file MD5 hashes, or system behaviors. They can also cover measurable events such as the creation or deletion of files, registry keys, and other activities crucial to system and network operations.

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

An observable can be [marked as an indicator of compromise (IOC)](update-an-observable-status.md#mark-an-observable-as-indicator-of-compromise-ioc) once it's identified as being linked to suspicious or malicious activity.

### Sighted

An observable can be [marked as sighted](update-an-observable-status.md#mark-an-observable-as-sighted) once it has been detected or observed in the environment.

## Similar alerts and cases

Observables are key to identifying similar cases and correlating malicious activity across different alerts and cases. TheHive uses observables to detect patterns and surface related items in the [**Similar alerts** and **Similar cases** tabs](../find-similar-alerts-cases.md). Similarity checks apply between cases and cases, alerts and alerts, and between alerts and cases.

If certain observables—like the company's domain name—aren’t meaningful for threat correlation, you can [exclude them from similarity checks](exclude-an-observable-from-similarity-checks.md).

### Rules for similarity

Cases and alerts are considered similar if all the following conditions are met:

* At least one observable not excluded from similarity checks shares the same value, such as an identical file name or IP address.
* The related cases and alerts belong to the same organization or to [linked organizations](../../../../administration/organizations/about-organizations-sharing-rules.md).
* Alerts don't have the status *Imported*. Alerts that have been merged into a case are no longer included in similarity checks—but the case is.

## Permissions

{!includes/access-manage-observables.md!}

<h2>Next steps</h2>

* [Add an Observable](add-an-observable.md)
* [Remove an Observable](remove-an-observable.md)
* [Update the Status of an Observable](update-an-observable-status.md)
* [Edit Multiple Observables](edit-multiple-observables.md)
* [Pin an Observable](pin-an-observable.md)
* [Export Data from Observables](export-data-observables.md)
* [Run Analyzers on an Observable](run-analyzers-on-an-observable.md)
* [Run Responders on an Observable](run-responders-on-an-observable.md)
* [Import Observables from Analyzer Reports](import-observables-from-analyzer-reports.md)
* [Exclude an Observable from Similarity Checks](exclude-an-observable-from-similarity-checks.md)