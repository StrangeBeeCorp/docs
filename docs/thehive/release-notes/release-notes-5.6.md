# Release Notes of 5.6 Series

{% include-markdown "includes/api-public-v0-deprecation.md" %}

## 5.6.2 - March 17, 2026

### Fixes

* Cases: Creating a restricted or external case from scratch now correctly checks user permissions and the allowed user list before the case is created.
* Markdown: The standard undo and redo keyboard shortcuts are operational again in the Markdown editor.
* Case preview: Counters for tasks, observables, and TTPs now update in real time.
* Timeline: Timeline events no longer render HTML content, which keeps event details displayed as plain text.
* Global endpoints: Fixed an issue affecting the organization input field when editing global endpoints.
* Case pages: Long code lines in Markdown blocks now wrap correctly on case pages.

### Vulnerabilities

* Images: Restricted accepted image MIME types to PNG, JPG, and JPEG.

### Improvements

* Cases: You can now filter the case list by restricted cases.
* Organizations: The user list now includes a profile type column.

## 5.6.1 - February 25, 2026

Last update: March 25, 2026

### Regression fix

* Private cases: Resolved a regression introduced in 5.6.0 that prevented Service users from accessing private cases.

### Fixes

* Cases: Fixed an issue where case data didn’t refresh correctly when navigating between cases.
* Case templates: Resolved a display issue in the case templates list to ensure action buttons remain accessible, even when template names are very long.
* Images in description fields: You can now paste images directly into descriptions when creating a case or a task.
* Markdown: Email addresses inside code blocks are no longer altered, preventing unwanted link formatting.
* Tasks: Improved performance when marking an action as required or done.
* Observables: Improved observable search performance and accuracy by optimizing data queries and indexing attachment properties.
* Notifications: Fixed an issue where global notification endpoints weren't properly shared with organizations.
* Authentication: Resolved several issues with auto-logout to ensure inactivity timers reset correctly and users are no longer disconnected while actively using TheHive, even across multiple tabs or in read-only mode.

## 5.6.0 - February 2, 2026

Last update: February 4, 2026

### New features

#### TheHive Portal <!-- md:license Platinum -->

[TheHive Portal](../administration/thehive-portal/about-thehive-portal.md) enables secure, restricted access to case information for external stakeholders. Analysts can control what case elements are shared, allowing collaboration while preserving internal confidentiality.

* See the [administrator guide to set up TheHive Portal](../administration/thehive-portal/set-up-thehive-portal-access.md).
* See the [analyst guide to share cases with external users](../user-guides/analyst-corner/cases/case-thehive-portal/share-case-external-users.md).
* See the [external user guide to activate TheHive Portal accounts and access shared cases](../thehive-portal/activate-thehive-portal-account.md).

#### Global Search in the top bar

A new [global search in the top bar](../user-guides/analyst-corner/cases/search-for-cases/find-a-case.md#method-1-search-bar) lets you quickly find cases, alerts, observables and tasks from a single entry point. Direct case number search remains available.

#### Shared views

* Users can save custom views for any filterable list and [share them across their organization](../user-guides/analyst-corner/views/change-visibility-custom-view.md#share-a-custom-view-with-the-entire-organization).
* Views are now stored on the backend, ensuring persistence across devices and browser sessions.

!!! info "Legacy views migration"
    Legacy saved views are automatically migrated to private backend views on login, when no equivalent backend view exists.

### Improvements

#### Filter user experience

The filter component has been redesigned to provide a more intuitive and responsive experience across cases, alerts, and tasks. It now offers increased flexibility and finer-grained filtering, while enabling more advanced frontend customization.

### Fixes

* SSO authentication: Fixed an issue with the Spanish translation.
* LDAP sync: Corrected the placeholder to display the appropriate attribute.
* Dashboard: Fixed an issue where selecting a “By severity” dashboard widget created a filter with an incorrect value.
* Custom tag: Improved performance of tag queries for list retrieval.