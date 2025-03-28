# About Statuses

The status represents the current state of a [case](../../user-guides/analyst-corner/cases/about-cases.md) or [alert](../../user-guides/analyst-corner/alerts/about-alerts.md).

This article explains how statuses works in TheHive.

## Predefined statuses

TheHive includes a set of predefined statuses. You can [change their color](change-color-of-a-status.md) or [hide them](change-visibility-of-a-status.md) to guide users toward using the [custom statuses you have created](create-a-status.md).

## Attributes

Each status is associated with:

* A stage: TheHive includes four predefined stages—*New*, *Imported*, *In progress*, and *Closed*. Stages are hard-coded and can't be modified, deleted, or extended.

!!! info "Imported stage"
    The *Imported* stage isn't available for selection in the interface. It is linked to an *Imported* status that is applied when an alert is [merged into an existing case](../../user-guides/analyst-corner/alerts/alerts-description/merge-alerts.md) or [a new case](../../user-guides/analyst-corner/alerts/alerts-description/new-case-from-selection.md).

* <!-- md:version 5.5 --> A visibility: The status is either displayed or hidden in TheHive interface.

* A color: The color should help users easily recognize the status.

## Behavior

!!! info "Alert status restrictions"
    You can't switch back to a status linked to the *New* or *In progress* stage if the alert is currently in a status linked to the *Closed* stage. The same restriction applies when trying to switch from *In progress* back to *New*.

* Statuses linked to the *In progress* stage are available at any time for cases, but only [when starting work on an alert](../../user-guides/analyst-corner/alerts/alerts-description/actions.md#start) for alerts.

* Statuses linked to the *Closed* stage can only be selected when [closing a case](../../user-guides/analyst-corner/cases/close-a-case.md) or [closing an alert](../../user-guides/analyst-corner/alerts/close-an-alert.md).

## Permissions

{!includes/administrator-access-manage-statuses.md!}

After creation, statuses are available to users in cases and alerts.

## Next steps

* [Create a Status](create-a-status.md)
* [Change a Status Visibility](change-visibility-of-a-status.md)
* [Change a Status Color](change-color-of-a-status.md)
* [Delete a Status](delete-a-status.md)