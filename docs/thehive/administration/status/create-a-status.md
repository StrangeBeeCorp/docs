# How to Create a Status

This topic provides step-by-step instructions for creating a [status](about-statuses.md) for cases and alerts in TheHive.

{!includes/administrator-access-manage-statuses.md!}

## Procedure

1. {!includes/entities-management-view-go-to.md!}

2. {!includes/status-tab-go-to.md!}

3. Select :fontawesome-regular-square-plus:.

4. In the **Add a custom status** drawer, enter the following information:

    **- Visibility** (available since version 5.5)

    Defines whether the status is displayed or hidden for users in cases and alerts.

    **- Stage**

    The stage linked to the status. TheHive includes three predefined stages—*New*, *In progress*, and *Closed*. Stages are hardcoded and can't be modified, deleted, or extended. Once a stage is linked to a status, it can't be changed. To assign a different stage, you must [delete the status](delete-a-status.md) and [create a new one](create-a-status.md).

    **- Value**

    The name of the status. Once created, the status name can't be changed. To use a different name, you must [delete the status](delete-a-status.md) and [create a new one](create-a-status.md).

    **- Color**

    Enter a hex color code in the format #RRGGBB, or select :fontawesome-solid-fill-drip: to open the color picker.

5. Verify that the preview looks correct.

6. Select **Confirm custom status creation**.

## Next steps

* [Change a Status Visibility](change-visibility-of-a-status.md)
* [Change a Status Color](change-color-of-a-status.md)
* [Delete a Status](delete-a-status.md)