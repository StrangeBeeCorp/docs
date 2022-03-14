# Advanced Settings

Authentication consists of a set of modules. Each module tries to authenticate the user. If it fails, the next one in the list is tried until the end of the list.

In this section you will find information about configuring the advanced authentication settings.

To configure the advanced authentication settings:

1. On the Platform Management page, in the Authentication tab, switch on the following buttons as per your requirement:

    1. **Enable Basic Authentication**: Authenticates HTTP requests using the login and password provided.
    1. **Enable API Key authentication**: Authenticates HTTP requests using an API key provided.
    1. **Enable HTTP Header Authentication**: Authenticates HTTP requests using a HTTP header containing the user login.
    1. **Enable Multifactor authentication**: Multi-Factor Authentication is enabled by default. This means users can configure their MFA through their User Settings page.

    <img src="../images/advanced-settings.png" alt="Configure Advanced Settings" width="1000" height="1000"/>

## Manage Authentication Providers

On the Platform Management page, in the Authentication tab, you can see the list of following Authentication providers.

1. **Local Authentication**: You can manage a local user database where you can configure the password policy.

    <img src="../images/local-authentication.png" alt="Local Authentication" width="1000" height="1000"/>

1. **Directories Authentication**: You can configure The Hive to use either active directory or LDAP to authorize the users. If you manage your users through a active directory, then you can configure TheHive in a way that every time a user enters the username, you will authenticate the crredentials in the configured active directory and if active directory accepts the credentials then you authorize the user.

    Active Directory Configuration:

    <img src="../images/directories-authentication-ad.png" alt="Active Directories Authentication" width="1000" height="1000"/>

    LDAP Configuration:

    <img src="../images/directories-authentication-ldap.png" alt="LDAP Authentication" width="1000" height="1000"/>

    
1. **OAuth 2 Authentication**: You can configure TheHive to sign in using single signon through external OAuth2 authenticator server.

    <img src="../images/oauth2-authentication.png" alt="OAuth 2 Authentication" width="1000" height="1000"/>
    
    