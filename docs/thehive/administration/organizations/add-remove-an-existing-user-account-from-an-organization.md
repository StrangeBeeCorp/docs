# Add or Remove an Existing User Account from an Organization

This topic provides step-by-step instructions for adding or removing an existing user account from an [organization](about-organizations.md) in TheHive.

To create a new user account and assign it to an organization, see [Create a User Account](../../user-guides/organization/configure-organization/manage-user-accounts/create-a-user-account.md).

To permanently delete a user account from all organizations, see [Delete a User Account](../../user-guides/organization/configure-organization/manage-user-accounts/delete-a-user-account.md).

<h2>Procedure</h2>

### As an administrator

{!includes/administrator-access-manage-user-accounts.md!}

1. {!includes/users-view-go-to.md!}

2. Locate the user account you're looking for, hover over it, and select :fontawesome-solid-eye:.

3. In the drawer, go to the **Organizations** section. Select the organizations to assign to the user account, and choose a [permission profile](../../administration/profiles/about-profiles.md) for each one. To remove access, deselect the corresponding organizations.

    !!! tip "Remove multiple user accounts in bulk from an organization"
        To remove multiple user accounts from an organization, go to the **Organizations** view and select the target organization. Select :fontawesome-regular-square: next to each account, then choose :fontawesome-solid-trash: and confirm with **OK**.

4. Select **Confirm**.

### As an organization administrator

{!includes/access-manage-user-accounts.md!}

!!! info "Adding existing users not supported"
    As an organization administrator, you can remove an existing user from an organization or [create a new user account](../../user-guides/organization/configure-organization/manage-user-accounts/create-a-user-account.md#as-an-organization-administrator), but you can't add an existing user. To do so, ask someone with an admin-type profile.

1. {!includes/organization-view-go-to.md!}

2. {!includes/users-tab-go-to.md!}

3. Select :fontawesome-solid-ellipsis: next to the user account you want to remove from the organization.

4. Select **Delete**.

    !!! warning "Possible deletion"
        Removing a user account from an organization automatically deletes the account if it isn't assigned to any other organization.

5. Select **OK**.

!!! tip "Remove multiple user accounts in bulk from an organization"
    To remove multiple user accounts from an organization, select :fontawesome-regular-square: next to each account, then choose :fontawesome-solid-trash: and confirm with **OK**.

<h2>Next steps</h2>

* [Link an Organization](link-an-organization.md)
* [Lock an Organization](lock-an-organization.md)