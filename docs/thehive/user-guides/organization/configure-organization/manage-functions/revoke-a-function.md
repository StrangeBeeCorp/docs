# How to Revoke a Function

This topic provides step-by-step instructions for revoking a [function](about-functions.md) in TheHive.

{!includes/access-functions.md!}

<h2>Procedure</h2>

1. {!includes/organization-view-go-to.md!}

2. {!includes/functions-tab-go-to.md!}

3. Select the function you want to revoke, or select :fontawesome-solid-ellipsis: and then **Edit**.

4. Select the **How to call the function** section.

5. Copy the cURL or Python command example to use in your HTTP call.

!!! note "Example"

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

    TheHive processes your input (the body of the HTTP call) using the function definition and executes the function accordingly. It then responds to the HTTP call with the data returned by the function.    

<h2>Next steps</h2>

* [Create a Function](create-a-function.md)