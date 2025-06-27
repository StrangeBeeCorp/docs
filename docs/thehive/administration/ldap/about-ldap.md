# About LDAP

This topic explains what Lightweight Directory Access Protocol (LDAP) is and how it's used in TheHive.

## What is LDAP

Lightweight Directory Access Protocol (LDAP) is a standard protocol used to access and manage directory information services over a network. It is commonly used for centralized authentication and user management.

Active Directory (AD) is Microsoft’s implementation of directory services that uses LDAP as one of its core protocols, providing a comprehensive solution for identity and access management in Windows environments.

## Benefits of using an LDAP server

Using an LDAP server:

* Enables centralized and scalable user authentication and authorization
* Simplifies user management by syncing accounts and permissions from a single source
* Supports integration with existing directory services like Microsoft Active Directory (AD)

## LDAP server usage in TheHive

[Configure an LDAP server](configure-ldap-server.md) in TheHive to enable:

* Automatic user account creation, deletion, and updates synchronized from LDAP
* Assignment of user accounts to organizations and permission profiles

[Configure an LDAP authentication provider](../authentication/ldap.md) or [an AD authentication provider](../authentication/ad.md) to enable user authentication based on their LDAP credentials.

## Permissions

{!includes/administrator-access-configure-ldap.md!}

<h2>Next steps</h2>

* [Configure an LDAP server](configure-ldap-server.md)
* [Configure an LDAP authentication provider](../authentication/ldap.md)
* [Configure an AD authentication provider](../authentication/ad.md)