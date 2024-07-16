# First Start of TheHive


## Initial Login

After following the installation guides and ensuring TheHive is up and running, open your web browser, navigate to ``http://IP_ADDRESS:9000``, and log in using the default account credentials:

| **Login**    | `admin` |
|--------------|-----------------------|
| **Password** | `secret`              |

![](./images/first-start-login.png)

---

## Install License

To unlock all features and quotas, log in to your account on StrangeBee's customer portal, and follow [this guide](../installation/activate-license.md) to setup the licence.

!!! Tip
    This action is particularly required if you are setting up TheHive as a cluster: 
    
    1. When starting TheHive service, start only one node
    2. setup the license by connecting to the started node
    3. start others TheHive nodes

---

## Change `Admin` password

It is crucial to change the default admin password immediately after your initial login to ensure the security of your TheHive instance. The default credentials are publicly known and leaving them unchanged poses a significant security risk. Unauthorized users can easily gain access to your system, potentially compromising sensitive data and operations.

### 1. Go to User Settings

![](./images/first-start-change-user-settings.png)

### 2. Change Your Password

![](./images/first-start-change-password.png)

### 3. Confirm Changes

Ensure you confirm the changes for them to take effect.

---

## Configuration

The Administrator's space is where all platform configurations are managed.

* Integrate TheHive with [SMTP servers](./smtp.md), authentication directory servers, Cortex, and MISP servers: Go to the **Platform Management page**

    ![](./images/first-start-platform-management.png)

* Create Organisations

    ![](./images/first-start-organisations.png)

* Create Users

    ![](./images/first-start-users.png)

* Customize Application Behavior for Users in the **Entity Management page**

    ![](./images/first-start-entities-management.png)