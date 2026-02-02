# Configure an SMTP Server

<!-- md:permission `[admin] managePlatform` -->

Configure an [SMTP server](about-smtp.md) to enable email notifications to [specific users](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-addr.md) and to [all users in your organization](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-users.md), as well as [password resets and edits emails](../../user-guides/manage-password.md) and invitation emails to the [TheHive Portal](../thehive-portal/about-thehive-portal.md) from TheHive.

<h2>Procedure</h2>

1. {% include-markdown "includes/platform-management-view-go-to.md" %}

    ---

2. {% include-markdown "includes/smtp-tab-go-to.md" %}

    ---

3. In the **Server settings** section, enter the following information:

    **- Server name or IP address \***

    The host name or IP address of your SMTP server.

    **- Port \***

    The port number your SMTP server uses.

    **- Send emails from \***

    The email address that appears as the sender of the emails.

    ---

4. In the **Security and authentication settings** section, enter the following information:

    **- Connection security \***

    Select the security protocol to use.

    **- Username**

    The username required to authenticate with your SMTP server.

    **- Password**

    The corresponding password for the SMTP username.

    ---

5. Select **Test SMTP configuration** to verify the connection settings. You should receive an email confirming the result of the test.

    ---

6. In the **Token expiration settings** section, enter the following information:

    **- Reset password expiration**

    Set how long password reset links remain valid. Shorter durations improve security by limiting the window for potential misuse, while longer durations accommodate users who may not check email immediately.

    **- Invitation expiration**

    <!-- md:version 5.6 --> <!-- md:license Platinum -->

    Set the validity period for [TheHive Portal](../thehive-portal/about-thehive-portal.md) invitation links.

    ---

7. Select **Confirm**.

<h2>Next steps</h2>

* [Configure the EmailerToAddr Notifier](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-addr.md)
* [Configure the EmailerToUser Notifier](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-users.md)