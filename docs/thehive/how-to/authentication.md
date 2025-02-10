---
hide:
  - navigation
---

# Authentication

TheHive supports several authentication providers:

- local (credential are securely stored in TheHive database)
- directory (LDAP and Active Directory)
- OAuth2/OpenID-Connect
- SAML
- based on HTTP header to delegate authentication to reverse proxy

![Authentication main page](../images/how-to/authentication/auth_main_page.png)

Multi-factor authentication can be enabled to enforce security on user authentication.

Several authentication providers can be enable. Each of them is check sequentially (order is important).

## Active Directory
![Active Directory configuration page](../images/how-to/authentication/auth_ad.png)

## LDAP
![LDAP configuration page](../images/how-to/authentication/auth_ldap.png)

## OAuth2 / OpenID-Connect
![OAuth2 configuration page](../images/how-to/authentication/auth_oauth2.png)

## SAML
![SAML configuration page](../images/how-to/authentication/auth_saml.png)

## User synchronisation
The user can be provisionned and deprovisionned automatically based on the content of a directory.
The user data are synchronised periodically. New users in LDAP are created in TheHive, removed users are disabled.

The organization membership and the profile of an user are set using LDAP groups. The configuration contain the mapping of LDAP groups with organization/profile.
![LDAP synchronisation configuration page](../images/how-to/authentication/auth_ldap_sync.png)