# About Dashboards

A dashboard compiles and visualizes data to provide key insights at a glance.

This topic describes dashboards in the context of TheHive, including their functionality.

!!! tip "Specific case reporting"
    To access reporting data for a specific case, use the [case report](../../analyst-corner/cases/case-reports/about-case-reports.md) and [case timeline](../cases/case-timelines/about-case-timelines.md) features.

## Configuration

Dashboards consist of [widgets](widgets-dashboards.md) that can be dragged into place.

TheHive includes four default dashboards: 

* Alerts statistics
* Cases statistics
* Observables statistics
* TTPs statistics

[Customize these default dashboards](add-remove-widgets-dashboard.md) and [create new ones from scratch](create-a-dashboard.md).

## Scope

Dashboards are at the organization level and can't be shared between organizations.

However, dashboards can be manually shared between organizations or TheHive instances by [exporting](export-import-a-dashboard.md#export-a-dashboard) and [importing](export-import-a-dashboard.md#import-a-dashboard). These dashboards remain independent and unlinked, providing a useful template for starting without building from scratch.

## Visibility

Dashboards can be private or shared with the entire organization.

Only the dashboard owner can [change its visibility](change-visibility-of-a-dashboard.md):

* For shared dashboards, the default owner is the creator.
* For private dashboards, the owner is the creator.

## Data interactions

Some widgets allow accessing detailed data directly from dashboards by selecting a value. This action opens the **Global search** view with predefined filters applied.

Data in certain widgets can also be hidden by selecting the corresponding item in the legend.

## Finding a dashboard

Organizing dashboards into groups makes them easier to find and use. Use the **Show items as group** button available on the dashboards list to organize dashboards by type.

Apply [filters and sorting](../../analyst-corner/about-filtering-and-sorting.md) to help locate specific dashboards. These preferences can be saved using [views](../../analyst-corner/about-views.md).

## Permissions

!!! warning "<!-- md:version 5.4 --> Required permissions"
    Only users with the `manageDashboard` permission can manage dashboards in TheHive. However, any user can view, download, and export dashboards.

Every user has read access to the dashboards within their organization and can export dashboards.

<h2>Next steps</h2>

* [Widgets in Dashboards](widgets-dashboards.md)
* [Create a Dashboard](create-a-dashboard.md)
* [Add or Remove Widgets in a Dashboard](add-remove-widgets-dashboard.md)
* [Change the Visibility of a Dashboard](change-visibility-of-a-dashboard.md)
* [Export or Import a Dashboard](export-import-a-dashboard.md)
* [Adjust Dashboard Refresh Frequency](adjust-dashboard-refresh-frequency.md)
* [Download a Dashboard](download-a-dashboard.md)
* [Delete a Dashboard](delete-a-dashboard.md)