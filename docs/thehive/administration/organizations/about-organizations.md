# About Organizations

Organizations are independent tenants in TheHive, such as divisions or business units.

{% include-markdown "includes/license-organizations.md" %}

## Default setup

TheHive includes a default Admin organization for users with administrator-type permissions. This organization manages global configurations, such as organizations, users, entities, and platform settings.

Non-Admin organizations manage operations on cases, alerts, and tasks.

By default, organizations are isolated and can't see or share data with each other. To enable data sharing, users with the necessary permissions must [link organizations](link-an-organization.md).

## Organizations and users

A user can belong to one or more organizations. A profile is assigned for each organization, defining the user's set of permissions within that organization.

[When assigning a user to an organization](add-remove-an-existing-user-account-from-an-organization.md), the system suggests only [permission profiles](../../administration/profiles/about-profiles.md) that match the organization's type (Admin or Non-Admin).

## Permissions

* Only users with an admin-type profile that has the `manageOrganisation` permission can create, link, or lock organizations in TheHive.
* Only users with the `manageUser` permission can assign users to organizations in TheHive.

<h2>Next steps</h2>

* [Create an Organization](create-an-organization.md)
* [Add or Remove an Existing User Account from an Organization](add-remove-an-existing-user-account-from-an-organization.md)
* [Link an Organization](link-an-organization.md)
* [Lock an Organization](lock-an-organization.md)