# How to Update MISP Taxonomies

This topic provides step-by-step instructions for updating MISP [taxonomies](about-taxonomies.md) in TheHive.

!!! info "TheHive upgrades don't update MISP taxonomies"
     TheHive includes the version of [MISP taxonomies](https://www.misp-project.org/taxonomies.html) available at the time of installation. Upgrading TheHive doesn't automatically update MISP taxonomies. To update them, you must perform a manual update.

{!includes/administrator-access-manage-taxonomies.md!}

## Procedure

1. {!includes/entities-management-view-go-to.md!}

2. {!includes/taxonomies-tab-go-to.md!}

3. Select **Import taxonomies**.

4. In the **Import taxonomies archive** drawer, download the latest archive of the official MISP taxonomies.

5. Drop the downloaded ZIP file into the **Taxonomies archive** section or select it from your computer.

6. Select **Import**.

## Next steps

* [Add a Custom Taxonomy](add-a-custom-taxonomy.md)
* [Activate Deactivate a Taxonomy](activate-deactivate-a-taxonomy.md)
* [Delete a Taxonomy](delete-a-taxonomy.md)
* [Add Tags to a Case](../../../analyst-corner/cases/tags/add-tags-to-a-case.md)
* [Remove Tags from a Case](../../../analyst-corner/cases/tags/remove-tags-from-a-case.md)
* [Add Tags to an Observable](../../../analyst-corner/cases/tags/add-tags-to-an-observable.md)
* [Remove Tags from an Observable](../../../analyst-corner/cases/tags/remove-tags-from-an-observable.md)
* [Add Tags to an Alert](../../../analyst-corner/alerts/add-tags-to-an-alert.md.md)
* [Remove Tags from an Alert](../../../analyst-corner/alerts/remove-tags-from-an-alert.md.md.md)