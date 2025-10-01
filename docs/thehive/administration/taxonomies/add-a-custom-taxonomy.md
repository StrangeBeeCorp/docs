# Add a Custom Taxonomy

This topic provides step-by-step instructions for adding a custom [taxonomy](about-taxonomies.md) in TheHive.

Use this procedure if you want to add taxonomies other than the default imported Malware Information Sharing Platform (MISP) taxonomies.

{% include-markdown "includes/administrator-access-manage-taxonomies.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/entities-management-view-go-to.md" %}

2. {% include-markdown "includes/taxonomies-tab-go-to.md" %}

3. Select **Import taxonomies**.

4. In the **Import taxonomies archive** drawer, drop a ZIP file into the **Taxonomies archive** section or select it from your computer. The ZIP file must contain at least one file named `machinetag.json` that follows the [MISP JSON schema](https://github.com/MISP/misp-taxonomies).

5. Select **Import**.

<h2>Next steps</h2>

* [Activate Deactivate a Taxonomy](activate-deactivate-a-taxonomy.md)
* [Update MISP Taxonomies](update-misp-taxonomies.md)
* [Delete a Taxonomy](delete-a-taxonomy.md)
* [Add or Remove Tags](../../user-guides/analyst-corner/cases/tags/add-remove-tags.md)