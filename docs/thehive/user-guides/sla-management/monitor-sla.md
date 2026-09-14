# Monitor SLA

<!-- md:version 5.8 --> <!-- md:license Platinum -->

Once [service level agreement (SLA) management is turned on](../organization/configure-organization/manage-sla/configure-sla-rules.md#turn-on-sla-management) and [SLA rules](../organization/configure-organization/manage-sla/configure-sla-rules.md#create-an-sla-rule) exist, TheHive shows SLA compliance directly in alert, case, and task list views and detail views.

## SLA status

Whether you're looking at the SLA column in a list view or an SLA card in a detail view, TheHive shows a badge for every SLA rule that applies to the entity, using the same colors and states:

| Status | Color | Displayed status | Meaning |
|---|---|---|---|
| On track | Blue, with a :fontawesome-regular-clock: | Remaining time countdown | Within the deadline, still counting down |
| At risk | Orange, with a :fontawesome-regular-clock: | Remaining time countdown | The warning threshold has been reached |
| Overdue | Red, with a :fontawesome-regular-clock: | Remaining time countdown, shown as a negative value | Past the deadline |
| Respected | Grey, with a green :fontawesome-regular-circle-check: | SLA met | The metric completed on time |
| Breached | Grey, with a red :fontawesome-regular-circle-xmark: | SLA breached | The metric completed after the deadline |

## Filter on SLA in list views

An **SLA** column appears in the alert, case, and task list views. It shows one badge per SLA rule that applies.

In addition, three SLA fields are available for filtering: **SLA status**, **SLA breach date**, and **SLA warning date**. See [About Filtering and Sorting](../analyst-corner/about-filtering-and-sorting.md) to understand how to filter or sort a list.

## View SLA cards in detail views

Open an alert, case, or task to see its SLA status in the left pane. TheHive shows one **SLA** card per matching rule, each displaying the rule name.

<h2>Next steps</h2>

* [About SLA Management](about-sla-management.md)
* [Configure SLA Rules](../organization/configure-organization/manage-sla/configure-sla-rules.md)
* [Configure SLA Notifications](configure-sla-notifications.md)
