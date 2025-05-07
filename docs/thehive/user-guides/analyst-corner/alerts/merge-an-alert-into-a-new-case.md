# How to Merge an Alert into a New Case

This topic provides step-by-step instructions for merging an [alert](about-alerts.md) into a new [case](../cases/about-cases.md) in TheHive.

During triage, merge an alert into a new case if it needs further investigation and no case exists yet. If an investigation is already ongoing, [merge the alert into an existing case](merge-an-alert-into-an-existing-case.md).

!!! info "Data transfer"
    When merging an alert into a new case, data from the alert, including observables, TTPs, attachments, comments, and custom fields, is automatically transferred to the case.

!!! note "Link to case"
    Merging an alert into a new case automatically [links the alert to the case](../cases/view-alerts-linked-to-a-case.md).

{!includes/access-create-case-from-alert.md!}

<h2>Procedure</h2>

1. [Locate the alert you want to merge into a new case](./search-for-alerts/find-an-alert.md).

2. In the alert description, select **Create case from alert**.

    ![Create case from alert](/thehive/images/user-guides/analyst-corner/cases/create-case-from-alert.png)

3. In the **Create case** drawer, select either **Empty case** or **From template**.

4. Follow the instructions provided in the related sections:

    * [Create an empty case](../cases/create-a-new-case.md#create-an-empty-case)
    * [Create a case from a template](../cases/create-a-new-case.md#create-a-case-from-a-template)

!!! tip "Bulk merge"
    To merge multiple alerts into a new case, go to the **Alerts** view and select :fontawesome-regular-square: next to each alert you want to include. Then select **New case from selection** at the top of the screen. This action merges all the selected alerts into a single case.

<h2>Next steps</h2>

* [Add Tasks to a Case](../cases/add-tasks-to-a-case.md)
* [Add a Link to a Case](../cases/case-links/add-a-link-to-a-case.md)
* [Change a Case Status](../cases/change-status-case.md)
* [Restrict Case Visibility](../cases/restrict-visibility-case.md)