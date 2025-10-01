# Configure a Local Authentication Provider

Configure a local authentication provider in TheHive.

By default, TheHive manages authentication with its own local database, where usernames and passwords are stored directly in the application.

{% include-markdown "includes/access-authentication.md" %}

<h2>Procedure</h2>

{% include-markdown "includes/prerequisites-authentication-providers.md" %}

1. {% include-markdown "includes/platform-management-view-go-to.md" %}

2. {% include-markdown "includes/authentication-tab-go-to.md" %}

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

* [Configure Authentication](configure-authentication.md)