# Share a Case with Other Organizations

This topic provides step-by-step instructions for configuring [local sharing rules](../../../administration/organizations/about-organizations-sharing-rules.md#local-sharing-rules) with [linked organizations](../../../administration/organizations/link-an-organization.md) for an existing case in TheHive.

!!! info "Global sharing rules"
    This guide focuses on local sharing rules for individual existing cases. To configure global sharing rules for all cases in your organization, refer to [How to Link an Organization](../../../administration/organizations/link-an-organization.md).

To learn more about how sharing rules function and interact, refer to the [About Organizations Sharing Rules](../../../administration/organizations/about-organizations-sharing-rules.md) topic.

{% include-markdown "includes/access-manage-case-sharing.md" %}

<h2>Procedure</h2>

1. [Locate the case you want to share](../../analyst-corner/cases/search-for-cases/find-a-case.md).

2. On the case description, select the **Sharing** button.

    ![Sharing a case](/thehive/images/user-guides/analyst-corner/cases/sharing-a-case.png)

3. Select the tasks sharing rules to apply.

    Pick an option from the dropdown list:

    * **manual** (default): Tasks aren't shared automatically. Users must [share them manually](../tasks/share-a-task.md).
    * **autoShare**: Tasks are shared automatically.

4. Select the observables sharing rules to apply.

    Pick an option from the dropdown list:
    
    * **manual** (default): Observables aren't shared automatically. Users must [share them manually](../cases/share-an-observable.md).
    * **autoShare**: Observables are shared automatically.

    !!! warning "Task and observable sharing scope"
        Task and observable sharing rules apply to all linked organizations the case is shared with.

5. Select **Confirm**.

6. Select **Manage case sharings**.

7. Turn on the **Share this case** toggle for each relevant organization and select the appropriate [permission profile](../../../administration/profiles/about-profiles.md).

8. Select **Confirm**.

<h2>Next steps</h2>

* [Share a Task with Other Organizations](../tasks/share-a-task.md)
* [Share an Observable with Other Organizations](share-an-observable.md)
