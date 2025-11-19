# Change a Status Visibility

<!-- md:version 5.5 --> <!-- md:permission `[admin] managePlatform` -->

Change a [status](about-statuses.md) visibility for cases and alerts in TheHive to hide [predefined statuses](about-statuses.md#predefined-statuses), so users only use the custom statuses you've created.

This setting doesn't apply to the [*Imported* status](about-statuses.md).

!!! note "No impact on API"
    Changing the visibility of a status doesn't affect [the API](https://docs.strangebee.com/thehive/api-docs/){target=_blank}. All statuses remain available through the API.

{% include-markdown "includes/task-statuses-excluded.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/entities-management-view-go-to.md" %}

2. {% include-markdown "includes/status-tab-go-to.md" %}

3. Select :fontawesome-solid-ellipsis: next to the status you want to edit.

4. Select **Edit**.

5. In the **Add a custom status** drawer, enter the new visibility you want to apply.

    Specifies whether you want to display or hide a status in TheHive interface.

    !!! info "Hiding impact on existing cases and alerts"
        If you hide a status that's already applied to existing cases or alerts, it remains applied until manually changed, but it's no longer available for selection.

6. Select **Confirm custom status update**.

<h2>Next steps</h2>

* [Create a Status](create-a-status.md)
* [Delete a Status](delete-a-status.md)