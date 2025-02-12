# Email Intake Connector

This documentation outlines the utilization of the Email Intake Connector for automatically generating alerts from a designated mailbox.

The Email Intake Connector facilitates the connection of mailboxes used to receive cybersecurity alerts. It automatically transforms new emails into alerts within TheHive platform. Presently, the primary function supported is the creation of alerts regardless of the received email content.


![](/thehive/images/administration-guides/eic-1.png)

---

## Configuration

### Global Configuration

The only parameter that requires adjustment is the `refresh interval`. By default, the connector polls mailboxes every *5* minutes. Adjust the frequency by increasing or decreasing the value.

![](/thehive/images/administration-guides/eic-2.png)

&nbsp;

### Adding a Mailbox

Configuration options are available for Microsoft 365 (OAuth2) and Google Workspace (OAuth2). If you use another email provider service, configuration through IMAP is necessary.

![](/thehive/images/administration-guides/eic-3.png)

&nbsp;

=== "Microsoft MS365"

    ### Setting up Microsoft365 for TheHive
     
    This section provides detailed instructions to configure Microsoft 365 to allow TheHive access to a shared mailbox. Please follow these steps to ensure proper integration.

    &nbsp;

    #### Prerequisites
    - Administrator account on Microsoft 365.
    - PowerShell installed and configured.
    - A shared mailbox already created in Microsoft 365 (e.g., `test-shared-mailbox@strangebee.com`).

        ![](/thehive/images/administration-guides/ms-intake-1.png){ width="600" }

    &nbsp;

    #### Step-by-Step Configuration

    1. **Create a Mail-Enabled Security Group**

        - Create a security group that includes the shared mailbox. This group will be used to restrict access to the application for the shared mailbox only.
        - Navigate to **Admin > Exchange Admin Center**, and create a **Mail-Enabled Security Group**.
        - Add the shared mailbox as a member of the security group.

        ![](/thehive/images/administration-guides/ms-intake-2.png)

    2. **Register a New Application in Microsoft Entra**

        - As an administrator, navigate to **Microsoft Entra admin center**.
        - Go to **Admin > Identity > Applications > App registrations**.

        ![](/thehive/images/administration-guides/ms-intake-3.png)
        

        -  Gather the following information:
            - **Tenant ID**
            - **Client ID (App ID)**
            - **Object ID** of the enterprise application

          ![](/thehive/images/administration-guides/ms-intake-4.png)

    3. **Create a Secret for the Application**

        - In the registered application page, go to **Certificates & Secrets**.
        - Create a new secret, which will be used as an OAuth2 input to authenticate the service.
        - Save the secret value securely for later use.

        ![](/thehive/images/administration-guides/ms-intake-5.png)

    4. **Assign API Permissions**

        - In the registered application page, go to **API Permissions**.
        - Ensure the application has the following permissions:
            - **Office 365 Exchange Online / IMAP.AccessAsApp**

        ![](/thehive/images/administration-guides/ms-intake-6.png)

    5. **Configure PowerShell Access**

        - Define the necessary values for the configuration:

            ```powershell
            $AppID = '{ClientID}'
            $TenantID = '{TenantID}'
            $ObjectID = '{ObjectID}'
            $SecurityGroup = '{SecurityGroup}'  # The mail-enabled security group
            $MailBox = '{MailBox}'  # The shared mailbox
            ```

        - Run the following PowerShell commands to configure access:

            - **Define App Permissions:**

            ```powershell
            New-ServicePrincipal -AppId $AppID -ServiceId $ObjectID
            ```

            - **Grant Security Group Full Access to the Mailbox:**

            ```powershell
            Add-MailboxPermission -Identity $MailBox -User $SecurityGroup -AccessRights FullAccess
            ```

            - **Restrict Access to Members of the Security Group Only:**

            ```powershell
            New-ApplicationAccessPolicy -AppId $AppID -PolicyScopeGroupId $SecurityGroup -AccessRight RestrictAccess -Description "Restrict this app to members of distribution group {$SecurityGroup}"
            ```

    6. **Test the Configuration**

        - Run the following command to test if the application access policy is properly configured:

            ```powershell
            Test-ApplicationAccessPolicy -AppId $AppID -Identity $MailBox
            ```

        - The expected output should be similar to:

            ```
            AppId             : 9367xxxx
            Mailbox           : test-shared-mailbox20231107190659
            AccessCheckResult : Granted
            ```

        - Running the command with a different mailbox should return `AccessCheckResult: Denied`.

    7. **Configure Intake Connector Settings in TheHive**

        To integrate TheHive with Microsoft 365, you will need the following information:

        - **Mailbox address**
        - **Tenant ID**
        - **Client ID**
        - **Secret Value**
        - **Authority:** `https://login.microsoftonline.com`
        - **Scope:** `https://outlook.office365.com/.default`

        ![](/thehive/images/administration-guides/ms-intake-7.png)

    ---

=== "Google Workspace"

    ### Setting up Google Workspace for TheHive

    This section describes the necessary steps to configure Google Workspace to allow TheHive access to a mailbox. Please follow these steps to ensure proper integration.

    &nbsp;

    #### Prerequisites
    - Access to the Google Cloud Admin Console.
    - Proper permissions to create projects and configure OAuth credentials.

    &nbsp;

    #### Step-by-Step Configuration

    1. **Access Google Cloud Admin Console**  
    Navigate to the Google Cloud Admin Console at [https://console.cloud.google.com/welcome](https://console.cloud.google.com/welcome).


    2. **Create a New Project**  

        - Click on **API & Services**.

        ![](/thehive/images/administration-guides/intake-1.png)

        - Select **Create a Project**.

        ![](/thehive/images/administration-guides/intake-2.png)

        - Provide a meaningful name for the project and click **Create**.

        ![](/thehive/images/administration-guides/intake-3.png)

    3. **Configure OAuth Consent Screen**  
    
        - In the left-hand menu, select **OAuth consent screen**.

        ![](/thehive/images/administration-guides/intake-4.png)

        - Choose **User Type** as **Internal** and click **Create**.

        ![](/thehive/images/administration-guides/intake-5.png)

        - Assign a name to the app and specify a mailbox for support contact.

        ![](/thehive/images/administration-guides/intake-6.png)

        - Provide a developer contact email address, then click **Save and Continue**.

        ![](/thehive/images/administration-guides/intake-7.png)

    4. **Add Gmail API Scope**  
    
        - In **Step 2**, click on **Add or Remove Scopes**.

        ![](/thehive/images/administration-guides/intake-8.png)

        - In the search bar, type the following scope: `https://mail.google.com/`.

        ![](/thehive/images/administration-guides/intake-9.png)

        - Click **Add to Table** to add the scope.

        ![](/thehive/images/administration-guides/intake-10.png)

        - Ensure that the new scope is checked, then click **Update**.

        ![](/thehive/images/administration-guides/intake-11.png)

        - Scroll down to verify that the Gmail scope exists, and click **Save and Continue**.

        ![](/thehive/images/administration-guides/intake-12.png)

    5. **Return to Dashboard**  
    
        - On the summary page, click **Back to Dashboard** to complete the OAuth consent configuration.

        ![](/thehive/images/administration-guides/intake-13.png)

    6. **Create OAuth Credentials**  
    
        - In the left-hand menu, select **Credentials**.

        ![](/thehive/images/administration-guides/intake-14.png)

        - Click on **Create Credentials** and choose **OAuth Client ID**.

        ![](/thehive/images/administration-guides/intake-15.png)

        - Set the application type as **Web application**.

        ![](/thehive/images/administration-guides/intake-16.png)

        - Provide a name for the OAuth client ID.

        - Under **Authorized JavaScript origins**, add the appropriate URI.

        ![](/thehive/images/administration-guides/intake-17.png)

        - Under **Authorized redirect URIs**, add the necessary URIs and click **Create**.

        ![](/thehive/images/administration-guides/intake-18.png)

    7. **Obtain Client ID and Secret** 

        * A dialog will appear with the **Client ID** and **Client Secret**.

        * Copy these values or download the JSON file for future reference.

        ![](/thehive/images/administration-guides/intake-19.png)

    8. **Configure Intake Connector Settings in TheHive**

        Set up the intake settings in TheHive by filling in the following values:

        * `Email`
        * `clientId`
        * `secret`

        ![](/thehive/images/administration-guides/eic-5.png)

    

=== "IMAP Mailbox"

    For IMAP configuration, you'll need to input the following information:

    - Host: `host`
    - Port: `port` (default: 993)

    Additionally, provide your mailbox credentials. We recommend enabling SSL Check Certificate Authority.

    ![](/thehive/images/administration-guides/eic-6.png)

    

### Settings

After testing your mailbox configuration, select the organization to connect, determining where alerts will be created. Define the mailbox folder to monitor (typically INBOX). Finally, specify the action to take on incoming emails: ``archive``, ``mark as read``, or ``no action``.

![](/thehive/images/administration-guides/eic-7.png)

---

## Generated Alerts and Observables

Following configuration, alerts and observables are generated in the selected organization.

### Alerts

Each alert will contain the following details:

!!! Info "Mapping of email data in the Alert"

    * **Title**: The email subject or "no subject"
    * **Type**: *email-intake*
    * **Source**: The configuration name is formatted as `Google Workspace @strangebee.com` => `googleworkspace-strangebee`
    * **Source reference**: `{message-id}` or `{lastUidValidity}.{uidEmail}` if the message-id is inaccessible
    * **Last sync date**: The date the email was received
    * **Severity**:  *low*
    * **TLP**: *amber*
    * **PAP**: *amber*
    *  **Follow**: *False*
    * **Tags**: [*email-intake*, {source}, {Provider Name}, {Inbox Folder Name}]
    * **Status**: *new*
    * **Description**: The content of the email
    * **Summary**: [Summary of Alert]
    * **Custom Fields**: [Custom Fields]
    * **Eternal link**: [Link to External Source]


---

### Observables

The email itself is included as a `.eml` file, along with its sender and all attached files, which are added to the alert as observables, with the following parameters:

!!! Info "Observables metadata added with the email data"

    - **Message**: The pre-formatted message
    - **TLP**: {alert.tlp}
    - **PAP**: {alert.pap}
    - **IOC**: false
    - **Sighted**: false
    - **Sighted at**: [Timestamp]
    - **Ignore similarity**: false
    - **dataType**: *file* if it's an attachment; otherwise, *mail* for the `.eml` file
    - **Tags**: {alert.tags}
    - **attachment Id**: {attachment.id}

&nbsp;