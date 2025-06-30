# About MISP Integration

This topic explains how the malware information sharing platform (MISP) integrates with TheHive.

{!includes/upgrade-misp.md!}

## What's MISP?

[MISP](https://www.misp-project.org/) is an open-source threat intelligence platform designed to improve the sharing of structured threat information. This includes indicators of compromise (IOCs), tactics, techniques, procedures (TTPs), and other relevant data.

MISP enables organizations to share, store, and correlate security information to enhance their cybersecurity efforts and collaborate with other organizations or threat intelligence communities.

## Connections with TheHive

TheHive integrates with MISP in several ways:

* [Default import of MISP taxonomies](../../administration/taxonomies/about-taxonomies.md) during TheHive installation
* [Automatic connections](connect-a-misp-server.md) to retrieve events from one or more MISP servers and convert them into alerts in TheHive
* [Manual import of MISP events into TheHive as cases](../../user-guides/analyst-corner/cases/create-a-new-case.md#create-a-case-from-a-misp-event)
* [Manual export of cases to MISP as events](../../user-guides/analyst-corner/cases/export-a-case-to-misp.md) for sharing observables marked as IOCs with the community

!!! note "Multiple MISP servers"
    TheHive supports connecting multiple MISP servers only with a paid license.

## Permissions

{!includes/administrator-access-manage-misp-servers.md!}

<h2>Next steps</h2>

* [Connect a MISP Server](connect-a-misp-server.md)
* [Delete a MISP Server Connection](delete-a-misp-server.md)