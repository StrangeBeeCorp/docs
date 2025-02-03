# How to Share or Unshare a Task

This topic provides step-by-step instructions for configuring [local sharing rules](../../../administration/organizations/about-organizations-sharing-rules.md#local-sharing-rules) on tasks with [linked organizations](../../../administration/organizations/link-an-organization.md) for a specific case in TheHive.

!!! info "Global sharing rules"
This guide focuses on local sharing rules on tasks for individual cases. To configure global sharing rules for tasks across all cases in your organization, refer to [Create an Organization](../../../administration/organizations/create-an-organization.md).

To learn more about how sharing rules function and interact, see [About Organizations Sharing Rules](../../../administration/organizations/about-organizations-sharing-rules.md).

{!includes/access-manage-case-sharing.md!}

1. [Locate the case where you want to modify the tasks sharing rules](../../analyst-corner/cases/search-for-cases/find-a-case.md).

2. On the case description, select ![Sharing button](../../../../images/user-guides/analyst-corner/cases/sharing-button.png).

    !!! warning "Bulk actions not allowed"
        You must modify local sharing rules on tasks individually. Bulk actions are not supported.

3. If the case is shared with at least one linked organization, select the tasks sharing rules to apply using the dropdown list.

    {!includes/sharing-rules-case.md!}

    !!! info "Sharing existing tasks"
    Tasks sharing rules apply only to new tasks. Existing tasks will not be shared automatically when updating the rules.

    If the case is not shared with any linked organization, refer to [Share or Unshare a Case](share-unshare-a-case.md).

4. [Optional] To apply the new rules to existing tasks, follow these steps:
    4.1 Select **Manage case sharings** again.
    4.2 Turn off the **Share this case?** toggle for the relevant organization.
    4.3 Select **Confirm**.
    4.4 Select **Manage case sharings** again.
    4.5 Turn on the **Share this case?** toggle for the relevant organization.
    4.6 Select **Confirm**.
    4.7 Select **Confirm** again.

## Next steps

* [Share or Unshare an Observable](../cases/share-unshare-an-observable.md)
* [Share or Unshare a Case](share-unshare-a-case.md)