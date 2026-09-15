# Manage Entry and Exit Variables

<!-- md:version 6.0 --> <!-- md:permission `manageOrchestrator/writeWorkflows` --> <!-- md:license One -->

[Workflow entry and exit variables](about-flow.md#variables) define the interface of a workflow, allowing it to exchange data with external systems or callers. Entry variables are assigned from the webhook payload using a [jq expression](https://jqlang.org/manual/){target=_blank} in the **Input mapping** section when [configuring a *Webhook* trigger](add-trigger.md#add-a-webhook-trigger), or receive the case or alert identifier when the workflow is [run from a case or alert page](manually-run-workflow.md#run-a-workflow-from-a-case-or-alert). They're referenced in nodes with the **$var** button, or by typing `$` and selecting the variable from the suggestions. An inserted reference is displayed as `$input.<variable_name>`.

{% include-markdown "includes/flow-entry-variables-manual-trigger.md" %}

## Create an entry or exit variable

1. {% include-markdown "includes/flow-view-go-to.md" %}

2. Select a workflow from the list.

3. Select :fontawesome-solid-ellipsis:, then **Settings**.

4. Go to the **Input variables** or **Output variables** section and add your variables and their respective types.

    The name `payload` is reserved for the [trigger payload](access-trigger-payload.md) and can't be used for an entry variable.

An entry variable has no value until it's assigned. Assign it in the [input mapping of a *Webhook* trigger](add-trigger.md#add-a-webhook-trigger), or through a [run from a case or alert page](manually-run-workflow.md#run-a-workflow-from-a-case-or-alert).

## Delete an entry or exit variable

1. {% include-markdown "includes/flow-view-go-to.md" %}

2. Select a workflow from the list.

3. Select :fontawesome-solid-ellipsis:, then **Settings**.

4. In the **Input variables** or **Output variables** section, select :fontawesome-solid-trash: next to the variable you want to delete.

<h2>Next steps</h2>

* [Manage Workflows](manage-workflows.md)
* [Add a Trigger](add-trigger.md)
* [Access the Trigger Payload](access-trigger-payload.md)
