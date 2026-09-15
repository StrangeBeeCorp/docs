# Access the Trigger Payload

<!-- md:version 6.0 --> <!-- md:permission `manageOrchestrator/writeWorkflows` --> <!-- md:license One -->

Every workflow run in [TheHive Flow](about-flow.md), whatever started it, exposes a built-in `$input.payload` variable carrying the data received by the trigger that started the run. Unlike [entry variables](manage-entry-exit-variables.md), it requires no declaration and no [input mapping](add-trigger.md#add-a-webhook-trigger). Insert it in a node with the **$var** button, or by typing `$` and selecting it from the suggestions. An inserted reference is displayed as `$input.payload`.

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

The `body` field is present only when the request body is valid JSON small enough to stay inline. The `body_kind` field is always present and reports which of the four cases applies:

* `inline`: The body is valid JSON small enough to stay inline, and `body` holds its parsed value.
* `promoted`: The body isn't inline JSON, whether a non-JSON content type at any size, invalid JSON, JSON null, or JSON at or above the inline limit. `body` is absent.
* `empty`: The request carried no readable body, either none at all or a `multipart/form-data` body, whose parts reach the payload as `form` instead. `body` is absent.
* `too_large`: The whole payload exceeded its 256 KiB limit, so the body was dropped to fit. `body` is absent.

When the body isn't in the payload, assign it to an entry variable with `$request.body` in the [input mapping](add-trigger.md#add-a-webhook-trigger) of the *Webhook* trigger instead.

## Additional fields from a manual run

A manual run adds the variables supplied with the run, by name: a [run from a case or alert page](manually-run-workflow.md#run-a-workflow-from-a-case-or-alert) adds the entity identifier, while a [run from the workflow editor](manually-run-workflow.md) adds nothing, as no input can be passed there.

* `payload_trimmed`: Set to `true` when the supplied variables exceeded the payload size limit and some were dropped to fit. It reports that a drop happened, not which fields went, and it's absent when nothing was dropped.

<h2>Next steps</h2>

* [Add a Trigger](add-trigger.md)
* [Manage Entry and Exit Variables](manage-entry-exit-variables.md)
