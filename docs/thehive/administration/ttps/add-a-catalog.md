# Add a Tactics, Techniques and Procedures Catalog

<!-- md:permission `[admin] managePattern` -->

This topic provides step-by-step instructions for adding a [Tactics, Techniques and Procedures (TTPs)](../../user-guides/analyst-corner/cases/ttps/about-ttps.md) catalog in TheHive.

TTPs describe the behaviors and methods commonly used by specific threat actors or groups.

Use this procedure to add more MITRE catalogs than the [default one included in TheHive](../../user-guides/analyst-corner/cases/ttps/about-ttps.md#mitre-attck-framework).

<h2>Procedure</h2>

1. {% include-markdown "includes/entities-management-view-go-to.md" %}

2. {% include-markdown "includes/attack-patterns-tab-go-to.md" %}

3. Select **Import MITRE ATT&CK patterns**.

4. In the **Import MITRE ATT&CK patterns** drawer, enter a unique name for the catalog. You can’t use a name that’s already taken.

5. Drop a JSON file.

6. Select **Import**.

    !!! info "Hang tight"
        It may take a few seconds to add a TTPs catalog.

<h2>Next steps</h2>

* [Update a Catalog](update-a-catalog.md)
* [Remove a Catalog](remove-a-catalog.md)
* [View Techniques in a Catalog](view-techniques-in-a-catalog.md)