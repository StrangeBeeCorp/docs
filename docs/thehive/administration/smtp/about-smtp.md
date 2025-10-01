# About SMTP

This topic explains what Simple Mail Transfer Protocol (SMTP) is and how it's used in TheHive.

## What's SMTP

Simple Mail Transfer Protocol (SMTP) is the standard protocol used on the internet for sending email messages. It's responsible solely for email delivery and typically requires client authentication via credentials before granting access.

## Benefits of using an SMTP server

Using an SMTP server:

* Provides a secure environment for sending emails
* Offers dedicated IP addresses along with flexible API and SMTP configurations
* Includes user-friendly software for easy setup and management

## SMTP server usage in TheHive

[Configure a SMTP server](configure-smtp-server.md) in TheHive to enable sending:

* [Email notifications to specific users in your organization](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-addr.md)
* [Email notifications to all users in your organization](../../user-guides/organization/configure-organization/manage-notifications/notifiers/email-to-users.md)
* [Emails for password resets and edits](../../user-guides/manage-password.md)

## Permissions

{% include-markdown "includes/administrator-access-configure-smtp.md" %}

<h2>Next steps</h2>

* [Configure an SMTP Server](configure-smtp-server.md)