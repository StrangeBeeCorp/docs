# How to Configure Authentication

This topic provides step-by-step instructions for configuring authentication in TheHive.

{!includes/access-authentication.md!}

## Procedure

1. {!includes/platform-management-view-go-to.md!}

    ---

2. {!includes/authentication-tab-go-to.md!}

    ---

3. Enter the values for each session setting:

    **Session expiration autologout**

    The amount of time before users are automatically signed out, regardless of activity. This is based on the total duration of the session.

    **Session expiration warning time**

    The amount of time remaining before session expiration when users receive a warning. This must be equal to or less than the session expiration autologout time.

    **Inactivity autologout**

    The amount of time before users are automatically signed out due to inactivity. If users interact with the interface, the timer is reset.

    **Inactivity warning time**

    The amount of time remaining before automatic sign-out due to inactivity when users receive a warning. This must be equal to or less than the inactivity autologout time.

    ---

4. Turn the toggles on or off for advanced settings based on your preferences:

    **Enable API key authentication**

    Authenticates HTTP requests using an API key.

    **Enable basic authentication**

    Authenticates HTTP requests using a login and password. When enabled, you must provide a realm—a string that defines a protected space on the server.

    **Enable HTTP header authentication**

    Authenticates HTTP requests using a HTTP header that contains a user login. When enabled, you must provide the header name that the server will use to extract the login information from incoming requests.

    **Enable multi-factor authentication**

    Enables multi-factor authentication (MFA), allowing users to activate it.

    **Default domain for user login**

    By default, logins use email addresses. This feature lets users sign in without specifying the email domain. Instead of entering *user@example.com*, they only need to enter *user*.

    ---

5. Select the authentication providers you want to configure.

    !!! note "Paid license required"
        A paid license is required to configure authentication providers other than the local database managed by TheHive.  
        A Platinum license is required to configure Active Directory, OAuth 2.0, and SAML authentication.

    **Local authentication**

    Authenticates users against a local database managed by TheHive. You can configure password policies, including complexity requirements, expiration periods, and account lockout settings.

    For more information, see the [Configure a Local Authentication Provider](local.md) topic.

    **Directories authentication**

    !!! info "Prerequisite"
        Users must have an existing account in TheHive's local database to authenticate successfully. [Configure the LDAP servers](../../administration/ldap-server.md) in TheHive to automate account creation.
    
        User data is synchronized periodically:  
        - New LDAP users are automatically created in TheHive.  
        - Removed users are disabled.  
        - Organization membership and user profiles are assigned based on LDAP group membership.  
    
        The configuration must include a mapping of LDAP groups to corresponding organizations and profiles.

    Authenticates users using a Lightweight Directory Access Protocol (LDAP) server or an Active Directory (AD) service, such as Microsoft Active Directory or OpenLDAP. This allows integration with existing enterprise directories for centralized user management.

    For more information, see the [Configure an Active Directory Authentication Provider](ad.md) and [Configure an LDAP Authentication Provider](ldap.md) topics.

    **OAuth 2.0 authentication**

    Enables single sign-on (SSO) through an external OAuth 2.0 provider, such as Keycloak, Okta, GitHub, Microsoft 365, or Google. This simplifies authentication by allowing users to sign in using their existing credentials from supported platforms.

    For more information, see the [Configure an OAuth 2.0 Authentication Provider](oauth2.md) topic.

    **SAML authentication**

    Enables single sign-on (SSO) through one or more Security Assertion Markup Language (SAML) providers, such as Okta or Microsoft Entra ID. This method supports secure, federated identity management for large organizations.

    For more information, see the [Configure a SAML Authentication Provider](saml.md) topic.

    ---

6. If you enabled multiple providers, adjust the priority order using the arrows.
    
    Set the most secure or frequently used provider first to define the priority order. TheHive then attempts authentication starting with the highest priority and continues down the list until it authenticates the user or checks all providers.

## Next steps

* [Configure a Local Authentication Provider](local.md)
* [Configure an Active Directory Authentication Provider](ad.md)
* [Configure an LDAP Authentication Provider](ldap.md)
* [Configure an OAuth 2.0 Authentication Provider](oauth2.md)
* [Configure a SAML Authentication Provider](saml.md)
* [Configure SSL](ssl.md)