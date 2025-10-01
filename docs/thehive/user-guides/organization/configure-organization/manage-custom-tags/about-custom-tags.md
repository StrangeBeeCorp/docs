# About Custom Tags

Custom tags are [one of the tag categories](../../../analyst-corner/cases/tags/about-tags.md#sources) in TheHive.

These free-text labels are created when users add them to cases, alerts, or observables.

This topic explains how custom tags work.

## Scope

Custom tags are specific to a single organization and can't be shared between organizations or TheHive instances. Tags can contain sensitive data without risking exposure outside the organization.

## Sources

Custom tags can be created:

* Manually by users when added to cases, alerts, or observables
* Automatically by connected external tools
* Automatically by [email servers](../../../../administration/email-intake-connector/about-email-intake-connectors.md)
* Automatically by [alert feeders](../manage-feeders/about-feeders.md)

## Actions

* Create custom tags by adding them directly to cases, alerts, and observables. Custom tags can't duplicate tags already present in a [taxonomy](../../../../administration/taxonomies/about-taxonomies.md), even if that taxonomy is deactivated.

    !!! tip "Consistent naming"
        Tag usage must be consistent, as TheHive doesn't enforce standardization. For example, tags with different formatting, such as *Phishing* and *phishing*, are treated as separate tags.

* Manage custom tags by:

    * [Changing the color of a custom tag](change-the-color-of-a-custom-tag.md)
    * [Renaming a custom tag](rename-a-custom-tag.md)
    * [Deleting a custom tag](delete-a-custom-tag.md)

    !!! warning "Changes applied everywhere"
        Modifying or deleting a custom tag applies to all instances of that tag across cases, alerts, and observables within the organization.

* [View the number of times a custom tag appears](view-custom-tag-statistics.md) in cases, case templates, alerts, and observables. This helps with cleanup and maintaining consistent naming.

## Permissions

{% include-markdown "includes/access-manage-custom-tags.md" %}

Users can create new custom tags by adding them directly to cases, alerts, and observables.

<h2>Next steps</h2>

* [Change the Color of a Custom Tag](change-the-color-of-a-custom-tag.md)
* [Rename a Custom Tag](rename-a-custom-tag.md)
* [View Custom Tag Statistics](view-custom-tag-statistics.md)
* [Delete a Custom Tag](delete-a-custom-tag.md)
