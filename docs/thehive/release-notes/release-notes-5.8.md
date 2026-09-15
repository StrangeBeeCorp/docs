# Release Notes of 5.8 Series

{% include-markdown "includes/api-public-v0-deprecation.md" %}

!!! warning "Database evolution on upgrade"
    Upgrading to TheHive 5.8 triggers a database evolution on first launch—schema and data updates whose duration depends on your database size and on the version you upgrade from. Plan a maintenance window accordingly.

## 5.8.0 - September 14, 2026

### New features

#### SLA management <!-- md:license Platinum -->

[Service level agreement (SLA) management](../user-guides/sla-management/about-sla-management.md) lets organization administrators define time-based response objectives for alerts, cases, and tasks, then track compliance against those objectives. Each rule builds on one of the [Time-To metrics](../user-guides/key-performance-indicators/key-performance-indicators.md) TheHive already calculates, and applies to the entities matching its conditions.

* [Configure SLA rules](../user-guides/organization/configure-organization/manage-sla/configure-sla-rules.md)
* [Monitor SLA](../user-guides/sla-management/monitor-sla.md)
* [Configure SLA notifications](../user-guides/sla-management/configure-sla-notifications.md)

#### Global Search for Knowledge Base pages and comments

[Knowledge Base pages](../user-guides/knowledge-base/about-knowledge-base.md), [case pages](../user-guides/knowledge-base/about-case-pages.md), and [comments](../user-guides/analyst-corner/cases/case-comments/comment-on-case.md) are now searchable from Global Search and from the top bar.

#### Taxonomy tag deactivation

[Individual tags in a taxonomy](../administration/taxonomies/about-taxonomies.md) can now be deactivated. A deactivated tag is no longer suggested when tagging an alert, a case, or an observable, and TheHive rejects any attempt to add it. Tags already applied keep their value and stay visible.

### Improvements

#### API documentation

The [API documentation](https://docs.strangebee.com/thehive/api-docs/) has been reworked:

* Get started section rewritten
* Query section rewritten, listing the operations and `extraData` available for each entity
* More complete endpoint descriptions
* Clearer parameter descriptions, with default values and enums where available
* Realistic examples throughout, with ready-to-use Python and curl payloads

Only the documentation for this release is covered. Other versions are unchanged.

The API itself—endpoints, parameters, request and response behavior—is unchanged, so existing integrations keep working.

#### Collapsible left panel on detail pages

The left panel on case, alert, and organization detail pages can now be collapsed to free up horizontal space. Each page keeps its own panel state between visits.

#### Merging an alert into the current case

Alerts in the similar alerts list of a case can now be merged into that case directly from the list, without opening the alert first.

#### Custom fields and tags in dashboard table widgets

Table widgets on dashboards can now show custom fields and tags as columns for cases and alerts.

#### Sorting in the similar observables list

The similar observables list on alerts and cases can now be sorted by observable creation date.

#### Expandable long content

Long descriptions and task logs written in Markdown are now collapsed by default, with a **Show more** button to reveal the full content.

#### Cortex analyzer and responder discovery in functions

Function scripts can now [list the Cortex analyzers and responders available to the organization](../user-guides/organization/configure-organization/manage-functions/functions-objects.md#cortex).

#### Faster list loading

List views load faster.

#### Single health indicator for connectors

The separate Cortex and MISP status icons at the bottom of the left navigation bar are replaced by a single health indicator that covers every configured connector, including Cortex, MISP, and Email Intake.

#### IAM authentication for S3 storage on AWS EKS

TheHive running on Amazon EKS can now authenticate to Amazon S3 with IAM Roles for Service Accounts (IRSA) or EKS Pod Identity, instead of a static access key and secret key stored in the configuration file.

### Fixes

#### API

* Rejected invalid request bodies on the authentication configuration endpoints, which previously accepted malformed payloads.
* Clarified the validation message returned when an enum value is invalid.

### Security

* Dependencies: Patched several CVEs reported in third-party libraries.
