# First Start of TheHive

## Initial Login

After completing the installation guides and verifying that TheHive is up and running, open your web browser and navigate to `http://IP_ADDRESS:9000`. Log in using the default account credentials:

| **Login**    | `admin` |
|--------------|-----------------------|
| **Password** | `secret`              |

![Initial Login](./images/first-start-login.png)

---

## Install License

To unlock all features and quotas, log in to your account on StrangeBee's customer portal, and follow [**this guide**](../installation/activate-license.md) to set up the license.

!!! Tip
    This action is particularly important if you are setting up TheHive as a cluster:

    1. When starting TheHive service, start only one node.
    2. Set up the license by connecting to the started node.
    3. Start the other TheHive nodes.

---

## Change `Admin` Password

It is crucial to change the default admin password immediately after your initial login to ensure the security of your TheHive instance. The default credentials are publicly known, and leaving them unchanged poses a significant security risk. Unauthorized users could easily gain access to your system, potentially compromising sensitive data and operations.

### 1. Go to User Settings

Navigate to the user settings page.

![User Settings](./images/first-start-change-user-settings.png)

### 2. Change Your Password

Update your password with a secure alternative.

![Change Password](./images/first-start-change-password.png)

### 3. Confirm Changes

Ensure you confirm the changes for them to take effect.

---

## Configuration

The Administrator's space is where all platform configurations are managed. Here are some key configurations you can perform:

* **Integrate Services:** Integrate TheHive with [SMTP servers](./smtp.md), authentication directory servers, Cortex, and MISP servers by navigating to the **Platform Management** page.

    ![Platform Management](./images/first-start-platform-management.png)

* **Create Organisations:** Set up organisations within TheHive.

    ![Create Organisations](./images/first-start-organisations.png)

* **Create Users:** Add users to TheHive to manage and operate within the platform.

    ![Create Users](./images/first-start-users.png)

* **Customize Application Behavior:** Tailor the application behavior for users in the **Entity Management** page.

    ![Entity Management](./images/first-start-entities-management.png)

&nbsp;