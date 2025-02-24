# How to Configure an Active Directory Authentication Provider

This topic provides step-by-step instructions for configuring an Active Directory authentication provider in TheHive.

{!includes/license-required-authentication.md!}

{!includes/access-authentication.md!}

## Procedure

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/authentication-tab-go-to.md!}

3. Select **Directories authentication** in the **Authentication providers** section.

4. In the **Directories authentication** drawer, turn on the **Enable directory** toggle.

5. Select **ad** from the dropdown list.

6. Enter the following information:

    **The addresses of the domain controllers**

    The IP addresses or hostnames of the domain controllers responsible for handling authentication requests within the network.

    **The Windows domain name**

    The name of the Windows domain that manages user accounts and permissions. This is typically the NetBIOS name used within the Windows network.

    Example: *DOMAIN*

    **The DNS domain name**

    The fully qualified domain name (FQDN) associated with the Windows domain (e.g., *corp.example.com*). This is used for resolving network resources through the Domain Name System (DNS).

    Example: *domain.local*

7. To secure communication between TheHive and the domain controllers using Secure Sockets Layer (SSL) encryption, turn on the **Use SSL** toggle.

    This ensures that authentication requests and responses are encrypted, protecting sensitive data from being intercepted during transmission.

8. Select **Confirm**.

## Next steps

* [How to Configure Authentication](configure-authentication.md)