# About Profiles

A profile is assigned to each user account within an organization in TheHive and determines the permissions available to that user in that context.

## Profile types

TheHive includes three profile types, each serving distinct organizational needs:

* Administration: Reserved for users who belong to the [Admin organization](../organizations/about-organizations.md#default-setup). These profiles grant platform-wide administrative capabilities.
* Organization: Applied to users in Non-Admin organizations. These profiles control access to operational features like case management, alert handling, and observable analysis.
* <!-- md:version 5.6 --> <!-- md:license Platinum --> External: Applied to users accessing [TheHive Portal](../thehive-portal/about-thehive-portal.md). These profiles provide limited access for stakeholders outside the Security team.

Each profile belongs to only one type and contains permissions specific to that type. The available permissions depend on whether the profile is an administration, organization, or external type, ensuring clear separation of access levels.

## Permission structure

Permissions in TheHive follow a consistent naming pattern: `manageEntity`, where `Entity` represents a specific platform component. Each `manageEntity` permission grants complete control over its associated entity—the ability to create, read, update, and delete.

For example, the `manageCase` permission allows users to create, update, and delete cases.

Permissions work cumulatively. Users with multiple permissions can perform actions across all granted areas.

## Predefined profiles

TheHive provides six predefined profiles that cover common organizational roles:

* Admin: Full platform administration
* Org-Admin: Organization-level administration
* Analyst: Standard security analyst operations
* Read-Only: View-only access across the platform
* <!-- md:version 5.6 --> <!-- md:license Platinum --> External-Reader: Read-only access through [TheHive Portal](../thehive-portal/about-thehive-portal.md)
* <!-- md:version 5.6 --> <!-- md:license Platinum --> External-Actor: Interactive access through [TheHive Portal](../thehive-portal/about-thehive-portal.md)

These profiles can't be modified or deleted—except for the Analyst profile.

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
* all permissions included in external-type profiles

When [creating or editing a profile](create-a-profile.md), licensed permissions are clearly marked to help identify which ones affect license usage. When [assigning a user to an organization](../../administration/organizations/add-remove-an-existing-user-account-from-an-organization.md), profiles that include at least one licensed permission are also marked accordingly.

## Permissions

Only users with an admin-type profile that has the `manageProfile` permission can manage permission profiles in TheHive.

<h2>Next steps</h2>

* [Create a Profile](create-a-profile.md)
* [Add or Remove Permissions from a Profile](add-remove-permissions-from-a-profile.md)
* [Delete a Profile](delete-a-profile.md)