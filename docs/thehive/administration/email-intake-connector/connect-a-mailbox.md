# Connect a Mailbox

<!-- md:permission `[admin] managePlatform` --> <!-- md:license Gold --> <!-- md:license Platinum -->

This topic provides step-by-step instructions for connecting a [mailbox](about-email-intake-connectors.md) in TheHive.

Use this procedure if your organization receives alerts via email and you want to automatically convert them into alerts within TheHive.

<h2>Procedure</h2>

1. {% include-markdown "includes/platform-management-view-go-to.md" %}

    ---

2. {% include-markdown "includes/connectors-tab-go-to.md" %}

    ---

3. {% include-markdown "includes/email-intake-tab-go-to.md" %}

    ---

4. Enter the time interval between refresh attempts. This setting applies to all connected mailboxes.

    !!! info "Manual refresh"
        If needed, you can also [manually trigger an email fetch](fetch-emails.md) for a mailbox.

    ---

5. Select :fontawesome-solid-plus:.

    ---

6. Configure your email intake connector by following these steps. IMAP configuration is required if your email provider is neither Google nor Microsoft.

    === "Google Workspace"
    
        <!-- md:license Platinum -->

        !!! warning "Prerequisites"
            You must have administrator access to the Google Cloud Console, with the necessary permissions to create projects and configure OAuth 2.0 credentials.

        #### Step 1: Create a project in the Google Cloud Console

        1. Go to the [Google Admin Console](https://console.cloud.google.com/welcome){target=_blank}.

        2. Select **APIs & Services**.

            ![Google Cloud Console APIs and services](/thehive/images/administration-guides/google-cloud-console-apis-services.png)

        3. Select **Create project**.

            ![Google Cloud Console Create project](/thehive/images/administration-guides/google-cloud-platform-create-project.png)

        4. Enter a name for the project, an organization, and a location.

        5. Select **Create**.

        #### Step 2: Configure OAuth consent

        6. Select **OAuth consent screen** from the left pane.

            ![OAuth consent screen](/thehive/images/administration-guides/google-cloud-platform-oauth-consent-screen.png)

        7. Select **Get started** to configure Google Auth Platform.

            ![Google Auth Platform](/thehive/images/administration-guides/google-cloud-platform-get-started.png)

        8. In the **App information** section, enter information about your application.

        9. In the **Audience** section, select *Internal*.

        10. In the **Contact information** section, enter the email address that will receive any updates related to the project.

        11. Select **Create**.

        #### Step 3: Add a scope in the Google Auth Platform

        12. Select **Data access** from the left pane.

            ![Google Auth Platform Data access](/thehive/images/administration-guides/google-auth-platform-data-access.png)

        13. Select **Add or remove scopes**.

            ![Google Auth Platform Add remove scopes](/thehive/images/administration-guides/google-auth-platform-add-remove-scopes.png)

        14. In the **Manually add scopes** section, enter *https://mail.google.com/*.

        15. Select **Add to table**.

        16. Make sure the new scope is selected, then select **Update**.

        17. Make sure the scope is added to the **Your restricted scopes** section, then select *Save*.

        #### Step 4: Create OAuth credentials

        18. Enter *credentials* in the search bar at the top of the screen.

        19. Select **Credentials** from the APIs & Services results.

        20. Select **Create credentials**, then **OAuth Client ID**.

            ![Google Cloud Platform Add credentials](/thehive/images/administration-guides/google-cloud-platform-credentials-oauthclientid.png)
        
        21. Select *Web application* as the application type.

        22. Enter an internal name for the OAuth 2.0 client.

        23. Select **Add URI** in the **Authorized JavaScript origins** section.

        24. Enter a URI following this format: https://<your-thehive-instance-fqdn>.org.

        25. Enter the same URI in the **Authorized redirect URIs** section.

        26. Select **Create**.

        27. Copy the Client ID and Client Secret values from the dialog for use in TheHive configuration.

        #### Step 5: Configure the email intake connector in TheHive

        28. Return to your TheHive application.

        29. In the **Provider** section, enter the following information:

            **- Name**

            A name for your connector.

            **- Provider**

            Select **Google Workspace** from the dropdown.

        30. In the **Authentication** section, enter the following information:

            **- Email**

            The email address associated with your account.

            **- ClientId**

            Paste the Client ID value you obtained from Google.

            **- Secret**

            Paste the Client Secret value you obtained from Google.

        Then, select **Connect** to authorize TheHive to access your Google Workspace account for use with the application.

    === "Microsoft 365"
        <!-- md:license Platinum -->
        !!! warning "Prerequisites"
            You must have:

            * Administrator access to Microsoft 365
            * PowerShell installed and properly configured
            * A shared mailbox already created in Microsoft 365

        #### Step 1: Create a mail-enabled security group

        Create a security group that includes the shared mailbox. This group will be used to restrict access to the application, ensuring it is available only to the shared mailbox.

        31. Go to your [Microsoft Exchange admin center](https://admin.exchange.microsoft.com/){target=_blank}.

        32. Follow the [Microsoft instructions to create a mail-enabled security group and add the shared mailbox as a member](https://learn.microsoft.com/en-us/exchange/recipients-in-exchange-online/manage-mail-enabled-security-groups#use-the-eac-to-create-a-mail-enabled-security-group){target=_blank}.

        #### Step 2: Register a new application

        33. Follow [the Microsoft instructions to register an application](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=certificate%2Cexpose-a-web-api#register-an-application){target=_blank}.

        34. Copy the Application (client) ID and Directory (tenant) ID for use in TheHive configuration.

        #### Step 3: Add a secret

        35. Select **Certificates & secrets** from the left pane.

        36. Follow [the Microsoft instructions to add a client secret](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=client-secret%2Cexpose-a-web-api#add-credentials){target=_blank}.

        37. Copy the secret's value for use in TheHive configuration.

            !!! warning "One-time display"
                This secret value is never displayed again after you leave this page.
        
        #### Step 4: Assign API permissions

        38. Select **API permissions** from the left pane.

        39. Follow [the Microsoft instructions and add the *IMAP.AccessAsApp* permission for Office 365 Exchange Online](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-configure-app-access-web-apis#add-permissions-to-access-your-web-api){target=_blank}.

        #### Step 5: Configure PowerShell access

        40. Define the necessary values for the configuration:

            ```powershell
            $AppID = '{ClientID}'
            $TenantID = '{TenantID}'
            $ObjectID = '{ObjectID}'
            $SecurityGroup = '{SecurityGroup}'  # The mail-enabled security group
            $MailBox = '{MailBox}'  # The shared mailbox
            ```

        41. Run the following PowerShell commands to configure access.

            a. Define app permissions:

            ```powershell
            New-ServicePrincipal -AppId $AppID -ServiceId $ObjectID
            ```

            b. Grant security group full access to the mailbox:

            ```powershell
            Add-MailboxPermission -Identity $MailBox -User $SecurityGroup -AccessRights FullAccess
            ```

            c. Restrict access to members of the security group only:

            ```powershell
            New-ApplicationAccessPolicy -AppId $AppID -PolicyScopeGroupId $SecurityGroup -AccessRight RestrictAccess -Description "Restrict this app to members of distribution group {$SecurityGroup}"
            ```

        42. Test the configuration.

            a. Run the following command to test if the application access policy is properly configured:

            ```powershell
            Test-ApplicationAccessPolicy -AppId $AppID -Identity $MailBox
            ```

            b. The expected output should be similar to:

            ```
            AppId             : 9367xxxx
            Mailbox           : test-shared-mailbox20231107190659
            AccessCheckResult : Granted
            ```

            c. Running the command with a different mailbox should return `AccessCheckResult: Denied`.

        #### Step 6: Configure the email intake connector in TheHive

        43. Return to your TheHive application.

        44. In the **Provider** section, enter the following information:

            **- Name**

            A name for your connector.

            **- Provider**

            Select **Microsoft 365** from the dropdown.

        45. In the **Authentication** section, enter the following information:

            **- Email**

            The email address associated with your account.

            **- TenantId**

            Paste the Tenant ID value you obtained from Microsoft.

            **- ClientId**

            Paste the Client ID value you obtained from Microsoft.

            **- Secret**

            Paste the Client Secret value you obtained from Microsoft.

        Then, select **Connect** to authorize TheHive to access your Microsoft 365 account for use with the application.

    === "Microsoft Graph API"

        <!-- md:version 5.5 --> <!-- md:license Platinum -->

        Microsoft Graph API is the recommended standard API for all interactions with Microsoft services.

        !!! warning "Prerequisites"
            You must have:

            * Administrator access to Microsoft 365
            * PowerShell installed and properly configured
            * A shared mailbox already created in Microsoft 365

        #### Step 1: Create a mail-enabled security group

        Create a security group that includes the shared mailbox. This group will be used to restrict access to the application, ensuring it is available only to the shared mailbox.

        46. Go to your [Microsoft Exchange admin center](https://admin.exchange.microsoft.com/){target=_blank}.

        47. Follow the [Microsoft instructions to create a mail-enabled security group and add the shared mailbox as a member](https://learn.microsoft.com/en-us/exchange/recipients-in-exchange-online/manage-mail-enabled-security-groups#use-the-eac-to-create-a-mail-enabled-security-group){target=_blank}.

        #### Step 2: Register a new application

        48. Follow [the Microsoft instructions to register an application](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=certificate%2Cexpose-a-web-api#register-an-application){target=_blank}.

        49. Copy the Application (client) ID and Directory (tenant) ID for use in TheHive configuration.

        #### Step 3: Add a secret

        50. Select **Certificates & secrets** from the left pane.

        51. Follow [the Microsoft instructions to add a client secret](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=client-secret%2Cexpose-a-web-api#add-credentials){target=_blank}.

        52. Copy the secret's value for use in TheHive configuration.

            !!! warning "One-time display"
                This secret value is never displayed again after you leave this page.
        
        #### Step 4: Assign API permissions

        53. Select **API permissions** from the left pane.

        54. Follow [the Microsoft instructions to add the relevant permissions](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-configure-app-access-web-apis#add-permissions-to-access-microsoft-graph){target=_blank}.

            !!! tip "Recommanded permissions"
                For Microsoft Graph to work correctly with TheHive, ensure that the following permissions are added:

                * [Mail.Read](https://learn.microsoft.com/en-us/graph/permissions-reference#mailread){target=_blank}
                * [Mail.ReadBasic](https://learn.microsoft.com/en-us/graph/permissions-reference#mailreadbasic){target=_blank}
                * [Mail.ReadBasic.All](https://learn.microsoft.com/en-us/graph/permissions-reference#mailreadbasicall){target=_blank}
                * [Mail.ReadWrite](https://learn.microsoft.com/en-us/graph/permissions-reference#mailreadwrite){target=_blank}
                * [MailboxFolder.Read.All](https://learn.microsoft.com/en-us/graph/permissions-reference#mailboxfolderreadall){target=_blank}
                * [User.Read.All](https://learn.microsoft.com/en-us/graph/permissions-reference#userreadall){target=_blank}
                * [User.ReadBasic.All](https://learn.microsoft.com/en-us/graph/permissions-reference#userreadbasicall){target=_blank}
                * [User.ReadWrite.All](https://learn.microsoft.com/en-us/graph/permissions-reference#userreadwriteall){target=_blank}
                * [UserAuthenticationMethod.Read.All](https://learn.microsoft.com/en-us/graph/permissions-reference#userauthenticationmethodreadall){target=_blank}
                * [UserAuthenticationMethod.ReadWrite.All](https://learn.microsoft.com/en-us/graph/permissions-reference#userauthenticationmethodreadwriteall){target=_blank}

        #### Step 5: Configure PowerShell access

        55. Define the necessary values for the configuration:

            ```powershell
            $AppID = '{ClientID}'
            $TenantID = '{TenantID}'
            $ObjectID = '{ObjectID}'
            $SecurityGroup = '{SecurityGroup}'  # The mail-enabled security group
            $MailBox = '{MailBox}'  # The shared mailbox
            ```

        56. Run the following PowerShell commands to configure access.

            a. Define app permissions:

            ```powershell
            New-ServicePrincipal -AppId $AppID -ServiceId $ObjectID
            ```

            b. Grant security group full access to the mailbox:

            ```powershell
            Add-MailboxPermission -Identity $MailBox -User $SecurityGroup -AccessRights FullAccess
            ```

            c. Restrict access to members of the security group only:

            ```powershell
            New-ApplicationAccessPolicy -AppId $AppID -PolicyScopeGroupId $SecurityGroup -AccessRight RestrictAccess -Description "Restrict this app to members of distribution group {$SecurityGroup}"
            ```

        57. Test the configuration.

            a. Run the following command to test if the application access policy is properly configured:

            ```powershell
            Test-ApplicationAccessPolicy -AppId $AppID -Identity $MailBox
            ```

            b. The expected output should be similar to:

            ```
            AppId             : 9367xxxx
            Mailbox           : test-shared-mailbox20231107190659
            AccessCheckResult : Granted
            ```

            c. Running the command with a different mailbox should return `AccessCheckResult: Denied`.

        #### Step 6: Configure the email intake connector in TheHive

        58. Return to your TheHive application.

        59. In the **Provider** section, enter the following information:

            **- Name**

            A name for your connector.

            **- Provider**

            Select **Microsoft 365 GraphAPI** from the dropdown.

        60. In the **Authentication** section, enter the following information:

            **- Email**

            The email address associated with your account.

            **- TenantId**

            Paste the Tenant ID value you obtained from Microsoft.

            **- ClientId**

            Paste the Client ID value you obtained from Microsoft.

            **- Secret**

            Paste the Client Secret value you obtained from Microsoft.

        Then, select **Connect** to authorize TheHive to access your Microsoft 365 account for use with the application.

    === "IMAP server"
    
        <!-- md:license Gold --> <!-- md:license Platinum -->

        61. In the **Provider** section, enter the following information:

            **- Name**

            A name for your connector.

            **- Provider**

            Select **IMAP server** from the dropdown.

            **- Host**

            The host address of the IMAP server.

            **- Port**

            The port number of the IMAP server.

        62. Add a certificate authority (CA).

            The server's SSL/TLS certificate must be trusted by the Java virtual machine (JVM) truststore for secure connections. If your server uses a certificate from an internal CA or self-signed certificate, add it to the JVM truststore first. See [Configure JVM Trust for SSL/TLS Certificates](../../configuration/ssl/configure-ssl-jvm.md) for instructions.

            You can turn off the **Don't check certificate authority** toggle to bypass certificate validation, but this isn't recommended as it may compromise connection security.

        63. Turn on the **Disable host name verification** toggle if you want to bypass the verification of the server's host name against the certificate.

        64. In the **Authentication** section, enter the following information:

            **- Login**

            The email address or account username associated with your account.

            **- Password**

            The password associated with your account.

    ---

7. In the **Settings** section, enter the following information:

    **- Organization**

    The TheHive organization where the alerts are sent.

    **- Folder**

    The folder from which emails are fetched.

    **- Action in mailbox**

    The action to perform in the mailbox when receiving an email.

    ---

8. <!-- md:version 5.5 --> In the **Alert properties** section, enter the following information:

    **- Type**

    The type of the alerts created through the email intake connector.

    **- Source**

    The source of the alerts created through the email intake connector.

    **- [Tags](../../user-guides/analyst-corner/cases/tags/about-tags.md)**

    The tags to apply to the alerts created through the email intake connector.

    ---

9. Select **Test connection** to verify your connection.

    ---

10. Select **Confirm**.

<h2>Next steps</h2>

* [Delete a Mailbox Connection](delete-a-mailbox-connection.md)
* [Manually Trigger Email Fetch in a Mailbox](fetch-emails.md)