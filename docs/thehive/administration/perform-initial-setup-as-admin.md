# How to Perform the Initial Setup as an Admin in TheHive

This topic provides step-by-step instructions for performing the initial setup as an administrator in TheHive.

Use this procedure before granting access to other users.

## Step 1: Log in with the default credentials

=== "On-premises"

    !!! warning "Requirements"
        This procedure assumes that you have already installed TheHive using the [step-by-step installation guide](../installation/step-by-step-installation-guide.md) and that TheHive is up and running.

    1. Launch your web browser.

    2. Browse to `http://<your-server-address>:9000/`.

        !!! tip "Don't know your server address?"
            Check the `application.conf` configuration file for the `application.baseUrl` value.

    3. Enter the default credentials.

        Username: `admin@thehive.local`
        Password: `secret`

    4. Select **Let me in**.

=== "SaaS"

    XXX

## Step 2: Change your password

!!! danger "Critical security risk"
    Change the default password immediately after your first login to protect your TheHive instance. Default credentials are publicly known, and leaving them unchanged allows unauthorized access, risking sensitive data and system integrity.

For detailed instructions, see [Edit your password](../user-guides/manage-password.md#edit-your-password).

## (Optional) Step 3: Activate your license

!!! note "On-premises users only"
    License activation is only required for on-premises deployments. SaaS users aren't affected.

Installing TheHive On-prem includes a 14-day Platinum trial license with two users and one organization. If you complete the setup within this period, the license is already activated, and no further action is needed.

Only proceed with this step if your trial period has expired and you have acquired a valid license to activate, or if you want to activate a valid license immediately.

## Step 4: Configure TheHive

### Configure a SMTP server

### Create organizations

Limitation with one if trial

### Create users

Limitation with two if trial

### Customize entities

Profiles, custom fields, observable types, case and alert statuses, analyzer templates, taxonomies, and attack patterns.

<h2>Next steps</h2>