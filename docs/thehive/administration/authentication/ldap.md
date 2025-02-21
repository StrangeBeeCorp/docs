# How to Configure LDAP Authentication

This topic provides step-by-step instructions for configuring LDAP authentication in TheHive.

{!includes/license-required-authentication.md!}

{!includes/access-authentication.md!}

## Procedure

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/authentication-tab-go-to.md!}

3. Select **Directories authentication** in the **Authentication providers** section.

4. Turn on the **Enable directory** toggle.

5. Select **ldap** from the dropdown list.

## Next steps


4. Confirm and save your changes
5. move the _Directories Authentication_ line to be the first provider to use in the list of authentication providers

!!! Tip "Using SSL with LDAP"
    To setup a custom Certificate Authority in TheHive, please refer to [this guide](../../configuration/ssl.md#use-custom-certificate-authorities).


## Authenticating with LDAP
Users able to authenticate should already have an account created in TheHive local database.