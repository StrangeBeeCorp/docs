# About Cases

This topic explains cases in TheHive, their components, and how they work.

## Definition

A case is a structured entity used to track, investigate, and respond to security incidents, threats, or suspicious activities. It serves as a central repository where security teams organize information, collaborate on investigations, and document their findings.

## Sources

In TheHive, you can create a case from the following sources:

* [Manual entry](../cases/create-a-new-case.md#create-an-empty-case): Cases created through direct input by users.

* [Merging cases](#merging-cases): A new case created by merging two existing cases.

* [Case templates](../cases/create-a-new-case.md#create-a-case-from-a-template): Predefined structures used to standardize case creation.

* [Archived cases](../cases/create-a-new-case.md#create-a-case-from-an-archived-case): Restored cases from previous investigations in TheHive.

* [MISP event files](../cases/create-a-new-case.md#create-a-case-from-a-misp-event): Cases created by manually importing MISP events.

* [Alert feeders](../../../user-guides/organization/configure-organization/manage-feeders/about-feeders.md) (available from version 5.5): Cases created from data retrieved from external systems using an alert feeder.

* [Alerts](../cases/create-a-new-case.md#create-a-case-from-an-alert): Cases generated from alerts received via connected detection tools (SIEM, EDR, IDS, or firewalls), threat intelligence platforms (like MISP), or [email servers](../../../administration/email-intake-connector.md).

* [Detection tools](../cases/create-a-new-case.md#create-a-case-from-a-detection-tool) (SIEM, EDR, IDS, or firewalls): Cases created automatically by trusted detection tools, when you prefer to manage alert triage within the tool or trust it to generate mostly true positives.

## Key components

In TheHive, a case includes the following elements:

* [Observables](../cases/cases-description/observables.md): Data points such as IP addresses, file hashes, domains, and email addresses that are relevant to an investigation.

* [Tasks](../tasks/about-tasks.md): Actions assigned to analysts to analyze, assess, and mitigate threats.

* [TTPs](../cases/cases-description/ttps.md): The methods and strategies used by attackers, based on the [MITRE ATT&CK](https://attack.mitre.org/) knowledge base.

## Merging cases

{!includes/access-merge-cases.md!}

Cases can be merged if they are similar or part of the same investigation, allowing you to centralize data. 

To merge cases, they must belong to the same organization and share the same permission profile pairs. Merging consolidates two cases into a new one, combining their contents and deleting the originals.

To learn how to merge cases, see [Merge Cases](../cases/merge-cases.md).

Merging also impacts:

* [Restricted cases](#merging-a-restricted-case)
* [Linked elements](#merging-cases-with-links)

## Linking elements

{!includes/case-links-v55.md!}

{!includes/access-manage-case-links.md!}

!!! info "Alerts as linked elements"
    You can't add an alert to the linked elements. To view alerts linked to a case, select the dedicated **Linked alerts** tab.

Cases can be linked to other TheHive cases or external resources. These links enhance traceability and help visualize relationships between related incidents.

### Link categories

Links must be categorized to reflect the type of relationship. If you don’t specify a category, *Internal link* is automatically applied when linking TheHive cases, and *External link* when linking external resources.

### Link display

Users can only view links to cases in their organization and cases they have access to.

Links automatically appear in both linked cases. Deleting a case automatically removes its related links.

Case links aren't included in case exports, reports, or dashboards.

### Actions

You can [add](add-a-link-to-a-case.md) or [remove](remove-a-link-from-a-case.md) a link in a case, but you can’t modify it after it’s added.

### Merging cases with links

* When you merge cases, links from both cases are combined, and duplicates are removed based on the link and its type. Any links that point to the source merged cases are automatically removed.

* When you create a case from a MISP alert or merge a MISP alert into a case, the MISP URL linked to the alert is added as an external link with the *External alert link* type. This link remains even if you later unlink the alert from the case.

## Case visibility

{!includes/case-visibility-v55.md!}

{!includes/license-required-case-visibility.md!}

{!includes/access-manage-visibility-cases.md!}

### Usage

Restricted case visibility allows you to control who can view a case by limiting access to specific team members and managers. This feature helps protect sensitive information and reduce the risk of unauthorized access.

### Configuration

By default, cases created through the user interface are visible to all users in the organization. 

You can [restrict visibility](restrict-visibility-case.md) to a specific group of users to secure sensitive cases and later [restore visibility](restore-visibility-case.md) if needed. 

The case assignee and the user performing the action always have access and can't be removed.

You can create cases with restricted visibility directly [using the API](https://docs.strangebee.com/thehive/api-docs/#tag/Case).

### Expected behavior

When you set a case to restricted visibility:

* For unauthorized users: The restricted case doesn't appear in linked elements, case lists, search results, or dashboards. All related elements, including observables, tasks, and attachments, are also hidden. Unauthorized users can't be assigned to the case.

* For authorized users: The restricted case appears in linked elements, case lists, search results, and dashboards. Authorized users can be assigned to the case.

#### Indicators

A restricted case is identifiable as follows:

* For unauthorized users: The restricted case is hidden from linked elements, case lists, search results, and dashboards, but it still appears in [an alert linked to the restricted case](../alerts/alerts-description/new-case-from-selection.md). In such an alert, a :fontawesome-solid-lock: symbol appears alongside the case number inside an orange warning box.

* For authorized users: The restricted case is marked with a :fontawesome-solid-lock: symbol in the case description, case list, and linked elements. The background color is also orange for easy recognition.

### Merging a restricted case

If you [merge one or more restricted cases with visible cases](merge-cases.md), the newly created merged case automatically inherits restricted visibility.

The list of authorized users includes all users who had access to any of the restricted cases involved in the merge.

<h2>Next steps</h2>

* [Find a Case](../cases/search-for-cases/find-a-case.md)
* [Create a Case](../cases/create-a-new-case.md)
* [Merge Cases](../cases/merge-cases.md)
* [Restrict Case Visibility](restrict-visibility-case.md)
* [Restore Case Visibility](restore-visibility-case.md)
* [Add a Link to a Case](add-a-link-to-a-case.md)
* [Remove a Link from a Case](remove-a-link-from-a-case.md)
* [View Links in a Case](view-links-in-a-case.md)