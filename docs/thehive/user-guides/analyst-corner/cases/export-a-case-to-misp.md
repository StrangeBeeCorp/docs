# How to Export a Case to MISP

This topic provides step-by-step instructions for manually exporting a [case](../cases/about-cases.md) to [MISP](https://www.misp-project.org/) in TheHive.

Use this procedure to share the results of your investigations with this open-source threat intelligence and sharing platform and contribute to the community.

Only observables marked as IOCs will be exported in the case. Once exported to MISP, any updates to the case IOCs is automatically synchronized with MISP, requiring no manual intervention.

!!! info "Requirements"
    The MISP server you want to share your case with must be [configured with either the *Import and export* or *Export only* purpose](../../../administration/misp-integration/connect-a-misp-server.md).

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