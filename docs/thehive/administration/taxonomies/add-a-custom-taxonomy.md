# How to Add a Custom Taxonomy

This topic provides step-by-step instructions for adding a custom [taxonomy](about-taxonomies.md) in TheHive.

This is useful if you want to add taxonomies other than the default imported MISP taxonomies.

{!includes/administrator-access-manage-taxonomies.md!}

## Procedure

1. {!includes/entities-management-view-go-to.md!}

2. {!includes/taxonomies-tab-go-to.md!}

3. Select **Import taxonomies**.

4. In the **Import taxonomies archive** drawer, drop a ZIP file into the **Taxonomies archive** section or select it from your computer. The ZIP file must contain at least one file named `machinetag.json` that follows the [MISP JSON schema](https://github.com/MISP/misp-taxonomies).

5. Select **Import**.

## Next steps

* [Activate Deactivate a Taxonomy](activate-deactivate-a-taxonomy.md)
* [Update MISP Taxonomies](update-misp-taxonomies.md)
* [Delete a Taxonomy](delete-a-taxonomy.md)
* [Add Tags to a Case](../../../analyst-corner/cases/tags/add-tags-to-a-case.md)
* [Remove Tags from a Case](../../../analyst-corner/cases/tags/remove-tags-from-a-case.md)
* [Add Tags to an Observable](../../../analyst-corner/cases/tags/add-tags-to-an-observable.md)
* [Remove Tags from an Observable](../../../analyst-corner/cases/tags/remove-tags-from-an-observable.md)
* [Add Tags to an Alert](../../../analyst-corner/alerts/add-tags-to-an-alert.md.md)
* [Remove Tags from an Alert](../../../analyst-corner/alerts/remove-tags-from-an-alert.md.md.md)