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

!!! note "Restrict case visibility"
    Starting from version 5.5, you can restrict the visibility of sensitive cases.

!!! note "Platinum licence required"
    Only users with a Platinum licence can manage the visibility of their cases.

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

## Next steps

* [Find a Case](../cases/search-for-cases/find-a-case.md)
* [Create a Case](../cases/create-a-new-case.md)
* [Merge Cases](../cases/merge-cases.md)
* [Restrict Case Visibility](restrict-visibility-case.md)
* [Restore Case Visibility](restore-visibility-case.md)