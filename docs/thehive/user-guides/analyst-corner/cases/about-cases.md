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

* [Feeders](../../../user-guides/organization/configure-organization/manage-feeders/about-feeders.md): Create a case using data retrieved from external systems through a feeder.

* [Alerts](../cases/create-a-new-case.md#create-a-case-from-an-alert): Convert alerts from connected detection tools (SIEM, EDR, IDS, or firewalls), threat intelligence platforms (like MISP), or [email servers](../../../administration/email-intake-connector.md) into cases for further investigation.

* [Detection tools](../cases/create-a-new-case.md#create-a-case-from-a-detection-tool) (SIEM, EDR, IDS, or firewalls): Create cases directly from your detection tools if you prefer to manage alert triage there or if you trust the tool to generate mostly true positives.

## Key components

In TheHive, a case includes the following elements:

* [Observables](../cases/cases-description/observables.md): Data points such as IP addresses, file hashes, domains, and email addresses that are relevant to an investigation.

* [Tasks](../tasks/about-tasks.md): Actions assigned to analysts to analyze, assess, and mitigate threats.

* [TTPs](../cases/cases-description/ttps.md): The methods and strategies used by attackers, based on the [MITRE ATT&CK](https://attack.mitre.org/) knowledge base.

## Next steps

* [Find a Case](../cases/search-for-cases/find-a-case.md)
* [Create a Case](../cases/create-a-new-case.md)