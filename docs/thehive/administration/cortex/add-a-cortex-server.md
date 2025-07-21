# Add a Cortex Server

This topic provides step-by-step instructions for adding a [Cortex](about-cortex.md) server in TheHive.

!!! warning "Requirements"
    Before adding a Cortex server, you must install and configure Cortex. For instructions, refer to the [Installation and Configuration Guides](../../../cortex/installation-and-configuration/index.md).

!!! note "Multiple Cortex servers"
    TheHive supports connecting multiple Cortex servers only with a paid license.

!!! info "Cortex support"
    <!-- md:version 5.5 --> Cortex 3.1.5 and earlier are no longer supported since version 5.5.

{!includes/administrator-access-manage-cortex-connection.md!}

<h2>Procedure</h2>

1. {!includes/platform-management-view-go-to.md!}

    ---

2. {!includes/connectors-tab-go-to.md!}

    ---

3. Select the **Cortex** tab.

    ---

4. In the **Servers** section, select :fontawesome-solid-plus:.

    ---

5. In the **Set up a new server** drawer, enter the following information:

    **- Server name**

    The name of the connection. If you have multiple connections, use explicit names for clarity.

    **- Server URL**

    The URL of the Cortex server to connect to.
    
    Example: *https://cortex.mycompany.com*

    **- API key**

    The API key associated with the dedicated Cortex account.

    ---

6. {!includes/proxy-settings.md!}

    ---

7. {!includes/certificate-authority.md!}

    ---

8. {!includes/host-name-verification.md!}

    ---

9. Select the organizations to share your connection with using the **Choose the filter on TheHive organizations** dropdown.

    By default, all analyzers and responders provided by Cortex are available to all organizations.

    ---

10. Select **Test server connection** to verify your connection.

    ---

11. Select **Add**.

<h2>Next steps</h2>

* [Remove a Cortex Server](remove-a-cortex-server.md)