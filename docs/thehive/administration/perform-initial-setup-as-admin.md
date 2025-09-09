# Perform Initial Login and Setup as an Admin

This topic provides step-by-step instructions for performing the initial login and setup as an administrator in TheHive.

Use this procedure at first start, before granting access to other users.

## Step 1: Log in with the default credentials

=== "TheHive On-prem"

    !!! warning "Requirements"
        This procedure assumes that you have already installed TheHive and that TheHive is up and running.

    1. Open your web browser.

    2. Browse to the URL you configured in the `application.baseUrl` setting inside the `/etc/thehive/application.conf` file.

    3. Enter the username and default password.

        Login: `admin@thehive.local`  
        Password: `secret`

    4. Select **Let me in**.

=== "TheHive Cloud Platform"

    1. Retrieve your URL, administrator username, and default administrator password from the PDF available via the SendSafely link sent to you.

    2. Open the provided URL in your browser.

    3. Enter the credentials.

    4. Select **Let me in**.

## Step 2: Change your default password

!!! danger "Critical security risk"
    Change the default password immediately after your first login to protect your TheHive instance. Leaving them unchanged allows unauthorized access, risking sensitive data and system integrity.

See [Edit your Password](../user-guides/manage-password.md#edit-your-password) for detailed instructions.

## (Optional) Step 3: Request and activate your license

<!-- md:version 5.3 --> Installing TheHive On-prem or using TheHive Cloud Platform for the first time includes a 14-day Platinum trial license. If you complete the setup within this period, the license is already activated, and you don’t need to take further action.

After this trial period, TheHive transitions to read-only mode. To maintain full functionality, request a free or paid license and activate it. For details, see [About Licenses](../installation/licenses/about-licenses.md).

## Step 4: Configure TheHive

### Configure an SMTP server

See [Configure an SMTP server](./smtp/configure-smtp-server.md) for detailed instructions.

### Create organizations

!!! note "Trial limitation"
    During the Platinum trial period, you can create up to two organizations.

See [Create an Organization](./organizations/create-an-organization.md) for detailed instructions.

### Create users

!!! note "Trial limitation"
    During the Platinum trial period, you can create up to five users.

See [Create a User Account](../user-guides/organization/configure-organization/manage-user-accounts/create-a-user-account.md) for detailed instructions.

### Customize entities

Customize the following elements for all your organizations:

* [Profiles](./profiles/create-a-profile.md)
* [Custom fields](./custom-fields/create-a-custom-field.md)
* [Observable types](./observable-types/create-an-observable-type.md)
* [Case and alert statuses](./status/create-a-status.md)
* [Analyzer templates](./analyzer-templates/import-analyzer-templates.md)
* [Taxonomies](./taxonomies/activate-deactivate-a-taxonomy.md)
* [TTPs](./ttps/add-a-catalog.md)

<h2>Next steps</h2>

* [Configure Authentication](./authentication/configure-authentication.md)
* [Connect a MISP Server](./misp-integration/connect-a-misp-server.md)
* [Add a Cortex Server](./cortex/add-a-cortex-server.md)
* [Connect a Mailbox](./email-intake-connector/connect-a-mailbox.md)