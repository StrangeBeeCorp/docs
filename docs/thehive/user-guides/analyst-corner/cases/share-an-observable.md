# How to Share an Observable

This topic provides step-by-step instructions for configuring [local sharing rules](../../../administration/organizations/about-organizations-sharing-rules.md#local-sharing-rules) with [linked organizations](../../../administration/organizations/link-an-organization.md) for observables linked to a case in TheHive.

!!! info "Global sharing rules"
    This guide focuses on local sharing rules on observables for individual cases. To configure global sharing rules for observables across all cases in your organization, refer to [Create an Organization](../../../administration/organizations/create-an-organization.md).

To learn more about how sharing rules function and interact, see [About Organizations Sharing Rules](../../../administration/organizations/about-organizations-sharing-rules.md).

{!includes/access-manage-case-sharing.md!}

1. [Locate the shared case where you want to modify the observables sharing rules](../../analyst-corner/cases/search-for-cases/find-a-case.md).

2. On the case description, select ![Sharing button](../../../images/user-guides/analyst-corner/cases/sharing-button.png).

3. Select the observables sharing rules to apply using the dropdown list.

    {!includes/sharing-rules-case-observables.md!}

    !!! info "Sharing existing observables"
        Observables sharing rules apply only to new observables. Existing observables will not be shared automatically when updating the rules.  
        To apply the new rules to existing observables, follow these steps:   
            1. Select **Manage case sharings** again.  
            2. Turn off the **Share this case?** toggle for the relevant organization.  
            3. Select **Confirm**.  
            4. Select **Manage case sharings** again.  
            5. Turn on the **Share this case?** toggle for the relevant organization.  
            6. Select **Confirm**.  
            7. Select **Confirm** again.   

## Next steps

* [Share a Task](../tasks/share-a-task.md)
* [Share a Case](share-a-case.md)