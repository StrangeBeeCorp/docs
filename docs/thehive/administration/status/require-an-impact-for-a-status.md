# Require an Impact for a Status

<!-- md:version 6.0 --> <!-- md:permission `[admin] managePlatform` --> <!-- md:license Gold --> <!-- md:license Platinum --> <!-- md:license One -->

Require an impact for a case [status](about-statuses.md) linked to the *Closed* stage in TheHive, so analysts must record whether the threat investigated in the case affected the organization when they [close a case](../../user-guides/analyst-corner/cases/close-a-case.md) with this status.

This setting applies to every organization on the platform.

!!! info "True Positive status"
    The predefined *True Positive* status always requires an impact.

!!! note "Closed case statuses only"
    The **Impact** field isn't available for alert statuses, or for case statuses linked to the *New* or *In progress* stages.

{% include-markdown "includes/task-statuses-excluded.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/entities-management-view-go-to.md" %}

2. Select the **Case status** tab.

3. Select :fontawesome-solid-ellipsis: next to the status you want to edit. The status must be linked to the *Closed* stage.

4. Select **Edit**.

5. In the **Edit a custom status** drawer, next to **Impact**, select one of the following options:

    * **Yes**: Analysts must state whether the case had an actual impact when they close a case with this status. They can't close the case until they select **Yes** or **No** in the **Impact** field.
    * **No**: The **Impact** field doesn't appear when closing a case with this status.

    !!! info "Cases that are already closed"
        Changing this setting doesn't affect cases that are already closed. It applies to the next closures.

6. Select **Confirm custom status update**.

<h2>Next steps</h2>

* [Create a Status](create-a-status.md)
* [Change a Status Visibility](change-visibility-of-a-status.md)
* [Close a Case](../../user-guides/analyst-corner/cases/close-a-case.md)
