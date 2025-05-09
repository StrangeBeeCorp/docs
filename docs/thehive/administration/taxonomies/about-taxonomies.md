# About Taxonomies

Taxonomies are catalogs of structured tags managed in TheHive. They're [one of the tag categories](../../user-guides/analyst-corner/cases/tags/about-tags.md) that can be added to cases, alerts, or observables.

This topic explains how taxonomies work.

## Sources

Taxonomies can be created in two ways:

* From MISP: [MISP taxonomies](https://github.com/MISP/misp-taxonomies) are imported by default when you install TheHive.

    !!! warning "Manual activation required"
        By default, MISP taxonomies aren't activated. You must [activate them manually](activate-deactivate-a-taxonomy.md).

* From custom files: You can [import custom taxonomies](add-a-custom-taxonomy.md) as needed.

## Actions

!!! info "MISP taxonomy upgrades"
    TheHive includes the version of [MISP taxonomies](https://www.misp-project.org/taxonomies.html) available at the time of installation. Upgrading TheHive doesn't automatically update MISP taxonomies. To update them, you must perform [a manual update](update-misp-taxonomies.md).

You can't modify taxonomies or their tags. 

However, you can:

* [Deactivate taxonomies](activate-deactivate-a-taxonomy.md)
* [Delete taxonomies](delete-a-taxonomy.md)

## Permissions

{!includes/administrator-access-manage-taxonomies.md!}

Once created, tags from activated taxonomies are available to add to cases, alerts, and observables.

<h2>Next steps</h2>

* [Activate Deactivate a Taxonomy](activate-deactivate-a-taxonomy.md)
* [Add a Custom Taxonomy](add-a-custom-taxonomy.md)
* [Update MISP Taxonomies](update-misp-taxonomies.md)
* [Delete a Taxonomy](delete-a-taxonomy.md)