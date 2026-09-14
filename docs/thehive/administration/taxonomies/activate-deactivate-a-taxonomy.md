# Activate or Deactivate a Taxonomy

<!-- md:permission `[admin] manageTaxonomy` -->

Activate or deactivate a [taxonomy](about-taxonomies.md) in TheHive to control which catalogs of structured tags are available for use. Taxonomy status applies to the whole instance, so deactivating a taxonomy affects every organization.

<!-- md:version 5.8 --> To keep a taxonomy active but rule out only some of its tags, [deactivate those tags individually](activate-deactivate-a-taxonomy-tag.md) instead.

!!! warning "Manual activation required"
    By default, MISP taxonomies aren't activated. You must activate them manually.

<h2>Procedure</h2>

1. {% include-markdown "includes/entities-management-view-go-to.md" %}

2. {% include-markdown "includes/taxonomies-tab-go-to.md" %}

3. Select :fontawesome-solid-ellipsis: next to the taxonomy you want to activate or deactivate.

4. Select **Activate** or **Deactivate**, depending on the action you want to take.

<h2>Next steps</h2>

* [Activate or Deactivate a Taxonomy Tag](activate-deactivate-a-taxonomy-tag.md)
* [Add a Custom Taxonomy](add-a-custom-taxonomy.md)
* [Update MISP Taxonomies](update-misp-taxonomies.md)
* [Delete a Taxonomy](delete-a-taxonomy.md)
* [Add or Remove Tags](../../user-guides/analyst-corner/cases/tags/add-remove-tags.md)