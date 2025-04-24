# How to Update the Status of an Observable

This topic provides step-by-step instructions for updating the status of an [observable](../../user-guides/analyst-corner/cases/observables/about-observables.md) in TheHive.

{!includes/access-manage-observables.md!}

!!! tip "Bulk updates"
    You can edit multiple observables at once to update their status. Follow the instructions in the [Edit Multiple Observables](edit-multiple-observables.md) topic.

## Mark an observable as sighted

You should mark an observable as sighted once it has been detected or observed in the environment.

1. [Locate the observable](../search-for-cases/find-an-observable.md) you want to update.

2. In the observable details, turn on the **Sighted** toggle.

3. Select **Save**.

## Mark an observable as indicator of compromise (IOC)

You should mark an observable as an indicator of compromise (IOC) once it is identified as being linked to suspicious or malicious activity.

1. [Locate the observable](../search-for-cases/find-an-observable.md) you want to update.

2. In the observable details, turn on the **IOC** toggle.

3. Select **Save**.

## Exclude an observable from the similarity check for alerts and cases

Similar alerts and cases are detected based on shared observables. You can choose to [ignore similarity for contextual observables](update-status-of-an-observable.md), such as the company domain name, or for observables that aren't related to any potential threat.

1. [Locate the observable](../search-for-cases/find-an-observable.md) you want to update.

2. In the observable details, turn on the **Ignore similarity** toggle.

3. Select **Save**.

<h2>Next steps</h2>

* [Add an Observable](add-an-observable.md)
* [Remove an Observable](remove-an-observable.md)
* [Edit Multiple Observables](edit-multiple-observables.md)
* [Pin or Unpin an Observable](pin-unpin-an-observable.md)
* [Export Data from Observables](export-data-observables.md)
* [Run Analyzers on an Observable](run-analyzers-on-observables.md)
* [Run Responders on an Observable](run-responders-on-an-observable.md)
* [Import Observables from Analyzer Reports](import-observables-from-analyzer-reports.md)