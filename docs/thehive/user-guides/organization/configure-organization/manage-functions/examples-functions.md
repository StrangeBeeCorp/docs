## Example 1: Function Use Case

Suppose you want to create an alert in TheHive when an event occurs in your system. Your external system may have its own event schema, similar to the example below:

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

Because this format differs from TheHive's alert schema, the data needs to be transformed into the correct format.

As an org-admin, you can create a new function for your organization to convert this input into TheHive's alert format and generate an alert. The function might look like this:

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
            const dataType = data.kind === "ip" ? "ip" : "other";
            return {
                "dataType": dataType,
                "data": data.value,
                "tags": [`name:${data.name}`] // use a tag for the data name
            };
        })
    };
    // call TheHive APIs, here alert creation
    return context.alert.create(theHiveAlert);
}
```

Creating and testing this function allows you to effortlessly convert your external event data into a format that TheHive can process as an alert.

---

## Example 2: Creating an Alert Based on a Splunk Alert

When setting up a Splunk alert, you can configure a [webhook as an action](https://docs.splunk.com/Documentation/Splunk/9.0.0/Alert/Webhooks). When the alert is triggered, the webhook will be invoked with a predefined payload, which cannot be modified. The payload will resemble something like this:

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

To convert this Splunk alert into a TheHive alert, you can use a function like the following:

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

In Splunk, you'll need to configure the webhook URL to point to the TheHive function URL.

---

## Example 3: Cold Case Automation Process

When invoked, this function will:

- Identify all cases marked as `New` or `InProgress` that haven't been updated in the past month.
- Add a `cold-case` tag to each of these cases.

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
