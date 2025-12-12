# Exclude an Observable from Similarity Checks

<!-- md:permission `manageObservable` -->

Exclude an [observable](about-observables.md) from similarity checks in TheHive to prevent it from being used to identify [similar alerts and cases](../find-similar-alerts-cases.md). This is useful for contextual observables, such as the company domain name, or for observables that aren't related to any potential threat.

{% include-markdown "includes/bulk-updates-observables.md" %}

<h2>Procedure</h2>

1. [Locate the observable](../search-for-cases/find-an-observable.md) you want to update.

2. In the observable details, turn on the **Ignore similarity** toggle.

3. Select **Save**.

<h2>Next steps</h2>

* [Add an Observable](add-an-observable.md)
* [Delete an Observable](delete-an-observable.md)
* [Update the Status of an Observable](update-an-observable-status.md)
* [Edit Multiple Observables](edit-multiple-observables.md)
* [Pin an Observable](pin-an-observable.md)
* [Export Data from Observables](export-data-observables.md)
* [Run Analyzers and Review Reports for an Observable](run-analyzers-on-an-observable.md)
* [Run Responders and Review Reports for an Observable](run-responders-on-an-observable.md)
* [Import Observables from Analyzer Reports](import-observables-from-analyzer-reports.md)