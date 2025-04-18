# Release Notes of 5.5 Series

!!! warning "Cortex support"
    Version 5.5 no longer supports Cortex versions earlier than 3.1.5 (released on June 22, 2022).

!!! info "Public API v0 deprecation"
    Version 5.5 is the last minor release to support API v0 routes, which will be deactivated by default in version 5.6. Note that API v0 has been deprecated since version 5.4.0.

## 5.5.0 - April 22, 2025

### New features

#### Private cases: Restrict access to sensitive cases

You can now [restrict case access](../user-guides/analyst-corner/cases/about-cases.md#case-visibility) to designated team members and managers, enhancing data security.

#### Alert feeders

An [alert feeder](../user-guides/organization/configure-organization/manage-feeders/about-feeders.md) is a connector that periodically requests data from an external HTTP REST API and converts it into an alert using a TheHive function. It enables data retrieval in pull mode from services that can't push or post data to TheHive's public API.

#### Case links: Link external or internal elements to a case

You can now [link cases](../user-guides/analyst-corner/cases/about-cases.md#linking-elements) to each other and to external URLs, offering a comprehensive view of related information directly within the **General** tab. Additionally, when you create a case from a MISP alert or merge a MISP alert into a case, the MISP URL associated with the alert is added as an external link.

#### Table widget in dashboard

The [table widget](../user-guides/analyst-corner/dashboard/widgets-dashboards.md#table-widget) displays a list of entities (cases, alerts, or tasks) in a tabular format. You can customize the columns, apply advanced filters, and select sorting options. This is typically used to view action-required cases directly on a dashboard.

#### New Markdown content formatting options

You now have access to three new improvements in [the Markdown formatting options](../user-guides/thehive-flavored-markdown.md):

* The ability to use the `<br />`, `<br/>`, or `<br>` HTML tags to break lines within table cells
* Code blocks with syntax highlighting
* Admonition blocks of types error, warning, success, or info

#### New OpenID SSO provider

TheHive now supports integration with an OpenID authentication provider, offering users Single Sign-On (SSO) access. While authentication via SAML and OAuth 2.0 was previously supported, OpenID, built on the OAuth2 authorization layer, simplifies the authentication process.

#### Hide predefined statuses

You can now [hide predefined statuses](../administration/status/change-visibility-of-a-status.md) for cases and alerts, allowing users to see only the custom statuses you’ve created. This provides a cleaner, more organized status list, displaying only relevant information for an improved user experience.

#### MS Graph API for email intakes

A new connector is available for email intakes. The Microsoft 365 Graph API connector uses the standard API recommended by Microsoft to connect and retrieve emails from a Microsoft mailbox.

#### Case report templates: Display the description of custom events

You can now hide or show the description of custom events in the timeline widget report.

### Improvements

#### Taxonomy drawer

The taxonomies component has been redesigned to provide an improved user experience.

#### Better user experience for custom fields

The display of custom fields has been improved for better consistency and intuitiveness, making data entry and management more efficient while reducing errors.

#### Images in descriptions

You can now display full-size images by dropping them directly into the descriptions of [cases](../user-guides/analyst-corner/cases/create-a-new-case.md#create-an-empty-case), [alerts](../user-guides/analyst-corner/alerts/enrich-alert-details.md), and [task logs](../user-guides/analyst-corner/tasks/create-a-task-log.md). This improvement complements the existing attachment system, which displays images as attachments.

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