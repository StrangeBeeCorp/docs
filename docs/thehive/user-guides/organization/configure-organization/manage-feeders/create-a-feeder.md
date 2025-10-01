# Create an Alert Feeder

<!-- md:version 5.5 --> <!-- md:license Platinum -->

This topic provides step-by-step instructions for creating an [alert feeder](about-feeders.md) in TheHive, with an example for [Airtable](#airtable-example).

Use this procedure to automatically retrieve data at a defined frequency from an external service via an HTTP API call and convert it into alerts in TheHive.

{% include-markdown "includes/access-feeders.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

    ---

2. {% include-markdown "includes/connectors-tab-organization-go-to.md" %}

    ---

3. Select :fontawesome-solid-plus:.

    ---

4. In the **General settings** section, enter the following information:

    **- Name**

    A unique name for the alert feeder. You can’t change this name later.

    **- Interval**

    How often the alert feeder sends requests to the external system.

    !!! warning "Define the interval carefully based on your reactivity requirements"
        Make sure the interval is shorter than the processing time to avoid potential issues, but not too short to prevent excessive requests to the API.

    **- Request timeout time**

    The maximum time, in seconds, the alert feeder waits for a response before timing out.

    **- Request response max size**

    The maximum response size, in megabytes, that the alert feeder accepts from the external system.

    **- Description**

    A description to provide additional context or notes about the alert feeder configuration.

    ---

5. In the **HTTP request** section, enter the following information:

    **- Method**

    The HTTP method to use when requesting data from the external system.

    **- URL**

    The endpoint URL of the external system.

    ---

6. {% include-markdown "includes/headers.md" %}

    ---

7. {% include-markdown "includes/authentication-type.md" %}

    ---

8. {% include-markdown "includes/proxy-settings.md" %}

    ---

9. {% include-markdown "includes/certificate-authority.md" %}

    ---

10. {% include-markdown "includes/host-name-verification.md" %}

    ---

11. Select **Test connection** to verify the connection to the external system.

    ---

12. Create a function to map fields from the external system to TheHive’s format:

    !!! info "Feeder function"
        Once created, the function is automatically added to the [functions list](../manage-functions/about-functions.md) with the type *feeder*. 

    **- Function name**

    Enter a name for the function. You can’t change this name later.

    **- Description**

    Describe what the function does.

    **- Definition**

    {% include-markdown "includes/function-definition.md" %}

    ---

13. {% include-markdown "includes/test-function.md" %}

    ---

14. Select **Confirm**.

## Airtable example

[Airtable](https://www.airtable.com/) is one of the external systems you can configure as an alert feeder in TheHive. Airtable is a cloud-based platform that combines the features of a spreadsheet and a database.

### Query

``` curl 
--location --request GET 'https://api.airtable.com/v0/<base_id>/<table_id>?returnFieldsByFieldId=false&cellFormat=string&timeZone=<timezone>&userLocale=<locale>' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <api_key>' \
--data '{
    "returnFieldsByFieldId": true,
    "maxRecords": 1
}'
```

### Response

``` json
{
    "records": [
        {
            "id": "rec3mzMkF2JNsApxn",
            "createdTime": "2025-01-23T16:18:13.000Z",
            "fields": {
                "Incident Category": "Security",
                "Issue Description": "Phishing campaign on financial department"
            }
        },
        {
            "id": "rec5FB3iOuoT9avrm",
            "createdTime": "2025-01-23T17:50:56.000Z",
            "fields": {
                "Incident Category": "Software",  
                "Reported By": "U003",  
                "Priority Level": "ASAP",  
                "Assigned Agent": "SOC Officer",  
                "Department": "Supply chain",  
                "Issue Description": "Supply chain server SPC-345 infected",  
                "Resolution Details": "RES-003"
            }
        },
        {
            "id": "rec6FGdVFzMQX3Ke4",
            "createdTime": "2025-01-21T14:00:49.000Z",
            "fields": {
                "Incident Category": "Security",
                "Reported By": "Automated alert",
                "Priority Level": "ASAP",
                "Issue Description": "Software version need to be updated"
            }
        },
        ...
    ]
}
```

### Feeder function

You can find the function example for creating an alert from Airtable in the [GitHub repository](https://github.com/StrangeBeeCorp/thehive-templates/blob/main/Functions%20Examples/Alert%20Feeder%20Functions/function_Feeder_alertFromAirtable.js).

<h2>Next steps</h2>

* [Turn Off an Alert Feeder](turn-off-a-feeder.md)
* [Delete an Alert Feeder](delete-a-feeder.md)