# About Taxonomies

Taxonomies are catalogs of structured tags managed in TheHive. They are [one of the tag categories](../../user-guides/analyst-corner/cases/tags/about-tags.md) that can be added to cases, alerts, or observables.

This topic explains how taxonomies are created and used.

## Sources

Taxonomies can be created in two ways:

* From MISP: MISP taxonomies are imported by default when you install TheHive.
* From custom files: You can [import custom taxonomies](create-custom-taxonomies.md) as needed.

## Actions

!!! info "TheHive upgrades don't update MISP taxonomies"
    Upgrading TheHive doesn't automatically update MISP taxonomies. To update them, you must perform [a manual update](update-taxonomies.md).

You can't modify taxonomies or their tags. 

However, you can:

* [Deactivate taxonomies](activate-deactivate-taxonomy.md)
* [Delete taxonomies](delete-a-taxonomy.md)

## Permissions

{!includes/administrator-access-manage-taxonomies.md!}

Once created, tags from activated taxonomies can be added by users to cases, alerts, and observables.

## Next steps

* [Activate Deactivate a Taxonomy](activate-deactivate-a-taxonomy.md)
* [Create a Custom Taxonomy](create-a-custom-taxonomy.md)
* [Update Taxonomies](update-taxonomies.md)
* [Delete a Taxonomy](delete-a-taxonomy.md)