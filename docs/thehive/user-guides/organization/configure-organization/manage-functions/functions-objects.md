# Functions Objects

Functions in TheHive have access to predefined objects that enable interaction with cases, alerts, tasks, observables, and other entities.

!!! info "API documentation for further details"
    The objects in functions are the same as those used in TheHive HTTP API.

    For details on the expected fields for each object, see the [TheHive HTTP API documentation](https://docs.strangebee.com/thehive/api-docs/){target=_blank}.

## User

* `userId: string` : Returns the login identifier of the user executing the function.
* `userName: string`: Returns the display name of the user executing the function.

## HTTP request

* `request.queryString() : Record<string, string[]>`: Returns a dictionary of query string parameters formatted as a key-value map.
* `request.getQueryString(key: string): string | null`: Retrieves the value associated with a specific query string key. Returns `null` if the key does not exist.
* `request.getHeader(name: string): string | null`: Retrieves the value of a specific HTTP request header. Returns `null` if the header is not present.
* `request.headers(): Record<string, string>`: Returns all request headers as a dictionary.
* `request.contentType: string`: Retrieves the `Content-Type` header value from the request.
* `request.remoteAddress(): string`: Returns the IP address of the client making the request.

## Query

* `query.execute(query: any[])`: Executes a database query.

## Alert

* `alert.create(input: InputCreateAlert): OutputAlert`: Creates a new alert.  

    ??? tip "Example"

        ```javascript
        context.alert.create({
            type: "brute_force",
            source: "Firewall logs",
            sourceRef: "3432",
            title: "Brute force attack detected",
            description: "Multiple failed login attempts detected on the admin portal.",
            severity: 3,
            pap: 2,
            tlp: 2
        });
        ```

        See the [`POST /api/v1/alert` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Alert/operation/Create%20Alert){target=_blank} for the complete object definition.

* `alert.update(alertId: string, update: InputUpdateAlert): OutputAlert`: Updates an alert.

    ??? tip "Example"

        ```javascript
        context.alert.update(
            "~456",
            {
                severity: 4,
                tags: ["brute-force", "login"]
            }
        );
        ```

        See the [`PATCH /api/v1/alert/{alertId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Alert/operation/Update%20Alert){target=_blank} for the complete object definition.

* `alert.bulkUpdate(update: {ids: string[]} & InputUpdateAlert): void`: Updates multiple alerts at once.

    ??? tip "Example"

        {% include-markdown "includes/typescript-notation.md" %}

        ```javascript
        context.alert.bulkUpdate({
            ids: ["~456", "~457"],
            severity: 1,
            tags: ["false-positive"]
        });
        ```

        See the [`PATCH /api/v1/alert/_bulk` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Alert/operation/Bulk%20update%20Alert){target=_blank} for the complete object definition.

* `alert.get(alertId: string): OutputAlert`: Retrieves an alert.
* `alert.delete(alertId: string): void`: Deletes an alert.
* `alert.bulkDelete(input: {ids: string[]}): void`: Deletes multiple alerts at once.
* `alert.createCase(alertId: string, input: InputCreateCaseFromAlert): OutputCase`: Converts an alert into a case.

    ??? tip "Example"

        ```javascript
        context.alert.createCase(
            "~456",
            {
                title: "DNS tunneling detected",
                description: "Suspicious DNS requests detected, indicating potential tunneling activity.",
                severity: 2,
                pap: 0,
                tlp: 4
            }
        );
        ```

        See the [`POST /api/v1/alert/{alertId}/case` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Alert/operation/Create%20Case%20from%20Alert){target=_blank} for the complete object definition.

* `alert.mergeWithCase(alertId: string, caseId: string): OutputCase`: Merges an alert with an existing case.
* `alert.importInCase(alertId: string, caseId: string): OutputAlert`: Imports observables and procedures from an alert into an existing case.
* `alert.bulkMergeWithCase(input: InputAlertsMergeWithCase): OutputCase`: Merges multiple alerts into a case.

    ??? tip "Example"

        ```javascript
        context.alert.bulkMergeWithCase({
            caseId: "~102",
            alertIds: ["~456", "~457"]
        });
        ```

        See the [`POST /api/v1/alert/merge/_bulk` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Alert/operation/Merge%20bulk%20Alerts%20with%20Case){target=_blank} for the complete object definition.

* `alert.followAlert(alertId: string): OutputAlert`: Starts following an alert for updates.
* `alert.unfollowAlert(alertId: string): OutputAlert`: Stops following an alert.
* `alert.find(query: any[]): OutputAlert[]`: Searches for alerts matching the given query.

## Case

!!! info "Caze"
    Because `case` is a reserved keyword in Java and JavaScript, the API uses `caze` instead.

* `caze.create(input: InputCreateCase): OutputCase`: Creates a new case.

    ??? tip "Example"

        ```javascript
        context.caze.create({
            title: "Phishing attempt detected",
            description: "A phishing email targeting employees with a fake login page.",
            severity: 2,
            pap: 2,
            tlp: 2
        });
        ```

        See the [`POST /api/v1/case` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Case/operation/Create%20case){target=_blank} for the complete object definition.

* `caze.update(idOrName: string, update: InputUpdateCase): void`: Updates a case.

    ??? tip "Example"

        ```javascript
        context.caze.update(
            "~102",
            {
                assignee: "sami@example.com"
            }
        );
        ```

        See the [`PATCH /api/v1/case/{idOrName}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Case/operation/Update%20case){target=_blank} for the complete object definition.

* `caze.bulkUpdate(update: {ids: string[]} & InputUpdateCase): void`: Updates multiple cases at once.

    ??? tip "Example"

        {% include-markdown "includes/typescript-notation.md" %}

        ```javascript
        context.caze.bulkUpdate({
            ids: ["~102", "~103"],
            assignee: "sami@example.com",
            status: "InProgress"
        });
        ```

        See the [`PATCH /api/v1/case/_bulk` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Case/operation/Bulk%20update%20case){target=_blank} for the complete object definition.

* `caze.get(idOrName: string): OutputCase`: Retrieves a case.
* `caze.merge(ids: string[]): OutputCase`: Merges multiple cases into one.
* `caze.delete(idOrName: string): void`: Deletes a case.
* `caze.changeCaseOwnership(caseId: string, input: InputChangeCaseOwnership): void`: Transfers ownership of a case.

    ??? tip "Example"

        ```javascript
        context.caze.changeCaseOwnership(
            "~102",
            {
                organisation: "TheOrganization",
                keepProfile: "analyst",
                taskRule: "autoShare",
                observableRule: "autoShare"
            }
        );
        ```

        See the [`POST /api/v1/case/{caseId}/owner` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Case/operation/Change%20Case%20owning%20organisation){target=_blank} for the complete object definition.

* `caze.unlinkAlert(caseId: string, alertId: string): void`: Removes an alert from a case.
* `caze.mergeSimilarObservables(caseId: string): void`: Merges observables within a case that share the same type, data, attachments, and visibility.
* `caze.bulkApplyCaseTemplate(input: {ids: string[]} & InputApplyCaseTemplate): void`: Applies a case template to multiple cases.

    ??? tip "Example"

        {% include-markdown "includes/typescript-notation.md" %}

        ```javascript
        context.caze.bulkApplyCaseTemplate({
            ids: ["~102", "~103"],
            caseTemplate: "Trademark infringement",
            importTasks: ["Preparation", "Identification unusual services", "Backup", "Remediation", "Recovery", "Report"]
        });
        ```

        See the [`POST /api/v1/case/_bulk/caseTemplate` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Case/operation/Apply%20CaseTemplate%20on%20existing%20cases){target=_blank} for the complete object definition.

* `caze.find(query: any[]): OutputCase[]`: Searches for cases based on a query.
* `caze.manageCaseAccess(caseId: string, input: InputManageCaseAccess): void`: Sets the access level for a case.

    ??? tip "Example"

        ```javascript
        context.caze.manageCaseAccess(
            "~102",
            {
                access: {
                    users: ["lucas@example.com", "emma@example.com"],
                    _kind: "UserAccessKind"
                }
            }
        );
        ```

        ```javascript
        context.caze.manageCaseAccess(
            "~103",
            {
                access: {
                    _kind: "AllExternalAccessKind"
                }
            }
        );
        ```

        Allowed values for `_kind`:

        * `OrganisationAccessKind`: Makes the case visible to all members of the organization.
        * `UserAccessKind`: Restricts access to specific internal users. The user list must include at least the case assignee and the user making the request.
        * `AllExternalAccessKind`: Shares the case with all external users via [TheHive Portal](../../../../administration/thehive-portal/about-thehive-portal.md). Authorizing all external users grants access to both current and future external users.
        * `ExternalAccessKind`: Shares the case with selected external users via [TheHive Portal](../../../../administration/thehive-portal/about-thehive-portal.md). External users must already exist in TheHive with the External account type.

        See the [`POST /api/v1/case/{caseId}/access` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Case/operation/Manage%20Case%20access){target=_blank} for the complete object definition.

* `caze.manageCaseAccess(ids: string[] & input: InputManageCaseAccessWithIds): void`: Sets the access level for multiple cases at once.

    ??? tip "Example"

        ```javascript
        context.caze.manageCaseAccess({
            ids: ["102", "103"],
            access: {
                users: ["lucas@example.com", "emma@example.com"],
                _kind: "UserAccessKind"
            } 
        });
        ```

        ```javascript
        context.caze.manageCaseAccess({
            ids: ["104", "105"],
            access: {
                _kind: "AllExternalAccessKind"
            } 
        });
        ```

        Allowed values for `_kind`:

        * `OrganisationAccessKind`: Makes the case visible to all members of the organization.
        * `UserAccessKind`: Restricts access to specific internal users. The user list must include at least the case assignee and the user making the request.
        * `AllExternalAccessKind`: Shares the case with all external users via [TheHive Portal](../../../../administration/thehive-portal/about-thehive-portal.md). Authorizing all external users grants access to both current and future external users.
        * `ExternalAccessKind`: Shares the case with selected external users via [TheHive Portal](../../../../administration/thehive-portal/about-thehive-portal.md). External users must already exist in TheHive with the External account type.

        See the [`POST /api/v1/case/_bulk/access` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Case/operation/Bulk%20Manage%20Case%20access){target=_blank} for the complete object definition.

## Task

* `task.createInCase(caseId: string, input: InputCreateTask): OutputTask`: Creates a new task within a case.

    ??? tip "Example"

        ```javascript
        context.task.createInCase(
            "~102",
            {
               title: "Restore the system to normal",
               group: "Recovery",
               status: "New",
               mandatory: true,
               dueDate: 1767312000000
            }
        );
        ```

        See the [`POST /api/v1/case/{caseId}/task` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Task/operation/Create%20Task%20in%20Case){target=_blank} for the complete object definition.

* `task.update(taskId: string, update: InputUpdateTask): void`: Updates a task.

    ??? tip "Example"

        ```javascript
        context.task.update(
            "~8642",
            {
                flag: true,
                mandatory: true,
                dueDate: 1767312000000
            }
        );
        ```

        See the [`PATCH /api/v1/task/{taskId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Task/operation/Update%20Task){target=_blank} for the complete object definition.

* `task.bulkUpdate(update: {ids: string[]} & InputUpdateTask): void`: Updates multiple tasks at once.

    ??? tip "Example"

        {% include-markdown "includes/typescript-notation.md" %}

        ```javascript
        context.task.bulkUpdate({
            ids: ["~8642", "~8643"],
            assignee: "sami@example.com"
        });
        ```

        See the [`PATCH /api/v1/task/_bulk` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Task/operation/Update%20bulk%20of%20Task){target=_blank} for the complete object definition.

* `task.get(taskId: string): OutputTask`: Retrieves a task.
* `task.delete(taskId: string): void`: Deletes a task.
* `task.find(query: any[]): OutputTask[]`: Searches for tasks matching the given query.
* `task.setActionRequired(taskId: string, orgId: string): void`: Marks a task as requiring action.
* `task.setActionDone(taskId: string, orgId: string): void`: Marks a task as completed.
* `task.isActionRequired(taskId: string): Record<string, boolean>`: Checks whether a task requires action.

## Log

* `log.create(taskId: string, input: InputCreateLog): OutputLog`: Creates a log entry for a task.

    ??? tip "Example"

        ```javascript
        context.log.create(
            "~8642",
            {
               message: "Investigated the source IP. Multiple failed SSH login attempts confirmed. No successful authentication observed. Blocking rule applied on the firewall."
            }
        );
        ```

        See the [`POST /api/v1/task/{taskId}/log` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Task-Log/operation/Create%20Task%20Log){target=_blank} for the complete object definition.

* `log.update(logId: string, update: InputUpdateLog): void`: Updates a log entry.

    ??? tip "Example"

        ```javascript
        context.log.update(
            "~86723",
            {
               includeInTimeline: 1767312000000
            }
        );
        ```

        See the [`PATCH /api/v1/log/{logId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Task-Log/operation/Update%20Task%20Log){target=_blank} for the complete object definition.

* `log.delete(logId: string): void`: Deletes a log entry.
* `log.deleteAttachment(logId: string, attachmentId: string): void`: Removes an attachment from a log entry.
* `log.find(query: any[]): OutputLog[]`: Searches for logs matching the given query.

## Observable

* `observable.createInCase(caseId: string, input: InputCreateObservable): OutputObservable`: Creates an observable within a case.

    ??? tip "Example"

        ```javascript
        context.observable.createInCase(
            "~102",
            {
               dataType: "uri_path",
               data: "/malicious-path",
               message: "URI path used in DNS tunneling."
            }
        );
        ```

        See the [`POST /api/v1/case/{caseId}/observable` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Observable/operation/Create%20Observable%20in%20Case){target=_blank} for the complete object definition.

* `observable.createInAlert(alertId: string, input: InputCreateObservable): OutputObservable`: Creates an observable within an alert.

    ??? tip "Example"

        ```javascript
        context.observable.createInAlert(
            "~456",
            {
               dataType: "username",
               data: "admin",
               message: "Account targeted in brute force attack."
            }
        );
        ```

        See the [`POST /api/v1/alert/{alertId}/observable` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Observable/operation/Create%20Observable%20in%20Alert){target=_blank} for the complete object definition.

* `observable.update(observableId: string, update: InputUpdateObservable): void`: Updates an observable.

    ??? tip "Example"

        ```javascript
        context.observable.update(
            "~93040",
            {
               sighted: true,
               sightedAt: 1767312000000
            }
        );
        ```

        See the [`PATCH /api/v1/observable/{observableId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Observable/operation/Update%20Observable){target=_blank} for the complete object definition.

* `observable.bulkUpdate(update: {ids: string[]} & InputUpdateObservable): void`: Updates multiple observables.

    ??? tip "Example"

        {% include-markdown "includes/typescript-notation.md" %}

        ```javascript
        context.observable.bulkUpdate({
            ids: ["~93040", "~93041"],
            tlp: 3,
            pap: 3,
            ioc: true
        });
        ```

        See the [`PATCH /api/v1/observable/_bulk` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Observable/operation/Update%20bulk%20of%20Observables){target=_blank} for the complete object definition.

* `observable.updateAllTypes(fromType: string, toType: string): void`: Changes the type of all observables from one type to another.
* `observable.get(observableId: string): OutputObservable`: Retrieves an observable.
* `observable.delete(observableId: string): void`: Deletes an observable.
* `observable.find(query: any[]): OutputObservable[]`: Searches for observables matching the given query.

## Observable type

* `observableType.create(input: InputObservableType): void`: Creates a new observable type.

    ??? tip "Example"

        ```javascript
        context.observableType.create({
            name: "ip"
        });
        ```

        See the [`POST /api/v1/observable/type` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Observable-Type/operation/Create%20Observable%20Type){target=_blank} for the complete object definition.

* `observableType.get(typeId: string): OutputObservableType`: Retrieves an observable type.
* `observableType.delete(typeId: string): void`: Deletes an observable type.
* `observableType.find(query: any[]): OutputObservableType[]`: Searches for observable types matching the given query.

## Custom field

* `customField.create(input: InputCustomField): OutputCustomField`: Creates a new custom field.

    ??? tip "Example"

        ```javascript
        context.customField.create({
            name: "risk-ranking",
            group: "Default",
            description: "A risk ranking score",
            type: "integer"
        });
        ```

        See the [`POST /api/v1/customField` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/CustomField/operation/Create%20CustomField){target=_blank} for the complete object definition.

* `customField.update(customFieldId: string, update: InputUpdateCustomField): void`: Updates a custom field.

    ??? tip "Example"

        ```javascript
        context.customField.update(
            "vip-targeted",
            {
               type: "boolean",
               mandatory: true
            }
        );
        ```

        See the [`PATCH /api/v1/customField/{customFieldId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/CustomField/operation/Update%20CustomField){target=_blank} for the complete object definition.

* `customField.list(): OutputCustomField[]`: Returns a list of all custom fields.
* `customField.delete(customFieldId: string): void`: Deletes a custom field.
* `customField.find(query: any[]): OutputCustomField[]`: Searches for custom fields matching the given query.

## Tag

* `tag.update(tagId: string, update: InputUpdateTag): void`: Updates a tag.

    ??? tip "Example"

        ```javascript
        context.tag.update(
            "brute-force",
            {
               colour: "#a90b0bff"
            }
        );
        ```

        See the [`PATCH /api/v1/tag/{tagId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Tag/operation/Update%20Tag){target=_blank} for the complete object definition.

* `tag.get(tagId: string): OutputTag`: Retrieves a tag.
* `tag.delete(tagId: string): void`: Deletes a tag.

## Case template

* `caseTemplate.create(input: InputCreateCaseTemplate): OutputCaseTemplate`: Creates a new case template.

    ??? tip "Example"

        ```javascript
        context.caseTemplate.create({
            name: "Unix/Linux Intrusion Detection (CERT-SG IRM3)",
            tlp: 3,
            tasks: [
                        {title: "Unusual accounts", group: "Identification"},
                        {title: "Unusual log entries", group: "Identification"},
                        {title: "Backup", group: "Containment"},
                        {title: "Remediation", group: "Remediation"},
                        {title: "Aftermath", group: "Report"}
                   ]
        });
        ```

        See the [`POST /api/v1/caseTemplate` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/CaseTemplate/operation/Create%20CaseTemplate){target=_blank} for the complete object definition.

* `caseTemplate.update(caseTemplateNameOrId: string, update: InputUpdateCaseTemplate): void`: Updates a case template.

    ??? tip "Example"

        ```javascript
        context.caseTemplate.update(
            "~73338",
            {
               name: "Website defacement (CERT-SG IRM6)",
               tlp: 3
            }
        );
        ```

        See the [`PATCH /api/v1/caseTemplate/{caseTemplateNameOrId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/CaseTemplate/operation/Update%20CaseTemplate){target=_blank} for the complete object definition.

* `caseTemplate.get(caseTemplateNameOrId: string): OutputCaseTemplate`: Retrieves a case template.
* `caseTemplate.delete(caseTemplateNameOrId: string): void`: Deletes a case template.
* `caseTemplate.find(query: any[]): OutputCaseTemplate[]`: Searches for case templates matching the given query.

## Procedure

* `procedure.bulkCreateInCase(caseId: string, input: {procedures: InputProcedure[]}): OutputProcedure[]`: Creates multiple procedures within a case.

    ??? tip "Example"

        ```javascript
        context.procedure.bulkCreateInCase(
            "~102",
            {
               procedures: [
                                {patternId: "T1557.002", occurDate: 1767312000000},
                                {patternId: "T1548", occurDate: 1767312000000}
                           ]
            }
        );
        ```

        See the [`POST /api/v1/case/{caseId}/procedures` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/TTP/operation/Create%20several%20Procedures%20for%20Case){target=_blank} for the complete object definition.

* `procedure.bulkCreateInAlert(alertId: string, input: {procedures: InputProcedure[]}): OutputProcedure[]`: Creates multiple procedures within an alert.

    ??? tip "Example"

        ```javascript
        context.procedure.bulkCreateInAlert(
            "~456",
            {
               procedures: [
                                {patternId: "T1531", occurDate: 1767312000000},
                                {patternId: "T1595", occurDate: 1767312000000}
                           ]
            }
        );
        ```

        See the [`POST /api/v1/alert/{alertId}/procedures` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/TTP/operation/Create%20several%20Procedures%20for%20Alert){target=_blank} for the complete object definition.

* `procedure.createInCase(caseId: string, input: InputProcedure): OutputProcedure`: Creates a single procedure within a case.

    ??? tip "Example"

        ```javascript
        context.procedure.createInCase(
            "~102",
            {
               patternId: "T1557.002",
               occurDate: 1767312000000
            }
        );
        ```

        See the [`POST /api/v1/case/{caseId}/procedure` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/TTP/operation/Create%20Procedure%20for%20Case){target=_blank} for the complete object definition.

* `procedure.createInAlert(alertId: string, input: InputProcedure): OutputProcedure`: Creates a single procedure within an alert.

    ??? tip "Example"

        ```javascript
        context.procedure.createInAlert(
            "~456",
            {
               patternId: "T1531",
               occurDate: 1767312000000
            }
        );
        ```

        See the [`POST /api/v1/alert/{alertId}/procedure` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/TTP/operation/Create%20Procedure%20for%20Alert){target=_blank} for the complete object definition.

* `procedure.update(procedureId: string, input: InputUpdateProcedure): void`: Updates a procedure.

    ??? tip "Example"

        ```javascript
        context.procedure.update(
            "~T1650",
            {
               description: "Adversaries may purchase or otherwise acquire an existing access to a target system or network. A variety of online services and initial access broker networks are available to sell access to previously compromised systems.(Citation: Microsoft Ransomware as a Service)(Citation: CrowdStrike Access Brokers)(Citation: Krebs Access Brokers Fortune 500) In some cases, adversary groups may form partnerships to share compromised systems with each other.(Citation: CISA Karakurt 2022)"
            }
        );
        ```

        See the [`PATCH /api/v1/procedure/{procedureId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/TTP/operation/Update%20Procedure){target=_blank} for the complete object definition.

* `procedure.delete(procedureId: string): void`: Deletes a procedure.
* `procedure.find(query: any[])`: Searches for procedures matching the given query.

## Case status

* `caseStatus.create(input: InputCreateCaseStatus): OutputCaseStatus`: Creates a new case status.

    ??? tip "Example"

        ```javascript
        context.caseStatus.create({
            value: "Pending analysis",
            stage: "InProgress"
        });
        ```

        See the [`POST /api/v1/caseStatus` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/CaseStatus/operation/Create%20CaseStatus){target=_blank} for the complete object definition.

* `caseStatus.update(id: string, update: InputUpdateCaseStatus): void`: Updates a case status.

    ??? tip "Example"

        ```javascript
        context.caseStatus.update(
            "Pending analysis",
            {
               color: "#FFFF00"
            }
        );
        ```

        See the [`PATCH /api/v1/caseStatus/{id}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/CaseStatus/operation/Update%20CaseStatus){target=_blank} for the complete object definition.

* `caseStatus.delete(id: string): void`: Deletes a case status.
* `caseStatus.find(query: any[]): OutputCaseStatus[]`: Searches for case statuses matching the given query.

## Alert status

* `alertStatus.create(input: InputCreateAlertStatus): OutputAlertStatus`: Creates a new alert status.

    ??? tip "Example"

        ```javascript
        context.alertStatus.create({
            value: "False positive",
            stage: "Closed"
        });
        ```

        See the [`POST /api/v1/alertStatus` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/AlertStatus/operation/Create%20AlertStatus){target=_blank} for the complete object definition.

* `alertStatus.update(id: string, update: InputUpdateAlertStatus): void`: Updates an alert status.

    ??? tip "Example"

        ```javascript
        context.alertStatus.update(
            "False positive",
            {
               color: "#52c41a"
            }
        );
        ```

        See the [`PATCH /api/v1/alertStatus/{id}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/AlertStatus/operation/Update%20AlertStatus){target=_blank} for the complete object definition.

* `alertStatus.delete(id: string): void`: Deletes an alert status.
* `alertStatus.find(query: any[]): OutputAlertStatus[]`: Searches for alert statuses matching the given query.

## Comment

* `comment.createInCase(caseId: string, input: InputCreateComment): OutputComment`: Adds a comment to a case.

    ??? tip "Example"

        ```javascript
        context.comment.createInCase(
            "~102",
            {
               message: "Analysis in progress. Network traffic review shows anomalous behavior that requires further validation. Next steps include memory analysis and user activity review."
            }
        );
        ```

        See the [`POST /api/v1/case/{caseId}/comment` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Comment/operation/Create%20Comment%20in%20Case){target=_blank} for the complete object definition.

* `comment.createInAlert(alertId: string, input: InputCreateComment): OutputComment`: Adds a comment to an alert.

    ??? tip "Example"

        ```javascript
        context.comment.createInAlert(
            "~456",
            {
               message: "Alert confirmed as suspicious after log correlation and endpoint review. Affected host has been isolated as a precaution. Awaiting additional artifacts from EDR for deeper investigation."
            }
        );
        ```

        See the [`POST /api/v1/alert/{alertId}/comment` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Comment/operation/Create%20Comment%20in%20Alert){target=_blank} for the complete object definition.

* `comment.update(commentId: string, update: InputUpdateComment): void`: Updates a comment.

    ??? tip "Example"

        ```javascript
        context.comment.update(
            "~394847",
            {
               message: "Additional analysis completed. No new indicators identified since the last review. Current findings confirm the initial assessment. Proceeding with recommended next steps."
            }
        );
        ```

        See the [`PATCH /api/v1/comment/{commentId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Comment/operation/Update%20Comment){target=_blank} for the complete object definition.

* `comment.delete(commentId: string): void`: Deletes a comment.
* `comment.find(query: any[]): OutputComment[]`: Searches for comments matching the given query.

## Page

* `page.createInOrg(input: InputCreatePage): OutputPage`: Creates a Knowledge Base page.

    ??? tip "Example"

        ```javascript
        context.page.createInOrg({
            title: "Post-Mortem Phishing Analysis",
            content: "Techniques observed in phishing campaigns, privilege escalation attempts, and lateral movement across corporate networks.",
            category: "Post-mortems"
        });
        ```

        See the [`POST /api/v1/page` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Page/operation/Create%20a%20Page){target=_blank} for the complete object definition.

* `page.updateInOrg(pageId: string, update: InputUpdatePage): void`: Updates a Knowledge Base page.

    ??? tip "Example"

        ```javascript
        context.page.updateInOrg(
            "~746482",
            {
               order: 0
            }
        );
        ```

        See the [`PATCH /api/v1/page/{pageId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Page/operation/Update%20a%20Page){target=_blank} for the complete object definition.

* `page.deleteInOrg(pageId: string): void`: Deletes a Knowledge Base page.

* `page.createInCase(caseId: string, input: InputCreatePage): OutputPage`: Creates a page at the case level.

    ??? tip "Example"

        ```javascript
        context.page.createInCase(
            "~102",
            {
                title: "Post-Mortem Phishing Analysis",
                content: "Techniques observed in phishing campaigns, privilege escalation attempts, and lateral movement across corporate networks.",
                category: "Post-mortems"
            }
        );
        ```

        See the [`POST /api/v1/case/{caseId}/page` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Page/operation/Create%20a%20Page%20in%20a%20Case){target=_blank} for the complete object definition.

* `page.updateInCase(caseId: string, pageId: string, update: InputUpdatePage): void`: Updates a page at the case level.

    ??? tip "Example"

        ```javascript
        context.page.updateInCase(
            "~102",
            "~746482",
            {
               order: 0
            }
        );
        ```

        See the [`PATCH /api/v1/case/{caseId}/page/{pageId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Page/operation/Update%20a%20Page%20in%20a%20Case){target=_blank} for the complete object definition.

* `page.deleteInCase(caseId: string, pageId: string): void`: Deletes a page at the case level.

## Share

* `share.shareCase(caseId: string, input: InputCreateShare): OutputShare`: Shares a case with specified permissions.

    ??? tip "Example"

        ```javascript
        context.share.shareCase(
            "~102",
            {
               shares: [
                            {organisation: "TheOrganization1", share: true, profile: "analyst", taskRule: "autoShare", observableRule: "manual"},
                            {organisation: "TheOrganization2", share: false}
                       ]
            }
        );
        ```

        See the [`POST /api/v1/case/{caseId}/shares` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Share/operation/Share%20a%20Case){target=_blank} for the complete object definition.

* `share.setCaseShares(caseId: string, input: InputCreateShares): OutputShare[]`: Sets sharing permissions for a case. Unlike the POST operation, this request replaces the existing configuration: it can create, update, or delete shares.

    ??? tip "Example"

        ```javascript
        context.share.setCaseShares(
            "~102",
            {
               shares: [
                            {organisation: "TheOrganization1", share: true, profile: "analyst", taskRule: "autoShare", observableRule: "manual"},
                            {organisation: "TheOrganization2", share: false}
                       ]
            }
        );
        ```

        See the [`PUT /api/v1/case/{caseId}/shares` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Case/operation/Set%20shares%20for%20Case){target=_blank} for the complete object definition.

* `share.shareTask(taskId: string, input: InputCreateShare): OutputShare`: Shares a task with specified permissions.

    ??? tip "Example"

        ```javascript
        context.share.shareTask(
            "~8642",
            {
               organisations: ["TheOrganization1", "TheOrganization2"]
            }
        );
        ```

        See the [`POST /api/v1/task/{taskId}/shares` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Share/operation/Share%20a%20Task){target=_blank} for the complete object definition.

* `share.shareObservable(observableId: string, input: InputCreateShare): OutputShare`: Shares an observable with specified permissions.

    ??? tip "Example"

        ```javascript
        context.share.shareObservable(
            "~93040",
            {
               organisations: ["TheOrganization1", "TheOrganization2"]
            }
        );
        ```

        See the [`POST /api/v1/observable/{observableId}/shares` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Share/operation/Share%20an%20Observable){target=_blank} for the complete object definition.

* `share.updateShare(shareId: string, update: InputUpdateShare): void`: Updates the sharing settings of a shared item.

    ??? tip "Example"

        ```javascript
        context.share.updateShare(
            "~529747",
            {
               profile: "analyst"
            }
        );
        ```

        See the [`POST /api/v1/case/share/{shareId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Share/operation/Update%20a%20Share){target=_blank} for the complete object definition.

* `share.removeSharesFromCase(caseId: string, remove: InputRemoveShares): void`: Revokes sharing permissions from a case.

    ??? tip "Example"

        ```javascript
        context.share.removeSharesFromCase(
            "~102",
            {
               organisations: ["~354", "~355"]
            }
        );
        ```

        See the [`DELETE /api/v1/case/{caseId}/shares` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Share/operation/Unshare%20a%20Case){target=_blank} for the complete object definition.

* `share.removeShare(shareId: string): void`: Removes a specific share.
* `share.removeShares(input: {ids: string[]} ): void`: Removes multiple shares at once.
* `share.removeTaskShares(taskId: string, remove: InputRemoveShares): void`: Revokes sharing permissions from a task.

    ??? tip "Example"

        ```javascript
        context.share.removeTaskShares(
            "~8642",
            {
               organisations: ["~354", "~355"]
            }
        );
        ```

        See the [`DELETE /api/v1/task/{taskId}/shares` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Share/operation/Unshare%20a%20Task){target=_blank} for the complete object definition.

* `share.removeObservableShares(observableId: string, remove: InputRemoveShares): void`: Revokes sharing permissions from an observable.

    ??? tip "Example"

        ```javascript
        context.share.removeObservableShares(
            "~93040",
            {
               organisations: ["~354", "~355"]
            }
        );
        ```

        See the [`DELETE /api/v1/observable/{observableId}/shares` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Share/operation/Unshare%20an%20Observable){target=_blank} for the complete object definition.

* `share.listShareCases(caseId: string): OutputShare[]`: Lists all shares for a case.
* `share.listShareTasks(taskId: string): OutputShare[]`: Lists all shares for a task.
* `share.listShareObservables(observableId: string): OutputShare[]`: Lists all shares for an observable.

## Organization

* `organisation.create(input: InputCreateOrganisation): OutputOrganisation`: Creates a new organization.

    ??? tip "Example"

        ```javascript
        context.organisation.create({
            name: "TheOrganization",
            description: "Organization used for incident response and case handling."
        });
        ```

        See the [`POST /api/v1/organisation` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Organisation/operation/Create%20Organisation){target=_blank} for the complete object definition.

* `organisation.update(orgId: string, update: InputUpdateOrganisation): void`: Updates an organization’s details.

    ??? tip "Example"

        ```javascript
        context.organisation.update(
            "~354",
            {
               locked: true
            }
        );
        ```

        See the [`PATCH /api/v1/organisation/{orgId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Organisation/operation/Update%20Organisation){target=_blank} for the complete object definition.

* `organisation.get(orgId: string): OutputOrganisation`: Retrieves details of an organization.
  
* `organisation.link(orgId: string, otherOrgId: string, input: InputOrganisationLink | null): void`: Creates a direct link between two organizations.

    ??? tip "Example"

        ```javascript
        context.organisation.link(
            "~354",
            "~355",
            {
               linkType: "default",
               otherLinkType: "supervised"
            }
        );
        ```

        See the [`PUT /api/v1/organisation/{orgId}/link/{otherOrgId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Organisation/operation/Link%20Organisations){target=_blank} for the complete object definition.

* `organisation.bulkLink(orgId: string, input: InputOrganisationBulkLink): void`: Links multiple organizations together.

    ??? tip "Example"

        ```javascript
        context.organisation.bulkLink(
            "~354",
            { 
                links: [
                            {toOrganisation: "~355", linkType: "default", otherLinkType: "supervised"},
                            {toOrganisation: "~356", linkType: "notify", otherLinkType: "notify"}
                       ]
            }
        );
        ```

        See the [`PUT /api/v1/organisation/{orgId}/links` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Organisation/operation/Bulk%20link%20Organisations){target=_blank} for the complete object definition.

* `organisation.unlink(orgId: string, otherOrgId: string): void`: Removes the link between two organizations.
* `organisation.listLinks(orgId: string): OutputOrganisationLink[]`: Lists all links between organizations.
* `organisation.listSharingProfiles(): OutputSharingProfile[]`: Retrieves the list of available sharing profiles.
* `organisation.find(query: any[]): OutputOrganisation[]`: Searches for organizations matching the given query.

## Profile

* `profile.create(input: InputCreateProfile): OutputProfile`: Creates a new user profile.

    ??? tip "Example"

        ```javascript
        context.profile.create({
            name: "triage-user",
            permissions: ["manageAlert/create", "manageAlert/delete", "manageAlert/import", "manageAlert/reopen", "manageAlert/update"]
        });
        ```

        See the [`POST /api/v1/profile` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Profile/operation/Create%20Profile){target=_blank} for the complete object definition.

* `profile.update(profileId: string, update: InputUpdateProfile): void`: Updates a user profile.

    ??? tip "Example"

        ```javascript
        context.profile.update(
            "manager",
            {
               permissions: ["manageDashboard", "manageKnowledgeBase"]
            }
        );
        ```

        See the [`PATCH /api/v1/profile/{profileId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Profile/operation/Update%20Profile){target=_blank} for the complete object definition.

* `profile.get(profileId: string): OutputProfile`: Retrieves a user profile.
* `profile.delete(profileId: string): void`: Deletes a user profile.
* `profile.find(query: any[]): OutputProfile[]`: Searches for user profiles matching the given query.

## Custom event

* `customEvent.createInCase(caseId: string, input: InputCustomEvent): OutputCustomEvent`: Creates a custom event within a case.

    ??? tip "Example"

        ```javascript
        context.customEvent.createInCase(
            "~102",
            {
               date: 1767312000000,
               title: "Account disabled"
            }
        );
        ```

        See the [`POST /api/v1/case/{caseId}/customEvent` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Timeline/operation/Create%20Custom%20Event){target=_blank} for the complete object definition.

* `customEvent.update(eventId: string, update: InputUpdateCustomEvent): void`: Updates an existing custom event.

    ??? tip "Example"

        ```javascript
        context.customEvent.update(
            "~18973",
            {
               endDate: 1767571200000
            }
        );
        ```

        See the [`PATCH /api/v1/customEvent/{eventId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Timeline/operation/Update%20a%20Custom%20Event){target=_blank} for the complete object definition.

* `customEvent.delete(eventId: string): void`: Deletes a custom event.
* `customEvent.find(query: any[]): OutputCustomEvent[]`: Searches for custom events matching the given query.

## Function

* `function.create(input: InputCreateFunction): OutputFunction`: Creates a new function.

    ??? tip "Example"

        ```javascript
        context.function.create({
            name: "createAlert",
            definition: `function handle(input, context) {
                            const myAlert = {
                                type: "myScript",
                                source: input.source,
                                sourceRef: input.ref,
                                title: input.title || "Default Title",
                                description: "Alert from myScript " + input.ref,
                                observables: (input.data || []).map(a => ({
                                dataType: a.type,
                                data: a.value
                                }))
                            };
                            const createdAlert = context.alert.create(myAlert);
                            if (createdAlert && createdAlert._id) {
                                console.log(\`Alert created with id ${createdAlert._id}\`);
                            }
                            return createdAlert;
                        }`,
            types: ["api"]
        });
        ```

        See the [`POST /api/v1/function` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Function/operation/Create%20Function){target=_blank} for the complete object definition.

* `function.update(functionId: string, update: InputUpdateFunction): void`: Updates an existing function.

    ??? tip "Example"

        ```javascript
        context.function.update(
            "createAlert",
            {
               mode: "Disabled"
            }
        );
        ```

        See the [`PATCH /api/v1/function/{functionId}` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Function/operation/Update%20Function){target=_blank} for the complete object definition.

* `function.delete(functionId: string): void`: Deletes a function.
* `function.find(query: any[]): OutputFunction[]`: Searches for functions matching the given query.

## Cortex

<!-- md:version 5.5.2 -->

### Analyzer

* `cortex.createJob(input: InputJob): OutputJob`:  Launches a Cortex analyzer job on an observable.

    ??? tip "Example"

        ```javascript
        context.cortex.createJob({
            analyzerId: "EmlParser_2_1",
            artifactId: "~93040",
            cortexId: "Cluster-1"
        });
        ```

        To list available analyzers and retrieve their full IDs, use the [`GET /api/v1/connector/cortex/analyzer` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Cortex/operation/List%20Analyzers){target=_blank}.

        See the [`POST /api/v1/connector/cortex/job` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Cortex/operation/Create%20Cortex%20job){target=_blank} for the complete object definition.

### Responder

* `cortex.createAction(input: InputAction): OutputAction`: Launches a Cortex responder action on a case, an alert, or a task.

    ??? tip "Example"

        ```javascript
        context.cortex.createAction({
            responderId: "cfbe6c77cc30dea5efe680cc622e3bd6",
            objectId: "~456",
            objectType: "alert"
        });
        ```

        To list available responders and retrieve their full IDs, use the [`GET /api/v1/connector/cortex/responder/` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Cortex/operation/List%20responders){target=_blank}.

        See the [`POST /api/v1/connector/cortex/action` endpoint](https://docs.strangebee.com/thehive/api-docs/#tag/Cortex/operation/Create%20an%20action){target=_blank} for the complete object definition.

<h2>Next steps</h2>

* [Create a Function](create-a-function.md)
* [Invoke a Function](invoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)