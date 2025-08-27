# Update a Tactics, Techniques and Procedures Catalog

This topic provides step-by-step instructions for updating a [Tactics, Techniques and Procedures (TTPs)](../../user-guides/analyst-corner/cases/ttps/about-ttps.md) catalog in TheHive.

TTPs describe the behaviors and methods commonly used by specific threat actors or groups.

The default and additional MITRE catalogs aren't updated automatically. Use this procedure to get the latest versions.

{!includes/administrator-access-manage-ttps.md!}

<h2>Procedure</h2>

1. {!includes/entities-management-view-go-to.md!}

2. {!includes/attack-patterns-tab-go-to.md!}

3. In the **Import MITRE ATT&CK patterns** drawer, select **Import MITRE ATT&CK patterns**.

4. Select the existing catalog you want to update.

5. Drop a JSON file from the latest version of the [Enterprise ATT&CK](https://raw.githubusercontent.com/mitre/cti/master/enterprise-attack/enterprise-attack.json?version=TheHive-{!includes/thehive-latest-version.md!lines=2}-1-SNAPSHOT) and [Mobile ATT&CK](https://raw.githubusercontent.com/mitre/cti/master/mobile-attack/mobile-attack.json?version=TheHive-{!includes/thehive-latest-version.md!lines=2}-1-SNAPSHOT) MITRE matrices.

6. Select **Import**.

<h2>Next steps</h2>

* [Add a Catalog](add-a-catalog.md)
* [Remove a Catalog](remove-a-catalog.md)
* [View Techniques in a Catalog](view-techniques-in-a-catalog.md)