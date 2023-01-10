<!-- ---
hide:
  - navigation
--- -->

# *Functions*

!!! Info
    This feature is available with TheHive versions 5.1 and higher.

Functions enable you to integrate external applications directly into TheHive processing.

A Function is a piece of custom Javascript code that runs inside TheHive. The function can receive inputs from the outside, treat it and call TheHive APIs directly.

This can be used for instance to create alerts inside TheHive without a python glue service that transforms the data.

## Create a function

Let's imagine that when an event occurs in your system, you want to create an alert in TheHive. Your external system has its own schema for the events, something like:

!!! Example ""

    ```json
    {
        "eventId": "d9ec98b1-410f-40eb-8634-cfe189749da6",
        "date": "2021-06-05T12:45:36.698Z",
        "title": "An intrusion was detected",
        "details": "An intrusion was detected on the server 10.10.43.2",
        "data": [
            {"kind": "ip", "value": "10.10.43.2", "name": "server-ip" },
            {"kind": "name", "value": "root", "name": "login" },
            {"kind": "ip", "value": "92.43.123.1", "name": "origin" }
        ]
    }
    ```

This format is not the same as TheHive, so you need to transform the data to match TheHive alert format.

As an `org-admin`, you can create new functions for your organisation that can take this input, transform it into TheHive format and create an alert from it.

The code of the function would be something like this:

!!! Example ""

    ```javascript
    function handle(input, context) {
        const theHiveAlert = {
            "type": "event",
            "source": "my-system",
            "sourceRef": input.eventId,
            "title": input.title,
            "description": input.details,
            "date": (new Date(input.date)).getTime(),
            "observables": input.data.map(data => {
                // map event data kind to TheHive Observable type
                const dataType = data.kind === "ip" ? "ip": "other";
                return {
                    "dataType": dataType,
                    "data": data.value,
                    "tags": [`name:${data.name}`] // use a tag for the data name
                }
            })
        };
        // call TheHive APIs, here alert creation
        return context.alert.create(theHiveAlert);
    }
    ```

<figure markdown>
![Create function](./images/functions_create.png){ width="500" }
</figure>

A function can be in one of three modes:

- `Enabled`: The function will be executed when called
- `Disabled`: The function will not be executed when called
- `Dry-Run`: The function will be executed but no entity will be created or modified in TheHive. Entity creations will return `null` instead. This can be useful to test your integration before setting it live.

The creation page allows you to test your function and see what it would return once executed.
In `dry-run` mode, the function will be executed but no resource creation or modification will be executed.

<figure markdown>
![Test function input](./images/functions_test_input.png){ width="500" }
</figure>

<figure markdown>
![Test function result](./images/function_test_result.png){ width="500" }
</figure>

## Call a function

Once saved, the function can then be called with an http call from your system:

!!! Example ""

    ```bash
    curl -X POST -H 'Authorization: Bearer $API_KEY' https://<thehive_url>/api/v1/function/<function_name> -H 'Content-Type: application/json' --data '
    {
        "eventId": "d9ec98b1-410f-40eb-8634-cfe189749da6",
        "date": "2021-06-05T12:45:36.698Z",
        "title": "An intrusion was detected",
        "details": "An intrusion was detected on the server 10.10.43.2",
        "data": [
            {"kind": "ip", "value": "10.10.43.2", "name": "server-ip" },
            {"kind": "name", "value": "root", "name": "login" },
            {"kind": "ip", "value": "92.43.123.1", "name": "origin" }
        ]
    }
    '
    ```

TheHive will take your input (the body of the http call), the definition of your function and execute the function with the input.
It will respond to the http call with the data returned by the function.

## Example: Create an alert from a Splunk alert

When creating a Splunk alert, you can define a [webhook as an action](https://docs.splunk.com/Documentation/Splunk/9.0.0/Alert/Webhooks). So when the alert is triggered the webhook is called with a payload. But the payload is defined by splunk and can't be changed.

It should look a bit like:

!!! Example ""

    ```json
    {
    "sid": "rt_scheduler__admin__search__RMD582e21fd1bdd5c96f_at_1659705853_1.1",
    "search_name": "My Alert",
    "app": "search",
    "owner": "admin",
    "results_link": "http://8afeb4633464:8000/app/search/search?q=%7Cloadjob%20rt_scheduler__admin__search__RMD582e21fd1bdd5c96f_at_1659705853_1.1%20%7C%20head%201%20%7C%20tail%201&earliest=0&latest=now",
    "result": {
        "_time": "1659705859.827088",
        "host": "8afeb4633464",
        "source": "audittrail",
        "sourcetype": "audittrail",
        "action": "edit_search_schedule_priority",
        "info": "granted",
        "user": "admin",
        "is_searches": "0",
        "is_not_searches": "1",
        "is_modify": "0",
        "is_not_modify": "1",
        "_confstr": "source::audittrail|host::8afeb4633464|audittrail",
        "_indextime": "1659705859",
        "_kv": "1",
        "_raw": "Audit:[timestamp=08-05-2022 13:24:19.827, user=admin, action=edit_search_schedule_priority, info=granted ]",
        "_serial": "1",
        "_si": [
        "8afeb4633464",
        "_audit"
        ],
        "_sourcetype": "audittrail",
        "_subsecond": ".827088"
    }
    }
    ```

To transform this splunk alert into a TheHive alert, a function like this can be used:

!!! Example ""

    ```javascript
    function handle(input, context) {
        const theHiveAlert = {
            "type": "splunk",
            "source": input.search_name,
            "sourceRef": input.result._serial,
            "title": `Splunk Alert triggered: ${input.search_name} by ${input.result.sourcetype}`,
            "description": `Alert created by splunk search '${input.search_name}:\n${input.result._raw}'`,
            "date": (new Date(parseFloat(input.result._time)*1000)).getTime(),
            "observables": [
                {"dataType": "hostname", "data": input.result.host},
                {"dataType": "other", "data": input.result.action, "message": "action"},
                {"dataType": "other", "data": input.result._raw, "message": "raw"}
            ]
        };
        return context.alert.create(theHiveAlert);
    }
    ```

In splunk, you will need to set the webhook url to TheHive function url.

## Example: Cold case automation

When called, this function will:

- find all cases that are `New` or `InProgress` and were not updated in the last month
- to each of those cases, add a tag `cold-case`

!!! Example ""

    ```javascript
    // Will find the "New" or "InProgress" cases that were not updated since one month
    // For each case, add a tag "cold-case"
    function handle(input, context) {
        const now = new Date();
        const lastMonth = new Date();
        lastMonth.setMonth(now.getMonth() - 1);
        const filters = [
            {
                _name: "filter",
                _and: [
                    {
                        _or: [{ _field: "stage", _value: "New" }, { _field: "stage", _value: "InProgress" },]
                    },
                    {
                        _lt: { _field: "_updatedAt", _value: lastMonth.getTime() }
                    }
                ]
            }
        ];
        const list = context.caze.find(filters);
        const authorizedCases = list
            .filter(caze => caze.userPermissions.indexOf("manageCase/update") > 0);
        console.log(authorizedCases.map(c => c.number));
        console.log(`Will update ${authorizedCases.length} cases`);

        authorizedCases.forEach(caze => {
            context.caze.update(caze._id, { addTags: ["cold-case"] })
        });
    }
    ```

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
- `alert.update(InputUpdateAlert): OutputAlert`
- `alert.delete(alertId: string): void`
- `alert.createCase(alert: InputCreateAlert): OutputCase`
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

### Organisation

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
- `function.invoke(functionIdOrName: string, dryRun: boolean, input: any): any`
- `function.update(functionIdOrName: string, update: InputUpdateFunction): void`
- `function.delete(functionIdOrName: string): void`
- `function.find(query: any[]): OutputFunction`
