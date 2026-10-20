# Access the Trigger Payload

<!-- md:version 6.0 --> <!-- md:permission `manageOrchestrator/writeWorkflows` --> <!-- md:license One -->

Every workflow run in [TheHive Flow](about-flow.md), whatever started it, exposes a built-in `$input.payload` variable carrying the data received by the trigger that started the run. Unlike [input variables](manage-input-exit-variables.md), it requires no declaration and no assignment. Insert it in a node with the **$var** button, or by entering `$` and selecting it from the suggestions. An inserted reference is displayed as `$input.payload`.

## Fields available in every run

* `trigger_kind`: How the run started, with `webhook` for a [*Webhook* trigger](add-trigger.md#add-a-webhook-trigger), `schedule` for a [*Scheduler* trigger](add-trigger.md#add-a-scheduler-trigger), or `user` for a [manual run](manually-run-workflow.md) from the workflow editor or a case or alert page
* `trigger_id`: The identifier of the trigger that started the run, or of the user for a manual run
* `triggered_at`: The UTC timestamp of when the run was triggered

A *Scheduler* trigger adds no fields beyond these.

## Additional fields from a *Webhook* trigger

* `body`: The JSON body of the incoming request
* `headers`: The request headers. Credential headers such as `Authorization` or `Cookie` are redacted.
* `query`: The query string parameters of the webhook URL
* `method`: The HTTP method of the request
* `form`: The form fields of a request sent as `multipart/form-data`
* `body_kind`: How the request body reached the payload

!!! danger "Secrets in the payload"
    The payload is stored with the run for the [run retention period](../configuration/flow-configuration.md#run-retention), and every user who can read workflows can see it. Only credential headers are redacted, including the header the webhook authenticates on. A secret sent in the body, the query string, or a form field is stored in clear.

The `body` field is present only when the request body is valid JSON small enough to stay inline. The `body_kind` field is always present and reports which of the four cases applies:

* `inline`: The body is valid JSON small enough to stay inline, and `body` holds its parsed value.
* `promoted`: The body isn't inline JSON, whether a non-JSON content type at any size, invalid JSON, JSON null, or JSON at or above the inline limit. `body` is absent.
* `empty`: The request carried no readable body, either none at all or a `multipart/form-data` body, whose parts reach the payload as `form` instead. `body` is absent.
* `too_large`: The whole payload exceeded its 256 KiB limit, so the body was dropped to fit. `body` is absent.

When the body isn't in the payload, assign it to an input variable with `$request.body` in the **Workflow input** section of the [*Webhook* trigger](add-trigger.md#add-a-webhook-trigger) instead.

## Additional fields from a manual run

A manual run adds the variables supplied with the run, by name. A [run from a case or alert page](manually-run-workflow.md#run-a-workflow-from-a-case-or-alert) adds the entity identifier. A [run from the workflow editor](manually-run-workflow.md) adds nothing, because no input can be passed there.

* `payload_trimmed`: Set to `true` when the supplied variables exceeded the payload size limit and some were dropped to fit. It reports that a drop happened, not which fields went, and it's absent when nothing was dropped.

## Payload of a called workflow

A workflow called by a [*Subworkflow* node](configure-flow-node.md#configure-a-subworkflow-flow-node) has no trigger of its own for that run. It receives the payload of the calling workflow, whole and unchanged, including the `trigger_kind`, `trigger_id`, and `triggered_at` fields of the calling run. The calling workflow can't modify it. To send other values to the called workflow, use its [input variables](manage-input-exit-variables.md).

## Inspect the payload of a past run

To check the payload a manual or *Webhook* run received, open the run in the **Executions** tab of the workflow and select the trigger node. The **Input** section of its execution details displays the payload. The execution details of a *Scheduler* run don't display the payload, only the **Current interval** of the trigger. For more details, see [Display Workflow Execution Logs](display-execution-logs.md#display-execution-logs-for-a-specific-workflow).

<h2>Next steps</h2>

* [Add a Trigger](add-trigger.md)
* [Manage Input and Exit Variables](manage-input-exit-variables.md)
* [Display Workflow Execution Logs](display-execution-logs.md)
