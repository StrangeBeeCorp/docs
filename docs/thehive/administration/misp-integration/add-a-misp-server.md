# How to Add a MISP Server

This topic provides step-by-step instructions for adding a [MISP server](about-misp-integration.md) in TheHive.

You can configure multiple MISP servers in TheHive.

This is useful if you want to automatically retrieve filtered MISP events as alerts in TheHive or share observables marked as IOCs from your cases with MISP. 

If you prefer to manually export your cases to MISP, see [How to Manually Export a Case to MISP](../../user-guides/analyst-corner/cases/export-a-case-to-misp.md).

To manually import a MISP event as a case in TheHive, refer to [How to Create a New Case](../../user-guides/analyst-corner/cases/create-a-new-case.md#create-a-case-from-a-misp-event).

!!! info "Requirements"
    Before proceeding with these instructions, ensure you have [a MISP API key](https://www.circl.lu/doc/misp/automation/#automation-api). You can find the API key under the **My Profile** page (/users/view/me) on your MISP instance.

{!includes/administrator-access-manage-misp-servers.md!}

<h2>Procedure</h2>

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/connectors-tab-go-to.md!}

3. {!includes/misp-tab-go-to.md!}

4. Enter the time interval between each event polling from TheHive to MISP.

    !!! info "Configuration for all MISP servers"
        This time interval applies to all MISP servers connected to TheHive.

5. Select :fontawesome-solid-plus:.

6. In the **Set up the new server** drawer, enter the following information in the **General settings** section:

    **- Server name**

    A name for the connection. Use explicit, precise names for each connection if you have multiple servers configured in TheHive.

    **- Server url**

    The URL of the MISP server to connect with. For example: *https://misp.mycompany.com*.

    **- API key**

    The API key for the dedicated MISP account. You can find the API key under the **My Profile** page (/users/view/me) on your MISP instance.

    **- Purpose**
    
    The purpose of this connection: *Import only*, *Export only*, or *Import and export*.

7. {!includes/proxy-settings.md!}

8. {!includes/certificate-authority.md!}

9. {!includes/host-name-verification.md!}

10. In the **Advanced settings** section, enter the following information:

    **- Choose the filter on TheHive organizations**

    By default, all your organizations in TheHive benefit from this connection.

    The following options are available:

    * Include all organizations
    * Include selected organizations
    * Exclude selected organizations

    **- [Tags](../../administration/taxonomies.md)**

    The tags to be appended to alerts when importing MISP events.

    **- Export case tags**

    When exporting observables marked as IOCs to MISP, also export the case tags in the MISP event.

    **- Export observables tags**

    When exporting observables marked as IOCs to MISP, also export the tags from the observables in the MISP event.

    **- Export TheHive URL**
  

11. In the **Filter settings** section, enter the following information:

    **- Maximum age**

    **- Organizations to include**

    **- Organizations to exclude**

    **- Maximum number of attributes**

    **- List of allowed tags**

    **- Prohibited tags list**

12. Select **Test server connection**.

13. Select **Add**.

<h2>Next steps</h2>