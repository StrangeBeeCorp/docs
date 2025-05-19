# Functions Objects

This topic lists all available objects for functions in TheHive.

!!! info "API documentation"
    The objects in functions are the same as those used in TheHive HTTP API.

    For details on the expected fields for each object, see the [TheHive HTTP API documentation](https://docs.strangebee.com/thehive/api-docs/).

## User

- `userId: string` : The login identifier of the user executing the function.
- `userName: string`: The display name of the user executing the function.

## HTTP request

- `request.queryString() : Record<string, string[]>`: Returns a dictionary of query string parameters formatted as a key-value map.
- `request.getQueryString(key: string): string | null`: Retrieves the value associated with a specific query string key. Returns `null` if the key does not exist.
- `request.getHeader(name: string): string | null`: Retrieves the value of a specific HTTP request header. Returns `null` if the header is not present.
- `request.headers(): Record<string, string>`: Returns all request headers as a dictionary.
- `request.contentType: string`: Retrieves the `Content-Type` header value from the request.
- `request.remoteAddress()`: Returns the IP address of the client making the request.

## Query

- `query.execute(query: any[])`: Executes a database query.

## Alert

- `alert.create(input: InputCreateAlert): OutputAlert`: Creates a new alert.
- `alert.get(id: string): OutputAlert`: Retrieves an alert by its ID.
- `alert.update(alertId: string, input: InputUpdateAlert): OutputAlert`: Updates an alert by its ID.
- `alert.delete(alertId: string): void`: Deletes an alert by its ID.
- `alert.createCase(alertId: string, input: InputCreateAlert): OutputCase`: Converts an alert into a case.
- `alert.bulkDelete(input: {ids: string[]}): void`: Deletes multiple alerts at once.
- `alert.mergeWithCase(alertId: string, caseId: string): OutputCase`: Merges an alert with an existing case.
- `alert.bulkMergeWithCase( {caseId: string, alertIds: string[]} ): OutputCase`: Merges multiple alerts into a case.
- `alert.followAlert(alertId: string): OutputAlert`: Starts following an alert for updates.
- `alert.unfollowAlert(alertId: string): OutputAlert`: Stops following an alert.
- `alert.importInCase(alertId: string, caseId: string): OutputAlert`: Imports an alert into an existing case.
- `alert.bulkUpdate(input: {ids: string[]} & InputUpdateAlert): void`: Updates multiple alerts at once.
- `alert.find(query: any[]): OutputAlert[]`: Searches for alerts matching the given query.

## Case

!!! info "Caze"
    Since `case` is a reserved keyword is Java, the API uses `caze`.

- `caze.create(input: InputCreateCase): OutputCase`: Creates a new case.
- `caze.get(idOrNumber: string): OutputCase`: Retrieves a case by its ID or case number.
- `caze.update(idOrNumber: string, update: InputUpdateCase): void`: Updates a case.
- `caze.merge(ids: string[]): OutputCase`: Merges multiple cases into one.
- `caze.delete(idOrNumber: string): void`: Deletes a case by its ID or case number.
- `caze.changeCaseOwnership(idOrNumber: string, update: InputChangeCaseOwnership): void`: Transfers ownership of a case.
- `caze.unlinkAlert(caseId: string, alertId: string): void`: Removes an alert from a case.
- `caze.mergeSimilarObservables(caseId: string): void`: Merges observables of the same type within a case.
- `caze.bulkUpdate(update: {ids: string[]} & InputUpdateCase): void `: Updates multiple cases simultaneously.
- `caze.bulkApplyCaseTemplate(update: {ids: string[]} & InputApplyCaseTemplate): void`: Applies a case template to multiple cases.
- `caze.find(query: any[]): OutputCase[]`: Searches for cases based on a query.

## Tasks

- `task.get(id: string): OutputTask`: Retrieves a task by its ID.
- `task.update(idOrName: string, update: Partial<OutputTask>): void`: Updates a task.
- `task.delete(id: string): void`: Deletes a task.
- `task.find(query: any[]): OutputTask[]`: Searches for tasks matching the given query.
- `task.setActionRequired(taskId: string, orgId: string): void`: Marks a task as requiring action.
- `task.setActionDone(taskId: string, orgId: string): void`: Marks a task as completed.
- `task.isActionRequired(taskId: string): Record<string, bool>`: Checks whether a task requires action.
- `task.createInCase(caseId: string, task: InputTask): OutputTask`: Creates a new task within a case.
- `task.bulkUpdate(update: {ids: string[]} & Partial<OutputTask>): void`: Updates multiple tasks at once.

## Log

- `log.create(taskId: string, log: InputCreateLog): OutputLog`: Creates a log entry for a task.
- `log.update(logId: string, update: InputUpdateLog): void`: Updates a log entry.
- `log.delete(logId: string): void`: Deletes a log entry.
- `log.deleteAttachment(logId: string, attachmentId: string): void`: Removes an attachment from a log entry.
- `log.find(query: any[]): OutputLog[]`: Searches for logs matching the given query.

## Observable

- `observable.createInCase(caseId: string, observable: InputObservable): OutputObservable`: Creates an observable within a case.
- `observable.createInAlert(alertId: string, observable: InputObservable): OutputObservable)`: Creates an observable within an alert.
- `observable.bulkUpdate(update: {ids: string[]} & Partial<OutputObservable>)`: Updates multiple observables.
- `observable.get(idOrName: string): OutputObservable`: Retrieves an observable by ID or name.
- `observable.update(id: string, update: Partial<OutputObservable>): void`: Updates an observable.
- `observable.delete(id: string): void`: Deletes an observable.
- `observable.find(query: any[]): OutputObservable[]`: Searches for observables.
- `observable.updateAllTypes(fromType: string, toType: String): void`: Changes the type of all observables from one type to another.

## Observable type

- `observableType.get(id: string): OutputObservableType`: Retrieves an observable type by its ID.
- `observableType.delete(id: string): void`: Deletes an observable type by its ID.
- `observableType.create(ot: InputObservableType)`: Creates a new observable type.
- `observableType.find(query: any[]): OutputObservableType[]`: Searches for observable types matching the given query.

## CustomField

- `customField.list(): OutputCustomField[]`: Returns a list of all custom fields.
- `customField.update(idOrName: string, update: Partial<OutputCustomField>): void`: Updates a custom field by its ID or name.
- `customField.delete(idOrName: string): void`: Deletes a custom field by its ID or name.
- `customField.create(cf: InputCustomField): OutputCustomField`: Creates a new custom field.
- `customField.find(query: any[]): OutputCustomField[]`: Searches for custom fields matching the query criteria.

## Case template

- `caseTemplate.get(idOrName: string): OutputCaseTemplate`: Retrieves a case template by its ID or name.
- `caseTemplate.update(idOrName: string, update: Partial<InputCaseTemplate>): void`: Updates a case template.
- `caseTemplate.delete(idOrName: string): void`: Deletes a case template.
- `caseTemplate.create(template: InputCaseTemplate): OutputCaseTemplate`: Creates a new case template.
- `caseTemplate.find(query: any[]): OutputCaseTemplate[]`: Searches for case templates matching the query.

## Procedure

- `procedure.bulkCreateInCase(caseId: string, input: {procedures: InputProcedure[]}): OutputProcedure[]`: Creates multiple procedures within a case.
- `procedure.bulkCreateInAlert(alertId: string, input: {procedures: InputProcedure[]}): OutputProcedure[]`: Creates multiple procedures within an alert.
- `procedure.createInCase(caseId: string, procedure: InputProcedure): OutputProcedure`: Creates a single procedure within a case.
- `procedure.createInAlert(alertId: string, procedure: InputProcedure): OutputProcedure`: Creates a single procedure within an alert.
- `procedure.update(id: string, procedure: Partial<OutputProcedure>): void`: Updates a procedure.
- `procedure.delete(id: string): void`: Deletes a procedure.
- `procedure.find(query: any[])`: Searches for procedures based on the query.

## Case status

- `caseStatus.create(input: InputCreateCaseStatus): OutputCaseStatus`: Creates a new case status.
- `caseStatus.update(idOrName: string, update: InputUpdateCaseStatus): void`: Updates a case status.
- `caseStatus.delete(idOrName: string): void`: Deletes a case status.
- `caseStatus.find(query: any[]): OutputCaseStatus[]`: Searches for case statuses.

## Alert status

- `alertStatus.create(input: InputCreateAlertStatus): OutputAlerttatus`: Creates a new alert status.
- `alertStatus.update(idOrName: string, update: InputUpdateAlertStatus): void`: Updates an alert status.
- `alertStatus.delete(idOrName: string): void`: Deletes an alert status.
- `alertStatus.find(query: any[]): OutputAlerttatus[]`: Searches for alert statuses.

## Comment

- `comment.createInCase(caseId: string, comment: InputCreateComment): OutputComment`: Adds a comment to a case.
- `comment.createInAlert(alertId:: string, comment: InputCreateComment): OutputComment`: Adds a comment to an alert.
- `comment.update(id: string, update: InputUpdateComment): void`: Updates a comment.
- `comment.delete(id: string): void`: Deletes a comment.
- `comment.find(query: any[]): OutputComment[]`: Searches for comments.

## Share

- `share.setCaseShares(caseId: string, input: InputCreateShares): OutputShare[]`: Sets sharing permissions for a case.
- `share.removeSharesFromCase(caseId: string, input: InputRemoveShares): void`: Revokes sharing permissions from a case.
- `share.removeShare(shareId: string): void`: Removes a specific share.
- `share.removeShares(input: {ids: string[]} ): void`: Removes multiple shares at once.
- `share.removeTaskShares(taskId: string, input: InputRemoveShares): void`: Revokes sharing permissions from a task.
- `share.removeObservableShares(observableId: string, input: InputRemoveShares): void`: Revokes sharing permissions from an observable.
- `share.listShareCases(caseId: string): OutputShare[]`: Lists all shared cases.
- `share.listShareTasks(taskId: string): OutputShare[]`: Lists all shared tasks.
- `share.listShareObservables(observableId: string): OutputShare[]`: Lists all shared observables.
- `share.shareCase(caseId: string, input: InputCreateShare): OutputShare`: Shares a case with specified permissions.
- `share.shareTask(taskId: string, input: InputCreateShare): OutputShare`: Shares a task with specified permissions.
- `share.shareObservable(observableId: string, input: InputCreateShare): OutputShare`: Shares an observable with specified permissions.
- `share.updateShare(shareId: string, update: InputUpdateShare): void`: Updates the sharing settings of a shared item.

## Organization

- `organisation.get(orgIdOrName: string): OutputOrganisation`: Retrieves details of an organization by ID or name.
- `organisation.create(org: InputCreateOrganisation): OutputOrganisation`: Creates a new organization.
- `organisation.update(orgIdOrName: string, update: InputUpdateOrganisation): void`: Updates an organization’s details.
- `organisation.bulkLink(orgIdOrName: string, links: InputOrganisationBulkLink): void`: Links multiple organizations together.
- `organisation.listLinks(orgIdOrName: string): OutputOrganisationLink[]`: Lists all links between organizations.
- `organisation.listSharingProfiles(): OutputSharingProfile[]`: Retrieves the list of available sharing profiles.
- `organisation.link(orgA: string, orgB: string, link: InputOrganisationLink | null): void`: Creates a direct link between two organizations.
- `organisation.unlink(orgA: string, orgB: string): void`: Removes the link between two organizations.
- `organisation.find(query: any[]): OutputOrganisation[]`: Searches for organizations based on query criteria.

## Profile

- `profile.get(idOrName: string): OutputProfile`: Retrieves a profile by ID or name.
- `profile.update(profileIdOrName: string, update: InputUpdateProfile): void`: Updates a user profile.
- `profile.delete(profileIdOrName: string): void`: Deletes a user profile.
- `profile.create(profile: InputCreateProfile): OutputProfile`: Creates a new user profile.
- `profile.find(query: any[]): OutputProfile[]`: Searches for user profiles based on query criteria.

## Custom event

- `customEvent.createInCase(caseId: string, input: InputCreateCustomEvent): OutputCustomEvent`: Creates a custom event within a case.
- `customEvent.update(id: string, update: InputUpdateCustomEvent): void`: Updates an existing custom event.
- `customEvent.delete(id: string): void`: Deletes a custom event.
- `customEvent.find(query: any[]): OutputCustomEvent[]`: Searches for custom events based on query parameters.

## Function

- `function.create(function: InputCreateFunction): OutputFunction`: Creates a new function.
- `function.update(functionIdOrName: string, update: InputUpdateFunction): void`: Updates an existing function.
- `function.delete(functionIdOrName: string): void`: Deletes a function.
- `function.find(query: any[]): OutputFunction`: Searches for functions based on query parameters.

## Cortex

<!-- md:version 5.5.2 -->

### Execute an analyzer

`cortex.createJob({ "analyzerId": "analyzerFullName", "artifactId": observableId, "cortexId": "cortexConnectorName"})`:  Launches a Cortex analyzer job with `analyzerId` as the full name of the analyzer to run (for example, *EmlParser_2_1*), `artifactId` as the ID of the observable to analyze, and `cortexId` as the name of the Cortex connector to use.

!!! example ""
    context.cortex.createJob(
        {
            "analyzerId": "EmlParser_2_1",
            "artifactId": ~7577792576,
            "cortexId": "Cluster 1"
        });

### Execute a responder

`cortex.createAction({ "responderId": "id", "objectId": inputId, "objectType": "type"})`: Launches a Cortex responder action with `responderId` as the full ID of the responder to run (for example, *cfbe6c77cc30dea5efe680cc622e3bd6*), `objectId` as of ID of the object to act on, and `objectType` as its type, such as case, alert, or task.

!!! example ""
    context.cortex.createAction(
        {
            "responderId": "cfbe6c77cc30dea5efe680cc622e3bd6",
            "objectId": ~8683597912,
            "objectType": "alert"
        });

<h2>Next steps</h2>

* [Create a Function](create-a-function.md)
* [Revoke a Function](revoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)