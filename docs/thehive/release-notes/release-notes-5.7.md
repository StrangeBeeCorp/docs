# Release Notes of 5.7 Series

{% include-markdown "includes/api-public-v0-deprecation.md" %}

## 5.7.0 - April 9, 2026

### New features

#### Case-insensitive observable management

Observable types can now [be configured as case-insensitive](../administration/observable-types/set-an-observable-type-case-insensitive.md). When enabled, new observables of these types are automatically normalized to lower case. Existing observables aren't affected.

#### New KPI: Time to handle tasks

A new KPI, [Time to handle](../user-guides/key-performance-indicators/key-performance-indicators.md#time-to-handle-tasks), is now available for tasks. Based on start and end timestamps, it helps identify bottlenecks and measure team efficiency at the task level.

#### Status display customization

Users can now [choose between two display styles for status labels](../user-guides/manage-user-settings.md#customize-status-style) in their personal settings.

#### Enforced multifactor authentication (MFA)

Administrators can now [enforce MFA for all users](../administration/authentication/configure-authentication.md). Users without MFA configured must set it up at their next login. This strengthens security and ensures consistent authentication policies.

### Improvements

#### (Beta) Improved browser multi-tab management

Enhances multi-tab performance, allowing up to 10 tabs to be opened simultaneously. Tabs refresh quickly and reliably using SSE, with a single shared stream across all open tabs. This feature is available in beta and can be enabled by Administrators in the **Platform management** view, under the **General settings** tab.

#### OAuth 2.0 support for Alert Feeder

Alert Feeder [now supports OAuth 2.0 authentication](../user-guides/organization/configure-organization/manage-feeders/create-a-feeder.md) using the client credentials flow.

#### Comments and Knowledge Base page sharing

[Comments](../user-guides/analyst-corner/cases/case-comments/share-a-comment.md) and [Knowledge Base pages](../user-guides/knowledge-base/share-a-knowledge-base-page.md) can now be shared via direct URLs.

#### Alphabetical tag sorting

Tags are now sorted in ascending alphabetical order.

#### Bulk execution of responders on observables

Users can now [run responders on multiple observables](../user-guides/analyst-corner/cases/observables/run-responders-on-an-observable.md).

#### Improved case merging workflow

The case merging interface has been redesigned for better usability. Recent cases are now highlighted, and search has been simplified to help users quickly find relevant cases.

#### Direct link to documentation

A direct link to the documentation has been added to the help menu for quicker access.

### Fixes

* Improved QR code readability for multifactor authentication (MFA) in dark mode.
* Fixed a crash related to date format settings.
* Fixed an issue where pages and comments could be deleted after case removal.
* Prevented data loss in the connector creation form (MISP and Cortex) after prolonged inactivity.
* Updated the behavior of the Invoke function, Invoke function on an object, and Run an alert feeder endpoints to return errors from the underlying function as HTTP 500 responses.