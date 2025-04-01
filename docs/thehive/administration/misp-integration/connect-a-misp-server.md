# How to Connect a MISP Server

This topic provides step-by-step instructions for connecting a [MISP server](about-misp-integration.md) to TheHive.

This is useful if you want to automatically retrieve filtered MISP events as alerts in TheHive or share observables marked as IOCs from your cases with MISP. 

You can configure multiple MISP servers in TheHive.

If you prefer to manually export your cases to MISP, see [How to Manually Export a Case to MISP](../../user-guides/analyst-corner/cases/export-a-case-to-misp.md).

To manually import a MISP event as a case in TheHive, refer to [How to Create a New Case](../../user-guides/analyst-corner/cases/create-a-new-case.md#create-a-case-from-a-misp-event).

!!! info "Requirements"
    Before proceeding with these instructions, ensure you have [a MISP API key](https://www.circl.lu/doc/misp/automation/#automation-api). You can find the API key under the **My Profile** page (/users/view/me) on your MISP instance.

{!includes/upgrade-misp.md!}

{!includes/administrator-access-manage-misp-servers.md!}

<h2>Procedure</h2>

1. {!includes/platform-management-view-go-to.md!}

    ---

2. {!includes/connectors-tab-go-to.md!}

    ---

3. {!includes/misp-tab-go-to.md!}

    ---

4. Enter the time interval between each event polling from TheHive to MISP.

    !!! info "Configuration for all MISP servers"
        This time interval applies to all MISP servers connected to TheHive.

    ---

5. Select :fontawesome-solid-plus:.

    ---

6. In the **Set up the new server** drawer, enter the following information in the **General settings** section:

    **- Server name**

    A name for the connection. Use explicit, precise names for each connection if you have multiple servers configured in TheHive.

    **- Server URL**

    The URL of the MISP server to connect with. For example: *https://misp.mycompany.com*.

    **- API key**

    The API key for the dedicated MISP account. You can find the API key under the **My Profile** page (/users/view/me) on your MISP instance.

    **- Purpose**
    
    The purpose of this connection: 
    
    * *Import only*: Only import events from MISP to TheHive.
    * *Export only*: Only export cases from TheHive to MISP.
    * *Import and export*: Enables two-way synchronization.

    ---

7. {!includes/proxy-settings.md!}

    ---

8. {!includes/certificate-authority.md!}

    ---

9. {!includes/host-name-verification.md!}

    ---

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

    Exports the case tags to the MISP event.

    **- Export observables tags**

    Exports the tags from the observables to the MISP event.

    **- Export TheHive URL**

    Exports the TheHive case link to the MISP event.

    ---
  
11. In the **Filter settings** section, enter the following information:

    **- Maximum age**

    The maximum age, based on the creation date, for an event to be imported into TheHive.

    **- Organizations to include**

    Only events created by the MISP organizations defined in this field are imported.

    **- Organizations to exclude**

    Only events not created by the MISP organizations defined in this field are imported.

    **- Maximum number of attributes**

    The maximum number of MISP attributes, corresponding to observables in TheHive, per event to import.

    **- List of allowed tags**

    Only events containing the tags defined in this field are imported.

    **- Prohibited tags list**

    Only events that don't contain the tags defined in this field are imported.

    ---

12. Select **Test server connection** to verify your connection.

    ---

13. Select **Add**.

<h2>Next steps</h2>

* [Edit a MISP Server Connection](edit-a-misp-server.md)
* [Delete a MISP Server Connection](delete-a-misp-server.md)