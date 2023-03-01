# OAuth2 / OpenID-Connect

![OAuth2 configuration page](./images/authentication-oauth2-1.png)


## Configuration

Authenticate the user using an external OAuth2 authenticator server. It accepts the following configuration parameters:

| Parameter                                           | Description                                                  |
|-----------------------------------------------------|--------------------------------------------------------------|
| Client ID                                           | client ID in the OAuth2 server                               |
| Client secret                                       | client secret in the OAuth2 server                           |
| TheHive redirect URL                                | the url of TheHive AOuth2 page ( `https://xxx/api/ssoLogin`) |
| Authorization URL                                   | the url of the OAuth2 server                                 |
| Token URL                                           | the token url of the OAuth2 server                           |
| User information URL                                | the url to get user information in OAuth2 server             |
| List of scope                                       | list of scope                                                |
| Field that contains the id of the user in user info | the field that contains the id of the user in user info      |


### Examples

!!! Example ""

    === "Keycloak"

        | Parameter                                           | Value                                                               |
        |-----------------------------------------------------|---------------------------------------------------------------------|
        | Client ID                                           | `CLIENT_ID`                                                         |
        | Client decret                                       | `CLIENT_SECRET`                                                     |
        | TheHive redirect URL                                | https://THEHIVE_URL/api/ssoLogin                                    |
        | Authorization URL                                   | http://KEYCLOAK/auth/realms/TENANT/protocol/openid-connect/auth     |
        | Token URL                                           | http://KEYCLOAK/auth/realms/TENANT/protocol/openid-connect/token    |
        | User information URL                                | http://KEYCLOAK/auth/realms/TENANT/protocol/openid-connect/userinfo |
        | List of scope                                       | `["openid", "email"]`                                               |
        | Field that contains the id of the user in user info | "email"                                                             |
        
    === "Okta"

        | Parameter                                           | Value                            |
        |-----------------------------------------------------|----------------------------------|
        | Client ID                                           | `CLIENT_ID`                      |
        | Client decret                                       | `CLIENT_SECRET`                  |
        | TheHive redirect URL                                | http://THEHIVE_URL/api/ssoLogin  |
        | Authorization URL                                   | https://OKTA/oauth2/v1/authorize |
        | Token URL                                           | http://OKTA/oauth2/v1/token      |
        | User information URL                                | http://OKTA/oauth2/v1/userinfo   |
        | List of scope                                       | `["openid", "email"]`            |
        | Field that contains the id of the user in user info | "email"                          |

    === "Github"

        | Parameter                                           | Value                                       |
        |-----------------------------------------------------|---------------------------------------------|
        | Client ID                                           | `CLIENT_ID`                                 |
        | Client decret                                       | `CLIENT_SECRET`                             |
        | TheHive redirect URL                                | https://THEHIVE_URL/api/ssoLogin            |
        | Authorization URL                                   | https://github.com/login/oauth/authorize    |
        | Token URL                                           | https://github.com/login/oauth/access_token |
        | User information URL                                | https://api.github.com/user                 |
        | List of scope                                       | `["user"]`                                  |
        | Field that contains the id of the user in user info | "email"                                     |
        
        !!! Note
            - `CLIENT_ID` and `CLIENT_SECRET` are created in the _OAuth Apps_ section at [https://github.com/settings/developers](https://github.com/settings/developers).
            - this configuration requires that users set the _Public email_ in their Public Profile on [https://github.com/settings/profile](https://github.com/settings/profile).

    === "Microsoft 365" 

        | Parameter                                           | Value                                                          |
        |-----------------------------------------------------|----------------------------------------------------------------|
        | Client ID                                           | `CLIENT_ID`                                                    |
        | Client decret                                       | `CLIENT_SECRET`                                                |
        | TheHive redirect URL                                | https://THEHIVE_URL/api/ssoLogin                               |
        | Authorization URL                                   | https://login.microsoftonline.com/TENANT/oauth2/v2.0/authorize |
        | Token URL                                           | https://login.microsoftonline.com/TENANT/oauth2/v2.0/token     |
        | User information URL                                | https://graph.microsoft.com/v1.0/me                            |
        | List of scope                                       | `["User.Read"]`                                                |
        | Field that contains the id of the user in user info | "mail"                                                         |
        

        !!! Note
            To create `CLIENT_ID`, `CLIENT_SECRET` and `TENANT`, register a new app at [https://aad.portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps](https://aad.portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps).

    === "Google" 

        | Parameter                                           | Value                                            |
        |-----------------------------------------------------|--------------------------------------------------|
        | Client ID                                           | `CLIENT_ID`                                      |
        | Client decret                                       | `CLIENT_SECRET`                                  |
        | TheHive redirect URL                                | https://THEHIVE_URL/api/ssoLogin                 |
        | Authorization URL                                   | https://accounts.google.com/o/oauth2/v2/auth     |
        | Token URL                                           | https://oauth2.googleapis.com/token              |
        | User information URL                                | https://openidconnect.googleapis.com/v1/userinfo |
        | List of scope                                       | `["email", "profile", "openid"]`                 |
        | Field that contains the id of the user in user info | "email"                                          |
        
        !!! Note
            - `CLIENT_ID` and `CLIENT_SECRET` are created in the `_APIs & Services_ > _Credentials_` section of the [GCP Console](https://console.cloud.google.com/apis/credentials)
            - Instructions on how to create Oauth2 credentials at [https://support.google.com/cloud/answer/6158849](https://support.google.com/cloud/answer/6158849)
            - For the latest reference for Google auth URLs please check Google's [.well-known/openid-configuration](https://accounts.google.com/.well-known/openid-configuration)


## User autocreation

To allow users to login without previously creating them, you can enable autocreation, and specify few options:

* Field that contains the name of the user in user info
* Field that contains the name of the organisation in user info
* Default organisation applied to new users
* Default profile applied to new users


![](./images/authentication-oauth2-2.png)