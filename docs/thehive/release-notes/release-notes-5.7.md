# Release Notes of 5.7 Series

{% include-markdown "includes/api-public-v0-deprecation.md" %}

!!! warning "Database evolution on upgrade"
    Upgrading to TheHive 5.7 from version 5.5 or earlier triggers a database evolution on first launch—schema and data updates whose duration scales with your database size. Plan a maintenance window accordingly.

!!! danger "Skip directly to version 5.7.3"
    Version 5.7.1 contains a critical bug that prevents Cortex job results from being retrieved by TheHive. Upgrade straight to 5.7.3 instead.

## 5.7.3 - June 5, 2026

### Improvements

* Authentication: Added informational logs to the LDAP synchronization process, covering sync start and end, search parameters, and per-user group and profile mappings.

### Fixes

#### Cases

* Resolved an issue where deleting a case left some attachments behind in storage.
* Corrected validation of custom field options to reject invalid configurations.

#### Alerts

* Removed an unsupported sort by observable count from the linked alerts tab of a case, which caused the list to render empty.

#### Tasks

* Repaired attachment download links in task logs, which returned a 404 since version 5.7.0.

#### Dashboards

* Corrected the legend on time-based charts to display the full property name instead of an internal identifier.
* Addressed broken aggregations on dashboard widgets that used nested properties.
* Turned off the legacy dashboard.

#### Search

* Changed tag suggestions to match by prefix instead of substring.
* Resolved a Global Search issue where re-running the same query after navigating away required a manual refresh.

#### Performance

* Improved query execution by reordering filter steps and removing an unnecessary barrier.

### Security

* API: Added HTTP security headers to server responses.
* Case report: Sanitized HTML content in case reports to prevent cross-site scripting (XSS).
* Dependencies: Patched several CVEs reported in third-party libraries.

## 5.7.2 - April 30, 2026

### Fixes

* Analyzers reports: Resolved an error that prevented Cortex jobs from being processed correctly.

## 5.7.1 - April 20, 2026

Last update: May 12, 2026

### Fixes

#### Cases

* Fixed an issue where tags from the case template were automatically merged into the case when creating it via the API, even when the request included an explicit tag list.
* Corrected a caching issue that caused outdated tag values to continue appearing in tag suggestions after an update.
* Enforced the share management permission check when updating task and observable rules on cases. Users without this permission now receive an error.

#### Custom fields

* Eliminated silent failures when an integer custom field value falls outside the valid 32-bit range: the form now shows an inline validation error and blocks submission.
* Corrected two issues with the `customFields` field when updated using the API on [cases](https://docs.strangebee.com/thehive/api-docs/#tag/Case/operation/Update%20case){target=_blank}, [alerts](https://docs.strangebee.com/thehive/api-docs/#tag/Alert/operation/Update%20Alert){target=_blank}, and [case templates](https://docs.strangebee.com/thehive/api-docs/#tag/CaseTemplate/operation/Update%20CaseTemplate){target=_blank}. The object format (`{"custom_field_name": "value", ...}`) now appends each entry without modifying or removing any existing custom field values. Array values inside the object format now return an error. To replace the full set of custom field values, use the array format (`[{"name": "custom_field_name", "value": "value", "order": 0}, ...]`) instead.

#### Observables

* Restored the option to import observables from analyzer reports when viewing alert observables. The import button was previously only shown for case observables.
* Fixed the display of past analyzer executions on the observable page for analyzers that are no longer listed in Cortex.

#### Notifications

* Corrected notification template rendering to fall back to the user's login when no email address is configured.
* Removed user-context template variables from the autocomplete in notifier inputs when user context isn't available.

#### Integrations

* Improved the sanitization of IP addresses in email content processed by the email intake connector.
* Corrected the OAuth 2.0 authority field handling in the email intake connector for Microsoft Graph API configurations.

#### Other

* Log entries now correctly include user and request context when Kamon monitoring is turned off.

### Security

* HTML, XHTML, and SVG attachments served inline are now sanitized to remove script tags and other unsafe content, preventing cross-site scripting (XSS) attacks.

## 5.7.0 - April 9, 2026

Last update: May 25, 2026

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

### Security

* Images: Restricted accepted branding image MIME types to PNG, JPG, and JPEG.