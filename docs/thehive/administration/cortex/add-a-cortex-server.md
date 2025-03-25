# How to Add a Cortex Server

This topic provides step-by-step instructions for adding a [Cortex](about-cortex.md) server in TheHive.

!!! info "Requirements"
    Before adding a Cortex server, you must install and configure Cortex. For instructions, refer to the [Installation and Configuration Guides](../../../cortex/installation-and-configuration/index.md).

{!includes/cortex-support-thehive-55.md!}

{!includes/administrator-access-manage-cortex-connection.md!}

## Procedure

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

## Next steps

* [Edit Cortex Connection Settings](edit-cortex-connection-settings.md)
* [Remove a Cortex Server](remove-a-cortex-server.md)