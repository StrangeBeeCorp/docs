# About MISP

MISP(Malware Information Sharing Platform) is an open-source platform that allows sharing, storing, and correlating Indicators of Compromise (IOCs) of targeted attacks, threat intelligence, financial fraud information, vulnerability information, or even counter-terrorism information. 

Indicators of compromise managed by MISP may originate from various sources, including internal incident investigation teams, intelligence sharing partners, or commercial intelligence sources.

Numerous independent organizations from variuos industries, utilize MISP for threat feeds. The purpose of MISP is to create a platform of trust by locally storing threat information and enhancing malware detection to encourage information exchange among organizations.


TheHive has the ability to connect to one or several MISP instances in order to import and export events. 

TheHive is able to:

* Receive events as they are added or updated from multiple MISP instances. These events will appear within the Alerts pane.
* Export cases as MISP events to one or several MISP instances. The exported cases will not be published automatically though as they need to be reviewed prior to publishing. We strongly advise you to review the categories and types of attributes at least, before publishing the corresponding MISP events.

> Please note that only and all the observables marked as IOCs will be used to create the MISP event. Any other observable will not be shared. This is not configurable.

Within the configuration file, you can register your MISP server(s) under the misp configuration keyword. Each server shall be identified using an arbitrary name, its url, the corresponding authentication key and optional tags to add each observable created from a MISP event. Any registered server will be used to import events as alerts. It can also be used to export cases to as MISP events, if the account used by TheHive on the MISP instance has sufficient rights.

This means that TheHive can import events from configured MISP servers and export cases to the same configured MISP servers.