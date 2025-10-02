# Configure Authentication

<!-- md:permission `managePlatform` -->

Authentication in TheHive controls how users and services sign in. You can use the built-in local database, integrate with enterprise directories such as LDAP or AD, or enable SSO through SAML or OpenID providers. Additional options include API key authentication, basic authentication, HTTP header authentication, multi-factor authentication, and configurable session management.

<h2>Procedure</h2>

1. {% include-markdown "includes/platform-management-view-go-to.md" %}

    ---

2. {% include-markdown "includes/authentication-tab-go-to.md" %}

    ---

3. Enter the values for each session setting:

    **- Session expiration autologout**

    The amount of time before users are automatically signed out, regardless of activity. This is based on the total duration of the session.

    **- Session expiration warning time**

    The amount of time remaining before session expiration when users receive a warning. This must be equal to or less than the session expiration autologout time.

    **- Inactivity autologout**

    The amount of time before users are automatically signed out due to inactivity. If users interact with the interface, the timer is reset.

    **- Inactivity warning time**

    The amount of time remaining before automatic sign-out due to inactivity when users receive a warning. This must be equal to or less than the inactivity autologout time.

    ---

4. Turn the toggles on or off for advanced settings based on your preferences:

    **- Enable API key authentication**

    Authenticates HTTP requests using an API key.

    **- Enable basic authentication**

    Authenticates HTTP requests using a login and password. When enabled, you must provide a realm—a string that defines a protected space on the server.

    **- Enable HTTP header authentication**

    Authenticates HTTP requests using a HTTP header that contains a user login. When enabled, you must provide the header name that the server will use to extract the login information from incoming requests.

    **- Enable multi-factor authentication**

    Enables MFA, allowing users to activate it.

    **- Default domain for user login**

    By default, logins use email addresses. This feature lets users sign in without specifying the email domain. Instead of entering *user@example.com*, they only need to enter *user*.

    ---

5. Select the authentication providers you want to configure.

    !!! warning "Paid license required"
        A [paid license](../../installation/licenses/about-licenses.md) is required to configure authentication providers other than the local database managed by TheHive.  
        A Platinum license is required to configure Active Directory, OAuth 2.0, OpenID, and SAML authentication.

    **- Local authentication**

    Authenticates users against a local database managed by TheHive. You can configure password policies, including complexity requirements, expiration periods, and account lockout settings.

    For more information, see the [Configure a Local Authentication Provider](local.md) topic.

    **- Directories authentication**

    !!! info "Prerequisite"
        Users must have an existing account in TheHive local database to authenticate successfully. [Configure an LDAP server](../../administration/ldap/configure-ldap-server.md) to automate account creation, updates, deletion, and assignment of user accounts to organizations and permission profiles within TheHive.

    Authenticates users using an LDAP server or an AD service, such as Microsoft Active Directory or OpenLDAP. This allows integration with existing enterprise directories for centralized user management.

    For more information, see the [Configure an Active Directory Authentication Provider](ad.md) and [Configure an LDAP Authentication Provider](ldap.md) topics.

    **- OAuth 2.0 authentication (deprecated)**

    !!! warning "Deprecated"
        The OAuth 2.0 is deprecated and will be removed in a future release. Use the [OpenID authentication provider](openid.md) instead.

    Enables SSO through an external OAuth 2.0 provider, such as Keycloak, Okta, GitHub, Microsoft 365, or Google. This simplifies authentication by allowing users to sign in using their existing credentials from supported platforms.

    For more information, see the [Configure an OAuth 2.0 Authentication Provider](oauth2.md) topic.

    **- SSO authentication**

    Enables SSO through one or more SAML providers or OpenID providers, such as Okta or Microsoft Entra ID. This method supports secure, federated identity management for large organizations.

    For more information, see the [Configure a SAML Authentication Provider](saml.md) and [Configure an OpenID Authentication Provider](openid.md) topics.

    ---

6. If you enabled multiple providers, adjust the priority order using the arrows.
    
    Set the most secure or frequently used provider first to define the priority order. TheHive then attempts authentication starting with the highest priority and continues down the list until it authenticates the user or checks all providers.

<h2>Next steps</h2>

* [Configure a Local Authentication Provider](local.md)
* [Configure an Active Directory Authentication Provider](ad.md)
* [Configure an LDAP Authentication Provider](ldap.md)
* [Configure an OAuth 2.0 Authentication Provider](oauth2.md)
* [Configure a SAML Authentication Provider](saml.md)
* [Configure an OpenID Authentication Provider](openid.md)
* [Configure JVM Trust for SSL/TLS Certificates](../../configuration/ssl/configure-ssl-jvm.md)