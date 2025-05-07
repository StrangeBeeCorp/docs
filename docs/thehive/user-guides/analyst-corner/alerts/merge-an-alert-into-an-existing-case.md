# How to Merge an Alert into an Existing Case

This topic provides step-by-step instructions for merging an [alert](about-alerts.md) into an existing [case](../cases/about-cases.md) in TheHive.

During triage, merge an alert into an existing case if it needs further investigation and a similar case has already been created.

If it requires a separate investigation, [merge the alert into a new case](merge-an-alert-into-a-new-case.md).

!!! info "Data transfer"
    When merging an alert into an existing case, data from the alert, including observables, TTPs, attachments, comments, and custom fields, is automatically transferred to the case.

!!! note "Link to case"
    Merging an alert into an existing case automatically [links the alert to the case](../cases/view-alerts-linked-to-a-case.md).

{!includes/access-create-case-from-alert.md!}

<h2>Procedure</h2>

1. [Locate the alert you want to merge into a case](./search-for-alerts/find-an-alert.md).

2. In the alert description, select **Merge alert into case**.

    ![Merge alert into case](/thehive/images/user-guides/analyst-corner/alerts/merge-alert-into-case.png)

3. In the **Merge alerts into case** drawer, search for the case by title or case number.

4. Select **Merge**.

!!! tip "Bulk merge"
    To merge multiple alerts into an existing case, go to the **Alerts** view and select :fontawesome-regular-square: next to each alert you want to include. Then select **Merge selection into case** at the top of the screen. This action merges all the selected alerts into a single case.

<h2>Next steps</h2>

* [Add Tasks to a Case](../cases/add-tasks-to-a-case.md)
* [Add a Link to a Case](../cases/case-links/add-a-link-to-a-case.md)
* [Change a Case Status](../cases/change-status-case.md)
* [Restrict Case Visibility](../cases/restrict-visibility-case.md)