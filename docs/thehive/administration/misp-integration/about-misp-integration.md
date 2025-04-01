# About MISP Integration

This topic explains how the malware information sharing platform (MISP) is integrated with TheHive.

## What is MISP?

[MISP](https://www.misp-project.org/) is an open-source threat intelligence platform designed to improve the sharing of structured threat information, including indicators of compromise (IOCs), tactics, techniques, and procedures (TTPs), and other relevant data. 

MISP enables organizations to share, store, and correlate security information to enhance their cybersecurity efforts and collaborate with other organizations or threat intelligence communities.

## Connections with TheHive

TheHive integrates with MISP in several ways:

* [Default import of MISP taxonomies](../taxonomies.md) during TheHive installation
* [Automatic connections](add-a-misp-server.md) to retrieve events from one or more MISP servers and convert them into alerts in TheHive
* [Manual import of MISP events into TheHive as cases](../../user-guides/analyst-corner/cases/create-a-new-case.md#create-a-case-from-a-misp-event)
* [Manual export of cases to MISP as events](../../user-guides/analyst-corner/cases/export-a-case-to-misp.md) for sharing information with the community

## Permissions

{!includes/administrator-access-manage-misp-servers.md!}

<h2>Next steps</h2>

* [Add a MISP Server](add-a-misp-server.md)
* [Remove a MISP Server](remove-a-misp-server.md)