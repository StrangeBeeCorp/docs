# How to Export a Case to MISP

This topic provides step-by-step instructions for exporting a [case](../cases/about-cases.md) to [MISP](https://www.misp-project.org/) in TheHive.

This is useful if you want to share the results of your investigations with this open-source threat intelligence and sharing platform and contribute to the community.

Only observables marked as IOCs will be exported in the case. Once exported to MISP, any updates to the case IOCs is automatically synchronized with MISP, requiring no manual intervention.

!!! info "Manual export to MISP only"
    You must manually export cases to MISP, as each case requires individual review.

!!! warning "MISP actions required"
    The event created in MISP is not published by default. You must review it and update its status in MISP to publish it.

## Procedure

1. [Locate the case](../cases/search-for-cases/find-a-case.md) you want to export.

2. In the case description, select the **Export** button.

    ![Export a case](/thehive/images/user-guides/analyst-corner/cases/export-a-case.png)

3. Select the relevant servers in the **Export to MISP** section.

4. Select **Export**.

## Next steps

* [Create a Case](create-a-new-case.md)