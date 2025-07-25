# Configure a Local Authentication Provider

This topic provides step-by-step instructions for configuring a local authentication provider in TheHive.

This is the default behavior of TheHive. The application stores usernames and passwords in a local database managed by TheHive.

{!includes/access-authentication.md!}

<h2>Procedure</h2>

{!includes/prerequisites-authentication-providers.md!}

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/authentication-tab-go-to.md!}

3. Select **Local authentication** in the **Authentication providers** section.

4. In the **Local authentication** drawer, enter:

    * The number of failed authentication attempts before temporarily blocking the user
    * The duration for automatic user unblocking

5. To define a password policy, enable the **Enabled password policy** toggle and enter the following password requirements:

    * Minimum length
    * Minimum number of lowercase characters
    * Minimum number of uppercase characters
    * Minimum number of digits
    * Minimum number of special characters

6. To prevent users from using their login as a password, enable the **Disallow using usernames as passwords** toggle.

<h2>Next steps</h2>

* [How to Configure Authentication](configure-authentication.md)