# About Organizations

Organizations are the customers or tenants, such as separate divisions or business units, that use TheHive independently.

## Default setup

TheHive includes a default Admin organization for users with administrator-type permissions. This organization is designed to manage global configurations, such as organizations, users, entities, and platform settings. 

Non-Admin organizations are intended for managing operations on cases, alerts, and tasks.

By default, organizations are isolated and cannot see or share data with each other. To enable data sharing, users with the [necessary permissions](#permissions) must [link organizations](link-an-organization.md).

## Organizations and users

Users can be assigned to one or more organizations.

[When assigning a user to an organization](add-users-to-an-organization.md), the system suggests only [permission profiles](../../administration/profiles.md) that match the organization's type (Admin or Non-Admin).

## Permissions

{!includes/administrator-access-manage-organizations.md!}

## Next steps

* [Create an Organization](create-an-organization.md)
* [Add Users to an Organization](add-users-to-an-organization.md)
* [Link an Organization](link-an-organization.md)
* [Lock an Organization](lock-an-organization.md)