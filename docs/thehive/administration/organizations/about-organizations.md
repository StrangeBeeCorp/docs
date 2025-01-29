# About Organizations

Organizations are the customers or tenants, such as separate divisions or business units, that use TheHive independently.

## Default setup

TheHive includes a default Admin organization for users with administrator-type permissions. This organization is designed to manage global configurations, such as organizations, users, entities, and platform settings. 

Non-admin organizations are intended for managing operations on cases, alerts, and tasks.

By default, organizations are isolated and cannot see or share data with each other. To enable data sharing, users in the Admin organization with the necessary permissions must [link organizations](organization-links.md).

## Organizations and users

Users can be assigned to one or more organizations.

When assigning a user to an organization, the system suggests only [permission profiles](../../administration/profiles.md) that match the organization's type (Admin or Non-Admin).

## Permissions

To access the **Organizations** view, you must be a member of the Admin organization with a profile that includes the `manageOrganisation` permission.

To assign users to organizations, you must be a member of the Admin organization with a profile that includes the `manageUser` permission.

## Next steps

* [How to Link Organizations](organization-links.md)
* [Manage Users in your Organization](../../user-guides/organisation/accounts.md)