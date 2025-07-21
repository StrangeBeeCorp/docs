# Add an Alert to an Existing Case

This topic provides step-by-step instructions for adding an [alert](about-alerts.md) to an existing [case](../cases/about-cases.md) in TheHive.

During triage, add an alert to an existing case if it needs further investigation and a similar case has already been created.

If it requires a separate investigation, [create a case from the alert](create-a-case-from-an-alert.md).

!!! info "Data transfer"
    When adding an alert to an existing case, data from the alert, including observables, TTPs, attachments, comments, and custom fields, is automatically transferred to the case.

!!! note "Link to case"
    Adding an alert to an existing case automatically [links the alert to the case](../cases/view-alerts-linked-to-a-case.md).

{!includes/access-create-case-from-alert.md!}

<h2>Procedure</h2>

!!! tip "Bulk merge"
    To add multiple alerts to an existing case, go to the **Alerts** view and select :fontawesome-regular-square: next to each alert you want to include. Then select **Merge selection into case** above the list. This action merges all the selected alerts into a single case.

1. [Locate the alert you want to merge into an existing case](./search-for-alerts/find-an-alert.md).

2. In the alert, select **Merge alert into case**.

    ![Merge alert into case](/thehive/images/user-guides/analyst-corner/alerts/merge-alert-into-case.png)

3. In the **Merge alerts into case** drawer, search for the case by title or case number.

    !!! note "Closed cases"
        If you’re unable to find closed cases, it means your organization has [deactivated merging alerts into closed cases](../../organization/configure-organization/manage-ui-configuration/prevent-merging-alerts-into-closed-cases.md).

4. Select **Merge**.

<h2>Next steps</h2>

* [Add Tasks to a Case](../cases/add-tasks-to-a-case.md)
* [Add a Link to a Case](../cases/case-links/add-a-link-to-a-case.md)
* [Change a Case Status](../cases/change-status-case.md)
* [Restrict Case Visibility](../cases/case-visibility/restrict-visibility-case.md)