# Add or Remove an Existing User Account from an Organization

Add or remove an existing user account from an [organization](about-organizations.md) in TheHive.

If the user account still belongs to at least one other organization, cases, alerts, and tasks assigned to that user in this organization remain assigned to them. TheHive interface then displays their login instead of their name. To find these entities, use the [Global Search](../../user-guides/analyst-corner/cases/search-for-cases/find-a-case.md#method-4-global-search-feature) on all elements with the user's login, then reassign them manually.

If the user account doesn't belong to any other organization, removing it deletes the account. TheHive then automatically unassigns the cases, alerts, and tasks assigned to that user.

When someone leaves your company, follow the steps in [Offboard a User](../../user-guides/organization/configure-organization/manage-user-accounts/offboard-a-user.md) before removing their user account from all its organizations, so their entities are reassigned first.

<!-- md:version 5.8 --> If the user is the only one with access to a case with [restricted visibility](../../user-guides/analyst-corner/cases/case-visibility/restrict-visibility-case.md) in this organization, the removal fails. Give another user access to these cases first.

To create a new user account and assign it to an organization, see [Create a User Account](../../user-guides/organization/configure-organization/manage-user-accounts/create-a-user-account.md).

To permanently delete a user account from all organizations, see [Delete a User Account](../../user-guides/organization/configure-organization/manage-user-accounts/delete-a-user-account.md).

<h2>Procedure</h2>

### As an administrator

<!-- md:permission `[admin] manageUser` -->

1. {% include-markdown "includes/users-view-go-to.md" %}

2. Locate the user account you're looking for, hover over it, and select :fontawesome-solid-eye:.

3. In the drawer, go to the **Organizations** section. Select the organizations to assign to the user account, and choose a [permission profile](../../administration/profiles/about-profiles.md) for each one. To remove access, deselect the corresponding organizations.

    !!! tip "Remove multiple user accounts in bulk from an organization"
        To remove multiple user accounts from an organization, go to the **Organizations** view and select the target organization. Select :fontawesome-regular-square: next to each account, then choose :fontawesome-solid-trash: and confirm with **OK**.

4. Select **Confirm**.

### As an organization administrator

<!-- md:permission `manageUser` -->

!!! info "Adding existing users not supported"
    As an organization administrator, you can remove an existing user from an organization or [create a new user account](../../user-guides/organization/configure-organization/manage-user-accounts/create-a-user-account.md#as-an-organization-administrator), but you can't add an existing user. To do so, ask someone with an admin-type profile.

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/users-tab-go-to.md" %}

3. Select :fontawesome-solid-ellipsis: next to the user account you want to remove from the organization.

4. Select **Delete**.

    !!! warning "Possible deletion"
        Removing a user account from an organization automatically deletes the account if it isn't assigned to any other organization.

5. Select **OK**.

!!! tip "Remove multiple user accounts in bulk from an organization"
    To remove multiple user accounts from an organization, select :fontawesome-regular-square: next to each account, then choose :fontawesome-solid-trash: and confirm with **OK**.

<h2>Next steps</h2>

* [Modify the Default Organization for a User Account](modify-default-organization-user-account.md)
* [Link an Organization](link-an-organization.md)
* [Lock an Organization](lock-an-organization.md)