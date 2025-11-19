# Export a Case to MISP

Manually export a [case](../cases/about-cases.md) from TheHive to the Malware Information Sharing Platform [(MISP)](https://www.misp-project.org/) to share your investigation results with the community.

Only observables marked as indicators of compromise (IOCs) are exported in the case. Once exported to MISP, any updates to the case IOCs is automatically synchronized with MISP, requiring no manual intervention.

!!! info "Requirements"
    The MISP server you want to share your case with must be [configured with either the *Import and export* or *Export only* purpose](../../../administration/misp-integration/connect-a-misp-server.md). If it’s configured for *Import and export*, TheHive automatically creates alerts with the *Imported* status once the events linked to the IOCs you shared to MISP are published.

!!! warning "MISP actions required"
    The event created in MISP isn't published by default. You must review it and update its status in MISP to publish it.

<h2>Procedure</h2>

1. [Locate the case](../cases/search-for-cases/find-a-case.md) you want to export.

2. In the case, select the **Export** button.

    ![Export a case](/thehive/images/user-guides/analyst-corner/cases/export-a-case.png)

3. Select the relevant servers in the **Export to MISP** section.

4. Select **Export**.

<h2>Next steps</h2>

* [Create a Case](create-a-new-case.md)