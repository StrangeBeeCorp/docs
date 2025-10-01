# Configure an LDAP Authentication Provider

<!-- md:license Gold --> <!-- md:license Platinum -->

Configure an [LDAP](../ldap/about-ldap.md) authentication provider in TheHive.

{% include-markdown "includes/access-authentication.md" %}

<h2>Procedure</h2>

{% include-markdown "includes/local-account-ldap-ad.md" %}

{% include-markdown "includes/prerequisites-authentication-providers.md" %}

1. {% include-markdown "includes/platform-management-view-go-to.md" %}

    ---

2. {% include-markdown "includes/authentication-tab-go-to.md" %}

    ---

3. Select **Directories authentication** in the **Authentication providers** section.

    ---

4. In the **Directories authentication** drawer, turn on the **Enable directory** toggle.

    ---

5. Select **ldap** from the dropdown list.

    ---

6. Enter the servers host name or IP address.

    Example: *ldap.company.com*

    ---

7. Turn on the **Auth-use SSL** toggle to encrypt communication between TheHive and the authentication provider.

    For more information about configuring SSL/TLS, refer to [Configure JVM Trust for SSL/TLS Certificates](../../configuration/ssl/configure-ssl-jvm.md).

    ---

8. Enter the following information:

    **- DN of the service account**

    The Distinguished Name (DN) of the service account used for authentication. This account is responsible for binding to the LDAP directory and performing search operations.

    Example: *cn=thehive,ou=users,dc=company,dc=com*

    **- Bind password**

    The password associated with the service account. This password authenticates the service account to allow LDAP queries.

    **- Users base DN**

    The base DN from which the search for user accounts will begin. This limits the search scope to a specific branch of the directory.

    Example: *ou=users,dc=company,dc=com*

    **- Filter used to search users**

    The LDAP filter to locate user accounts. This filter helps narrow down search results to relevant users.

    Example: *(&(uid={0})(objectClass=inetOrgPerson))*

    ---

9. Select **Confirm**.

<h2>Next steps</h2>

* [Configure Authentication](configure-authentication.md)
* [Configure JVM Trust for SSL/TLS Certificates](../../configuration/ssl/configure-ssl-jvm.md)