## Context API

!!! Info
    The objects in the context API are the same as the ones used in the v1 Http Api.

    For more details on the expected fields of each object, please refer to the [Http Api Documentation](/thehive/api-docs/)

### User

- `userId: string` : login of the user executing the function
- `userName: string`: name of the user executing the function

### Http request

- `request.queryString() : Record<string, string[]>`: Dictionary with the request query string formatted as a map
- `request.getQueryString(key: string): string | null`: Get a value from the query string
- `request.getHeader(name: string): string | null`: Get the value of a header from the request
- `request.headers(): Record<string, string>`: Get the request headers
- `request.contentType: string`: Value of the request header Content-Type
- `request.remoteAddress()`: Get the ip adress of the caller

### Query

- `query.execute(query: any[])`: execute a query on the database (cf. Api docs => query)


### Alert

- `alert.create(input: InputCreateAlert): OutputAlert`
- `alert.get(id: string): OutputAlert`
- `alert.update(alertId: string, input: InputUpdateAlert): OutputAlert`
- `alert.delete(alertId: string): void`
- `alert.createCase(alertId: string, input: InputCreateAlert): OutputCase`
- `alert.bulkDelete(input: {ids: string[]}): void`
- `alert.mergeWithCase(alertId: string, caseId: string): OutputCase`
- `alert.bulkMergeWithCase( {caseId: string, alertIds: string[]} ): OutputCase`
- `alert.followAlert(alertId: string): OutputAlert`
- `alert.unfollowAlert(alertId: string): OutputAlert`
- `alert.importInCase(alertId: string, caseId: string): OutputAlert`
- `alert.bulkUpdate(input: {ids: string[]} & InputUpdateAlert): void`
- `alert.find(query: any[]): OutputAlert[]`


### Case

`case` is a reserved keywork is java, so `caze` is used instead.

- `caze.create(input: InputCreateCase): OutputCase`
- `caze.get(idOrNumber: string): OutputCase`
- `caze.update(idOrNumber: string, update: InputUpdateCase): void`
- `caze.merge(ids: string[]): OutputCase`
- `caze.delete(idOrNumber: string): void`
- `caze.changeCaseOwnership(idOrNumber: string, update: InputChangeCaseOwnership): void`
- `caze.unlinkAlert(caseId: string, alertId: string): void`
- `caze.mergeSimilarObservables(caseId: string): void`
- `caze.bulkUpdate(update: {ids: string[]} & InputUpdateCase): void `
- `caze.bulkApplyCaseTemplate(update: {ids: string[]} & InputApplyCaseTemplate): void`
- `caze.find(query: any[]): OutputCase[]`


### Tasks

- `task.get(id: string): OutputTask`
- `task.update(idOrName: string, update: Partial<OutputTask>): void`
- `task.delete(id: string): void`
- `task.find(query: any[]): OutputTask[]`
- `task.setActionRequired(taskId: string, orgId: string): void`
- `task.setActionDone(taskId: string, orgId: string): void`
- `task.isActionRequired(taskId: string): Record<string, bool>`
- `task.createInCase(caseId: string, task: InputTask): OutputTask`
- `task.bulkUpdate(update: {ids: string[]} & Partial<OutputTask>): void`

### Log

- `log.create(taskId: string, log: InputCreateLog): OutputLog`
- `log.update(logId: string, update: InputUpdateLog): void`
- `log.delete(logId: string): void`
- `log.deleteAttachment(logId: string, attachmentId: string): void`
- `log.find(query: any[]): OutputLog[]`

### Observable

- `observable.createInCase(caseId: string, observable: InputObservable): OutputObservable`
- `observable.createInAlert(alertId: string, observable: InputObservable): OutputObservable)` 
- `observable.bulkUpdate(update: {ids: string[]} & Partial<OutputObservable>)`
- `observable.get(idOrName: string): OutputObservable`
- `observable.update(id: string, update: Partial<OutputObservable>): void`
- `observable.delete(id: string): void`
- `observable.find(query: any[]): OutputObservable[]`
- `observable.updateAllTypes(fromType: string, toType: String): void`

### Observable Type

- `observableType.get(id: string): OutputObservableType`
- `observableType.delete(id: string): void`
- `observableType.create(ot: InputObservableType)`
- `observableType.find(query: any[]): OutputObservableType[]`

### CustomField

- `customField.list(): OutputCustomField[]`
- `customField.update(idOrName: string, update: Partial<OutputCustomField>): void`
- `customField.delete(idOrName: string): void`
- `customField.create(cf: InputCustomField): OutputCustomField`
- `customField.find(query: any[]): OutputCustomField[]`

### Case Template

- `caseTemplate.get(idOrName: string): OutputCaseTemplate` 
- `caseTemplate.update(idOrName: string, update: Partial<InputCaseTemplate>): void`
- `caseTemplate.delete(idOrName: string): void`
- `caseTemplate.create(template: InputCaseTemplate): OutputCaseTemplate`
- `caseTemplate.find(query: any[]): OutputCaseTemplate[]`


### Procedure

- `procedure.bulkCreateInCase(caseId: string, input: {procedures: InputProcedure[]}): OutputProcedure[]`
- `procedure.bulkCreateInAlert(alertId: string, input: {procedures: InputProcedure[]}): OutputProcedure[]`
- `procedure.createInCase(caseId: string, procedure: InputProcedure): OutputProcedure`
- `procedure.createInAlert(alertId: string, procedure: InputProcedure): OutputProcedure`
- `procedure.update(id: string, procedure: Partial<OutputProcedure>): void`
- `procedure.delete(id: string): void`
- `procedure.find(query: any[])`


### Case Status

- `caseStatus.create(input: InputCreateCaseStatus): OutputCaseStatus`
- `caseStatus.update(idOrName: string, update: InputUpdateCaseStatus): void`
- `caseStatus.delete(idOrName: string): void`
- `caseStatus.find(query: any[]): OutputCaseStatus[]`

### Alert Status

- `alertStatus.create(input: InputCreateAlertStatus): OutputAlerttatus`
- `alertStatus.update(idOrName: string, update: InputUpdateAlertStatus): void`
- `alertStatus.delete(idOrName: string): void`
- `alertStatus.find(query: any[]): OutputAlerttatus[]`

### Comment

- `comment.createInCase(caseId: string, comment: InputCreateComment): OutputComment`
- `comment.createInAlert(alertId:: string, comment: InputCreateComment): OutputComment`
- `comment.update(id: string, update: InputUpdateComment): void`
- `comment.delete(id: string): void`
- `comment.find(query: any[]): OutputComment[]`

### Share

- `share.setCaseShares(caseId: string, input: InputCreateShares): OutputShare[]`
- `share.removeSharesFromCase(caseId: string, input: InputRemoveShares): void`
- `share.removeShare(shareId: string): void`
- `share.removeShares(input: {ids: string[]} ): void`
- `share.removeTaskShares(taskId: string, input: InputRemoveShares): void`
- `share.removeObservableShares(observableId: string, input: InputRemoveShares): void`
- `share.listShareCases(caseId: string): OutputShare[]`
- `share.listShareTasks(taskId: string): OutputShare[]`
- `share.listShareObservables(observableId: string): OutputShare[]`
- `share.shareCase(caseId: string, input: InputCreateShare): OutputShare`
- `share.shareTask(taskId: string, input: InputCreateShare): OutputShare`
- `share.shareObservable(observableId: string, input: InputCreateShare): OutputShare`
- `share.updateShare(shareId: string, update: InputUpdateShare): void`

### Organization

- `organisation.get(orgIdOrName: string): OutputOrganisation`
- `organisation.create(org: InputCreateOrganisation): OutputOrganisation`
- `organisation.update(orgIdOrName: string, update: InputUpdateOrganisation): void`
- `organisation.bulkLink(orgIdOrName: string, links: InputOrganisationBulkLink): void`
- `organisation.listLinks(orgIdOrName: string): OutputOrganisationLink[]`
- `organisation.listSharingProfiles(): OutputSharingProfile[]`
- `organisation.link(orgA: string, orgB: string, link: InputOrganisationLink | null): void`
- `organisation.unlink(orgA: string, orgB: string): void`
- `organisation.find(query: any[]): OutputOrganisation[]`

### Profile

- `profile.get(idOrName: string): OutputProfile`
- `profile.update(profileIdOrName: string, update: InputUpdateProfile): void`
- `profile.delete(profileIdOrName: string): void`
- `profile.create(profile: InputCreateProfile): OutputProfile`
- `profile.find(query: any[]): OutputProfile[]`

### Custom Event

- `customEvent.createInCase(caseId: string, input: InputCreateCustomEvent): OutputCustomEvent`
- `customEvent.update(id: string, update: InputUpdateCustomEvent): void`
- `customEvent.delete(id: string): void`
- `customEvent.find(query: any[]): OutputCustomEvent[]`

### Function

- `function.create(function: InputCreateFunction): OutputFunction`
- `function.update(functionIdOrName: string, update: InputUpdateFunction): void`
- `function.delete(functionIdOrName: string): void`
- `function.find(query: any[]): OutputFunction`

&nbsp;