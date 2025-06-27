# How to Perform Initial Login and Setup as an Admin

This topic provides step-by-step instructions for performing the initial login and setup as an administrator in TheHive.

Use this procedure before granting access to other users.

## Step 1: Log in with the default credentials

=== "TheHive On-prem"

    !!! warning "Requirements"
        This procedure assumes that you have already installed TheHive using the [step-by-step installation guide](../installation/step-by-step-installation-guide.md) and that TheHive is up and running.

    1. Open your web browser.

    2. Browse to `http://<your-server-address>:9000/`.

        !!! tip "Not sure of your server address?"
            Check the `application.conf` configuration file for the `application.baseUrl` setting.

    3. Enter the username and default password.

        Username: `admin@thehive.local`
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

For detailed instructions, see [Edit your Password](../user-guides/manage-password.md#edit-your-password).

## (Optional) Step 3: Activate your license

<!-- md:version 5.3 --> Installing TheHive On-prem or using TheHive Cloud Platform for the first time includes a 14-day Platinum trial license. If you complete the setup within this period, the license is already activated, and no further action is needed. After this trial period, TheHive transitions to read-only mode, requiring a valid license for all users for continued full functionality.

Only proceed with this step if your trial period has expired and you have acquired a [valid license](../installation/licenses/about-licenses.md) to activate, or if you want to activate a valid license immediately.

For detailed instructions, see [Activate a License](../installation/licenses/activate-a-license.md).

## Step 4: Configure TheHive

### Connect an SMTP server

See [Connect an SMTP server](smtp.md) for detailed instructions.

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

* [Create a profile](./profiles/create-a-profile.md)
* [Create a custom field](./custom-fields/create-a-custom-field.md)
* [Create an observable type](./observable-types/create-an-observable-type.md)
* [Create a case or alert status](./status/create-a-status.md)
* [Activate a taxonomy](./taxonomies/activate-deactivate-a-taxonomy.md)
* [Add a TTPs catalog](./ttps/add-a-catalog.md)

<h2>Next steps</h2>

* [Configure Authentication](./authentication/configure-authentication.md)
* [Connect a MISP Server](./misp-integration/connect-a-misp-server.md)
* [Add a Cortex Server](./cortex/add-a-cortex-server.md)
* [Connect a Mailbox](./email-intake-connector/connect-a-mailbox.md)