# Create a Case from an Alert

This topic provides step-by-step instructions for creating a [case](../cases/about-cases.md) from an [alert](about-alerts.md) in TheHive.

During triage, create a case from an alert if it needs further investigation and no case exists yet.

If an investigation is already ongoing, [add the alert to an existing case](add-an-alert-to-an-existing-case.md).

!!! info "Data transfer"
    When creating a case from an alert, data from the alert, including observables, TTPs, attachments, comments, and custom fields, is automatically transferred to the case.

!!! note "Link to case"
    Creating a case from an alert automatically [links the alert to the case](../cases/view-alerts-linked-to-a-case.md).

{% include-markdown "includes/access-create-case-from-alert.md" %}

<h2>Procedure</h2>

!!! tip "Bulk merge"
    To create a case from multiple alerts, go to the **Alerts** view and select :fontawesome-regular-square: next to each alert you want to include. Then select **New case from selection** at the top of the screen. This action merges all the selected alerts into a single case.

    By default, you can merge up to 50 alerts at once. You can change this limit using the `alert.maxMergeInCase` setting in the `application.conf` file. Proceed with caution: modifying this limit may affect platform stability.

1. [Locate the alert you want to merge into a new case](./search-for-alerts/find-an-alert.md).

2. In the alert, select **Create case from alert**.

    ![Create case from alert](/thehive/images/user-guides/analyst-corner/cases/create-case-from-alert.png)

3. In the **Create case** drawer, select either **Empty case** or **From template**.

4. Follow the instructions provided in the related sections:

    * [Create an empty case](../cases/create-a-new-case.md#create-an-empty-case)
    * [Create a case from a template](../cases/create-a-new-case.md#create-a-case-from-a-template)

<h2>Next steps</h2>

* [Add Tasks to a Case](../cases/add-tasks-to-a-case.md)
* [Add a Link to a Case](../cases/case-links/add-a-link-to-a-case.md)
* [Change a Case Status](../cases/change-status-case.md)
* [Restrict Case Visibility](../cases/case-visibility/restrict-visibility-case.md)