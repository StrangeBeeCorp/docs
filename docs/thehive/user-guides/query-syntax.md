# Query Syntax

TheHive uses a common query syntax to search, filter, sort, and paginate data across all entity types. A query is an array of chained steps, each identified by a `_name` field.

Use this page to look up the available operations, filter operators, and `extraData` values. Query results only include entities accessible to the current user.

The same syntax applies in two contexts:

* The [Query API](https://docs.strangebee.com/thehive/api-docs/#tag/Query-and-Export/operation/Query%20API) endpoint `POST /api/v1/query` handles listing, filtering, sorting, and pagination for every entity type.
* [Function scripts](organization/configure-organization/manage-functions/about-functions.md) use the same query arrays to search TheHive data. This includes functions run by the [*Function* notifier](organization/configure-organization/manage-notifications/notifiers/function.md) of a notification.

!!! note "Related filter formats"
    Two other features filter entities with their own formats:

    * The [FilteredEvent trigger](organization/configure-organization/manage-notifications/write-filtered-event-trigger.md) of notifications uses the same operator style to filter events, with a few differences. See [FilteredEvent Trigger Operators](organization/configure-organization/manage-notifications/filtered-event-trigger-operators.md) for the operators available in that context.
    * The conditions of [SLA rules](organization/configure-organization/manage-sla/configure-sla-rules.md) use a simpler format of field-value pairs, for example `{"severity": 3}`, optionally combined under a top-level `_and`.

## How a query works

A query pipeline runs as follows:

1. Start with a [primary operation](#primary-operations) to define the initial entity set. This step is required.
2. Optionally chain [related object operations](#related-object-operations) to navigate from one entity to its related entities.
3. Optionally apply [filter](#filters) and [sort](#sorting) steps to narrow or order the results.
4. Optionally end with a [page](#pagination-and-extra-data) step to paginate and request computed extra fields.

To discover which properties exist on an entity type, called a model in the API, and whether they can be filtered, sorted, or aggregated, use the [Describe a model](https://docs.strangebee.com/thehive/api-docs/#tag/Describe/operation/Describe%20a%20model) endpoint `GET /api/v1/describe/{model}`, or the [Describe all models](https://docs.strangebee.com/thehive/api-docs/#tag/Describe/operation/Describe%20all%20models) endpoint `GET /api/v1/describe/_all` for every entity type at once.

## Query API request body

When sent to `POST /api/v1/query`, the request body accepts three fields:

| Field | Required | Description |
|---|---|---|
| `query` | Yes | An array of operation objects, each with a `_name` field identifying the operation type |
| `includeFields` | No | An array of field names to keep in every result object. All other fields are omitted |
| `excludeFields` | No | An array of field names to omit from every result object. Ignored when `includeFields` is set |

!!! example
    Get the first 10 high-severity cases, sorted by creation date with the newest first, with task statistics, share count, and the total number of results in the `X-Total` response header:

    ```json
    {
      "query": [
        {"_name": "listCase"},
        {
          "_name": "filter",
          "_eq": {"_field": "severity", "_value": 3}
        },
        {
          "_name": "sort",
          "_fields": [{"_createdAt": "desc"}]
        },
        {
          "_name": "page",
          "from": 0,
          "to": 10,
          "extraData": ["taskStats", "shareCount", "total"]
        }
      ],
      "excludeFields": ["description"]
    }
    ```

See the [Query and Export](https://docs.strangebee.com/thehive/api-docs/#tag/Query-and-Export) section of the API documentation for ready-to-use curl and Python examples.

## Primary operations

Primary operations are the first step in a query pipeline. Two types are available:

* `listXxx`: Returns all entities of that type accessible to the current user.
* `getXxx`: Returns a single entity identified by `idOrName`, which is either an ID prefixed with `~` or a type-specific field.

!!! example
    List all cases accessible to the current user:

    ```json
    {
      "query": [
        {"_name": "listCase"}
      ],
      "excludeFields": ["description"]
    }
    ```

    Get case `~1234` by its ID:

    ```json
    {
      "query": [
        {"_name": "getCase", "idOrName": "~1234"}
      ],
      "excludeFields": ["description"]
    }
    ```

### Primary operations by entity

| Entity | Operation | Description |
|---|---|---|
| Any entity | `listAny` | Lists all alerts, cases, observables, tasks, and task logs accessible to the current user, in a single result set |
| Any entity | `getAny` | Gets any entity by ID across all entity types accessible to the current user |
| [Case](analyst-corner/cases/about-cases.md) | `listCase` | Lists all cases accessible to the current user |
| Case | `getCase` | Gets a single case by ID or case number |
| Case | `countCase` | Deprecated. Counts cases accessible to the current user. Replaced by `[{"_name": "listCase"}, {"_name": "count"}]`. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| [Alert](analyst-corner/alerts/about-alerts.md) | `listAlert` | Lists all alerts accessible to the current user |
| Alert | `getAlert` | Gets a single alert by ID or by alert reference in the form `type;source;sourceRef` |
| Alert | `countAlert` | Deprecated. Counts alerts accessible to the current user. Replaced by a `listAlert`+`count` chain. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `countUnreadAlert` | Deprecated. Counts alerts with stage *New*. Replaced by a `listAlert`+`filter`+`count` chain. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `countImportedAlert` | Deprecated. Counts alerts with [stage *Imported*](../administration/status/about-statuses.md#attributes). Replaced by a `listAlert`+`filter`+`count` chain. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `countRelatedAlert` | Deprecated. Counts alerts related to a given case. Replaced by a `listAlert`+`filter`+`count` chain. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| [Task](analyst-corner/tasks/about-tasks.md) | `listTask` | Lists all tasks accessible to the current user |
| Task | `getTask` | Gets a single task by ID |
| Task | `listCaseTask` | Lists tasks linked to cases, excluding case template tasks |
| Task | `waitingTasks` | Lists tasks with status *Waiting* linked to cases |
| Task | `myTasks` | Lists tasks assigned to the current user |
| Task | `waitingTask` | Deprecated. Alias for `waitingTasks` |
| Task | `countTask` | Deprecated. Counts non-cancelled tasks for a given case. Replaced by a `listTask`+`filter`+`count` chain. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| [Observable](analyst-corner/cases/observables/about-observables.md) | `listObservable` | Lists all observables accessible to the current user |
| Observable | `getObservable` | Gets a single observable by ID |
| Observable | `countCaseObservable` | Deprecated. Counts observables of a given case. Replaced by a `listObservable`+`filter`+`count` chain. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Observable | `countAlertObservable` | Deprecated. Counts observables of a given alert. Replaced by a `listObservable`+`filter`+`count` chain. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| [Log](analyst-corner/tasks/about-task-logs.md) | `listLog` | Lists all task logs accessible to the current user |
| Log | `getLog` | Gets a single task log by ID |
| Comment | `listComment` | Lists all comments accessible to the current user |
| Comment | `getComment` | Gets a single comment by ID |
| [Share](../administration/organizations/about-organizations-sharing-rules.md) | `listShare` | Lists all sharing configurations |
| Share | `getShare` | Gets a single sharing configuration by ID |
| [Procedure](analyst-corner/cases/ttps/about-ttps.md) | `listProcedure` | Lists all procedures, also known as Tactics, Techniques, and Procedures (TTPs), accessible to the current user |
| Procedure | `getProcedure` | Gets a single procedure by ID |
| Page | `listPage` | Lists all pages accessible to the current user, including [Knowledge Base pages](knowledge-base/about-knowledge-base.md) and [case pages](knowledge-base/about-case-pages.md) |
| Page | `listOrganisationPage` | Lists the Knowledge Base pages of the current organization |
| Page | `getPage` | Gets a single Knowledge Base page or case page by ID |
| [Case template](organization/configure-organization/manage-templates/case-templates/about-case-templates.md) | `listCaseTemplate` | Lists all case templates |
| Case template | `getCaseTemplate` | Gets a single case template by ID or name |
| [Page template](organization/configure-organization/manage-templates/case-page-templates/about-case-page-templates.md) | `listPageTemplate` | Lists all page templates |
| Page template | `getPageTemplate` | Gets a single page template by ID |
| [Organization](../administration/organizations/about-organizations.md) | `listOrganisation` | Lists all organizations |
| Organization | `getOrganisation` | Gets a single organization by ID or name |
| [User](organization/configure-organization/manage-user-accounts/about-user-accounts.md) | `listUser` | Lists all users |
| User | `getUser` | Gets a single user by ID or login |
| User | `currentUser` | Returns the currently authenticated user |
| User | `listVisibleUsers` | Lists users from all organizations visible to the current user |
| [Custom field](../administration/custom-fields/about-custom-fields.md) | `listCustomField` | Lists all custom fields |
| Custom field | `getCustomField` | Gets a single custom field by ID or name |
| [Alert status](../administration/status/about-statuses.md) | `listAlertStatus` | Lists all alert statuses |
| Alert status | `getAlertStatus` | Gets a single alert status by ID or value |
| [Case status](../administration/status/about-statuses.md) | `listCaseStatus` | Lists all case statuses |
| Case status | `getCaseStatus` | Gets a single case status by ID or value |
| [Observable type](analyst-corner/cases/observables/about-observables.md#type) | `listObservableType` | Lists all observable types |
| Observable type | `getObservableType` | Gets a single observable type by ID or name |
| [Pattern](analyst-corner/cases/ttps/about-ttps.md) | `listPattern` | Lists all attack techniques accessible to the current user |
| Pattern | `getPattern` | Gets a single attack technique by ID |
| [Taxonomy](../administration/taxonomies/about-taxonomies.md) | `listTaxonomy` | Lists all taxonomies accessible to the current user |
| Taxonomy | `getTaxonomy` | Gets a single taxonomy by ID or namespace |
| [Tag](analyst-corner/cases/tags/about-tags.md) | `listTag` | Lists all custom tags of the current organization, excluding taxonomy-imported tags |
| Tag | `getTag` | Gets a single tag by ID |
| Tag | `freetags` | Alias for `listTag` |
| Tag | `tagAutoComplete` | Autocompletes tag suggestions. Takes a `TagHint` parameter with `namespace`, `predicate`, `value`, `freeTag`, and `limit` fields. Doesn't support sort, filter, pagination, or `extraData` |
| Tag | `countFreetags` | Counts custom tags of the current organization. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| [Catalog of patterns](analyst-corner/cases/ttps/about-ttps.md) | `listCatalog` | Lists all attack technique catalogs |
| Catalog of patterns | `getCatalog` | Gets a single attack technique catalog by ID or name |
| [Profile](../administration/profiles/about-profiles.md) | `listProfile` | Lists all profiles |
| Profile | `getProfile` | Gets a single profile by ID or name |
| [Dashboard](analyst-corner/dashboard/about-dashboards.md) | `listDashboard` | Lists all dashboards accessible to the current user |
| Dashboard | `getDashboard` | Gets a single dashboard by ID |
| [Custom event](analyst-corner/cases/case-timelines/about-case-timelines.md) | `listCustomEvent` | Lists all custom events in timelines accessible to the current user |
| Custom event | `getCustomEvent` | Gets a single custom event from timelines by ID |
| [Case report](analyst-corner/cases/case-reports/about-case-reports.md) | `listCaseReport` | Lists all case reports accessible to the current user |
| Case report | `getCaseReport` | Gets a single case report by ID |
| [Case report template](organization/configure-organization/manage-templates/case-report-templates/about-case-report-templates.md) | `listCaseReportTemplate` | Lists all case report templates |
| Case report template | `getCaseReportTemplate` | Gets a single case report template by ID |
| [Audit](organization/about-audit-logs.md) | `getAudit` | Gets a single audit log by ID |
| Audit | `listAuditFromObject` | Lists audit logs for a given object. Takes an `id` parameter: the object's ID |
| Cortex action | `listAction` | Lists all Cortex responder actions accessible to the current user |
| Cortex action | `getAction` | Gets a single Cortex responder action by ID |
| [Cortex analyzer template](../administration/analyzer-templates/about-analyzer-templates.md) | `listAnalyzerTemplate` | Lists all analyzer report templates |
| Cortex analyzer template | `getReportTemplate` | Gets a single analyzer report template by ID |
| Cortex job | `listJob` | Lists all Cortex analysis jobs accessible to the current user |
| Cortex job | `getJob` | Gets a single Cortex analysis job by ID |
| [Function](organization/configure-organization/manage-functions/about-functions.md) | `listFunction` | Lists all functions accessible to the current user. Requires a Platinum license |
| Function | `getFunction` | Gets a single function by ID or name. Requires a Platinum license |

## Related object operations

After a primary operation, chain a related object operation to navigate to associated entities. These operations return the related entities and can themselves be followed by filter, sort, or further related object steps.

!!! example
    Get all observables across all accessible cases:

    ```json
    {
      "query": [
        {"_name": "listCase"},
        {"_name": "observables"}
      ],
      "excludeFields": ["description"]
    }
    ```

    Get the task logs of case `~1234`:

    ```json
    {
      "query": [
        {"_name": "getCase", "idOrName": "~1234"},
        {"_name": "tasks"},
        {"_name": "logs"}
      ],
      "excludeFields": ["description"]
    }
    ```

### Related object operations by entity

| Source entity | Operation | Returns |
|---|---|---|
| Any entity | `count` | Number of entities in the current result set. Recommended replacement for the deprecated `countXxx` operations |
| [Case](analyst-corner/cases/about-cases.md) | `tasks` | Tasks of the case |
| Case | `taskGroups` | Distinct task group names in the case. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `observables` | Observables of the case |
| Case | `alerts` | Alerts merged into the case |
| Case | `shares` | Sharing configurations of the case |
| Case | `organisations` | Organizations the case is shared with |
| Case | `procedures` | Procedures attached to the case |
| Case | `pages` | Pages attached to the case |
| Case | `attachments` | Attachments of the case |
| Case | `comments` | Comments on the case |
| Case | `allComments` | Comments on the case and on its merged alerts |
| Case | `assignableUsers` | Users who can be assigned to the case |
| Case | `similarCasesLight` | Cases sharing observables with this case, with the matching observables grouped by data type. Doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `similarCaseLightCount` | Number of cases sharing observables with this case. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `similarAlertsLight` | Alerts sharing observables with this case, with the matching observables grouped by data type. Doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `similarAlertLightCount` | Number of alerts sharing observables with this case. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `similarCases` | Deprecated. Use `similarCasesLight` for improved performance. Doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `similarCaseCount` | Deprecated. Use `similarCaseLightCount` for improved performance. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `similarAlerts` | Deprecated. Use `similarAlertsLight` for improved performance. Doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `similarAlertCount` | Deprecated. Use `similarAlertLightCount` for improved performance. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `linkedCases` | Deprecated. Alias for `similarCases`. Use `similarCasesLight` instead. Doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `linkedCaseCount` | Deprecated. Use `similarCaseLightCount` for improved performance. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Case | `customEvents` | Custom events attached to the case in the timeline |
| Case | `caseReports` | Case reports of the case |
| Case | `timeline` | Activity timeline of the case |
| Case | `actions` | Cortex responder executions run on the case |
| Case | `external` | Restricts the result set to external-access cases shared through [TheHive Portal](../administration/thehive-portal/about-thehive-portal.md). Requires a Platinum license |
| [Alert](analyst-corner/alerts/about-alerts.md) | `case` | Case the alert was merged into |
| Alert | `observables` | Observables of the alert |
| Alert | `procedures` | Procedures attached to the alert |
| Alert | `comments` | Comments on the alert |
| Alert | `attachments` | Attachments of the alert |
| Alert | `assignableUsers` | Users who can be assigned to the alert |
| Alert | `similarCasesLight` | Cases sharing observables with this alert, with the matching observables grouped by data type. Doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `similarCaseLightCount` | Number of cases sharing observables with this alert. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `similarAlertsLight` | Alerts sharing observables with this alert, with the matching observables grouped by data type. Doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `similarAlertLightCount` | Number of alerts sharing observables with this alert. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `similarCases` | Deprecated. Use `similarCasesLight` for improved performance. Doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `similarCaseCount` | Deprecated. Use `similarCaseLightCount` for improved performance. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `similarAlerts` | Deprecated. Use `similarAlertsLight` for improved performance. Doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `similarAlertCount` | Deprecated. Use `similarAlertLightCount` for improved performance. Returns a value directly and doesn't support sort, filter, pagination, `extraData`, or output |
| Alert | `actions` | Cortex responder executions run on the alert |
| [Task](analyst-corner/tasks/about-tasks.md) | `case` | Case the task belongs to |
| Task | `caseTemplate` | Case template the task originates from |
| Task | `logs` | Task logs of the task |
| Task | `shares` | Sharing configurations of the task |
| Task | `organisations` | Organizations the task is shared with |
| Task | `assignableUsers` | Users who can be assigned to the task |
| Task | `inCase` | Restricts the result set to tasks linked to a case, excluding case template tasks |
| Task | `actions` | Cortex responder executions run on the task |
| [Observable](analyst-corner/cases/observables/about-observables.md) | `case` | Case the observable belongs to |
| Observable | `alert` | Alert the observable belongs to |
| Observable | `shares` | Sharing configurations of the observable |
| Observable | `organisations` | Organizations the observable is shared with |
| Observable | `similar` | Observables similar to this one |
| Observable | `attachments` | Attachments of the observable |
| Observable | `jobs` | Cortex analysis jobs run on the observable |
| Observable | `actions` | Cortex responder executions run on the observable |
| Observable | `fromCase` | Restricts the result set to observables attached to a case |
| Observable | `fromAlert` | Restricts the result set to observables attached to an alert |
| Observable | `fromJobReport` | Restricts the result set to observables produced by a Cortex analyzer report |
| [Log](analyst-corner/tasks/about-task-logs.md) | `attachments` | Attachments of the log |
| Log | `actions` | Cortex responder executions run on the task log |
| [Share](../administration/organizations/about-organizations-sharing-rules.md) | `case` | Case associated with the share |
| Share | `observables` | Observables associated with the share |
| Share | `tasks` | Tasks associated with the share |
| Share | `organisation` | Organization associated with the share |
| [Case template](organization/configure-organization/manage-templates/case-templates/about-case-templates.md) | `tasks` | Task templates of the case template |
| Case template | `pageTemplates` | Page templates of the case template |
| [Page template](organization/configure-organization/manage-templates/case-page-templates/about-case-page-templates.md) | `caseTemplates` | Case templates that include the page template |
| Page template | `headerPage` | Experimental. Page template header info, without the content field. Accepts `from`, `to`, and `extraData` pagination parameters |
| [Organization](../administration/organizations/about-organizations.md) | `users` | Users in the organization |
| Organization | `caseTemplates` | Case templates of the organization |
| Organization | `alerts` | Alerts of the organization |
| Organization | `attachments` | Attachments of the organization |
| Organization | `visible` | Restricts the result set to organizations visible to the current user |
| [User](organization/configure-organization/manage-user-accounts/about-user-accounts.md) | `tasks` | Tasks assigned to the user |
| User | `cases` | Cases assigned to the user |
| User | `alerts` | Alerts assigned to the user |
| [Tag](analyst-corner/cases/tags/about-tags.md) | `freetags` | Restricts the result set to custom tags of the current organization |
| Tag | `text` | Display name of each tag. Doesn't support sort, filter, pagination, or `extraData` |
| [Catalog of patterns](analyst-corner/cases/ttps/about-ttps.md) | `patterns` | Techniques in the attack catalog |
| Catalog of patterns | `tactics` | Tactics in the attack catalog. Supports sort, filter, count, and aggregation. Doesn't support pagination, `extraData`, or output |
| [Taxonomy](../administration/taxonomies/about-taxonomies.md) | `tags` | Tags belonging to the taxonomy |
| [Case report template](organization/configure-organization/manage-templates/case-report-templates/about-case-report-templates.md) | `attachments` | Files uploaded to the template for use in *Image* widgets |
| Cortex job | `observable` | Observable the job analyzed |
| Cortex job | `reportObservables` | Observables produced by the analyzer report |

## Filters

Use `"_name": "filter"` to narrow the current result set.

| Filter | Syntax | Description |
|---|---|---|
| `_and` | `{"_and": [...other filters]}` | All conditions must match |
| `_or` | `{"_or": [...other filters]}` | At least one condition must match |
| `_not` | `{"_not": { other filter }}` | Condition must not match |
| `_any` | `{"_any": null}` | Matches any entity |
| `_lt` | `{"_lt": {"_field": "<field>", "_value": <value>}}` | Less than |
| `_gt` | `{"_gt": {"_field": "<field>", "_value": <value>}}` | Greater than |
| `_lte` | `{"_lte": {"_field": "<field>", "_value": <value>}}` | Less than or equal |
| `_gte` | `{"_gte": {"_field": "<field>", "_value": <value>}}` | Greater than or equal |
| `_ne` | `{"_ne": {"_field": "<field>", "_value": <value>}}` | Not equal |
| `_eq` | `{"_eq": {"_field": "<field>", "_value": <value>}}` | Equal |
| `_is` | `{"_is": {"_field": "<field>", "_value": <value>}}` | Same as `_eq` |
| `_startsWith` | `{"_startsWith": {"_field": "<field>", "_value": "<value>"}}` | String starts with |
| `_endsWith` | `{"_endsWith": {"_field": "<field>", "_value": "<value>"}}` | String ends with |
| `_id` | `{"_id": "~<id>"}` | Filter by ID |
| `_between` | `{"_between": {"_field": "<field>", "_from": <from>, "_to": <to>}}` | Range filter. `_from` is inclusive and `_to` is exclusive. Both are required |
| `_in` | `{"_in": {"_field": "<field>", "_values": [<value1>, ...]}}` | Field matches one of the given values |
| `_has` | `{"_has": "<field>"}` | The object has this field |
| `_like` | `{"_like": {"_field": "<field>", "_value": "<value>"}}` | The field or a word within it contains the substring, depending on the index type |
| `_match` | `{"_match": {"_field": "<field>", "_value": "<value>"}}` | Field contains the word |
| `_contains` | `{"_contains": "<field>"}` | Deprecated. Replaced by `_has` |

!!! example
    Filter the case list to keep only high-severity cases:

    ```json
    {
      "query": [
        {"_name": "listCase"},
        {
          "_name": "filter",
          "_eq": {"_field": "severity", "_value": 3}
        }
      ],
      "excludeFields": ["description"]
    }
    ```

    Get the tasks of case `~1234` that are still in progress:

    ```json
    {
      "query": [
        {"_name": "getCase", "idOrName": "~1234"},
        {"_name": "tasks"},
        {
          "_name": "filter",
          "_eq": {"_field": "status", "_value": "InProgress"}
        }
      ],
      "excludeFields": ["description"]
    }
    ```

### Date values in filters

Date fields accept two formats.

#### Timestamp

A numeric value in milliseconds since the Unix epoch. Available with `_lt`, `_gt`, `_lte`, `_gte`, `_ne`, `_eq`, `_between`, and `_in`.

```json
"_gte": {
  "_field": "_createdAt",
  "_value": 1734425224596
}
```

#### Relative date

A JSON object expressing a date relative to now. Available with `_lt`, `_gt`, `_lte`, `_gte`, and `_between`.

| Field | Required | Type | Value |
|---|---|---|---|
| `amount` | Yes | int | 0 or greater |
| `unit` | Yes | string | `seconds`, `minutes`, `hours`, `days`, `weeks`, `months`, `years` |
| `look` | Yes | string | `behind`, `ahead` |
| `timezone` | No | string | Time zone ID. Defaults to the system time zone |
| `modifier` | No | string | `startOfDay`, which sets the time to `00:00:00`, or `endOfDay`, which sets the time to `23:59:59.999999999` |

A relative date resolves against the current time, which is the same point in time regardless of time zone. When `modifier` is set, the resulting time depends on the time zone. Use `timezone` and `modifier` together to get predictable results.

!!! example
    Fetches data created yesterday:

    ```json
    {
      "_name": "filter",
      "_between": {
        "_field": "_createdAt",
        "_from": {"amount": 1, "unit": "days", "look": "behind", "modifier": "startOfDay"},
        "_to":   {"amount": 1, "unit": "days", "look": "behind", "modifier": "endOfDay"}
      }
    }
    ```

    Fetches data created today:

    ```json
    {
      "_name": "filter",
      "_gt": {
        "_field": "_createdAt",
        "_value": {"amount": 0, "unit": "days", "look": "behind", "modifier": "startOfDay"}
      }
    }
    ```

    Fetches data created in the last six months in a specific time zone:

    ```json
    {
      "_name": "filter",
      "_between": {
        "_field": "_createdAt",
        "_from": {"amount": 6, "unit": "months", "look": "behind", "timezone": "Australia/Darwin", "modifier": "startOfDay"},
        "_to":   {"amount": 0, "unit": "days",   "look": "behind"}
      }
    }
    ```

## Sorting

Use `"_name": "sort"` with a `_fields` array to order results. The direction is one of `asc` or `desc`.

!!! example
    Sort the high-severity cases by creation date, newest first:

    ```json
    {
      "query": [
        {"_name": "listCase"},
        {
          "_name": "filter",
          "_eq": {"_field": "severity", "_value": 3}
        },
        {
          "_name": "sort",
          "_fields": [{"_createdAt": "desc"}]
        }
      ],
      "excludeFields": ["description"]
    }
    ```

## Pagination and extra data

Use `"_name": "page"` as the last step to paginate results and request computed fields:

| Field | Description |
|---|---|
| `from` | Index of the first result to return |
| `to` | Index after the last result to return |
| `extraData` | An array of computed field names to add to each result |

Not every operation supports `page`. Some return a value that's already final and accept no further step at all. For the rest, leaving off the last step already returns the full and unpaginated result, without `extraData` or the `X-Total` total count. Adding `"_name": "output"` as the last step makes that intent explicit without changing the response.

TheHive adds an `extraData` object to each result containing the requested computed fields. Available values depend on the entity type. See [Extra data by entity](#extra-data-by-entity).

Include `"total"` in `extraData` to receive the total number of matching results in the `X-Total` response header.

!!! example
    Get the first 5 in-progress tasks of case `~1234`, sorted by due date with the earliest first, with the assigned case template:

    ```json
    {
      "query": [
        {"_name": "getCase", "idOrName": "~1234"},
        {"_name": "tasks"},
        {
          "_name": "filter",
          "_eq": {"_field": "status", "_value": "InProgress"}
        },
        {
          "_name": "sort",
          "_fields": [{"dueDate": "asc"}]
        },
        {
          "_name": "page",
          "from": 0,
          "to": 5,
          "extraData": ["caseTemplate", "total"]
        }
      ],
      "excludeFields": ["description"]
    }
    ```

### Extra data by entity

| Entity | Value | Description |
|---|---|---|
| Any entity | `total` | Total number of matching results across all pages. Returned in the `X-Total` response header |
| [Case](analyst-corner/cases/about-cases.md) | `observableStats` | Statistics about observables in the case |
| Case | `taskStats` | Statistics about tasks in the case |
| Case | `alerts` | Alerts linked to the case |
| Case | `alertCount` | Number of alerts linked to the case |
| Case | `isOwner` | Whether the requesting organization owns the case |
| Case | `shareCount` | Number of organizations the case is shared with |
| Case | `permissions` | Permissions the current user has on the case |
| Case | `actionRequired` | Whether an action is required from the current user |
| Case | `procedureCount` | Number of procedures attached to the case |
| Case | `attachmentCount` | Number of attachments in the case |
| Case | `contributors` | Users who have contributed to the case |
| Case | `computed.handlingDuration` | Time elapsed from case creation to close, in milliseconds |
| Case | `computed.handlingDurationInSeconds` | Handling duration in seconds |
| Case | `computed.handlingDurationInMinutes` | Handling duration in minutes |
| Case | `computed.handlingDurationInHours` | Handling duration in hours |
| Case | `computed.handlingDurationInDays` | Handling duration in days |
| Case | `status` | Status object with stage and color |
| Case | `owningOrganisation` | Organization that owns the case |
| Case | `links` | Cases linked to this case |
| [Alert](analyst-corner/alerts/about-alerts.md) | `importDate` | Date the alert was merged into a case |
| Alert | `caseNumber` | Deprecated. Number of the case the alert was merged into |
| Alert | `relatedCase` | Case the alert was merged into |
| Alert | `status` | Status object with stage and color |
| Alert | `procedureCount` | Number of procedures attached to the alert |
| [Task](analyst-corner/tasks/about-tasks.md) | `case` | Case the task belongs to |
| Task | `caseId` | ID of the case the task belongs to |
| Task | `caseTemplate` | Case template the task originates from |
| Task | `caseTemplateId` | ID of the case template |
| Task | `isOwner` | Whether the requesting organization owns the task |
| Task | `shareCount` | Number of organizations the task is shared with |
| Task | `actionRequired` | Whether an action is required on the task |
| Task | `actionRequiredMap` | Map of organizations requiring action on the task |
| Task | `logCount` | Number of logs in the task |
| [Observable](analyst-corner/cases/observables/about-observables.md) | `seen` | Deprecated. Whether the observable has been seen in other cases |
| Observable | `seenSummary` | Summary of cases where the observable appears |
| Observable | `shares` | Organizations the observable is shared with |
| Observable | `links` | Observables linked to this one |
| Observable | `permissions` | Permissions the current user has on the observable |
| Observable | `isOwner` | Whether the requesting organization owns the observable |
| Observable | `shareCount` | Number of organizations the observable is shared with |
| [Log](analyst-corner/tasks/about-task-logs.md) | `case` | Case the task log belongs to |
| Log | `task` | Task the log belongs to |
| Log | `taskId` | ID of the task the log belongs to |
| Log | `actionCount` | Number of actions on the task log |
| Comment | `links` | Case or alert the comment belongs to |
| [Procedure](analyst-corner/cases/ttps/about-ttps.md) | `pattern` | Attack techniques associated with the procedure |
| Procedure | `tactic` | Attack tactics associated with the procedure |
| Procedure | `patternParent` | Parent attack technique in the hierarchy |
| Procedure | `patternTactics` | All tactics associated with the attack technique |
| Procedure | `patternCatalog` | Catalog the attack technique belongs to |
| [Organization](../administration/organizations/about-organizations.md) | `userCount` | Number of users in the organization |
| [User](organization/configure-organization/manage-user-accounts/about-user-accounts.md) | `lockout` | Information about authentication lockout for the user |
| User | `organisations` | Organizations the user belongs to |
| [Pattern](analyst-corner/cases/ttps/about-ttps.md) | `parent` | Parent attack technique in the hierarchy |
| Pattern | `children` | Child attack techniques in the hierarchy |
| Pattern | `tactics` | Tactics associated with the attack technique |
| Pattern | `catalog` | Catalog the attack technique belongs to |
| [Catalog of patterns](analyst-corner/cases/ttps/about-ttps.md) | `tactics` | Tactics defined in the attack catalog |
| [Tag](analyst-corner/cases/tags/about-tags.md) | `usage` | Usage statistics for the tag |
| [Taxonomy](../administration/taxonomies/about-taxonomies.md) | `enabled` | Whether the taxonomy is enabled in the current organization |
| [Custom field](../administration/custom-fields/about-custom-fields.md) | `deletable` | Whether the custom field can be deleted |
| [Alert status](../administration/status/about-statuses.md) | `canDelete` | Whether the alert status can be deleted |
| [Case status](../administration/status/about-statuses.md) | `canDelete` | Whether the case status can be deleted |
| [Case template](organization/configure-organization/manage-templates/case-templates/about-case-templates.md) | `pageTemplateHeaders` | Headers of the page templates linked to the case template |
| [Page template](organization/configure-organization/manage-templates/case-page-templates/about-case-page-templates.md) | `caseTemplateCount` | Number of case templates that include this page template |
| Cortex job | `links` | Case or alert the Cortex job's observable belongs to |
| Cortex job | `report` | Cortex analyzer report content |
| [Attachment](analyst-corner/cases/attachments/about-attachments.md) | `task` | Task log the attachment belongs to, when the attachment is a log attachment |

<h2>Next steps</h2>

* [Functions Objects](organization/configure-organization/manage-functions/functions-objects.md)
* [Write a FilteredEvent Trigger](organization/configure-organization/manage-notifications/write-filtered-event-trigger.md)
* [Date Field Definitions for Alerts and Cases](date-field-definitions-alerts-cases.md)
