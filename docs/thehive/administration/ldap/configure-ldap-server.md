# How to Configure an LDAP Server

<!-- md:license Platinum -->

This topic provides step-by-step instructions for configuring an [Lightweight Directory Access Protocol (LDAP) server](about-ldap.md) in TheHive, including Microsoft’s Active Directory (AD).

Use this procedure to synchronize your local TheHive database with LDAP, enabling automatic user account creation, deletion, and assignment to [organizations](../organizations/about-organizations.md) and [permission profiles](../profiles/about-profiles.md) within TheHive.

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

    Example: `ldap.domain.local`

    **- auth-Use SSL \***

    Turn on this toggle to use SSL/TLS encryption when connecting to the LDAP server for secure communication.

    **- DN of the service account \***

    The Distinguished Name (DN) of the LDAP user account used by TheHive to bind to the LDAP server.

    Example: `cn=thehive,ou=users,dc=domain,dc=local`

    **- Bind password \***

    The password associated with the service account used for binding to the LDAP server.

    **- Users base DN \***

    The starting point in the LDAP directory tree from which user searches begins.

    Example: `ou=users,dc=domain,dc=local`

    **- Filter used to search users**

    The LDAP search filter used to find user entries within the directory.

    Example: `(objectClass=user)`

    **- Search scope**

    Defines how deep the LDAP search should go from the base DN.

    Typical options include `base`, `onelevel`, or `subtree`.

    **- Page size**

    The number of entries retrieved per page during LDAP queries, useful for handling large directories efficiently.

5. Enter the following information under the **Map of LDAP attributes** section:

    **- Login \***

    **- Name \***

    **- Member of \***

    **- Email**

    **- Locked**

    **- API key**

    **- TOTP secret**

    **- Type**

<h2>Next steps</h2>


## User synchronisation
Users can be provisionned and deprovisionned automatically based on the content of a directory.
Users data is synchronised periodically. New users in LDAP are created in TheHive, removed users are disabled.

The organization membership and the profile of an user are set using LDAP groups. The configuration contain the mapping of LDAP groups with organization/profile.

User data is synchronized periodically to:

    * Automatically create new LDAP users in TheHive
    * Automatically deactivate in TheHive removed LDAP users
    * Organization membership and user profiles are assigned based on LDAP group membership.

    The configuration must include a mapping of LDAP groups to corresponding organizations and profiles.


![LDAP synchronisation configuration page](../images/administration-guides/auth_ldap_sync.png)