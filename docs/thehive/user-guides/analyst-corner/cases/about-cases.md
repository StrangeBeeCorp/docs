# About Cases

This topic explains cases, their components, and how to create them in TheHive.

## Definition

A case is a structured entity used to track, investigate, and respond to security incidents, threats, or suspicious activities. It serves as a central repository where security teams organize information, collaborate on investigations, and document their findings.

## Sources

In TheHive, you can create a case from the following sources:

* [Manual entry](../cases/create-a-new-case.md#create-an-empty-case): Create a case manually by entering details.

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

## Visibility

manageCase/changeAccess
ManagePrivateAccess

Platinum licence

!!! note "Restrict access to a case"
    Starting from version 5.5, you can restrict access to sensitive cases.

By default, cases created through the interface are visible to all users in the organization. You can create cases with restricted access using the API.

You can change the visibility of cases to restrict access to sensitive cases to a list of users (at minimum, the assignee and the person performing the action and they can't be removed). You can make it visible to all users again afterwards.

Restricted cases are identified with a :fontawesome-solid-lock: on case descriptions and the list of cases on the cases view. And background color in list is orange.

This feature allows case owners to restrict visibility to designated team members and managers, protecting critical information and minimising the risk of data leaks.

Users who don't have access can see the case but not access to it? Not sure

When a case is defined as private, it and its children (observable, tasks, etc.) no longer appear in the global search results or in the dashboard indicators, regardless of the user connected, which guarantees strict control of its visibility and acceptable performance. This results stay only visible by the selected users.

Only authorized users can be assigned to a case.

This visibilty rules must be apply to children of case (task, observables etc.).

What about tasks, observables, TTPs?

What should be displayed for alerts that are linked to private cases? How do we ensure that sensitive information is not inadvertently exposed through linked alerts?

Impact on merge?

System Behavior:

If at least one of the cases being merged is marked as private, the newly created merged case will also be automatically marked as private.

When multiple private cases are involved in the merge, the merged case will inherit the private status, and the list of authorized users for the new case will include all users who had access to any of the private cases involved in the merge.

The authorized user list for the merged case is a union of all users who had access to any of the private cases that were merged.

No unauthorized users gain access to the merged case if they were not part of the private cases' access list.

What about a case shared between organizations?

Rules:

If the case is public and shared within our organization: label without a lock and clickable.

If the case is public but not shared within our organization: label without a lock and not clickable.

If the case is private and visible to the user: label with a lock and clickable.

If the case is private and not visible to the user: label with a lock and not clickable. (only for alert)

## Next steps

* [Find a Case](../cases/search-for-cases/find-a-case.md)
* [Create a Case](../cases/create-a-new-case.md)