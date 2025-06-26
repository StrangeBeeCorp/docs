# How to Perform the Initial Setup as an Admin in TheHive

This topic provides step-by-step instructions for performing the initial setup as an administrator in TheHive.

Use this procedure before granting access to other users.

## Step 1: Log in with the default credentials

=== "TheHive On-prem"

    !!! warning "Requirements"
        This procedure assumes that you have already installed TheHive using the [step-by-step installation guide](../installation/step-by-step-installation-guide.md) and that TheHive is up and running.

    1. Open your web browser.

    2. Browse to `http://<your-server-address>:9000/`.

        !!! tip "Not sure of your server address?"
            Check the `application.conf` configuration file for the `application.baseUrl` setting.

    3. Enter the default credentials.

        Username: `admin@thehive.local`
        Password: `secret`

    4. Select **Let me in**.

=== "TheHive Cloud Platform"

    1. Locate the email you received containing your URL and default credentials.

    2. Open the provided URL in your browser.

    3. Enter the default credentials.

    4. Select **Let me in**.

## Step 2: Change your password

!!! danger "Critical security risk"
    Change the default password immediately after your first login to protect your TheHive instance. Default credentials for TheHive On-prem are publicly known, so leaving them unchanged allows unauthorized access, risking sensitive data and system integrity.

For detailed instructions, see [Edit your password](../user-guides/manage-password.md#edit-your-password).

## (Optional) Step 3: Activate your license

!!! note "TheHive On-prem users only"
    License activation is only necessary for on-premises deployments. TheHive Cloud Platform users aren't affected since the Platinum license is activated automatically.

<!-- md:version 5.3 --> Installing TheHive On-prem includes a 14-day Platinum trial license. If you complete the setup within this period, the license is already activated, and no further action is needed. After this trial period, TheHive transitions to read-only mode, requiring a valid license for all users for continued full functionality.

Only proceed with this step if your trial period has expired and you have acquired a [valid license](../installation/licenses/about-licenses.md) to activate, or if you want to activate a valid license immediately.

## Step 4: Configure TheHive

### Configure a SMTP server

### Create organizations

Limitation with one if trial

### Create users

Limitation with two if trial

### Customize entities

Profiles, custom fields, observable types, case and alert statuses, analyzer templates, taxonomies, and attack patterns.

<h2>Next steps</h2>