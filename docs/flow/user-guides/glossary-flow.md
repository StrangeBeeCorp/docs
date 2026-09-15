# TheHive Flow Glossary

<!-- md:version 6.0 --> <!-- md:license One -->

TheHive Flow is the automation engine in TheHive that enables users to create workflows responding to events, processing data, and executing actions across integrated systems. The glossary below defines the key terms and concepts of TheHive Flow.

Terms are listed alphabetically.

For more details and to understand how the concepts relate to each other, refer to [About TheHive Flow](about-flow.md).

## Action node

A workflow component that performs generic operations such as sending requests or messages, running Cortex analyzers and responders, or calling an LLM. Action nodes represent the output of workflows, creating changes or triggering downstream processes. Available actions include: [*HTTP request*](#http-request-action), [*Send email*](#send-email-action), [*Slack - Send Message*](#slack-send-message-action), [*Teams - Send message*](#teams-send-message-action), [*Analyzer*](#analyzer-action), [*Responder*](#responder-action), and [*AI*](#ai-action).

## *AI* action

An [action node](#action-node) that sends a message to a large language model (LLM) and returns its response. The node uses one of the [LLM providers configured in TheHive](../../thehive/administration/manage-llm-providers.md) by an administrator. The response can be constrained to a structured output schema so downstream nodes can consume individual fields.

## *Analyzer* action

An [action node](#action-node) that triggers [Cortex analyzers](../../thehive/administration/cortex/about-cortex.md) on [observables](../../thehive/user-guides/analyst-corner/cases/observables/about-observables.md) to perform automated analysis and threat intelligence enrichment.

## *CrowdStrike Falcon* integration

An [integration node](#integration-node) that performs operations through the CrowdStrike Falcon APIs, such as querying devices and vulnerabilities, running response actions on hosts, querying and updating alerts, looking up threat intelligence indicators, managing custom indicators of compromise, and detonating file samples in the Falcon sandbox.

## *Elastic Security* integration

An [integration node](#integration-node) that performs operations through the Elasticsearch API, such as searching and indexing documents, running ES|QL queries, and listing Elastic Security detection alerts.

## Entry variable

A named field extracted from the webhook payload using a jq expression. Declared in [workflow settings](manage-entry-exit-variables.md). Its value is assigned in the input mapping of a [*Webhook* trigger](add-trigger.md#add-a-webhook-trigger), or when the workflow is [run from a case or alert page](manually-run-workflow.md#run-a-workflow-from-a-case-or-alert), which assigns the entity identifier to the `case_id` or `alert_id` entry variable.

## Exit variable

A named [jq expression](https://jqlang.org/){target=_blank} declared in [workflow settings](manage-entry-exit-variables.md) that is evaluated when the workflow completes. Its computed value is returned to the caller in the run response body.

## File reference

A small object that stands in for a value [stored as a file](about-flow.md#files), such as a large output or binary content. Referencing the variable reads the file content back transparently when it's JSON and small enough. The file metadata is available through the `$files` namespace.

## Flow node

A workflow component that controls how execution branches, loops over items, or pauses. Flow nodes include: [*If*](#if-flow), [*For each*](#for-each-flow), and [*Sleep*](#sleep-flow).

## *For each* flow

A [flow node](#flow-node) that iterates over each item in an array or object, executing the same sequence of nodes for each entry. Iterations run sequentially by default, or in parallel when the **Parallel execution** toggle is on.

## Global variable

A value shared across all workflows within an organization. Global variables can't be modified within workflows. They can be defined as visible or secret, with secret global variables intended for sensitive information such as API keys, passwords, or SSL/TLS certificate files. The value of a secret variable is never displayed in the interface and never appears in execution logs.

## *HarfangLab EDR* integration

An [integration node](#integration-node) that performs operations through the HarfangLab API, such as searching and isolating endpoints, managing alerts, running jobs on agents, searching telemetry, managing IOC rules, and listing Sigma rules.

## *HTTP request* action

An [action node](#action-node) that sends HTTP requests to external APIs and [TheHive API](https://docs.strangebee.com/thehive/api-docs/){target=_blank}.

## *If* flow

A [flow node](#flow-node) that evaluates a [jq expression](#jq-expression) and directs execution down two branches based on the boolean result.

## Integration node

A workflow component that performs operations in TheHive or a third-party product through its API. Each integration node targets one product and exposes its operations as dedicated actions selected within the node. Available integrations include: [*TheHive*](#thehive-integration), [*Splunk*](#splunk-integration), [*Microsoft Defender for Endpoint*](#microsoft-defender-for-endpoint-integration), [*Microsoft Defender (Graph Security API)*](#microsoft-defender-graph-security-api-integration), [*Microsoft Entra ID*](#microsoft-entra-id-integration), [*Microsoft Sentinel*](#microsoft-sentinel-integration), [*Recorded Future*](#recorded-future-integration), [*VirusTotal*](#virustotal-integration), [*CrowdStrike Falcon*](#crowdstrike-falcon-integration), [*Elastic Security*](#elastic-security-integration), [*HarfangLab EDR*](#harfanglab-edr-integration), [*Jira Cloud v3*](#jira-cloud-v3-integration), and [*Slack*](#slack-integration).

## *JavaScript code* transformation

A [transformation node](#transformation-node) that executes JavaScript scripts within the workflow.

## *Jira Cloud v3* integration

An [integration node](#integration-node) that performs operations through the Jira Cloud platform REST API, such as creating, editing, transitioning, and searching issues, managing comments, attachments, worklogs, watchers, and votes, and browsing projects and issue metadata.

## jq expression

A [query language](https://jqlang.org/){target=_blank} used to evaluate conditions and manipulate JSON data. Used in [flow nodes](#flow-node) to define conditions and collections, and in any node field where an inserted [variable reference](about-flow.md#variables) is wrapped in a jq expression, displayed as a blue reference.

## Local variable

A variable scoped to a single workflow, created during workflow execution using a [*Set local variable*](#set-local-variable-transformation) transformation node.

## Loop output variable

A variable declared on a [*For each* flow node](#for-each-flow) to collect results across iterations. Each loop output variable is a named [jq expression](#jq-expression) evaluated after every iteration. The values are aggregated across all iterations and available in the nodes that follow the loop, referenced as `$<node_name>.<variable_name>`.

## *Microsoft Defender for Endpoint* integration

An [integration node](#integration-node) that performs operations through the Microsoft Defender for Endpoint API, such as listing, retrieving, and updating alerts, running response actions on devices, and creating indicators.

## *Microsoft Defender (Graph Security API)* integration

An [integration node](#integration-node) that performs operations through the Microsoft Graph security API, such as listing, retrieving, and updating Microsoft Defender XDR alerts and incidents.

## *Microsoft Entra ID* integration

An [integration node](#integration-node) that performs operations through the Microsoft Graph API, such as looking up users, sign-ins, audit logs, devices, and risk detections, and taking account actions such as disabling a user or forcing a password reset.

## *Microsoft Sentinel* integration

An [integration node](#integration-node) that performs operations through the Microsoft Sentinel REST API, such as listing, retrieving, and updating incidents, managing incident comments, and listing or writing watchlists.

## Node

A building block in a workflow that performs a specific function. Nodes connect sequentially to form workflow logic, with data flowing from one node to the next. Each node receives input from previous steps and produces output for subsequent operations. Node types include [trigger](#trigger-node), [flow](#flow-node), [transformation](#transformation-node), [action](#action-node), and [integration](#integration-node) nodes.

## Output variable

A variable scoped to a single workflow. Output variables are automatically generated by nodes during execution and can be reused in all subsequent nodes.

## *Python code* transformation

A [transformation node](#transformation-node) that executes Python scripts within the workflow.

## *Recorded Future* integration

An [integration node](#integration-node) that performs operations through the Recorded Future API, such as enriching and triaging indicators in bulk, looking up domains, IP addresses, hashes, and URLs, and searching analyst notes and threat maps.

## *Responder* action

An [action node](#action-node) that triggers [Cortex responders](../../thehive/administration/cortex/about-cortex.md) on [alerts](../../thehive/user-guides/analyst-corner/alerts/about-alerts.md), [cases](../../thehive/user-guides/analyst-corner/cases/about-cases.md), [observables](../../thehive/user-guides/analyst-corner/cases/observables/about-observables.md), [tasks](../../thehive/user-guides/analyst-corner/tasks/about-tasks.md), or [task logs](../../thehive/user-guides/analyst-corner/tasks/about-task-logs.md) to perform automated response actions.

## *Scheduler* trigger

A trigger type within a [trigger node](#trigger-node) that starts the workflow on a recurring schedule. Multiple scheduler blocks can coexist on the same trigger node, each running independently on its own schedule.

## *Send email* action

An [action node](#action-node) that sends emails using TheHive [SMTP configuration](../../thehive/administration/smtp/about-smtp.md).

## *Set local variable* transformation

A [transformation node](#transformation-node) that creates local variables.

## *Slack* integration

An [integration node](#integration-node) that performs operations through the Slack Web API, such as posting, updating, and deleting messages, managing reactions, reading threads and channel history, and looking up channels and users.

## *Slack Send message* action

An [action node](#action-node) that sends messages to Slack.

## *Sleep* flow

A [flow node](#flow-node) that pauses the execution path for a specified duration before continuing with the next node.

## *Splunk* integration

An [integration node](#integration-node) that performs operations through the Splunk REST API, such as creating and following search jobs, running searches, listing indexes and fired alerts, submitting events, and updating Splunk Enterprise Security findings and investigations.

## *Teams Send message* action

An [action node](#action-node) that sends messages to Microsoft Teams.

## *TheHive* integration

An [integration node](#integration-node) that performs operations in TheHive through [TheHive API](https://docs.strangebee.com/thehive/api-docs/){target=_blank}, such as creating, updating, querying, or deleting cases, alerts, tasks, and observables, managing comments and task logs, or starting a Cortex job.

## Transformation node

A workflow component that processes or manipulates data. Allows users to perform custom operations that modify, extract, or format information as it moves through the workflow. Includes [*Set local variable*](#set-local-variable-transformation), [*JavaScript code*](#javascript-code-transformation), and [*Python code*](#python-code-transformation) nodes.

## Trigger node

The entry point that initiates workflow execution. Every workflow requires one trigger node, automatically created when creating a workflow. Multiple triggers can be configured within this node and work as OR conditions: any one of them independently starts the workflow. Available trigger types: [*Webhook*](#webhook-trigger) and [*Scheduler*](#scheduler-trigger).

## Trigger payload

A built-in variable, referenced as `$input.payload`, automatically available in every run with no declaration or [input mapping](add-trigger.md#add-a-webhook-trigger). It carries the data received by the trigger that started the run, such as the JSON body, headers, and query parameters of a webhook request. See [Access the Trigger Payload](access-trigger-payload.md).

## *VirusTotal* integration

An [integration node](#integration-node) that performs operations through the VirusTotal API, such as scanning URLs and files, and retrieving domain, IP address, file, and analysis reports.

## *Webhook* trigger

A trigger type within a [trigger node](#trigger-node) that listens for incoming HTTP requests from external systems or TheHive itself. It accepts the `GET`, `POST`, `PUT`, `DELETE`, `PATCH`, `HEAD`, and `OPTIONS` methods unless the accepted methods are restricted, and it defines its own authentication method, as the webhook URL is reachable without signing in to TheHive.

## Workflow

An automated process created in TheHive Flow consisting of interconnected nodes that define automated procedures. Workflows must begin with a [trigger node](#trigger-node) and can include [flows](#flow-node), [transformations](#transformation-node), [actions](#action-node), and [integrations](#integration-node).
