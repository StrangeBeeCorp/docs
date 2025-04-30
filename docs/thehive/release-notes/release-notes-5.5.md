# Release Notes of 5.5 Series

!!! warning "Cortex support"
    Version 5.5 no longer supports Cortex versions earlier than 3.1.5 (released on June 22, 2022).

!!! info "Public API v0 deprecation"
    Version 5.5 is the last minor release to support API v0 routes, which will be deactivated by default in version 5.6. Note that API v0 has been deprecated since version 5.4.0.

## 5.5.1 - April 30, 2025

### Security fixes

This update includes four patches addressing vulnerabilities that haven't been exploited in the wild. Further details will be provided in an upcoming security bulletin, in line with our responsible disclosure policy.

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
* Corrected a problem in the order of events in the live feed.
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