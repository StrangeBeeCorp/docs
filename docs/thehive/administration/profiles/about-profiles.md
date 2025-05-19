# About Profiles

Profiles are assigned to user accounts for each organization. Each profile is linked to a specific set of permissions that control what the user can do within that organization.

This topic provides a general overview of how profiles work in TheHive.

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

* Licensed: Consume a Gold or Platinum license
* Unlicensed: Don't affect license usage

The following permissions are considered unlicensed:

* `manageDashboard`
* `manageUser`
* `manageConfig`
* `manageKnowledgeBase`

When [creating or editing a profile](create-a-profile.md), licensed permissions are clearly marked to help identify which ones affect license usage. When [assigning a user to an organization](../../administration/organizations/add-remove-an-existing-user-account-from-an-organization.md), profiles that include at least one licensed permission are also marked accordingly.

All permissions in administration-type profiles are treated as unlicensed.

## Permissions

{!includes/administrator-access-manage-profiles.md!}

<h2>Next steps</h2>

* [Create a Profile](create-a-profile.md)
* [Add or Remove Permissions from a Profile](add-remove-permissions-from-a-profile.md)
* [Delete a Profile](delete-a-profile.md)