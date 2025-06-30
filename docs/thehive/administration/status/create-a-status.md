# How to Create a Status

<!-- md:license Gold --> <!-- md:license Platinum -->

This topic provides step-by-step instructions for creating a [status](about-statuses.md) for cases and alerts in TheHive.

Use this procedure to add custom statuses in addition to [the predefined ones managed by TheHive](about-statuses.md#predefined-statuses).

{!includes/task-statuses-excluded.md!}

{!includes/administrator-access-manage-statuses.md!}

<h2>Procedure</h2>

1. {!includes/entities-management-view-go-to.md!}

    ---

2. {!includes/status-tab-go-to.md!}

    ---

3. Select :fontawesome-regular-square-plus:.

    ---

4. In the **Add a custom status** drawer, enter the following information:

    **- Visibility** <!-- md:version 5.5 -->

    Specifies whether you want to display or hide a status in TheHive interface.

    **- Stage**

    The stage linked to the status. TheHive includes four predefined stages—*New*, *Imported*, *In progress*, and *Closed*. These stages are hard-coded and you can't modify, delete, or extend them. After you link a stage to a status, you can't change it. To assign a different stage, you must [delete the status](delete-a-status.md) and [create a new one](create-a-status.md).

    !!! info "Imported stage"
        The *Imported* stage isn't available for selection in the interface. It is linked to an *Imported* status that is applied when an alert is [merged into an existing case](../../user-guides/analyst-corner/alerts/add-an-alert-to-an-existing-case.md) or [merged into a new case](../../user-guides/analyst-corner/alerts/create-a-case-from-an-alert.md).

    **- Value**

    The name of the status. After you create a status, you can't change its name. To use a different name, you must [delete the status](delete-a-status.md) and [create a new one](create-a-status.md).

    **- Color**

    Enter a hex color code in the format #RRGGBB, or select :fontawesome-solid-fill-drip: to open the color picker.

    ---

5. Verify that the preview looks correct.

    ---

6. Select **Confirm custom status creation**.

<h2>Next steps</h2>

* [Change a Status Visibility](change-visibility-of-a-status.md)
* [Change a Status Color](change-color-of-a-status.md)
* [Delete a Status](delete-a-status.md)