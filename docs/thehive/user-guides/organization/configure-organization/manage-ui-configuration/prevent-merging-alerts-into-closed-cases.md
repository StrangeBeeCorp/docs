# Prevent Users from Merging Alerts into Closed Cases

This topic provides step-by-step instructions for deactivating the ability to [merge alerts into closed cases](../../../analyst-corner/alerts/add-an-alert-to-an-existing-case.md) in TheHive.

A closed case is one with a [status](../../../../administration/status/about-statuses.md) assigned to the *Closed* stage.

By default, it's possible to merge alerts into a closed case. Use this procedure to restrict merging alerts into cases statuses linked to the *New* or *In progress* stages.

!!! warning "Required permissions"
    Only users with the `manageConfig` permission can deactivate merging alerts into closed cases in TheHive.

<h2>Procedure</h2>

1. {!includes/organization-view-go-to.md!}

2. {!includes/ui-configuration-tab-go-to.md!}

3. In the **Alert and case** section, turn on the **Merge alerts into closed cases** toggle.

4. Select **Confirm**.

<h2>Next steps</h2>

* [Pause Dashboard Refresh](pause-dashboard-refresh.md)
* [Remove the All Periods Option in a Dashboard](remove-all-periods-option.md)
* [Prevent Users from Creating Empty Cases](prevent-creating-empty-cases.md)
* [Select Similar Cases and Alerts Filters](select-similar-cases-alerts-filters.md)
* [Hide Key Performance Indicators](hide-key-performance-indicators.md)