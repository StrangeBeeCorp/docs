# How to Configure an SMTP Server

This topic provides step-by-step instructions for configuring an [SMTP server](about-smtp.md) in TheHive.

Use this procedure to enable sending [email notifications to specific users](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-addr.md) and [all users in your organization](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-users.md), as well as [emails for password resets and edits](../../user-guides/manage-password.md).

{!includes/administrator-access-configure-smtp.md!}

<h2>Procedure</h2>

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/smtp-tab-go-to.md!}

3. In the **Server settings** section, enter the following information:

    **- Server name or IP address \***

    The host name or IP address of your SMTP server.

    **- Port \***

    The port number your SMTP server uses.

    **- Send emails from \***

    The email address that appears as the sender of the emails.

4. In the **Security and authentication settings** section, enter the following information:

    **- Connection security \***

    Select the security protocol to use.

    **- Username**

    The username required to authenticate with your SMTP server.

    **- Password**

    The corresponding password for the SMTP username.

5. Select **Test SMTP configuration** to verify the connection settings. You should receive an email confirming the result of the test.

6. In the **Reset Password** section, set the token expiration duration to control how long password reset tokens stay valid before they expire. This limits the time users have to complete a password reset and helps keep your system secure.

7. Select **Confirm**.

<h2>Next steps</h2>

* [Configure the EmailerToAddr Notifier](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-addr.md)
* [Configure the EmailerToUser Notifier](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-users.md)