# Manage Workflows

<!-- md:version 6.0 --> <!-- md:license One -->

Workflows in [TheHive Flow](about-flow.md) consist of interconnected nodes that define automated processes. They begin with a trigger and can include flow, transformation, action, and integration nodes. Workflows are scoped to the organization and shared among all members with sufficient permissions. There's no personal or user-isolated workspace.

{% include-markdown "includes/flow-other-automations.md" %}

!!! tip "Reusing workflows"
    You can [import workflows from other TheHive instances or organizations](import-export-workflows.md).

## Create a workflow

<!-- md:permission `manageOrchestrator/writeWorkflows` -->

Create workflows in [TheHive Flow](about-flow.md) to automate operations when specific events occur.

1. {% include-markdown "includes/flow-view-go-to.md" %}

2. Select :fontawesome-solid-plus:.

3. In the **Workflow information** drawer, enter the following information:

    *Fields marked with \* are mandatory.*

    **- Name \***

    The name of your workflow.

    **- Description**

    A description of your workflow.

    **- Tags**

    Free text tags to categorize and filter workflows.

    **- Timeout**

    The maximum allowed execution time for the entire workflow. Defaults to 1 hour if left blank. The minimum allowed value is 30 seconds.

    You can also configure different timeout values at the node level. In that case, the shortest timeout value applies.

    The timeout also prevails over the duration of a [*Sleep* flow node](configure-flow-node.md#configure-a-sleep-flow-node): if the duration exceeds the workflow timeout, the execution times out before the pause completes.

4. Select **Save**.

    TheHive creates a workflow with a default trigger node. The trigger node is the entry point that initiates workflow execution.

5. Optional: To declare the [workflow's input and exit variables](about-flow.md#variables), select :fontawesome-solid-ellipsis:, then **Settings**, and fill in the **Input variables** and **Output variables** sections.

    You can also declare and assign input variables directly when [configuring a *Webhook* trigger](add-trigger.md#add-a-webhook-trigger). A [run from a case or alert page](manually-run-workflow.md#run-a-workflow-from-a-case-or-alert) assigns the case or alert identifier to an input variable named `case_id` or `alert_id` when the workflow declares it. The identifier is also always available in the [trigger payload](access-trigger-payload.md#additional-fields-from-a-manual-run).

6. Optional: Create [global variables](about-flow.md#variables) to store fixed values shared across workflows. See [Manage Global Variables](manage-global-variables.md#create-a-global-variable) for detailed instructions.

    {% include-markdown "includes/local-variables-flow.md" %}

7. Select **Add a trigger** to configure one or more triggers in the [trigger node](about-flow.md#trigger-nodes).

    For configuration instructions, see [Add a Trigger](add-trigger.md).

    {% include-markdown "includes/manual-trigger-workflow-editor-flow.md" %}

8. Add nodes to build your workflow by dragging the previous node connector to an empty area of the canvas.

    ![Drag a node connector to an empty area](../images/drag-node-empty-area.gif)

9. Select the node you want to add:

    * [Flow nodes](about-flow.md#flow-nodes) to control workflow branching and loops
    * [Transformation nodes](about-flow.md#transformation-nodes) to process and manipulate data
    * [Action nodes](about-flow.md#action-nodes) to perform generic operations such as sending requests or messages, running Cortex analyzers and responders, or calling an LLM
    * [Integration nodes](about-flow.md#integration-nodes) to perform operations in TheHive or third-party products through their APIs

    For configuration instructions, see [Configure a Flow Node](configure-flow-node.md), [Configure a Transformation Node](configure-transformation-node.md), [Configure an Action Node](configure-action-node.md), or [Configure an Integration Node](configure-integration-node.md).

Once created, the workflow is automatically saved.

## Duplicate a workflow

<!-- md:permission `manageOrchestrator/writeWorkflows` -->

Duplicate a workflow to reuse its structure, or to keep a copy before making significant changes, because workflows have no versioning.

1. In the workflow list, select :fontawesome-solid-ellipsis: next to the workflow you want to duplicate.

2. Select **Duplicate**.

The copy takes the name of the original workflow followed by `- Copy`. To rename it, select :fontawesome-solid-ellipsis: next to the copy, then **Settings**. The copy starts turned off and has no *Webhook* or *Scheduler* trigger: [add the triggers](add-trigger.md) it needs, then [enable it](#enable-a-workflow).

## Duplicate a node

<!-- md:permission `manageOrchestrator/writeWorkflows` -->

{% include-markdown "includes/flow-no-versioning.md" %}

1. In a workflow, select :fontawesome-solid-ellipsis: on the node you want to duplicate.

2. Select **Duplicate**.

    ![Duplicate a node](../images/duplicate-node.png)

## Delete a node

<!-- md:permission `manageOrchestrator/writeWorkflows` -->

!!! info "Trigger node can't be deleted"
    The trigger node is mandatory and can't be deleted from a workflow. However, you can delete individual triggers inside the trigger node.

!!! danger "Deleting a node invalidates references to its outputs"
    Later nodes can reference the deleted node's [output or local variables](about-flow.md#variables). After the deletion, these references become invalid and the affected nodes report errors. Until you update or remove the invalid references, a workflow can't be [enabled](#enable-a-workflow), and an already enabled workflow rejects every run attempt, whether triggered or manual.

{% include-markdown "includes/flow-no-versioning.md" %}

1. In a workflow, select :fontawesome-solid-ellipsis: on the node you want to delete.

2. Select **Delete**.

    ![Delete a node](../images/delete-node.png)

## Delete a branch

<!-- md:permission `manageOrchestrator/writeWorkflows` -->

!!! danger "Deleting a branch can invalidate references to outputs"
    When the branch is the only path to a node whose [output variables](about-flow.md#variables) are referenced downstream, the confirmation shows a warning. After the deletion, these references become invalid and the affected nodes report errors. Until you update or remove these references, a workflow can't be [enabled](#enable-a-workflow), and an already enabled workflow rejects every run attempt, whether triggered or manual.

{% include-markdown "includes/flow-no-versioning.md" %}

1. In a workflow, hover over the branch between two nodes to reveal its actions.

2. Select :fontawesome-solid-trash:.

3. Select **Delete**.

## Enable a workflow

<!-- md:permission `manageOrchestrator/writeWorkflows` -->

Enable a workflow to run it automatically when triggered. You can also [run an enabled workflow manually from the workflow editor or from a case or alert page](manually-run-workflow.md).

!!! warning "Resolve errors before enabling"
    You can't enable a workflow that contains errors. Errors are marked in the workflow with :fontawesome-solid-triangle-exclamation:. Resolve all errors before enabling the workflow.

In the workflow editor, select **Enable workflow**.

![Enable workflow](../images/enable-workflow.png)

## Turn off a workflow

<!-- md:permission `manageOrchestrator/writeWorkflows` -->

Turn off a workflow to edit it without affecting production operations. A workflow that's turned off never runs. Its triggers are ignored and manual runs are unavailable. A [*Subworkflow* node](configure-flow-node.md#configure-a-subworkflow-flow-node) that calls it fails, so turning it off also affects the workflows that call it.

In the workflow editor, select **Disable workflow**.

![Disable workflow](../images/disable-workflow.png)

## Delete a workflow

<!-- md:permission `manageOrchestrator/deleteWorkflows` -->

!!! danger "Permanent action"
    Deleting a workflow is permanent and can't be undone. To pause a workflow temporarily, [turn it off](#turn-off-a-workflow) instead.

    Workflows that call the deleted workflow through a [*Subworkflow* node](configure-flow-node.md#configure-a-subworkflow-flow-node) can't run until another workflow is selected in that node.

1. In the workflow list, select :fontawesome-solid-ellipsis: next to the workflow you want to delete.

2. Select **Delete**.

3. Select **OK**.

<h2>Next steps</h2>

* [Build Your First Workflow](build-your-first-workflow.md)
* [Workflow Templates](workflow-templates.md)
* [Manage Global Variables](manage-global-variables.md)
* [Manage Input and Exit Variables](manage-input-exit-variables.md)
* [Add a Trigger](add-trigger.md)
* [Configure a Flow Node](configure-flow-node.md)
* [Configure a Transformation Node](configure-transformation-node.md)
* [Configure an Action Node](configure-action-node.md)
* [Configure an Integration Node](configure-integration-node.md)
* [Manually Run a Workflow](manually-run-workflow.md)