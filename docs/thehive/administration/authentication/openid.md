# Configure an OpenID Authentication Provider

 <!-- md:version 5.5 --> <!-- md:license Platinum -->

Configure an OpenID authentication provider in TheHive.

{% include-markdown "includes/access-authentication.md" %}

<h2>Procedure</h2>

{% include-markdown "includes/prerequisites-authentication-providers.md" %}

!!! info "Login flow with multiple OpenID providers"
    You can configure multiple OpenID providers in TheHive. When a user attempts to log in, TheHive queries each provider sequentially, following the defined order. The process stops as soon as a provider grants authorization.

1. {% include-markdown "includes/platform-management-view-go-to.md" %}

    ---

2. {% include-markdown "includes/authentication-tab-go-to.md" %}

    ---

3. Select **SSO authentication** in the **Authentication providers** section.

    ---

4. In the **SSO authentication** drawer, turn on the **Enable SSO** toggle.

    ---

5. Select **Add a provider** or select :fontawesome-solid-plus:.

    ---

6. Select **OpenID** from the dropdown list.

    ---

7. Enter the following information:

    **- Name \***

    A recognizable name for the IdP in TheHive.

    Example: *Microsoft Entra ID*

    **- Client ID \***

    The unique identifier for the OpenID application registered with the IdP.

    **- Secret \***

    The secret key associated with the Client ID.

    **- Identity provider metadata type \***

    Select how TheHive retrieves configuration information for the IdP—either from an JSON file or a URL.

    * If you choose *url*, provide the full link to the metadata document.
    
        Example: *https://login.microsoftonline.com/{tenant-id}/.well-known/openid-configuration*

    * If you choose *json*, paste the JSON content directly into the field.
    
        Example: 

        ``` json
        {
            "issuer": "https://login.microsoftonline.com/<tenant-id>/v2.0",
            "authorization_endpoint": "https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/authorize",
            "token_endpoint": "https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/token",
            "userinfo_endpoint": "https://graph.microsoft.com/oidc/userinfo"
        }
        ```

    **- User login attribute**

    The name of the attribute from the IdP that contains the user's login information (such as email or username).

<h2>Next steps</h2>

* [Configure Authentication](configure-authentication.md)