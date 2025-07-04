# About Statuses

The status represents the current state of a [case](../../user-guides/analyst-corner/cases/about-cases.md) or [alert](../../user-guides/analyst-corner/alerts/about-alerts.md).

This topic explains how statuses works in TheHive.

{!includes/task-statuses-excluded.md!}

## Predefined statuses

TheHive includes a set of predefined statuses. Administrators can [change their color](change-color-of-a-status.md), or [hide them](change-visibility-of-a-status.md) to encourage the use of [custom statuses](create-a-status.md).

## Attributes

Each status is associated with:

* A stage: TheHive includes four predefined stages—*New*, *Imported*, *In progress*, and *Closed*. Stages are hard-coded and can't be modified, deleted, or extended.

    !!! info "Imported stage"
        The *Imported* stage and status aren't available for selection in the interface. The *Imported* status is automatically applied when an alert is [merged into an existing case](../../user-guides/analyst-corner/alerts/add-an-alert-to-an-existing-case.md) or [merged into a new case](../../user-guides/analyst-corner/alerts/create-a-case-from-an-alert.md).

* <!-- md:version 5.5 --> A visibility: The status is either displayed or hidden in TheHive interface.

* A color: The color helps users easily recognize the status.

## Behavior

!!! info "Alert status restrictions"
    Alerts in a status linked to the *Closed* stage can't return to a *New* or *In progress* stage unless the user has permission to [reopen a closed alert](../../user-guides/analyst-corner/alerts/reopen-an-alert.md). The same restriction applies when trying to switch from *In progress* back to *New*.

* Statuses linked to the *In progress* stage are available at any time for cases, but only [when starting the investigation of an alert](../../user-guides/analyst-corner/alerts/start-investigating-an-alert.md) or [reopening a closed alert](../../user-guides/analyst-corner/alerts/reopen-an-alert.md) for alerts.

* Statuses linked to the *Closed* stage are available only when [closing a case](../../user-guides/analyst-corner/cases/close-a-case.md) or [closing an alert](../../user-guides/analyst-corner/alerts/close-an-alert.md).

## Permissions

{!includes/administrator-access-manage-statuses.md!}

After creation, statuses are available to users in cases and alerts.

<h2>Next steps</h2>

* [Create a Status](create-a-status.md)
* [Change a Status Visibility](change-visibility-of-a-status.md)
* [Change a Status Color](change-color-of-a-status.md)
* [Delete a Status](delete-a-status.md)