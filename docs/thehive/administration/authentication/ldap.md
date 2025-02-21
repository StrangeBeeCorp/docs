# How to Configure LDAP Authentication

This topic provides step-by-step instructions for configuring LDAP authentication in TheHive.

{!includes/license-required-authentication.md!}

{!includes/access-authentication.md!}

## Procedure

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/authentication-tab-go-to.md!}

3. Select **Directories authentication** in the **Authentication providers** section.

4. In the **Directories authentication** drawer, turn on the **Enable directory** toggle.

5. Select **ldap** from the dropdown list.

6. Enter the servers hostname or IP adress.

  You must [configure LDAP servers](../../administration/ldap-server.md) in TheHive first.

7. Turn on the **Auth-use SSL** toggle to encrypt communication between TheHive and the authentication provider.

8. Enter the following information:

  **DN of the service account**

  The Distinguished Name (DN) of the service account used for authentication. This account is responsible for binding to the LDAP directory and performing search operations.

  **Bind password**

  The password associated with the service account. This password authenticates the service account to allow LDAP queries.

  **Users base DN**

  The base DN from which the search for user accounts will begin. This limits the search scope to a specific branch of the directory.

  **Filter used to search users**

  The LDAP filter to locate user accounts. This filter helps narrow down search results to relevant users.

## Next steps


4. Confirm and save your changes
5. move the _Directories Authentication_ line to be the first provider to use in the list of authentication providers

!!! Tip "Using SSL with LDAP"
    To setup a custom Certificate Authority in TheHive, please refer to [this guide](../../configuration/ssl.md#use-custom-certificate-authorities).


## Authenticating with LDAP
Users able to authenticate should already have an account created in TheHive local database.