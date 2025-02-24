# How to Configure Authentication

This topic provides step-by-step instructions for configuring authentication in TheHive.

{!includes/access-authentication.md!}

## Procedure

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/authentication-tab-go-to.md!}

3. Enter the values for each session setting:

    **Session expiration auto-logout**

    The amount of time before you are automatically signed out when your session expires.

    **Session expiration warning time**

    The amount of time remaining before session expiration when you receive a warning. This must be equal to or less than the session expiration auto-logout time.

    **Inactivity auto-logout**

    The amount of time before you are automatically signed out due to inactivity.

    **Inactivity warning time**

    The amount of time remaining before automatic sign-out due to inactivity when you receive a warning. This must be equal to or less than the inactivity auto-logout time.

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

5. Select the authentication providers you want to configure.

    {!includes/license-required-authentication.md!}

    **Local authentication**

    Authenticates users against a local database managed by TheHive. You can configure password policies, including complexity requirements, expiration periods, and account lockout settings.

    For more information, see the [Configure Local Authentication](local.md) topic.

    **Directories authentication**

    Authenticates users using a Lightweight Directory Access Protocol (LDAP) server, such as Microsoft Active Directory or OpenLDAP. This allows integration with existing enterprise directories for centralized user management.

    !!! warning "LDAP servers required"
        Configuring LDAP means you must have [LDAP servers configured](../../administration/ldap-server.md) in TheHive.

    For more information, see the [Configure an Active Directory Authentication](ad.md) and [Configure LDAP Authentication](ldap.md) topics.

    **OAuth 2.0 authentication**

    Enables single sign-on (SSO) through an external OAuth 2.0 provider, such as Google, Microsoft Azure AD, or GitHub. This simplifies authentication by allowing users to sign in using their existing credentials from supported platforms.

    For more information, see the [Configure OAuth 2.0 Authentication](oauth2.md) topic.

    **SAML authentication**

    Enables single sign-on (SSO) through one or more Security Assertion Markup Language (SAML) providers, such as Okta, ADFS, or Google Workspace. This method supports secure, federated identity management for large organizations.

    For more information, see the [Configure SAML Authentication](saml.md) topic.

6. If you enabled multiple providers, adjust the priority order using the arrows.
    
    The priority order defines the sequence in which TheHive attempts authentication. It starts with the highest priority and moves down until the user is authenticated or all providers are checked. Set the most secure or frequently used provider first.

## Next steps

* [Configure Local Authentication](local.md)
* [Configure an Active Directory Authentication](ad.md)
* [Configure LDAP Authentication](ldap.md)
* [Configure OAuth 2.0 Authentication](oauth2.md)
* [Configure SAML Authentication](saml.md)