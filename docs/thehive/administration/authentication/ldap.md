# How to Configure an LDAP Authentication Provider

This topic provides step-by-step instructions for configuring an Lightweight Directory Access Protocol (LDAP) authentication provider in TheHive.

{!includes/license-required-authentication.md!}

{!includes/access-authentication.md!}

## Procedure

!!! info "Prerequisite"
    Users must have an existing account in TheHive's local database to authenticate successfully. To automate account creation, ensure that [LDAP servers](../../administration/ldap-server.md) are configured in TheHive.

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/authentication-tab-go-to.md!}

3. Select **Directories authentication** in the **Authentication providers** section.

4. In the **Directories authentication** drawer, turn on the **Enable directory** toggle.

5. Select **ldap** from the dropdown list.

6. Enter the servers host name or IP address.

    Example: *ldap.company.com*

7. Turn on the **Auth-use SSL** toggle to encrypt communication between TheHive and the authentication provider.

  For more information about configuring SSL, refer to the [Configure SSL](ssl.md) topic.

8. Enter the following information:

    **DN of the service account**

    The Distinguished Name (DN) of the service account used for authentication. This account is responsible for binding to the LDAP directory and performing search operations.

    Example: *cn=thehive,ou=users,dc=company,dc=com*

    **Bind password**

    The password associated with the service account. This password authenticates the service account to allow LDAP queries.

    **Users base DN**

    The base DN from which the search for user accounts will begin. This limits the search scope to a specific branch of the directory.

    Example: *ou=users,dc=company,dc=com*

    **Filter used to search users**

    The LDAP filter to locate user accounts. This filter helps narrow down search results to relevant users.

    Example: *(&(uid={0})(objectClass=inetOrgPerson))*

9. Select **Confirm**.

## Next steps

* [How to Configure Authentication](configure-authentication.md)
* [Configure SSL](ssl.md)