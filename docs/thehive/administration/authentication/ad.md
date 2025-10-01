# Configure an AD Authentication Provider

<!-- md:license Platinum -->

Configure an [AD](../ldap/about-ldap.md) authentication provider in TheHive.

{% include-markdown "includes/access-authentication.md" %}

<h2>Procedure</h2>

{% include-markdown "includes/local-account-ldap-ad.md" %}

{% include-markdown "includes/prerequisites-authentication-providers.md" %}

1. {% include-markdown "includes/platform-management-view-go-to.md" %}

    ---

2. {% include-markdown "includes/authentication-tab-go-to.md" %}

    ---

3. Select **Directories authentication** in the **Authentication providers** section.

    ---

4. In the **Directories authentication** drawer, turn on the **Enable directory** toggle.

    ---

5. Select **ad** from the dropdown list.

    ---

6. Enter the following information:

    **- The addresses of the domain controllers**

    The IP addresses or host names of the domain controllers responsible for handling authentication requests within the network.

    **- The Windows domain name**

    The name of the Windows domain that manages user accounts and permissions. This is typically the NetBIOS name used within the Windows network.

    Example: *DOMAIN*

    **- The DNS domain name**

    The FQDN associated with the Windows domain (for example, *corp.example.com*). This is used for resolving network resources through the DNS.

    Example: *domain.local*

    ---

7. To secure communication between TheHive and the domain controllers using SSL/TLS encryption, turn on the **Use SSL** toggle.

    This encrypts authentication requests and responses, protecting sensitive data from interception during transmission.

    For more information about configuring SSL/TLS, refer to [Configure JVM Trust for SSL/TLS Certificates](../../configuration/ssl/configure-ssl-jvm.md).

    ---

8. Select **Confirm**.

<h2>Next steps</h2>

* [Configure Authentication](configure-authentication.md)
* [Configure JVM Trust for SSL/TLS Certificates](../../configuration/ssl/configure-ssl-jvm.md)