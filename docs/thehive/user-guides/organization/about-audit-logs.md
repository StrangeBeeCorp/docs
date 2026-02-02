# About Audit Logs

Audit logs in TheHive record all user actions, ensuring full traceability of activities performed within the platform.

Every create, update, delete, merge, and function invocation generates an audit entry that captures comprehensive details about the action, the user who performed it, and the affected objects.

TheHive displays audit logs in the **History** tab within case and alert descriptions. The most recent key events from these audit logs are also displayed in the [Live Feed](../analyst-corner/about-live-feed.md) for real-time activity monitoring.

!!! tip "Tag and custom field changes"
    <!-- md:version 5.5.9 --> Starting with TheHive 5.5.9, audit logs now record updates to tags and custom fields.

!!! info "TheHive Portal activities"
    <!-- md:version 5.6 --> <!-- md:license Platinum --> All actions performed through [TheHive Portal](../../administration/thehive-portal/about-thehive-portal.md) are recorded as audit logs in the main TheHive interface. This includes both external user activities in the portal and internal user actions to share cases, comments, and attachments with external users.

## Key use cases

Audit logs provide critical insights into system activity and security that are usually used to:

### Workflow automation

Audit logs stream to orchestration platforms like SOAR systems, where specific events trigger automated response workflows. For example, when an analyst escalates a case severity, the audit log can automatically notify the incident response team.

### Security monitoring

Security teams forward audit logs to SIEM systems to detect anomalous behavior patterns. Unusual access patterns, privilege escalations, or bulk data modifications generate alerts for immediate investigation.

### Activity traceability

The **History** tab maintains a permanent record of all case and alert modifications. This immutable audit trail satisfies regulatory requirements and enables forensic analysis of incident handling procedures.

## Audit log structure

Each audit log entry contains fields that capture the complete context of an action:

### Core identification fields

* `_id`: Unique identifier of the audit log entry.
* `_type`: Always contains the value `Audit`.
* `_createdBy`: Email address of the user who performed the action.
* `_createdAt`: Timestamp when the action occurred—Unix timestamp in milliseconds.

### Action details

* `action`: Type of action performed, which can be `create`, `update`, `delete`, `merge` or `invoke` for functions.
* `mainAction`: Boolean—`true` for the primary action; `false` for a derived event, for example when the action occurs in another organization that shares elements with this one.
* `requestId`: Unique identifier of the HTTP request that triggered the audit entry.
* `details`: JSON object containing only the modified fields and their new values.

### Object information

* `objectId`: The `_id` of the directly affected object.
* `objectType`: The `_type` of the affected object.
* `object`: Complete state of the object after the modification.
* `rootId`: The `_id` of the parent object. For example, the case ID when a task is modified.

### Organizational context

* `context`: Full description of the parent object, providing complete situational awareness.
* `organisation`: Organization receiving the audit event, which may differ from the performing organization in [sharing scenarios](../../administration/organizations/about-organizations-sharing-rules.md).

## Example audit entries

### Case status update from *New* to *InProgress*

```json
{
  "_id": "~327684328",
  "_type": "Audit",
  "_createdBy": "alice@example.com",
  "_createdAt": 1694441999960,
  "action": "update",
  "mainAction": true,
  "requestId": "74dc37479904ebe7:3957d351:18a847d4266:-8000:109",
  "rootId": "~327925760",
  "details": {
    "status": "InProgress",
    "stage": "InProgress"
  },
  "objectId": "~327925760",
  "objectType": "Case",
  "object": {
    "_id": "~327925760",
    "_type": "Case",
    "_createdBy": "sami@example.com",
    "_updatedBy": "alice@example.com",
    "_createdAt": 1693412835689,
    "_updatedAt": 1694441999230,
    "number": 34,
    "title": "Suspicious network activity detected",
    "description": "***Description***",
    "severity": 3,
    "severityLabel": "HIGH",
    "startDate": 1693151602000,
    "tags": [
      "tagA"
    ],
    "flag": false,
    "tlp": 2,
    "tlpLabel": "AMBER",
    "pap": 1,
    "papLabel": "GREEN",
    "status": "InProgress",
    "stage": "InProgress",
    "assignee": "sami@example.com",
    "customFields": [],
    "userPermissions": [],
    "extraData": {},
    "newDate": 1693412835673,
    "inProgressDate": 1694441998841,
    "timeToDetect": 261233673,
    "timeToTriage": 1029163168,
    "timeToAcknowledge": 1290396841,
    "customFieldValues": {}
  },
  "context": {
    "_id": "~327925760",
    "_type": "Case",
    "_createdBy": "sami@example.com",
    "_updatedBy": "alice@example.com",
    "_createdAt": 1693412835689,
    "_updatedAt": 1694441999230,
    "number": 34,
    "title": "Suspicious network activity detected",
    "description": "***Description***",
    "severity": 3,
    "severityLabel": "HIGH",
    "startDate": 1693151602000,
    "tags": [
      "tagA"
    ],
    "flag": false,
    "tlp": 2,
    "tlpLabel": "AMBER",
    "pap": 1,
    "papLabel": "GREEN",
    "status": "InProgress",
    "stage": "InProgress",
    "assignee": "sami@example.com",
    "customFields": [],
    "userPermissions": [],
    "extraData": {},
    "newDate": 1693412835673,
    "inProgressDate": 1694441998841,
    "timeToDetect": 261233673,
    "timeToTriage": 1029163168,
    "timeToAcknowledge": 1290396841,
    "customFieldValues": {}
  },
  "organisation": {
    "organisationId": "~4169864",
    "organisation": "TheOrganization"
  }
}
```

### Custom field update from *Support* to *Engineering*

<!-- md:version 5.5.9 -->

```json
{
  "_id": "~327684328",
  "_type": "Audit",
  "_createdBy": "alice@example.com",
  "_createdAt": 1694441999960,
  "action": "update",
  "mainAction": true,
  "requestId": "74dc37479904ebe7:3957d351:18a847d4266:-8000:109",
  "rootId": "~327925760",
  "details": {
    "customFields": [
      {
        "_id": "business-unit:Engineering",
        "name": "business-unit",
        "type": "string",
        "value": "Engineering",
        "order": 0
      }
    ],
    "customFieldChanges": [
      {
        "operation": "valuesAdded",
        "name": "business-unit",
        "values": [
          "Engineering"
        ]
      },
      {
        "operation": "valuesRemoved",
        "name": "business-unit",
        "values": [
          "Support"
        ]
      }
    ]
  },
  "objectId": "~327925760",
  "objectType": "Case",
  "object": {
    "_id": "~327925760",
    "_type": "Case",
    "_createdBy": "sami@example.com",
    "_updatedBy": "alice@example.com",
    "_createdAt": 1693412835689,
    "_updatedAt": 1694441999230,
    "number": 34,
    "title": "Suspicious network activity detected",
    "description": "***Description***",
    "severity": 3,
    "severityLabel": "HIGH",
    "startDate": 1693151602000,
    "tags": ["tagA"],
    "flag": false,
    "tlp": 2,
    "tlpLabel": "AMBER",
    "pap": 1,
    "papLabel": "GREEN",
    "status": "InProgress",
    "stage": "InProgress",
    "assignee": "sami@example.com",
    "customFields": [
      {
        "_id": "business-unit:Engineering",
        "name": "business-unit",
        "type": "string",
        "value": "Engineering",
        "order": 0
      }
    ],
    "userPermissions": [],
    "extraData": {},
    "newDate": 1693412835673,
    "inProgressDate": 1694441998841,
    "timeToDetect": 261233673,
    "timeToTriage": 1029163168,
    "timeToAcknowledge": 1290396841,
    "customFieldValues": {
      "business-unit": "Engineering"
    }
  },
  "context": {
    "_id": "~327925760",
    "_type": "Case",
    "_createdBy": "sami@example.com",
    "_updatedBy": "alice@example.com",
    "_createdAt": 1693412835689,
    "_updatedAt": 1694441999230,
    "number": 34,
    "title": "Suspicious network activity detected",
    "description": "***Description***",
    "severity": 3,
    "severityLabel": "HIGH",
    "startDate": 1693151602000,
    "tags": [
      "tagA"
    ],
    "flag": false,
    "tlp": 2,
    "tlpLabel": "AMBER",
    "pap": 1,
    "papLabel": "GREEN",
    "status": "InProgress",
    "stage": "InProgress",
    "assignee": "sami@example.com",
    "customFields": [
      {
        "_id": "business-unit:Engineering",
        "name": "business-unit",
        "type": "string",
        "value": "Engineering",
        "order": 0
      }
    ],
    "userPermissions": [],
    "extraData": {},
    "newDate": 1693412835673,
    "inProgressDate": 1694441998841,
    "timeToDetect": 261233673,
    "timeToTriage": 1029163168,
    "timeToAcknowledge": 1290396841,
    "customFieldValues": {
      "business-unit": "Engineering"
    }
  },
  "organisation": {
    "organisationId": "~4169864",
    "organisation": "TheOrganization"
  }
}
```

<h2>Next steps</h2>

* [Write a FilteredEvent Trigger](../organization/configure-organization/manage-notifications/write-filtered-event-trigger.md)