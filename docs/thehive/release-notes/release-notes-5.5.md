# Release Notes of 5.5 Series

!!! warning "Cortex support"
    Version 5.5 no longer supports Cortex versions earlier than 3.1.5 (released on June 22, 2022).

!!! note "Public API v0 deprecation"
    Version 5.5 is the last minor release to support API v0 routes. These routes will be deactivated by default in version 5.6. API v0 has been deprecated since the release of TheHive 5.4.0.

## 5.5.0 - April 3, 2025

### New features

#### [Private cases: Restrict access to sensitive cases](../user-guides/analyst-corner/cases/about-cases.md#case-visibility)

You can now make a case private, allowing authorized users to restrict access to designated team members and managers, enhancing data security.

#### [Alert feeder](../user-guides/organization/configure-organization/manage-feeders/about-feeders.md)

The Alert feeder is a connector that periodically requests data from an external HTTP REST API and converts it into an alert using a TheHive function. It enables data retrieval in pull mode from services that can't push or post data to TheHive's public API.

#### [Case links: Link external or internal elements to a case](../user-guides/analyst-corner/cases/about-cases.md#linking-elements)

You can now link cases to each other and to external URLs, offering a comprehensive view of related information directly within the **General** tab. Additionally, when you create a case from a MISP alert or merge a MISP alert into a case, the MISP URL associated with the alert is added as an external link.

#### [Table widget in dashboard](../user-guides/analyst-corner/dashboard/widgets-dashboards.md#table-widget)

This new widget displays a list of entities (cases, alerts, or tasks) in a table format. You can customize the columns, apply advanced filters, and select sorting options. This is typically used to view action-required cases directly on a dashboard.

#### [New Markdown content formatting options](../user-guides/thehive-flavored-markdown.md)

You now have access to three new improvements in the Markdown formatting options:

1. The ability to use the `<br />`, `<br/>`, or `<br>` HTML tags to break lines within table cells

2. Code blocks with syntax highlighting

3. Admonition blocks of types: error, warning, success, or info

#### New OpenID SSO provider

This feature allows to plug TheHive with an OpenID authentication provider, and offer the users a Single Sign-On (SSO) access to TheHive. It was already possible to authenticate with SAML, and OAuth2. Built on-top of OAuth2 authorization layer, OpenID makes easier the authentication.

#### Hide some status 

Introduces a new option to hide statuses in Cases and Alerts, providing a cleaner, more organized status list that displays only relevant information for an improved user experience.

#### MS Graph API for Email Intake

A new connector is available for Email Intake. The Microsoft 365 GraphAPI connector uses the recommended by Microsoft standard API, to connect and get emails from a Microsoft mail-box.

#### Case report template: new option to display the description of custom events

This option makes clearer the timelines information included in a case report. It is now possible to hide or show the custom events description in the timeline widget report.

### Improvements

### Fixes