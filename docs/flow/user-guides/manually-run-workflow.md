# Manually Run a Workflow

<!-- md:version 6.0 --> <!-- md:permission `manageOrchestrator/writeWorkflows` --> <!-- md:license One -->

Execute your workflow on demand, regardless of its trigger configuration: from the workflow editor while building it, or from a case or alert page in TheHive.

!!! warning "Prerequisite"
    You must enable a workflow, and resolve any errors marked with :fontawesome-solid-triangle-exclamation:, before you can run it manually.

{% include-markdown "includes/flow-input-variables-manual-trigger.md" %}

## Run a workflow from the workflow editor

1. {% include-markdown "includes/flow-view-go-to.md" %}

2. Select a workflow.

3. In the workflow editor, select **Run workflow**.

    ![Run workflow](../images/run-workflow.png)

## Run a workflow from a case or alert

<!-- md:permission `manageOrchestrator/readWorkflows` --> <!-- md:permission `manageOrchestrator/writeWorkflows` -->

Run a workflow on a specific case or alert from its Automation Center, in the **Automations** tab.

1. Open a case or an alert.

2. Go to the **Automations** tab.

3. Select the **Workflows** tab.

    ![Run a workflow from a case or alert](../images/workflows-tab-case-alert.png)

    The tab [lists the workflow runs already launched on the case or alert](display-execution-logs.md#display-execution-logs-from-a-case-or-alert).

4. Select **Run workflows**.

5. Select one or more workflows, then select **Launch action(s)**.

Each selected workflow runs once. TheHive passes the identifier of the case or alert to the run as a variable named `case_id` or `alert_id`. The identifier is available in the nodes as `$input.payload.case_id` or `$input.payload.alert_id`, through the [trigger payload](access-trigger-payload.md#additional-fields-from-a-manual-run). To reference it as `$input.case_id` or `$input.alert_id` instead, [declare an input variable](manage-input-exit-variables.md) with that exact name.

<h2>Next steps</h2>

* [Add a Trigger](add-trigger.md)
* [Display Workflow Execution Logs](display-execution-logs.md)
* [Export or Import a Workflow](import-export-workflows.md)
