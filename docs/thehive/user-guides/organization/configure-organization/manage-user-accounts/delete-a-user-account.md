# Delete a User Account

<!-- md:permission `[admin] manageUser` -->

Delete a [user account](about-user-accounts.md) from TheHive to permanently remove it at the client level.

TheHive automatically unassigns cases, alerts, and tasks assigned to a deleted user.

When someone leaves your company, follow the steps in [Offboard a User](offboard-a-user.md) before deleting their user account, so their entities are reassigned first.

<!-- md:version 5.8 --> If the user is the only one with access to a case with [restricted visibility](../../../analyst-corner/cases/case-visibility/restrict-visibility-case.md), the deletion fails. Give another user access to these cases first.

!!! danger "Permanent action"
    This action permanently deletes the user account at the client level, removing it from all organizations.

{% include-markdown "includes/reuse-deleted-user-login.md" %}

To lock a user account without deleting it, see [Lock a User Account](lock-a-user-account.md).

To remove a user account from a specific organization without deleting it, see [Add or Remove an Existing User Account to an Organization](../../../../administration/organizations/add-remove-an-existing-user-account-from-an-organization.md).

<h2>Procedure</h2>

1. {% include-markdown "includes/users-view-go-to.md" %}

2. Hover over the user account you want to delete and select :fontawesome-solid-eye:.

    {% include-markdown "includes/find-a-user-account.md" %}

3. In the drawer, select **Delete user**.

    !!! tip "Delete multiple user accounts in bulk"
        To delete multiple user accounts, select :fontawesome-regular-square: next to each account you want to delete. Then select :fontawesome-solid-trash: and confirm with **OK**.

4. Select **OK**.

<h2>Next steps</h2>

* [Create a User Account](create-a-user-account.md)
* [Lock a User Account](lock-a-user-account.md)
* [Export a List of User Accounts](export-list-user-accounts.md)
* [Manage User Accounts](manage-user-accounts.md)
* [Add or Remove an Existing User Account from an Organization](../../../../administration/organizations/add-remove-an-existing-user-account-from-an-organization.md)