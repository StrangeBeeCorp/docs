# Release Notes of 5.6 Series

{% include-markdown "includes/api-public-v0-deprecation.md" %}

## 5.6.1 - February 25, 2026

### Regression fix

* Private cases: Resolved a regression introduced in 5.6.0 that prevented Service users from accessing private cases.

### Security fixes

* This update includes a patch addressing a vulnerability that hasn't been exploited in the wild. Further details will be provided soon in a dedicated security bulletin, in line with our [Responsible Vulnerability Disclosure Policy](https://github.com/StrangeBeeCorp/Security/blob/main/Policies/Vulnerability%20Disclosure%20policy.md){target=_blank}.

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