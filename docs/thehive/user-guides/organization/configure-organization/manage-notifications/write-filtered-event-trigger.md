# Write a FilteredEvent Trigger

<!-- md:permission `manageConfig` -->

Write a *FilteredEvent* [trigger](../manage-notifications/about-notifications.md#triggers) in TheHive to send notifications based on custom event filters.

For a list of available operators, see [FilteredEvent Trigger Operators](filtered-event-trigger-operators.md).

<h2>Procedure</h2>

1. When [creating a new notification](create-a-notification.md) or editing an existing one, select the *FilteredEvent* trigger.

    Selecting *FilteredEvent* opens a field where you can define a custom JSON filter. These filters apply to all actions recorded in the organization's [audit logs](../../about-audit-logs.md). When an action matches the filter criteria, a notification is triggered.

2. Write your filter.

    {% include-markdown "includes/operators-list.md" %}

    To write an effective JSON filter, you first need to understand the structure of the event payload and how to access its fields.

    Event payloads may include the following top-level fields, depending on the event type:

    * `object`: The object affected by the event.
    * `details`: The specific changes applied to the object.
    * `context`: The related object providing context for the event, such as the parent object or the object itself.

    To access a specific field within a JSON object, use `.` to navigate through nested properties.

    You can inspect the event structure using either a *Function* notifier or a *Webhook* notifier.

    === "Function option"

        Log the full event payload directly from a function.

        a. [Create a function](../manage-functions/create-a-function.md) of type *Notification* with the following definition:

        ```javascript
        function handle(input, context) {
          console.log("=== INPUT RECEIVED ===");
          console.log(JSON.stringify(input, null, 2));
          console.log("=== END INPUT ===");
        } 
        ```

        b. [Create a dedicated notification](create-a-notification.md) using a [*Function* notifier](./notifiers/function.md), and select the function you just created.

        c. Trigger the notification based on the trigger you selected.

        d. Return to the function configuration and open the **Last success** section to view the event payload and analyze its structure.

    === "Webhook option"

        Inspect the event payload by sending it to a Webhook endpoint.

        a. [Create a dedicated notification](create-a-notification.md) using a [*Webhook* notifier](./notifiers/webhook.md).

        b. Review the received JSON payload on the Webhook endpoint to understand the event structure.

    ??? example "Event payload example"

        Example of an event payload generated after a VirusTotal analyzer report is created for an observable:

        ```json
        {
        "_id": "~8847368352",
        "object": {
            "_type": "Observable",
            "tlp": 1,
            "data": "suspicious@example.com",
            "_updatedAt": 1747992922320,
            "ioc": true,
            "pap": 2,
            "reports": {
            "VirusTotal_GetReport_3_1": {
                "taxonomies": [
                {
                    "level": "info",
                    "namespace": "VT",
                    "predicate": "GetReport",
                    "value": "0/92"
                }
                ]
            },
            "CyberCrime-Tracker_1_0": {
                "taxonomies": [
                {
                    "level": "info",
                    "namespace": "CCT",
                    "predicate": "C2 Search",
                    "value": "0 hits"
                }
                ]
            },
            "Abuse_Finder_3_0": {
                "taxonomies": [
                {
                    "level": "info",
                    "namespace": "Abuse_Finder",
                    "predicate": "Address",
                    "value": "None"
                }
                ]
            }
            },
            "ignoreSimilarity": false,
            "sighted": false,
            "_createdAt": 1747138172568,
            "startDate": 1747138172568,
            "_createdBy": "alice@example.com",
            "tlpLabel": "GREEN",
            "_id": "~8561545240",
            "tags": [],
            "papLabel": "AMBER",
            "_updatedBy": "alice@example.com",
            "message": "Domain involved in DNS tunneling.",
            "extraData": {},
            "case": {
            "number": 3275,
            "_type": "Case",
            "assignee": "sami@example.com",
            "severityLabel": "HIGH",
            "inProgressDate": 1747733026675,
            "pap": 0,
            "_createdAt": 1747138171189,
            "startDate": 1640200000000,
            "_createdBy": "alice@example.com",
            "stage": "InProgress",
            "timeToResolve": 594888828,
            "tlp": 3,
            "endDate": 1747733026675,
            "description": "Suspicious DNS requests detected, indicating potential tunneling activity.\n  \n#### Merged with alert #compromised_account-20250203154628-800386a4 Compromised Account Detected\n\nSuspicious login activity detected for user emma@example.com.",
            "tlpLabel": "AMBER+STRICT",
            "_id": "~8765923376",
            "newDate": 1747138171143,
            "customFieldValues": {},
            "tags": [
                "dns",
                "tunneling",
                "compromised",
                "account"
            ],
            "alertNewDate": 1738232244332,
            "_updatedAt": 1769010542427,
            "customFields": [],
            "papLabel": "CLEAR",
            "_updatedBy": "alice@example.com",
            "alertImportedDate": 1747138171140,
            "timeToQualify": 8905926808,
            "alertDate": 1640200000000,
            "timeToTriage": 8905893515,
            "closedDate": 1747733026675,
            "alertInProgressDate": 1747138137847,
            "status": "InProgress",
            "timeToDetect": 98032244332,
            "flag": true,
            "severity": 3,
            "extraData": {},
            "title": "DNS Tunneling Detected",
            "handlingDuration": 594888828,
            "summary": "",
            "impactStatus": "WithImpact",
            "access": {
                "_kind": "OrganisationAccessKind"
            },
            "userPermissions": [],
            "timeToAcknowledge": 106938137847
            },
            "dataType": "fqdn"
        },
        "objectType": "Observable",
        "rootId": "~8765923376",
        "details": {
            "reports": {
            "VirusTotal_GetReport_3_1": {
                "taxonomies": [
                {
                    "predicate": "GetReport",
                    "text": "VT:GetReport=\"0/92\"",
                    "value": "0/92",
                    "namespace": "VT",
                    "level": "info"
                }
                ]
            }
            }
        },
        "_createdAt": 1769070800405,
        "_type": "Audit",
        "organisation": {
            "organisationId": "~6840459424",
            "organisation": "Documentation"
        },
        "context": {
            "_type": "Observable",
            "tlp": 1,
            "data": "suspicious@example.com",
            "_updatedAt": 1747992922320,
            "ioc": true,
            "pap": 2,
            "reports": {
            "VirusTotal_GetReport_3_1": {
                "taxonomies": [
                {
                    "level": "info",
                    "namespace": "VT",
                    "predicate": "GetReport",
                    "value": "0/92"
                }
                ]
            },
            "CyberCrime-Tracker_1_0": {
                "taxonomies": [
                {
                    "level": "info",
                    "namespace": "CCT",
                    "predicate": "C2 Search",
                    "value": "0 hits"
                }
                ]
            },
            "Abuse_Finder_3_0": {
                "taxonomies": [
                {
                    "level": "info",
                    "namespace": "Abuse_Finder",
                    "predicate": "Address",
                    "value": "None"
                }
                ]
            }
            },
            "ignoreSimilarity": false,
            "sighted": false,
            "_createdAt": 1747138172568,
            "startDate": 1747138172568,
            "_createdBy": "alice@example.com",
            "tlpLabel": "GREEN",
            "_id": "~8561545240",
            "tags": [],
            "papLabel": "AMBER",
            "_updatedBy": "alice@example.com",
            "message": "Domain involved in DNS tunneling.",
            "extraData": {},
            "case": {
            "number": 3275,
            "_type": "Case",
            "assignee": "sami@example.com",
            "severityLabel": "HIGH",
            "inProgressDate": 1747733026675,
            "pap": 0,
            "_createdAt": 1747138171189,
            "startDate": 1640200000000,
            "_createdBy": "alice@example.com",
            "stage": "InProgress",
            "timeToResolve": 594888828,
            "tlp": 3,
            "endDate": 1747733026675,
            "description": "Suspicious DNS requests detected, indicating potential tunneling activity.\n  \n#### Merged with alert #compromised_account-20250203154628-800386a4 Compromised Account Detected\n\nSuspicious login activity detected for user emma@example.com.",
            "tlpLabel": "AMBER+STRICT",
            "_id": "~8765923376",
            "newDate": 1747138171143,
            "customFieldValues": {},
            "tags": [
                "dns",
                "tunneling",
                "compromised",
                "account"
            ],
            "alertNewDate": 1738232244332,
            "_updatedAt": 1769010542427,
            "customFields": [],
            "papLabel": "CLEAR",
            "_updatedBy": "alice@example.com",
            "alertImportedDate": 1747138171140,
            "timeToQualify": 8905926808,
            "alertDate": 1640200000000,
            "timeToTriage": 8905893515,
            "closedDate": 1747733026675,
            "alertInProgressDate": 1747138137847,
            "status": "InProgress",
            "timeToDetect": 98032244332,
            "flag": true,
            "severity": 3,
            "extraData": {},
            "title": "DNS Tunneling Detected",
            "handlingDuration": 594888828,
            "summary": "",
            "impactStatus": "WithImpact",
            "access": {
                "_kind": "OrganisationAccessKind"
            },
            "userPermissions": [],
            "timeToAcknowledge": 106938137847
            },
            "dataType": "fqdn"
        },
        "mainAction": false,
        "requestId": "6348d5be16e93bc8:-15fbcccd:19be2caa21b:-8000::2872",
        "objectId": "~8561545240",
        "_createdBy": "alice@example.com",
        "action": "update"
        }
        ```

    {% include-markdown "includes/tag-customfield-changes.md" %}

3. Select the relevant notifiers to configure them:

    * [EmailerToAddr](../manage-notifications/notifiers/email-to-addr.md)
    * [HttpRequest](../manage-notifications/notifiers/http-request.md)
    * [Mattermost](../manage-notifications/notifiers/mattermost.md)
    * [Slack](../manage-notifications/notifiers/slack.md)
    * [Teams](../manage-notifications/notifiers/teams.md)
    * [Webhook](../manage-notifications/notifiers/webhook.md)
    * [Kafka](../manage-notifications/notifiers/kafka.md)
    * [Redis](../manage-notifications/notifiers/redis.md)
    * [RunAnalyzer](../manage-notifications/notifiers/analyzers.md)
    * [RunResponder](../manage-notifications/notifiers/responders.md)
    * [Function](../manage-notifications/notifiers/function.md)

## Examples

{% include-markdown "includes/operators-list.md" %}

### Case severity updated to High or Critical

```json
{
  "_and": [
    { "_is": { "action": "update" } },
    { "_is": { "objectType": "Case" } },
    { "_gte": { "details.severity": 3 } }
  ]
}
```

### Alert closed without an assignee

```json
{
  "_and": [
    { "_is": { "objectType": "Alert" } },
    { "_is": { "details.stage": "Closed" } },
    { "_not": { "_has": "object.assignee" } },
    { "_not": { "_has": "details.assignee" } }
  ]
}
```

### Observable updated with a report from analyzer `Crt_sh_Transparency_Logs_1_0`

```json
{
  "_and": [
    { "_is": { "action": "update" } },
    { "_is": { "objectType": "Observable" } },
    { "_has": "details.reports.Crt_sh_Transparency_Logs_1_0" }
  ]
}
```

### Responder action finished

```json
{
  "_and": [
    { "_is": { "action": "update" } },
    { "_is": { "objectType": "Action" } },
    {
      "_or": [
        { "_is": { "details.status": "Success" } },
        { "_is": { "details.status": "Failure" } }
      ]
    }
  ]
}
```

### Case status updated to `TruePositive` or `FalsePositive`, with the custom field `business-unit` set to `Sales` or `Marketing`

```json
{
  "_and": [
    { "_is": { "action": "update" } },
    { "_is": { "objectType": "Case" } },
    {
      "_or": [
        { "_is": { "details.status": "TruePositive" } },
        { "_is": { "details.status": "FalsePositive" } }
      ]
    },
    {
      "_or": [
        { "_is": { "object.customFieldValues.business-unit": "Sales" } },
        { "_is": { "object.customFieldValues.business-unit": "Marketing" } }
      ]
    }
  ]
}
```

### Custom field `business-unit` updated to `Engineering`

<!-- md:version 5.5.9 -->

```json
{
  "_arrayMatch": {
    "_field": "details.customFieldChanges",
    "_filter": {
      "_and": [
        { "_eq": { "operation": "valuesAdded" } },
        { "_eq": { "name": "business-unit" } },
        { "_eq": { "values": "Engineering" } }
      ]
    }
  }
}
```

### Analyzer `EmlParser_2_1` completed successfully

```json
{
  "_and": [
    { "_is": { "objectType": "Job" } },
    { "_is": { "object.analyzerName": "EmlParser_2_1" } },
    { "_is": { "object.status": "Success" } }
  ]
}
```

<h2>Next steps</h2>

* [Configure the EmailerToAddr Notifier](../manage-notifications/notifiers/email-to-addr.md)
* [Configure the HttpRequest Notifier](../manage-notifications/notifiers/http-request.md)
* [Configure the Mattermost Notifier](../manage-notifications/notifiers/mattermost.md)
* [Configure the Slack Notifier](../manage-notifications/notifiers/slack.md)
* [Configure the Teams Notifier](../manage-notifications/notifiers/teams.md)
* [Configure the webhook Notifier](../manage-notifications/notifiers/webhook.md)
* [Configure the Kafka Notifier](../manage-notifications/notifiers/kafka.md)
* [Configure the Redis Notifier](../manage-notifications/notifiers/redis.md)
* [Configure the RunAnalyzer Notifier](../manage-notifications/notifiers/analyzers.md)
* [Configure the RunResponder Notifier](../manage-notifications/notifiers/responders.md)
* [Configure the Function Notifier](../manage-notifications/notifiers/function.md)