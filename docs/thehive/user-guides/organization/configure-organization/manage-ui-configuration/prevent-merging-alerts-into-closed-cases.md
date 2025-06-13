# How to Prevent Users from Merging Alerts into Closed Cases

This topic provides step-by-step instructions for deactivating the ability to [merge alerts into closed cases](../../../analyst-corner/alerts/add-an-alert-to-an-existing-case.md) in TheHive.

A closed case is defined as a case with a [status](../../../../administration/status/about-statuses.md) associated with the *Closed* stage.

By default, it's possible to merge alerts into a closed case. Use this procedure to restrict merging alerts into cases statuses linked to the *New* or *In progress* stages.

!!! warning "Required permissions"
    Only users with the `manageConfig` permission can deactivate merging alerts into closed cases in TheHive.

<h2>Procedure</h2>

1. {!includes/organization-view-go-to.md!}

2. {!includes/ui-configuration-tab-go-to.md!}

3. In the **Alert and case** section, turn on the **Merge alerts into closed cases** toggle.

4. Select **Confirm**.

<h2>Next steps</h2>