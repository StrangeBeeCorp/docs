# About Audit Logs

Audit logs in TheHive record all user actions, ensuring full traceability of activities performed within the platform.

Users can view a graphical representation of audit logs in the **History** tab, accessible in case and alert descriptions.

This document explains the purpose, usage, and benefits of audit logs in TheHive.

## Usage

Audit logs provide critical insights into system activity and security. 

Their key use cases include:

* Workflow automation: Logs can be sent to an orchestration system to trigger automated workflows.
* Security monitoring: Logs can be forwarded to a Security Information and Event Management (SIEM) system to detect suspicious or abnormal behaviors.
* Activity traceability: The **History** tab records all actions on cases and alerts for accountability and compliance.

## Main audit fields

Audit logs in TheHive include the following key fields:

* `_id`: Unique identifier of the audit log.
* `_type`: Always set to `Audit`.
* `_createdBy`: The user who performed the action.
* `action`: The type of action performed, which can be `create`, `update`, `delete`, `merge` or `invoke` (for functions).
* `requestId`: Identifier of the HTTP request that triggered the audit entry.
* `details`: A JSON object containing the modifications made to the affected object.
* `objectId`: The `_id` of the impacted object.
* `objectType`: The `_type` of the impacted object.
* `object`: The full description of the object after modifications.
* `rootId`: The `_id` of the top-level object. For example, if a task is updated, this field stores the `_id` of the associated case.
* `context`: The context of the audit entry, depending on the created or updated object.
* `organisation`: Details about the organization where the action occurred.

## Anatomy of an audit

An audit entry is represented as a JSON object with the following structure:

```json
{
  "_id": "~327684328",
  "_type": "Audit",
  "_createdBy": "director@movies.io",
  "_createdAt": 1694441999960,
  "action": "update",
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
    "_createdBy": "mia@movies.io",
    "_updatedBy": "director@movies.io",
    "_createdAt": 1693412835689,
    "_updatedAt": 1694441999230,
    "number": 34,
    "title": "Behind themselves watch price take. I probably single service. Develop fear hotel real.",
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
    "assignee": "mia@movies.io",
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
    "_createdBy": "mia@movies.io",
    "_updatedBy": "director@movies.io",
    "_createdAt": 1693412835689,
    "_updatedAt": 1694441999230,
    "number": 34,
    "title": "Behind themselves watch price take. I probably single service. Develop fear hotel real.",
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
    "assignee": "mia@movies.io",
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
    "organisation": "Pulp Fiction"
  }
}
```

## Next steps

* [Write a FilteredEvent Trigger](../organization/configure-organization/manage-notifications/write-filtered-event-trigger.md)