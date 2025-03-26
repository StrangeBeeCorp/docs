# How to Change a Status Visibility

This topic provides step-by-step instructions for changing a [status](about-statuses.md) visibility for cases and alerts in TheHive.

This is useful if you want to hide [TheHive’s predefined statuses](about-statuses.md#predefined-statuses), so users only use the custom statuses you have created. 

!!! note "No impact on API"
    Changing the visibility of a status doesn't affect [the API](https://docs.strangebee.com/thehive/api-docs/). All statuses remain available through the API.

!!! info "Available since version 5.5"
    Starting with version 5.5, you can manage the visibility of a status.

{!includes/administrator-access-manage-statuses.md!}

## Procedure

1. {!includes/entities-management-view-go-to.md!}

2. {!includes/status-tab-go-to.md!}

3. Select :fontawesome-solid-ellipsis: next to the status you want to edit.

4. Select **Edit**.

5. In the **Add a custom status** drawer, enter the new visibility you want to apply.

    Specifies whether you want to display or hide a status in TheHive interface.
    
    !!! info "Hiding impact on existing cases and alerts"
        If you hide a status that is already applied to existing cases or alerts, it remains applied until manually changed. It is no longer available for selection in the interface. This doesn't apply to the *Imported* status, which is automatically assigned to alerts when they are merged into a case.

6. Select **Confirm custom status creation**.

## Next steps

* [Create a Status](create-a-status.md)
* [Delete a Status](delete-a-status.md)