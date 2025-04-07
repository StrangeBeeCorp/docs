# How to Connect a Mailbox

This topic provides step-by-step instructions for connecting a [mailbox](about-email-intake-connectors.md) in TheHive.

{!includes/administrator-access-manage-email-intake-connectors.md!}

<h2>Procedure</h2>

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/connectors-tab-go-to.md!}

3. {!includes/email-intake-tab-go-to.md!}

4. Enter the time interval between refresh attempts. This setting applies to all connected mailboxes.

    !!! info "Manual refresh"
        If needed, you can also [manually trigger an email fetch](fetch-emails.md) for a mailbox. 

5. Select :fontawesome-solid-plus: to create a new connection, or select :fontawesome-solid-ellipsis: next a connector and select **Edit**.

6. Configure your email intake connector by following these steps. IMAP configuration is required if your email provider is neither Google nor Microsoft.

    === "Google Workspace"
    
        <!-- md:license Platinum -->

        !!! warning "Prerequisites"
            You must have administrator access to the Google Cloud Console, with the necessary permissions to create projects and configure OAuth 2.0 credentials.

        ### Step 1: Create a project in the Google Cloud Console

        1. Go to the [Google Admin Console](https://console.cloud.google.com/welcome).

        2. Select **APIs & Services**.

            ![Google Cloud Console APIs and services](/thehive/images/administration-guides/google-cloud-console-apis-services.png)

        3. Select **Create project**.

            ![Google Cloud Console Create project](/thehive/images/administration-guides/google-cloud-platform-create-project.png)

        4. Enter a name for the project, an organization, and a location.

        5. Select **Create**.

        ### Step 2: Configure OAuth consent

        1. Select **OAuth consent screen** from the left pane.

            ![OAuth consent screen](/thehive/images/administration-guides/google-cloud-platform-oauth-consent-screen.png)

        2. Select **Get started** to configure Google Auth Platform.

            ![Google Auth Platform](/thehive/images/administration-guides/google-cloud-platform-get-started.png)

        3. In the **App information** section, enter information about your application.

        4. In the **Audience** section, select *Internal*.

        5. In the **Contact information** section, enter the email address that will receive any updates related to the project.

        6. Select **Create**.

        ### Step 3: Add a scope in the Google Auth Platform

        1. Select **Data access** from the left pane.

            ![Google Auth Platform Data access](/thehive/images/administration-guides/google-auth-platform-data-access.png)

        2. Select **Add or remove scopes**.

            ![Google Auth Platform Add remove scopes](/thehive/images/administration-guides/google-auth-platform-add-remove-scopes.png)

        3. In the **Manually add scopes** section, enter *https://mail.google.com/*.

        4. Select **Add to table**.

        5. Make sure the new scope is selected, then select **Update**.

        6. Make sure the scope is added to the **Your restricted scopes** section, then select *Save*.

        ### Step 4: Create OAuth credentials

        1. Enter *credentials* in the search bar at the top of the screen.

        2. Select **Credentials** from the APIs & Services results.

        3. Select **Create credentials**, then **OAuth Client ID**.

            ![Google Cloud Platform Add credentials](/thehive/images/administration-guides/google-cloud-platform-credentials-oauthclientid.png)
        
        4. Select *Web application* as the application type.

        5. Enter an internal name for the OAuth 2.0 client.

        6. Select **Add URI** in the **Authorized JavaScript origins** section.

        8. Enter a URI following this format: https://<your-thehive-instance-fqdn>.org.

        9. Enter the same URI in the **Authorized redirect URIs** section.

        10. Select **Create**.

        11. Copy the Client ID and Client Secret values from the dialog for use in TheHive configuration.

        ### Step 5: Configure the email intake connector in TheHive

        1. Return to your TheHive application.

        2. In the **Provider** section, enter the following information:

            **- Name**

            A name for your connector.

            **- Provider**

            Select *Google Workspace* from the dropdown.

        3. In the **Authentication** section, enter the following information:

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
            - Administrator access to Microsoft 365.  
            - PowerShell installed and properly configured.  
            - A shared mailbox already created in Microsoft 365.

        ### Step 1: Create a mail-enabled security group

        Create a security group that includes the shared mailbox. This group will be used to restrict access to the application, ensuring it is available only to the shared mailbox.

        1. Go to your [Microsoft Exchange admin center](https://admin.exchange.microsoft.com/).

        2. Follow the [Microsoft instructions to create a mail-enabled security group and add the shared mailbox as a member](https://learn.microsoft.com/en-us/exchange/recipients-in-exchange-online/manage-mail-enabled-security-groups#use-the-eac-to-create-a-mail-enabled-security-group).

        ### Step 2: Register a new application

        1. Follow [the Microsoft instructions to register an application](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=certificate%2Cexpose-a-web-api#register-an-application).

        2. Copy the Application (client) ID and Directory (tenant) ID for use in TheHive configuration.

        ### Step 3: Add a secret

        1. Select **Certificates & secrets** from the left pane.

        2. Follow [the Microsoft instructions to add a client secret](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=client-secret%2Cexpose-a-web-api#add-credentials).

        3. Copy the secret's value for use in TheHive configuration.

            !!! warning "One-time display"
                This secret value is never displayed again after you leave this page.
        
        ### Step 4: Assign API permissions

        1. Select **API permissions** from the left pane.

        2. Follow [the Microsoft instructions and add the *IMAP.AccessAsApp* permission for Office 365 Exchange Online](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-configure-app-access-web-apis#add-permissions-to-access-your-web-api).

        ### Step 5: Configure PowerShell access

        1. Define the necessary values for the configuration:

            ```powershell
            $AppID = '{ClientID}'
            $TenantID = '{TenantID}'
            $ObjectID = '{ObjectID}'
            $SecurityGroup = '{SecurityGroup}'  # The mail-enabled security group
            $MailBox = '{MailBox}'  # The shared mailbox
            ```

        2. Run the following PowerShell commands to configure access.

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

        3. Test the configuration.

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

        ### Step 6: Configure the email intake connector in TheHive

        1. Return to your TheHive application.

        2. In the **Provider** section, enter the following information:

            **- Name**

            A name for your connector.

            **- Provider**

            Select *Microsoft 365* from the dropdown.

        3. In the **Authentication** section, enter the following information:

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
            - Administrator access to Microsoft 365.  
            - PowerShell installed and properly configured.  
            - A shared mailbox already created in Microsoft 365.

        ### Step 1: Create a mail-enabled security group

        Create a security group that includes the shared mailbox. This group will be used to restrict access to the application, ensuring it is available only to the shared mailbox.

        1. Go to your [Microsoft Exchange admin center](https://admin.exchange.microsoft.com/).

        2. Follow the [Microsoft instructions to create a mail-enabled security group and add the shared mailbox as a member](https://learn.microsoft.com/en-us/exchange/recipients-in-exchange-online/manage-mail-enabled-security-groups#use-the-eac-to-create-a-mail-enabled-security-group).

        ### Step 2: Register a new application

        1. Follow [the Microsoft instructions to register an application](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=certificate%2Cexpose-a-web-api#register-an-application).

        2. Copy the Application (client) ID and Directory (tenant) ID for use in TheHive configuration.

        ### Step 3: Add a secret

        1. Select **Certificates & secrets** from the left pane.

        2. Follow [the Microsoft instructions to add a client secret](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=client-secret%2Cexpose-a-web-api#add-credentials).

        3. Copy the secret's value for use in TheHive configuration.

            !!! warning "One-time display"
                This secret value is never displayed again after you leave this page.
        
        ### Step 4: Assign API permissions

        1. Select **API permissions** from the left pane.

        2. Follow [the Microsoft instructions and add the *IMAP.AccessAsApp* permission](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-configure-app-access-web-apis#add-permissions-to-access-microsoft-graph).

        ### Step 5: Configure PowerShell access

        1. Define the necessary values for the configuration:

            ```powershell
            $AppID = '{ClientID}'
            $TenantID = '{TenantID}'
            $ObjectID = '{ObjectID}'
            $SecurityGroup = '{SecurityGroup}'  # The mail-enabled security group
            $MailBox = '{MailBox}'  # The shared mailbox
            ```

        2. Run the following PowerShell commands to configure access.

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

        3. Test the configuration.

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

        ### Step 6: Configure the email intake connector in TheHive

        1. Return to your TheHive application.

        2. In the **Provider** section, enter the following information:

            **- Name**

            A name for your connector.

            **- Provider**

            Select *Microsoft 365 GraphAPI* from the dropdown.

        3. In the **Authentication** section, enter the following information:

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

        1. In the **Provider** section, enter the following information:

            **- Name**

            A name for your connector.

            **- Provider**

            Select *IMAP server* from the dropdown.

            **- Host**

            The host address of the IMAP server.

            **- Port**

            The port number of the IMAP server.

        2. Add a certificate authority.

            For more information about configuring SSL, refer to the [Configure SSL](/thehive/administration/authentication/ssl/) topic.

            Use certificates only from trusted, predefined authorities for secure connections. Custom certificate authorities are not allowed.

            You can turn off the **Don't check certificate authority** toggle to bypass certificate validation, but this isn't recommended as it may compromise connection security.

        3. Turn on the **Disable host name verification** toggle if you want to bypass the verification of the server's host name against the certificate.

        4. In the **Authentication** section, enter the following information:

            **- Email**

            The email address associated with your account.

            **- Password**

            The password associated with your account.

7. In the **Settings** section, enter the following information:

    **- Organization**

    The TheHive organization where the alerts are sent.

    **- Folder**

    The folder from which emails are fetched.

    **- Action in mailbox**

    The action to perform in the mailbox when receiving an email.

8. <!-- md:version 5.5 --> In the **Alert properties** section, enter the following information:

    **- Type**

    The type of the alerts created through the email intake connector.

    **- Source**

    The source of the alerts created through the email intake connector.

    **- [Tags](../../user-guides/analyst-corner/cases/tags/about-tags.md)**

    The tags to apply to the alerts created through the email intake connector.

9. Select **Test connection** to verify your connection.

10. Select **Confirm**.

<h2>Next steps</h2>

* [Delete a Mailbox Connection](delete-a-mailbox-connection.md)
* [Manually Trigger Email Fetch in a Mailbox](fetch-emails.md)