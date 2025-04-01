# How to Add a MISP Server

This topic provides step-by-step instructions for adding a [MISP server](about-misp-integration.md) in TheHive.

You can configure multiple MISP servers in TheHive.

This is useful if you want to automatically retrieve filtered MISP events as alerts in TheHive or share observables marked as IOCs from your cases with MISP. 

If you prefer to manually export your cases to MISP, see [How to Manually Export a Case to MISP](../../user-guides/analyst-corner/cases/export-a-case-to-misp.md).

To manually import a MISP event as a case in TheHive, refer to [How to Create a New Case](../../user-guides/analyst-corner/cases/create-a-new-case.md#create-a-case-from-a-misp-event).

!!! info "Requirements"
    Before proceeding with these instructions, ensure you have [a MISP API key](https://www.circl.lu/doc/misp/automation/#automation-api). You can find the API key under the **My Profile** page (/users/view/me) on your MISP instance.

{!includes/administrator-access-manage-misp-servers.md!}

## Procedure

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/connectors-tab-go-to.md!}

3. {!includes/misp-tab-go-to.md!}

4. Select :fontawesome-solid-plus:.

5. In the **Set up the new server** drawer, enter the following information in the **General settings** section:

    **- Server name**

    **- Server url**

    **- API key**

    **- Purpose**

6. {!includes/proxy-settings.md!}

7. {!includes/certificate-authority.md!}

8. {!includes/host-name-verification.md!}

9. In the **Advanced settings** section, enter the following information:

    **- Choose the filter on TheHive organizations**

    **- Tags**

    **- Export case tags**

    **- Export observables tags**

    **- Export TheHive url**

10. In the **Filter settings** section, enter the following information:

    **- Maximum age**

    **- Organizations to include**

    **- Organizations to exclude**

    **- Maximum number of attributes**

    **- List of allowed tags**

    **- Prohibited tags list**

## Next steps