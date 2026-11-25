# Offboard a User

<!-- md:permission `[admin] manageUser` --> <!-- md:permission `manageUser` -->

Offboard a user in TheHive when they leave your company, to remove their access and make sure someone else takes over their cases, alerts, and tasks.

<h2>Procedure</h2>

1. [Lock the user account](lock-a-user-account.md) as soon as the person leaves your company.

    Locking blocks access in all organizations, keeps the user's assignments in place, and can be undone if needed. Locked user accounts don't count toward the [license limit](../../../../installation/licenses/about-licenses.md#terms-and-quotas).

2. <!-- md:version 5.4 --> <!-- md:license Platinum --> <!-- md:license ONE --> To keep a record of who handled a case, [save a case report](../../../analyst-corner/cases/case-reports/save-download-a-case-report.md) for each case assigned to the user.

3. Reassign their cases, alerts, and tasks. To find them, use the [Global Search](../../../analyst-corner/cases/search-for-cases/find-a-case.md#method-4-global-search-feature) on all elements with the user's login.

4. If your company's internal policies require it, [delete the user account](delete-a-user-account.md) as an administrator, or [remove it from all its organizations](../../../../administration/organizations/add-remove-an-existing-user-account-from-an-organization.md).

    <!-- md:version 5.8 --> If the user is the only one with access to a case with [restricted visibility](../../../analyst-corner/cases/case-visibility/restrict-visibility-case.md), give another user access to it first. Otherwise, the deletion or removal fails.

    {% include-markdown "includes/reuse-deleted-user-login.md" %}

<h2>Next steps</h2>

* [Lock a User Account](lock-a-user-account.md)
* [Delete a User Account](delete-a-user-account.md)
* [Add or Remove an Existing User Account from an Organization](../../../../administration/organizations/add-remove-an-existing-user-account-from-an-organization.md)
* [Manage User Accounts](manage-user-accounts.md)
