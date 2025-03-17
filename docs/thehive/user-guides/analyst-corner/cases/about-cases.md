# About Cases

This topic explains cases, their components, and how to create them in TheHive.

## Definition

A case is a structured entity used to track, investigate, and respond to security incidents, threats, or suspicious activities. It serves as a central repository where security teams organize information, collaborate on investigations, and document their findings.

## Sources

In TheHive, you can create a case from the following sources:

* [Manual entry](../cases/create-a-new-case.md#create-an-empty-case): Create a case manually by entering details.

* [Merging cases](#merging-cases): Merging cases creates a new case and deletes the original merged cases.

* [Case templates](../cases/create-a-new-case.md#create-a-case-from-a-template): Use predefined templates to standardize and simplify case creation.

* [Archived cases](../cases/create-a-new-case.md#create-a-case-from-an-archived-case): Restore cases from previous investigations stored in TheHive.

* [MISP event files](../cases/create-a-new-case.md#create-a-case-from-a-misp-event): Create cases by manually importing MISP events for further investigation.

* [Alerts](../cases/create-a-new-case.md#create-a-case-from-an-alert): Convert alerts from connected detection tools (SIEM, EDR, IDS, or firewalls), threat intelligence platforms (like MISP), or [email servers](../../../administration/email-intake-connector.md) into cases for further investigation.

* [Detection tools](../cases/create-a-new-case.md#create-a-case-from-a-detection-tool) (SIEM, EDR, IDS, or firewalls): Create cases directly from your detection tools if you prefer to manage alert triage there or if you trust the tool to generate mostly true positives.

## Key components

In TheHive, a case includes the following elements:

* [Observables](../cases/cases-description/observables.md): Data points such as IP addresses, file hashes, domains, and email addresses that are relevant to an investigation.

* [Tasks](../tasks/about-tasks.md): Actions assigned to analysts to analyze, assess, and mitigate threats.

* [TTPs](../cases/cases-description/ttps.md): The methods and strategies used by attackers, based on the [MITRE ATT&CK](https://attack.mitre.org/) knowledge base.

## Merging cases

{!includes/access-merge-cases.md!}

You can merge two cases if they share the same organization and permission profile pairs.

Merging cases deletes the original cases and creates a new case that combines elements from both.

To learn how to merge cases, see [Merge Cases](../cases/merge-cases.md).

## Visibility

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

* For unauthorized users: The restricted case doesn't appear in case lists, search results, or dashboards. All related elements, including observables, tasks, and attachments, are also hidden. Unauthorized users can't be assigned to the case.

* For authorized users: The restricted case appears in case lists, search results, or dashboards. Authorized users can be assigned to the case.

#### Indicators

A restricted case is identifiable as follows:

* For unauthorized users: The restricted case doesn't appear in case lists, search results, or dashboards, except in [an alert linked to the restricted case](../alerts/alerts-description/new-case-from-selection.md). In such an alert, a :fontawesome-solid-lock: symbol appears alongside the case number inside an orange warning box.

* For authorized users: The restricted case is identified by a :fontawesome-solid-lock: symbol in the case description and case list. Additionally, the background color in the case list is orange for easy recognition.

### Merging a restricted case

If you [merge one or more restricted cases with visible cases](merge-cases.md), the newly created merged case automatically inherits restricted visibility.

The list of authorized users includes all users who had access to any of the restricted cases involved in the merge.

## Linking cases

{!includes/case-links-v55.md!}

{!includes/access-manage-case-links.md!}

You can link a case to other cases and external resources in TheHive. This enhances traceability and supports the investigation of complex incidents involving multiple related cases and assets.

### Link types

You can link cases to:

* Other TheHive cases
* External resources

### Link categories

Each link is categorized to reflect the relationship type. If you don’t specify a category, *Internal link* is automatically applied when linking TheHive cases, and *External link* when linking external resources.

### Actions

You can create or delete a link, but you can’t modify it after it’s created.

### Behavior

#### XXXX

When linking two TheHive cases together, it will appear in the second one automatically. Case links are automatically removed id the case has been deleted. The linking cases only display cases from the current organisation and red cases linked to the current organisation that the logged-in user has access to. Case links are not included in any export of case data.

#### Links behavior when merging cases

Merge case : merge of the links and deduplication
The system will perform a deduplication process based on the combination of the link and link type to ensure no duplicate links are added.
Any links pointing to the source merged cases will be removed.

#### Links behavior when merge a case into an alert

When merging a case into an alert, external URL linked to the alert as an external link. When an alert is imported into a case, the system automatically links the external alert URL to the case under the link type "External alert link" (field externalLink). When a user unlinks an alert from a case, the corresponding case link is automatically removed from the "Linked elements" section of the case.

#### Links behavior when linking a private case

When a private case link is added, the linked case will display an orange background and a lock icon with title and number. (Only if the logged in user have the access). If user don’t have access to this private case, he don’t see it.

## Next steps

* [Find a Case](../cases/search-for-cases/find-a-case.md)
* [Create a Case](../cases/create-a-new-case.md)
* [Merge Cases](../cases/merge-cases.md)
* [Restrict Case Visibility](restrict-visibility-case.md)
* [Restore Case Visibility](restore-visibility-case.md)