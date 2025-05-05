# How to Create a User Account

This topic provides step-by-step instructions for creating a [user account](about-user-accounts.md) in TheHive.

To add an existing user account to an organization, see [Add or Remove an Existing User Account from an Organization](../../../../administration/organizations/add-remove-an-existing-user-account-from-an-organization.md).

{!includes/license-user-accounts.md!}

## Create a user account for an organization

### As an administrator

{!includes/administrator-access-manage-user-accounts.md!}

1. {!includes/organizations-view-go-to.md!}

    ---

2. Select the organization to add the user account to, then select :fontawesome-solid-plus:. Alternatively, hover over the organization, select :fontawesome-solid-eye:, and select **Add** in the **Users** section.

    ---

3. In the **Adding a user** drawer, enter:

    **- Type \***

    The user account type you want to create.

    Pick an option from the dropdown list:   
        - *Normal*: Intended for users who access TheHive through the web interface. Normal accounts support all authentication methods. These accounts can also generate API keys if enabled.  
        - *Service*: Designed for programmatic access to TheHive via the API. Service accounts authenticate exclusively using an API key and can't sign in to the web interface.

    **- Login \***

    The login used for the user to sign in. It can be an email address or another identifier, depending on [your authentication configuration](../../../../administration/authentication/configure-authentication.md).

    **- Name \***

    The user account's display name.

    **- Profile \***

    Select a [permission profile](../../../../administration/profiles.md) for the user account from the dropdown list.

    ---

{!includes/create-a-user-account.md!}

### As an organization administrator

{!includes/access-manage-user-accounts.md!}

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/users-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-plus:.

    ---

4. In the **Adding a user** drawer, enter:

    **- Type \***

    The user account type you want to create.

    Pick an option from the dropdown list:   
        - *Normal*: Intended for users who access TheHive through the web interface. Normal accounts support all authentication methods. These accounts can also generate API keys if enabled.  
        - *Service*: Designed for programmatic access to TheHive via the API. Service accounts authenticate exclusively using an API key and can't sign in to the web interface.

    **- Login \***

    The login used for the user to sign in. It can be an email address or another identifier, depending on [your authentication configuration](../../../../administration/authentication/configure-authentication.md).

    **- Name \***

    The user account's display name.

    **- Profile \***

    Select a [permission profile](../../../../administration/profiles.md) for the user account from the dropdown list.

    ---

{!includes/create-a-user-account.md!}

## Create a user account for multiple organizations

{!includes/administrator-access-manage-user-accounts.md!}

1. {!includes/users-view-go-to.md!}

    ---

2. Select :fontawesome-solid-plus:.

    ---

3. In the **Adding a user** drawer, enter:

    **- Type \***

    The user account type you want to create.

    Pick an option from the dropdown list:   
        - *Normal*: Intended for users who access TheHive through the web interface. Normal accounts support all authentication methods. These accounts can also generate API keys if enabled.  
        - *Service*: Designed for programmatic access to TheHive via the API. Service accounts authenticate exclusively using an API key and can't sign in to the web interface.

    **- Login \***

    The login used for the user to sign in. It can be an email address or another identifier, depending on [your authentication configuration](../../../../administration/authentication/configure-authentication.md).

    **- Name \***

    The user account's display name.

    **- Organizations \***

    Select one or more organizations to assign to the user account. To set the default organization the user accesses when signing in to TheHive, select **Set as default**.

    For each organization, select a [permission profile](../../../../administration/profiles.md) for the user account from the dropdown list.

    <!-- md:version 5.4.3 --> Profiles that require a Gold or Platinum license are labeled *License required*.

    ---

{!includes/create-a-user-account.md!}

<h2>Next steps</h2>

* [Delete a User Account](delete-a-user-account.md)
* [Lock a User Account](lock-a-user-account.md)
* [Export a List of User Accounts](export-list-user-accounts.md)
* [Manage User Accounts](manage-user-accounts.md)
* [Add or Remove an Existing User Account from an Organization](../../../../administration/organizations/add-remove-an-existing-user-account-from-an-organization.md)