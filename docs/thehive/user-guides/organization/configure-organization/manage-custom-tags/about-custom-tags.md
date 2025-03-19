# About Custom Tags

Custom tags are [one of the tag categories](../../../analyst-corner/cases/tags/about-tags.md#sources) in TheHive.

These free-text labels are created when users add them directly to cases, alerts, or observables.

This topic explains how custom tags are created and used.

## Scope

Custom tags are specific to a single organization and can't be shared between organizations or TheHive instances. You can include sensitive data in tags without the risk of data leakage outside the organization.

## Sources

Custom tags can be created:

* Manually by users
* Automatically by connected external tools
* Automatically by [email servers](../../../../administration/email-intake-connector.md)
* Automatically by [alert feeders]()

## Rules

!!! tip "Consistent naming"
    Tag usage must be consistent, as TheHive does not enforce standardization. For example, tags with different formatting, such as *Phishing* and *phishing*, are treated as separate tags.

You can't add a custom tag that already exists in a [taxonomy](../../../../administration/taxonomies/about-taxonomies.md), even if the taxonomy is deactivated.

## Actions

You can manage custom tags by:

* [Changing the color of a custom tag](change-the-color-of-a-custom-tag.md)
* [Renaming a custom tag](rename-a-custom-tag.md)
* [Deleting a custom tag](delete-a-custom-tag.md)

!!! warning "Changes applied everywhere"
    Modifying or deleting a custom tag applies to all instances of that tag across cases, alerts, and observables within the organization.

You can also [view the number of times a custom tag appears](view-custom-tag-statistics.md) in cases, case templates, alerts, and observables. This helps with cleanup and maintaining consistent naming.

## Permissions

## Next steps

