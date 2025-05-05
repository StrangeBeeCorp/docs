# About User Accounts

This topic explains how user accounts are managed in TheHive.

## Types

<!-- md:version 5.0 --> 

TheHive supports two types of user accounts:

* Normal accounts: Intended for users who access TheHive through the web interface. Normal accounts support all authentication methods. These accounts can also generate API keys if enabled.

* Service accounts: Designed for programmatic access to TheHive via the API. Service accounts are typically used for automation tasks, such as creating alerts. They authenticate exclusively using an API key and can't sign in to the web interface.

## Organizations

Each use account belongs to one or more [organizations](../../../../administration/organizations/about-organizations.md). If a user is linked to multiple organizations, they can [switch between them at any time](../../../switch-organizations.md).

## Profiles

Each user account is assigned a [profile](../../../../administration/profiles.md). Profiles define the set of permissions available to the user.

## Permissions

{!includes/administrator-access-manage-user-accounts.md!}

{!includes/access-manage-user-accounts.md!}

<h2>Next steps</h2>

* [Create a User Account](create-a-user-account.md)
* [Delete a User Account](delete-a-user-account.md)
* [Lock a User Account](lock-a-user-account.md)
* [Export a List of User Accounts](export-list-user-accounts.md)
* [Manage User Accounts](manage-user-accounts.md)