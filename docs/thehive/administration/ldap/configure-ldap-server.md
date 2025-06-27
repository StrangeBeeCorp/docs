# How to Configure an LDAP Server

<!-- md:license Platinum -->

This topic provides step-by-step instructions for configuring an [Lightweight Directory Access Protocol (LDAP) server](about-ldap.md) in TheHive, including Microsoft’s Active Directory (AD).

Use this procedure to periodically synchronize your local TheHive database with LDAP, enabling automatic user account creation, updates, deletion, and assignment to [organizations](../organizations/about-organizations.md) and [permission profiles](../profiles/about-profiles.md) within TheHive.

{!includes/administrator-access-configure-ldap.md!}

<h2>Procedure</h2>

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/ldap-tab-go-to.md!}

3. Select :fontawesome-solid-plus: or **Add LDAP server**.

4. In the **LDAP configuration** drawer, enter the following information under the **General settings** section:

    **- Name of the configuration \***

    A descriptive name to identify this LDAP configuration within TheHive.

    **- Servers hostname or IP address \***

    The address of the LDAP server you want to connect to, either a hostname or an IP address.

    Example: *ldap.domain.local*

    **- Auth-Use SSL \***

    Turn on this toggle to use SSL/TLS encryption when connecting to the LDAP server for secure communication.

    **- DN of the service account \***

    The Distinguished Name (DN) of the LDAP user account used by TheHive to bind to the LDAP server.

    Example: *cn=thehive,ou=users,dc=domain,dc=local*

    **- Bind password \***

    The password associated with the service account used for binding to the LDAP server.

    **- Users base DN \***

    The starting point in the LDAP directory tree from which user searches begins.

    Example: *ou=users,dc=domain,dc=local*

    **- Filter used to search users**

    The LDAP search filter used to find user entries within the directory.

    Example: *(objectClass=user)*

    **- Search scope**

    Defines how deep the LDAP search should go from the base DN.

    Typical options include *base*, *onelevel*, or *subtree*.

    **- Page size**

    The number of entries retrieved per page during LDAP queries, useful for handling large directories efficiently.

5. Enter the following information under the **Map of LDAP attributes** section:

    **- Login \***

    The LDAP attribute that contains the user’s login name or username.

    Example: *uid*

    **- Name \***

    The LDAP attribute that contains the user’s full name.

    Example: *cn*

    **- Member of \***

    The LDAP attribute that lists the groups or roles the user belongs to, used to assign permission profiles and organizations in TheHive.

    Example: *memberOf*

    **- Email**

    The LDAP attribute holding the user’s email address.

    Example: *mail*

    **- Locked**

    The LDAP attribute that indicates whether the user account is locked.

    Example: *pwdAccountLockedTime*

    **- API key**

    The LDAP attribute used to store the user’s API key for TheHive authentication.

    **- TOTP secret**

    The LDAP attribute that holds the Time-Based One-Time Password (TOTP) secret for two-factor authentication (2FA).

    **- Type**

    The LDAP attribute indicating the [user account type](../../user-guides/organization/configure-organization/manage-user-accounts/about-user-accounts.md#types), which can be either *normal* or *service*.

6. Select **Add map group field** under the **Groups mapping** section.

7. Enter the following information:

    **- Group map**

    The LDAP attribute used to map groups to TheHive organizations and permission profiles.

    Example: *cn=soc,ou=groups,dc=domain,dc=local*

    **- Organization**

    The name of the organization in TheHive to which the LDAP group corresponds.

    Example: *SOC*

    **- Profile**

    The permission profile in TheHive assigned to user accounts belonging to the LDAP group.

    Example: *org-admin*

8. Select **Confirm**.

<h2>Next steps</h2>

* [Configure an LDAP Authentication Provider](../authentication/ldap.md)
* [Configure an AD Authentication Provider](../authentication/ad.md)