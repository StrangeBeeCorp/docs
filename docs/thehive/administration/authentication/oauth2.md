# How to Configure an OAuth 2.0 Authentication Provider

This topic provides step-by-step instructions for configuring an OAuth 2.0 authentication provider in TheHive.

By following this guide, you’ll learn how to integrate popular OAuth 2.0 providers—such as Keycloak, Okta, GitHub, Microsoft 365, and Google.

{!includes/license-required-authentication.md!}

{!includes/access-authentication.md!}

## Procedure

1. {!includes/platform-management-view-go-to.md!}

    ---

2. {!includes/authentication-tab-go-to.md!}

    ---

3. Select **OAuth 2 authentication** in the **Authentication providers** section.

    ---

4. In the **OAuth 2 authentication** drawer, turn on the **Enable OAuth 2 provider** toggle.

    ---

5. Enter the following information:

    **Client ID**

    The unique identifier assigned to TheHive by the OAuth 2.0 provider when you register the application. TheHive uses this identifier to authenticate with the OAuth server during the authorization process.

    **Client secret**

    A confidential string issued by the OAuth 2.0 provider, used along with the client ID to authenticate TheHive securely.

    **TheHive redirect URL**

    The URL where the OAuth 2.0 server redirects users after authentication.
    
    Format: *https://<your-hive-domain>/api/ssoLogin*

    **Grant type**

    Specifies the OAuth 2.0 authorization flow used for authentication. 
    
    Common types include:

    * Authorization code (recommended for server-side apps)
    * Client credentials (used for machine-to-machine authentication)
    * Implicit (used for browser-based apps, though less secure)

    **Authorization URL**

    The endpoint of the OAuth 2.0 provider where users are redirected to authenticate and authorize access.

    **Prefix of the authorization header**

    Defines the type of token to pass in the authorization header, typically:

    * Bearer (most common)
    * Basic (used for basic authentication)

    **Token URL**

    The endpoint used by TheHive to exchange the authorization code for an access token.

    **User information URL**

    The endpoint that TheHive calls using the access token to retrieve user details (such as ID, email, or name).

    **List of scope**

    Specifies the access permissions that TheHive requests from the OAuth 2.0 server. 
    
    Examples include:

    * *openid*: Access to basic user information
    * *email*: Access to the user’s email address
    * *profile*: Access to profile information

    **Field that contains the id of the user in user info**

    The specific field in the user information response that holds the user's unique identifier. TheHive uses this field to map authenticated users.

    ---

6. Turn on the **Enable user auto creation** to automatically create a user account in TheHive when a new user successfully authenticates through the OAuth 2.0 provider.

    Then enter the following information:

    * Field that contains the name of the user in user info
    * Field that contains the name of the organization in user info
    * Default organization used to create TheHive user
    * Default profile used to create TheHive user

    Turn on the **Allow admin user auto creation** to automatically assign administrative privileges to newly created users upon successful authentication.

    ---

7. Select the proxy settings you want to apply:

    * *Default configuration*
    * *Disabled*
    * *Enabled*:
        * Enter the type of protocol, either HTTP or HTTPS.
        * Enter the IP address or domain name of the proxy server.
        * Enter the port number used by the proxy server.
    
    ---

8. Add a certificate authority.

    For more information about configuring SSL, refer to the [Configure SSL](ssl.md) topic.

    Only use certificates from trusted, predefined authorities for secure connections; you can't use custom certificate authorities.

    You can turn off the **Don't check certificate authority** toggle to bypass certificate validation, but this isn't recommended as it may compromise connection security.

    ---

9. Turn on the **Disable host name verification** toggle if you want to bypass the verification of the server's host name against the certificate.

    ---

10. Select **Confirm**.

## Examples

!!! Example ""

    === "Keycloak"

        | Parameter                                           | Value                                                               |
        |-----------------------------------------------------|---------------------------------------------------------------------|
        | Client ID                                           | CLIENT_ID                                                         |
        | Client secret                                       | CLIENT_SECRET                                                     |
        | TheHive redirect URL                                | https://THEHIVE_URL/api/ssoLogin                                |
        | Grant type                                          | authorization_code                                  |
        | Authorization URL                                   | http://KEYCLOAK/auth/realms/TENANT/protocol/openid-connect/auth     |
        | Prefix of the authorization header                  | Bearer                                |
        | Token URL                                           | http://KEYCLOAK/auth/realms/TENANT/protocol/openid-connect/token    |
        | User information URL                                | http://KEYCLOAK/auth/realms/TENANT/protocol/openid-connect/userinfo |
        | List of scope                                       | ["openid", "email"]                                               |
        | Field that contains the id of the user in user info | "email"                                                             |
        
    === "Okta"

        | Parameter                                           | Value                            |
        |-----------------------------------------------------|----------------------------------|
        | Client ID                                           | CLIENT_ID                      |
        | Client secret                                       | CLIENT_SECRET                  |
        | TheHive redirect URL                                | http://THEHIVE_URL/api/ssoLogin  |
        | Grant type                                          | authorization_code                                  |
        | Authorization URL                                   | https://OKTA/oauth2/v1/authorize |
        | Prefix of the authorization header                  | Bearer                                |
        | Token URL                                           | http://OKTA/oauth2/v1/token      |
        | User information URL                                | http://OKTA/oauth2/v1/userinfo   |
        | List of scope                                       | ["openid", "email"]            |
        | Field that contains the id of the user in user info | "email"                          |

    === "GitHub"

        | Parameter                                           | Value                                       |
        |-----------------------------------------------------|---------------------------------------------|
        | Client ID                                           | CLIENT_ID                                 |
        | Client secret                                       | CLIENT_SECRET                             |
        | TheHive redirect URL                                | https://THEHIVE_URL/api/ssoLogin            |
        | Grant type                                          | authorization_code                                  |
        | Authorization URL                                   | https://github.com/login/oauth/authorize    |
        | Prefix of the authorization header                  | Bearer                                |
        | Token URL                                           | https://github.com/login/oauth/access_token |
        | User information URL                                | https://api.github.com/user                 |
        | List of scope                                       | ["user"]                                  |
        | Field that contains the id of the user in user info | "email"                                     |
        
        !!! note "GitHub configuration"
            - Generate the `CLIENT_ID` and `CLIENT_SECRET` in the OAuth Apps section at [GitHub Developer Settings](https://github.com/settings/developers).
            - Ensure users set a public email address in their profile at [GitHub Profile Settings](https://github.com/settings/profile) for this configuration to work correctly.

    === "Microsoft 365" 

        | Parameter                                           | Value                                                          |
        |-----------------------------------------------------|----------------------------------------------------------------|
        | Client ID                                           | CLIENT_ID                                                    |
        | Client secret                                       | CLIENT_SECRET                                                |
        | TheHive redirect URL                                | https://THEHIVE_URL/api/ssoLogin                               |
        | Grant type                                          | authorization_code                                  |
        | Authorization URL                                   | https://login.microsoftonline.com/TENANT/oauth2/v2.0/authorize |
        | Prefix of the authorization header                  | Bearer                                |
        | Token URL                                           | https://login.microsoftonline.com/TENANT/oauth2/v2.0/token     |
        | User information URL                                | https://graph.microsoft.com/v1.0/me                            |
        | List of scope                                       | ["User.Read"]                                                |
        | Field that contains the id of the user in user info | "mail"                                                         |

        !!! note "Microsoft configuration"
            To generate the `CLIENT_ID`, `CLIENT_SECRET` and `TENANT`, register a new application in the [Azure Active Directory App Registrations portal](https://aad.portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps).

    === "Google" 

        | Parameter                                           | Value                                            |
        |-----------------------------------------------------|--------------------------------------------------|
        | Client ID                                           | CLIENT_ID                                      |
        | Client secret                                       | CLIENT_SECRET                                  |
        | TheHive redirect URL                                | https://THEHIVE_URL/api/ssoLogin                 |
        | Grant type                                          | authorization_code                                  |
        | Authorization URL                                   | https://accounts.google.com/o/oauth2/v2/auth     |
        | Prefix of the authorization header                  | Bearer                                |
        | Token URL                                           | https://oauth2.googleapis.com/token              |
        | User information URL                                | https://openidconnect.googleapis.com/v1/userinfo |
        | List of scope                                       | ["email", "profile", "openid"]                 |
        | Field that contains the id of the user in user info | "email"                                          |
        
        !!! note "Google configuration"
            - Generate the `CLIENT_ID` and `CLIENT_SECRET` in the **APIs & Services > Credentials** section of the [Google Cloud Console](https://console.cloud.google.com/apis/credentials).
            - Follow the [Google OAuth 2.0 credentials guide](https://support.google.com/cloud/answer/6158849) for step-by-step instructions.
            - Refer to [Google's OpenID Connect configuration](https://accounts.google.com/.well-known/openid-configuration) for the latest authentication URLs.            

## Next steps

* [How to Configure Authentication](configure-authentication.md)
* [Configure SSL](ssl.md)