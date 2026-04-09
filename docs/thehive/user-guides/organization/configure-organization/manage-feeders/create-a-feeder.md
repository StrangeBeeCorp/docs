# Create an Alert Feeder

<!-- md:version 5.5 --> <!-- md:permission `manageConfig` --> <!-- md:license Platinum -->

Create an [alert feeder](about-feeders.md) in TheHive to automatically retrieve data at a defined frequency from an external service via an HTTP API call and convert it into alerts.

For an example configuration, see the [Airtable example](#airtable-example).

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

    * **None**: Use this method when the external API doesn't require authentication.
    * **Basic**: Use this method to authenticate using HTTP Basic authentication.  
    Enter the username and password provided by the external system, which will be sent in the `Authorization` header.
    * **Key**: Use this method to authenticate using an API key.  
    Enter the API key provided by the external system.
    * **Bearer**: Use this method to authenticate using a bearer token.  
    Enter the bearer token, which will be sent in the `Authorization` header.
    * <!-- md:version 5.7 --> **OAuth 2.0** (client credentials): Use this method to authenticate with an OAuth 2.0 authorization server using the client credentials grant type.

        **- Client authentication method \***

        Defines how the client credentials are sent to the token endpoint.

        Supported values:

        * `client_secret_post`: The client credentials are sent in the request body as form parameters.
        * `client_secret_basic`: The client credentials are sent in the HTTP `Authorization` header using Basic authentication.
      
        **- Client ID \***

        The unique identifier assigned to TheHive by the OAuth 2.0 provider when you register the application. TheHive uses this identifier to authenticate with the OAuth server during the authorization process.

        **- Client secret \***

        A confidential string issued by the OAuth 2.0 provider, used along with the client ID to authenticate TheHive securely.

        **- Token URL \***

        The OAuth 2.0 token endpoint used to obtain an access token.

        **- Scope**

        Optional list of scopes to request from the authorization server.

        **- Token parameters**

        Additional parameters to include in the token request.

        !!! Example "Examples"

            === "Keycloak"

                | Parameter                                           | Value                                                          |
                |-----------------------------------------------------|----------------------------------------------------------------|
                | Client authentication method                        | `client_secret_post`                                                 |
                | Client ID                                           | `<client_id>`                                                  |
                | Client secret                                       | `<client_secret>`                                                |
                | Token URL                                           | `https://<keycloak_url>/auth/realms/<realm_name>/protocol/openid-connect/token`      |
                | Scope                                       | `["openid", "email"]`                                               |

                !!! Note "Keycloak URL"
                    The `/auth` prefix may vary depending on your Keycloak version.

            === "Microsoft 365"

                | Parameter                                           | Value                                                          |
                |-----------------------------------------------------|----------------------------------------------------------------|
                | Client authentication method                        | `client_secret_post`                                            |
                | Client ID                                           | `<client_id>`                                                    |
                | Client secret                                       | `<client_secret>`                                                |
                | Token URL                                           | `https://login.microsoftonline.com/<tenant>/oauth2/v2.0/token`     |
                | Scope                                       | `["User.Read"]`                                              |

                !!! note "Microsoft configuration"
                    To generate the `<client_id>`, `<client_secret>` and `<tenant>`, register a new application in the [Azure Active Directory App Registrations portal](https://aad.portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps){target=_blank}.

    ---

8. In the **Proxy settings** section, select the proxy settings you want to apply:

    * *Default configuration*
    * *Disabled*
    * *Enabled*:
        * Enter the type of protocol, either HTTP or HTTPS.
        * Enter the IP address or domain name of the proxy server.
        * Enter the port number used by the proxy server.
        * The username and password to authenticate with the proxy server.

    ---

9. {% include-markdown "includes/certificate-authority.md" %}

    ---

10. {% include-markdown "includes/host-name-verification.md" %}

    ---

11. Select **Test connection** to verify the connection to the external system.

    ---

12. Create a function to map fields from the external system to TheHive format:

    !!! info "Feeder function"
        Once created, the function is automatically added to the [functions list](../manage-functions/about-functions.md) with the type *feeder*.

    **- Function name**

    Enter a name for the function. You can’t change this name later.

    **- Description**

    Describe what the function does.

    **- Definition**

    {% include-markdown "includes/function-definition.md" %}

    ---

13. In the **Test function** section, you can test your function as follows:

      * Enter input data by selecting *input*.

      * Select one of the following:

          * **Run function (dry-run)** to simulate the function without sending data.
          * **Run function** to execute the function with actual data.

      * After running the function, select one of the following to view results:

          * *result* to view the function’s output
          * *stdout* to display standard output from the function
          * *stderr* to display errors and warnings

    ---

14. Select **Confirm**.

## Airtable example

[Airtable](https://www.airtable.com/){target=_blank} is one of the external systems you can configure as an alert feeder in TheHive. Airtable is a cloud-based platform that combines the features of a spreadsheet and a database.

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

You can find the function example for creating an alert from Airtable in the [GitHub repository](https://github.com/StrangeBeeCorp/integrations/blob/main/.generated/docs/functions/airtable-alertfromairtable.md){target=_blank}.

<h2>Next steps</h2>

* [Turn Off an Alert Feeder](turn-off-a-feeder.md)
* [Delete an Alert Feeder](delete-a-feeder.md)