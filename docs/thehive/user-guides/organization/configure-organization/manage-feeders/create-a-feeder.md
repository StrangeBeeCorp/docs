# How to Create an Alert Feeder

This topic provides step-by-step instructions for creating an [alert feeder](about-feeders.md) in TheHive.

You can also find an example of [how to configure an Airtable alert feeder](#airtable-example).

{!includes/access-feeders.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

    ---

2. Select the **Connectors** tab.

    Image

    ---

3. Select :fontawesome-regular-square-plus:.

    ---

4. In the **General settings** section, enter the following information:

    **- Name**

    A unique name for the alert feeder. You can’t change this name later.

    **- Interval**

    How often the alert feeder sends requests to the external system. Make sure the interval is shorter than the processing time to avoid potential issues.

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

6. {!includes/headers.md!}

    ---

7. {!includes/authentication-type.md!}

    ---

8. {!includes/proxy-settings.md!}

    ---

9. {!includes/certificate-authority.md!}

    ---

10. {!includes/host-name-verification.md!}

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

    {!includes/function-definition.md!}

    ---

13. {!includes/test-function.md!}

    ---

14. Select **Confirm**.

## Airtable example

### Query

``` curl 
--location --request GET 'https://api.airtable.com/v0/appq4BcPkTvbqPeYD/tbloC5oeiM4H8JNFP?returnFieldsByFieldId=false&cellFormat=string&timeZone=GMT&userLocale=fr' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer ASKMEFORTHEKEY' \
--header 'Cookie: brw=brwpMBTzB0WQMhB2D; AWSALBTG=GYogHbsKgqNBpu0DcXqpNXmFyX+fC9ff0uyw0FKAxMy45ODSwt1GMBKwSi6hk3DYrmL7jx24HMG2NYWW3J1LWHwqyiwxQK99LfB2u8SgLtSqSnW90/zKX207KY/VrO0xZUBuQDS+rWqpUNvZodN9KGIk3A/fKMSfsZLWgpIng5Ajw/8PyTc=; AWSALBTGCORS=GYogHbsKgqNBpu0DcXqpNXmFyX+fC9ff0uyw0FKAxMy45ODSwt1GMBKwSi6hk3DYrmL7jx24HMG2NYWW3J1LWHwqyiwxQK99LfB2u8SgLtSqSnW90/zKX207KY/VrO0xZUBuQDS+rWqpUNvZodN9KGIk3A/fKMSfsZLWgpIng5Ajw/8PyTc=' \
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
                "Issue Description": "Last Alert of the day"
            }
        },
        {
            "id": "rec5FB3iOuoT9avrm",
            "createdTime": "2025-01-23T17:50:56.000Z",
            "fields": {
                "Incident Category": "Software",
                "Reported By": "U003",
                "Priority Level": "ASAP",
                "Assigned Agent": "Charlie Chocolate",
                "Department": "Code Conjurers",
                "Issue Description": "Lalerte du soir",
                "Resolution Details": "RES-003"
            }
        },
        {
            "id": "rec6FGdVFzMQX3Ke4",
            "createdTime": "2025-01-21T14:00:49.000Z",
            "fields": {
                "Incident Category": "Security",
                "Reported By": "UI",
                "Priority Level": "ASAP",
                "Issue Description": "Feeder is not broken"
            }
        },
        ...
    ]
}
```

### Feeder function

You can find the function example for creating an alert from Airtable in the [GitHub repository]().

## Next steps

* [Edit an Alert Feeder](edit-a-feeder.md)
* [Turn Off an Alert Feeder](turn-off-a-feeder.md)
* [Delete an Alert Feeder](delete-a-feeder.md)