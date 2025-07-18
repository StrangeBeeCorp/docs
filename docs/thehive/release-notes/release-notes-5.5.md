# Release Notes of 5.5 Series

!!! warning "Cortex support"
    Version 5.5 no longer supports Cortex versions earlier than 3.1.5 (released on June 22, 2022).

!!! info "Public API v0 deprecation"
    Version 5.5 is the last minor release to support API v0 routes, which will be deactivated by default in version 5.6. Note that API v0 has been deprecated since version 5.4.0.

## 5.5.5 - July 10, 2025

### Regression fixes

* Case start date: Corrected an issue where the start date was incorrectly set after case creation.
* Tags: Fixed custom tag auto-completion problems when editing cases or configuring filters.

### Improvements

Optimized audit JSON rendering to improve overall application performance and reduce CPU usage.

### Other fixes

* Dashboards: Resolved display issues with donut and bar widgets when using custom fields or statuses as categories.
* Metrics: Fixed inaccurate calculations in dashboard widgets that use metric-per-unit fields (such as TimeToDetectInHour and TimeToQualifyInDay).
* Case links: Improved conversion of external alert links into case links to prevent display errors caused by improperly formatted URLs.

## 5.5.4 - June 25, 2025

### Regression fixes

Fixed a regression where the `creationDate` field wasn't automatically set to the current date when creating a new case.

### Improvements

* Functions: Added the ability to [switch a case to restricted mode using a function](../user-guides/organization/configure-organization/manage-functions/functions-objects.md#case).
* Docker image: Introduced [a new entry point to support custom certificate authority (CA) handling](../../cortex/installation-and-configuration/run-cortex-with-docker.md#overriding-configuration-with-a-custom-file).

### Other fixes

* Alert status: Fixed a display issue with the import date in alert status.
* Restricted cases: Resolved a bug affecting similarity checks for restricted cases.
* Case links: Fixed duplication issues when importing multiple alerts containing identical links.
* Description field: Improved visibility of the resize button in Chrome-based browsers.
* Filters: Fixed sorting issue in the case list when using the `title` field.

## 5.5.3 - June 2, 2025

### Regression fixes

* Markdown: Resolved a regression affecting table formatting in Markdown content.
* Description fields: Corrected an issue causing some description fields to display in editing mode by default.
* Custom fields: Fixed a display problem when custom fields contained more than 12 options.

### Other fixes

* Live Feed: Addressed a redirection issue related to attachment actions within the Live Feed.
* Case reports: Corrected image export issues in case descriptions within generated HTML reports.
* Email Intake: Fixed a problem handling duplicated email message-IDs.

## 5.5.2 - May 13, 2025

### Performance fixes

Fixed a performance issue introduced by the new [case links feature](#case-links-link-external-or-internal-elements-to-a-case) that could cause significant slowdowns in environments with large data volumes.

### Other fixes

#### Case reports

Fixed an issue where images uploaded in the case description weren't displayed in generated HTML and Word reports.

#### Attachments for shared cases

Fixed an issue where attachment files weren't visible in shared cases.

#### Public API

Fixed incorrect HTTP response code returned when a merge operation failed due to an ID conflict.

### Improvements

Analyzers and responders can now be triggered directly [from a TheHive function](../user-guides/organization/configure-organization/manage-functions/functions-objects.md#cortex), enabling greater automation capabilities.

## 5.5.1 - April 30, 2025

Last update: May 26, 2025

### Security fixes

* This update includes four patches addressing vulnerabilities identified as [CVE-2025-48738](https://nvd.nist.gov/vuln/detail/CVE-2025-48738), [CVE-2025-48739](https://nvd.nist.gov/vuln/detail/CVE-2025-48739), [CVE-2025-48740](https://nvd.nist.gov/vuln/detail/CVE-2025-48740), and [CVE-2025-48741](https://nvd.nist.gov/vuln/detail/CVE-2025-48741). None have been exploited in the wild. Further details are provided in our [security bulletin](https://github.com/StrangeBeeCorp/Security?tab=readme-ov-file#2025), in line with our [Responsible Vulnerability Disclosure Policy](https://github.com/StrangeBeeCorp/Security/blob/main/Policies/Vulnerability%20Disclosure%20policy.md).
* JSON endpoints now strictly validate the `Content-Type` header. Requests must explicitly include `Content-Type: application/json`. If not, the server returns a `400 Bad Request` response.
    * A temporary compatibility mode is available to support legacy clients or scripts that don't set the `Content-Type` header properly. To enable it, add the following line to your `application.conf` file: `ignoreCSRFProtection = true`.
    * After enabling compatibility mode, update all clients to send `Content-Type: application/json`. Once all clients are updated, remove this override to re-enable full validation.

### Improvements

#### Tasks

You can now sort tasks by their due dates.

### Fixes

#### Dashboards

* Bar widget: The `_total` field no longer appears when data is stacked.
* Table widget: Fixed an issue with filter configuration, and corrected two issues affecting the maximum number of elements.

#### Filters

* Fixed incorrect handling of the hyphen character (`-`) with certain search and filter operators.
* Fixed an issue where the filter form was wiped when a new alert arrived.
* Fixed the "Owned by my organization" quick filter, which wasn't working as expected.

#### Others

* Improved performance of TheHive when handling a high number of analyses coming from Cortex.
* Fixed a display issue in the timeline tab.

## 5.5.0 - April 22, 2025

### New features

#### Private cases: Restrict access to sensitive cases

You can now [restrict access to sensitive cases](../user-guides/analyst-corner/cases/about-cases.md#case-visibility) to designated team members and managers.

#### Alert feeders

An [alert feeder](../user-guides/organization/configure-organization/manage-feeders/about-feeders.md) is a connector that periodically requests data from an external HTTP REST API and converts it into an alert using a TheHive function. It enables data retrieval in pull mode from services that can't push or post data to TheHive's public API.

#### Case links: Link external or internal elements to a case

You can now [link cases](../user-guides/analyst-corner/cases/about-cases.md#linking-elements) to each other and to external URLs, offering a comprehensive view of related information directly within the **General** tab. Additionally, when you create a case from a MISP alert or merge a MISP alert into a case, the MISP URL associated with the alert is added as an external link.

#### Table widget in dashboard

The [table widget](../user-guides/analyst-corner/dashboard/widgets-dashboards.md#table-widget) displays a list of entities (cases, alerts, or tasks) in a tabular format. You can customize the columns, apply advanced filters, and select sorting options. This can be used to view action-required cases directly on a dashboard.

#### New Markdown content formatting options

You now have access to three new improvements in [the Markdown formatting options](../user-guides/thehive-flavored-markdown.md):

* The ability to use the `<br />`, `<br/>`, or `<br>` HTML tags to break lines within table cells
* Code blocks with syntax highlighting
* Admonition blocks of types error, warning, success, or info

#### New OpenID SSO provider

TheHive now supports integration with an [OpenID authentication provider](../administration/authentication/openid.md), offering users Single Sign-On (SSO) access. While authentication via SAML and OAuth 2.0 was previously supported, OpenID, built on the OAuth2 authorization layer, simplifies the authentication process.

#### Hide predefined statuses

You can now [hide predefined statuses](../administration/status/change-visibility-of-a-status.md) for cases and alerts, allowing users to see only the custom statuses you’ve created. This provides a cleaner, more organized status list, displaying only relevant information for an improved user experience.

#### MS Graph API for email intakes

The [Microsoft 365 Graph API connector](../administration/email-intake-connector/connect-a-mailbox.md) is now available for email intakes. It uses the standard API recommended by Microsoft to connect and retrieve emails from a Microsoft mailbox.

#### Case report templates: Display the description of custom events

You can now hide or show the description of custom events in the [timeline widget](../user-guides/organization/configure-organization/manage-templates/case-report-templates/widgets-case-report-templates.md#timeline-widget) within case reports.

### Improvements

#### Taxonomy drawer

The taxonomies component has been redesigned to provide an improved user experience.

#### Better user experience for custom fields

The display of custom fields has been improved for better consistency and intuitiveness, making data entry and management more efficient while reducing errors.

#### Images in descriptions

You can now display full-size images by dropping them directly into the descriptions of cases, alerts, and task logs. This improvement complements the existing attachment system, which displays images as attachments.

#### Status visibility in the Tasks tab of cases

The status of tasks is now clearly visible in each row of the **Tasks** tab in cases, enabling quick identification without needing to open the details.

#### Public API observable route optimization

The observable creation routes in alerts and cases have been optimized, making the creation of dozens of observables five times faster.

### Fixes

#### UI

##### Dark Mode

* Corrected rendering of tag colors in report analyzers.
* Fixed color display for failure messages on dashboards.

#### Others

* MISP server connection: Improved by trimming the server URL.
* Attachment tab on cases: Fixed the counter to display the correct number. Filtering and sorting of attachments now work correctly.
* Case and alert closure: Added the ability to input multiple values in custom fields.
* Dashboards: 
    * Selecting *Audit* in the **Entity** field is no longer allowed for any widget. Previously created widgets remain unaffected.
    * Fixed an issue when using a date-type custom field as the date field in the widget.
* Case export to MISP: Fixed an issue with attachments when exporting a case to MISP.
* Merged alert audits: Fixed a regression introduced in [version 5.4.8](release-notes-5.4.md) related to the JSON audit object of merged alerts. In the audit, the `object.*` field refers to the merged alert, while the `context.*` object refers to the case where the alert has been merged.
* Notification form: Improved the performance of the filteredEvent input.

### Documentation updates

#### Administration

* Authentication
* Organizations
* Cortex server connection
* Email intake connectors
* MISP integration
* Custom fields
* Taxonomies
* Case and alert statuses

#### Configure organization

* Notifications and endpoints
* Functions
* Templates
* Custom tags

#### Analyst's corner

* Closing alerts and cases
* Merging cases
* Task and task logs
* Case reports
* Case timelines
* Dashboards
* Knowledge Base