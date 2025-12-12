# About Profiles

A profile is assigned to each user account within an organization in TheHive and determines the permissions available to that user in that context.

## Profile types

Two types of profiles are available in TheHive:

* Administration: Reserved for users who belong to the [Admin organization](../organizations/about-organizations.md#default-setup)
* Organization: Used for all users across Non-Admin organizations

## Profile permissions

Each profile contains a set of permissions that define what users can do within the platform.

Permissions follow the format `manageEntity`, where `Entity` represents a specific component of the application. For example, the `manageCase` permission allows users to create, update, and delete cases.

## Predefined profiles

TheHive includes a set of predefined profiles:

* Analyst
* Admin
* Org-admin
* Read-only

These profiles can't be modified or deleted—except for the analyst profile.

<!-- md:license Gold --> <!-- md:license Platinum --> This set can be extended by [creating custom profiles](create-a-profile.md) tailored to specific needs.

## Licensed vs. unlicensed profiles

<!-- md:version 5.4.3 -->

TheHive separates permissions into two types for organization-type profiles:

* Licensed: Consume a [license](../../installation/licenses/about-licenses.md)
* Unlicensed: Don't affect license usage

These permissions don't require a license:

* `manageDashboard`
* `manageUser`
* `manageConfig`
* `manageKnowledgeBase`
* all permissions included in administration-type profiles

When [creating or editing a profile](create-a-profile.md), licensed permissions are clearly marked to help identify which ones affect license usage. When [assigning a user to an organization](../../administration/organizations/add-remove-an-existing-user-account-from-an-organization.md), profiles that include at least one licensed permission are also marked accordingly.

## Permissions

Only users with an admin-type profile that has the `manageProfile` permission can manage permission profiles in TheHive.

<h2>Next steps</h2>

* [Create a Profile](create-a-profile.md)
* [Add or Remove Permissions from a Profile](add-remove-permissions-from-a-profile.md)
* [Delete a Profile](delete-a-profile.md)