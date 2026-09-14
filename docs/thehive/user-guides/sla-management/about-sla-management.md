# About SLA Management

<!-- md:version 5.8 --> <!-- md:license Platinum -->

Security operations center (SOC) teams and managed security service providers (MSSPs) often operate under contractual response-time commitments. Service level agreement (SLA) management lets organization administrators define time-based response objectives for [alerts](../analyst-corner/alerts/about-alerts.md), [cases](../analyst-corner/cases/about-cases.md), and [tasks](../analyst-corner/tasks/about-tasks.md), then track and prove compliance against those objectives natively in TheHive.

## Overview

An SLA rule defines the entity type it applies to, the metric it's measured against, which entities it applies to through conditions, and the deadline and warning threshold for meeting it.

Alerts, cases, and tasks that already exist when a rule is saved aren't evaluated straight away, but they are [the next time each one is updated](../organization/configure-organization/manage-sla/configure-sla-rules.md#create-an-sla-rule). The SLA then counts from their own metric start date, not from the moment the rule was saved.

Once [SLA management is turned on and rules exist](../organization/configure-organization/manage-sla/configure-sla-rules.md), [an SLA column and dedicated cards show the status of every covered alert, case, or task](monitor-sla.md).

[Notifications can be configured](configure-sla-notifications.md) to notify users when an SLA warning threshold is reached or a deadline is exceeded.

## How SLA is calculated

Each SLA rule is based on one of the [Time-To metrics](../key-performance-indicators/key-performance-indicators.md) TheHive already calculates for alerts, cases, and tasks.

| Entity | Available metrics |
|---|---|
| Alert | [Time to detect (TTD)](../key-performance-indicators/key-performance-indicators.md#time-to-detect-ttd), [Time to triage (TTT)](../key-performance-indicators/key-performance-indicators.md#time-to-triage-ttt), [Time to acknowledge (TTA)](../key-performance-indicators/key-performance-indicators.md#time-to-acknowledge-tta), [Time to qualify (TTQ)](../key-performance-indicators/key-performance-indicators.md#time-to-qualify-ttq) |
| Case | [Time to detect (TTD)](../key-performance-indicators/key-performance-indicators.md#time-to-detect-ttd), [Time to triage (TTT)](../key-performance-indicators/key-performance-indicators.md#time-to-triage-ttt), [Time to acknowledge (TTA)](../key-performance-indicators/key-performance-indicators.md#time-to-acknowledge-tta), [Time to resolve (TTR)](../key-performance-indicators/key-performance-indicators.md#time-to-resolve-ttr), [Time to qualify (TTQ)](../key-performance-indicators/key-performance-indicators.md#time-to-qualify-ttq) |
| Task | [Time to handle (TTH)](../key-performance-indicators/key-performance-indicators.md#time-to-handle-tasks) |

Each SLA rule picks one metric for one entity type. When an alert, case, or task is created or updated, TheHive evaluates it against every active rule that applies, and shows the result as an [SLA indicator](monitor-sla.md#sla-status).

## Ownership

An SLA rule belongs to the organization that created it. TheHive evaluates it only against alerts, cases, and tasks owned by that organization.

Sharing a case with another organization doesn't change which rules apply to it: the owning organization's rules keep governing it, and the other organization's own rules are never applied. The other organization sees the resulting SLA badges and rule names in both list views and detail views, but not the rule's configuration.

Transferring ownership of a case moves it, and its tasks, onto the new owner's rules. TheHive re-evaluates the case and every one of its tasks as soon as the transfer completes: SLA states from the previous owner are removed, whether they were still running or already resolved, and the new owner's matching rules apply straight away. The SLA still counts from each entity's own metric start date, not from the transfer.

When SLA management is turned off in your own organization, no SLA badge appears at all, including on cases shared by an organization that still has it turned on.

## Permissions

Viewing SLA rules doesn't require any permission.

Only users with the `manageSla` permission can create, edit, or delete SLA rules in TheHive.

<h2>Next steps</h2>

* [Configure SLA Rules](../organization/configure-organization/manage-sla/configure-sla-rules.md)
* [Monitor SLA](monitor-sla.md)
* [Configure SLA Notifications](configure-sla-notifications.md)
