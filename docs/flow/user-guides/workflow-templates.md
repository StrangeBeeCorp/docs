# Workflow Templates

<!-- md:version 6.0 --> <!-- md:license One -->

[TheHive Flow](about-flow.md) provides ready-made workflow templates that cover common security automation scenarios. Use this page to look up what each template does and which elements to adapt to your environment after [importing it](import-export-workflows.md#import-a-workflow) into your organization.

## Customization common to all templates

Templates reference [global variables](manage-global-variables.md) from the organization that created them: the URL of the TheHive instance as a visible global variable and the API key as a secret global variable. These variables don't exist in your organization after import. Before enabling a template:

1. [Create a global variable](manage-global-variables.md#create-a-global-variable) holding the URL of your TheHive instance.

2. [Create a secret global variable](manage-global-variables.md#create-a-global-variable) holding the [API key](../../thehive/user-guides/organization/configure-organization/manage-user-accounts/manage-user-accounts.md#manage-a-user-account-api-key) used to authenticate against TheHive.

3. In every *TheHive* [integration node](configure-integration-node.md), replace the imported references with your own variables in the **Base URL** and **Bearer token** fields.

Templates that call third-party products store their credentials the same way and need the equivalent replacement in each corresponding [integration node](configure-integration-node.md).

## Alert triage

The *Alert triage* template automates the first triage of alerts coming from a third-party detection product, in this template an Elastic Security EDR. Each alert the product sends to the *Webhook* trigger becomes a normalized alert in TheHive, with its severity, observables, and MITRE ATT&CK techniques carried over. The workflow then checks the reputation of the IP address and hash observables against Recorded Future. When threat intelligence confirms an indicator of compromise (IOC), the workflow raises the alert severity to *Critical* and escalates the alert to a case, ready for investigation. Alerts without a confirmed IOC stay in the alert queue for manual review.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Recorded Future API key: [Create a secret global variable](manage-global-variables.md#create-a-global-variable) holding your Recorded Future API key and select it in both [*Recorded Future* integration nodes](configure-integration-node.md#configure-a-recorded-future-integration-node): *Recorded Future IP check* and *Recorded Future Hash check*. Replace these nodes with your own intelligence provider if you don't use Recorded Future.
* Normalization script: The *Normalize Alert* Python node maps Elastic Security fields, such as `kibana.alert.severity` and `host.ip`, to TheHive alert fields. Rewrite this mapping if your alerts come from another product.
* Custom fields: The normalization script fills a `sourcefields` custom field on the alert. [Create this custom field](../../thehive/administration/custom-fields/create-a-custom-field.md), or remove the `customFields` section from the script. TheHive rejects the alert creation when this custom field doesn't exist.
* Data type conditions: The *If dataType IP* and *If dataType Hash* conditions route observables to enrichment. Adapt them if you enrich other data types.
* Escalation threshold: The *If Recorded Report Malicious* condition escalates at a risk score of 65 or higher. Change this value to match your triage policy.

## Command line analysis

The *Command line analysis* template reveals what the PowerShell command lines attached to an alert actually do and surfaces the indicators of compromise (IOCs) they contain. It has no trigger: [run it manually from an alert](manually-run-workflow.md#run-a-workflow-from-a-case-or-alert) in TheHive. Malicious commands are often obfuscated with a Base64-encoded `-Enc` argument: the workflow decodes them and documents the decoded command on the alert, both as a comment and as a new `command-line` observable. It then adds the IP addresses, URLs, domains, and hashes it finds as observables, extracted from the decoded command or from the raw command line when no encoding is present.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Observable type: [Create a `command-line` observable type](../../thehive/administration/observable-types/create-an-observable-type.md) in TheHive. Without it, alerts can't carry the observables this workflow reads and creates. Adapt the *Set Command Line Array* node if you store command lines under another data type.
* Extraction patterns: The Python code nodes detect the `-Enc` argument and extract IOCs with regular expressions. Extend these patterns if your commands use other encodings or if you want to extract other data types.

## Slack alert manager

The *Slack alert manager* template lets your team triage new TheHive alerts directly from Slack: an emoji reaction acknowledges the alert, raises its severity, or closes it as a false positive. A [*Webhook* trigger](add-trigger.md#add-a-webhook-trigger) wired to a [TheHive notification](../../thehive/user-guides/organization/configure-organization/manage-notifications/create-a-notification.md) starts the workflow when an alert is created. The workflow posts a message announcing the alert title and severity in a Slack channel, then watches the message for about 3 minutes. Emoji reactions drive actions on the alert in TheHive:

| Reaction | Action in TheHive |
|---|---|
| `:hand:` | Adds a comment acknowledging the alert with the name of the Slack user who reacted |
| `:exclamation:` | Sets the alert severity to *Critical* |
| `:x:` | Sets the alert status to *FalsePositive* |

The workflow also copies new Slack thread replies to the alert as comments.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Slack credentials: [Create secret global variables](manage-global-variables.md#create-a-global-variable) holding your Slack bot token and the identifier of the channel to post in, then select them in every [*Slack* node](configure-integration-node.md#configure-a-slack-integration-node).
* Trigger wiring: Create the TheHive notification with a *Webhook* notifier pointing to the trigger URL, as described in [Add a Trigger](add-trigger.md#add-a-webhook-trigger).
* Email notification: The *Send Email - Critical Alert* node ships with `N/A` placeholders. Set the sender and recipient addresses, or remove the node.
* Alert status: The `:x:` reaction sets the *FalsePositive* status. Change it if your organization uses other [alert statuses](../../thehive/administration/status/about-statuses.md).
* Watch duration: The *For Each* loop runs nine iterations with a 20-second pause. Increase these values to watch reactions for longer.

## Suspicious email campaign

The *Suspicious email campaign* template processes the emails your users report and detects phishing campaigns: it enriches each reported email alert and groups the alerts belonging to the same campaign into a single case. A [*Scheduler* trigger](add-trigger.md#add-a-scheduler-trigger) runs the workflow at a regular interval, for example every 15 minutes. Each run retrieves the new alerts created by the [email intake connector](../../thehive/administration/email-intake-connector/about-email-intake-connectors.md), parses each email with the *EmlParser* Cortex analyzer, updates the alert with the sender, subject, and a preview of the email, and adds the suspicious sender and domain as observables. The workflow then searches for an existing case with the same email subject and sender: it merges the alert into that case when one exists, and otherwise escalates the alert to a new case carrying a campaign identifier and a case page with the email headers.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Custom fields: [Create the custom fields](../../thehive/administration/custom-fields/create-a-custom-field.md) the workflow fills: `sender`, `recipient`, `reporter`, and `reporteddate` for alerts, and `campaign` for cases. TheHive rejects the update requests when these custom fields don't exist.
* Email intake: Configure the [email intake connector](../../thehive/administration/email-intake-connector/about-email-intake-connectors.md) so incoming emails create alerts tagged `email-intake`. The *Get Unprocessed Email-Intake Alerts* node selects alerts by this tag and the *New* status.
* Cortex analyzer: Enable the *EmlParser* analyzer on a [Cortex server connected to TheHive](../../thehive/administration/cortex/add-a-cortex-server.md), then select your Cortex server and analyzer in the *Run EmlParser Analyzer* node.
* Schedule: Set the trigger interval to match your email volume, typically every 15 to 30 minutes.

## TheHive to Jira ITSM sync

The *TheHive to Jira ITSM sync* template mirrors every new TheHive alert as a Jira issue and keeps the two in sync: comments travel in both directions, and the issue closes when the synchronization ends. A [*Webhook* trigger](add-trigger.md#add-a-webhook-trigger) wired to a [TheHive notification](../../thehive/user-guides/organization/configure-organization/manage-notifications/create-a-notification.md) starts the workflow when an alert is created. The workflow creates a Jira issue with the alert title and description, then synchronizes comments in both directions: new TheHive comments appear on the Jira issue prefixed with `[From TheHive]`, new Jira comments appear on the alert prefixed with `[From Jira]`, and a `[Synced]` marker prevents synchronization loops. When the synchronization loop completes, the workflow transitions the Jira issue to *Done*.

After importing this template, adjust the following elements:

* TheHive connection: Set the base URL and API key in every *TheHive* node, as described in [Customization common to all templates](#customization-common-to-all-templates).
* Jira connection: [Create a global variable](manage-global-variables.md#create-a-global-variable) holding the URL of your Jira Cloud site and a secret global variable holding an [Atlassian API token](https://id.atlassian.com/manage-profile/security/api-tokens){target=_blank}, then select them in the **Base URL** and **Password** fields of every [*Jira Cloud v3* node](configure-integration-node.md#configure-a-jira-cloud-v3-integration-node). Replace the email address in the **Username** field of every *Jira Cloud v3* node with the Atlassian account email of your service account.
* Jira project and issue type: The *Set Jira Project Key and Issue Type* node ships with empty values. Set the `jira_project_key` and `jira_issue_type` variables to match the Jira project receiving the issues.
* Trigger wiring: Create the TheHive notification with a *Webhook* notifier pointing to the trigger URL, as described in [Add a Trigger](add-trigger.md#add-a-webhook-trigger).
* Closing transition: The *Jira close issue* node applies the transition named *Done*. Change this name if your Jira project uses another workflow.
* Sync duration: The *For Each (While)* loop runs nine synchronization cycles with a 10-second pause. Increase these values to keep the alert and the issue in sync for longer.

<h2>Next steps</h2>

* [Export or Import a Workflow](import-export-workflows.md)
* [Manage Workflows](manage-workflows.md)
* [Manage Global Variables](manage-global-variables.md)
