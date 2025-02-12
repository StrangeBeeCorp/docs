# How to Create a Case

This topic provides step-by-step instructions for creating a [case](../cases/about-cases.md) in TheHive.

Several options are offered to create a case in TheHive:

* [Create an empty case](#create-an-empty-case)

* [Create a case from a template](#create-a-case-from-a-template)

* [Create a case from an archived case](#create-a-case-from-an-archived-case)

* [Create a case from a MISP event](#create-a-case-from-a-misp-event)

* [Create a case from an alert](#create-a-case-from-an-alert)

{!includes/access-create-a-case.md!}

## Create an empty case

1. {!includes/create-a-case.md!}

2. In the **Create case** drawer, select **Empty case**.

3. Enter the following fields:

    **Title \***  
    The title of the case.

    **Date \***  
    The start date and time of the case. It indicates when the incident occured. By default, this field is prefilled with the current date and time. This information is used to calculate [KPIs](../../key-performance-indicators/key-performance-indicators-formulas.md).

    **Severity \***  
    The severity level for the case.

    **TLP \***  
    The TLP level for the case.

    **PAP \***  
    The PAP level for the case.

    **[Tags](../cases/adding_to_a_case.md)**  
    Relevant tags to categorize the case.

    **Description \***  
    A description of the case.

    **[Tasks](../cases/adding_to_a_case.md)**  
    Tasks for the case.

    **[Custom fields](../cases/adding_to_a_case.md)**  
    Custom fields for the case, with or without predefined values.

    **[Pages](../../../../thehive/how-to/knowledge-base.md#case-pages)**  
    Pages to document the case.

    **Sharing**  
    By default, [global sharing rules set at the organization level](../../../administration/organizations/about-organizations-sharing-rules.md#global-sharing-rules) are applied when you create a new case. Here, you can modify these rules to apply local sharing settings to the case. You can modify local sharing rules for tasks and observables linked to the case after it is created. For more details, see the [Share a Case](../cases/share-a-case.md) topic.

4. Select **Confirm**.

!!! info "Case template"
    You can apply [a case template](../../organization/configure-organization/manage-templates/case-templates/about-case-templates.md) after creating the case. For more details, see the [Apply a Case Template](../cases/apply-a-case-template.md) topic.

## Create a case from a template

1. {!includes/create-a-case.md!}

2. In the **Create case** drawer, select a template from the dropdown list in the **From template** section.

3. In the **Create case from template** drawer, review the values inherited from the template and complete any missing ones. For more information about the fields, see the [Create an empty case](#create-an-empty-case) section.

4. Select **Confirm**.

## Create a case from an archived case

1. {!includes/create-a-case.md!}

2. In the **Create case** drawer, select **From archive (.thar)**.

3. In the **Import case** drawer:

    **Attachment \***  
    Drop a THAR file direclty into the **Attachment** section or select the THAR file from your computer. THAR files are TheHive archive files. For instructions on exporting a case as an archive, see the [Export a Case](export-a-case.md) topic.

    **Password \***  
    Enter the archive password that was set during the case export.

    **Sharing**  
    By default, [global sharing rules set at the organization level](../../../administration/organizations/about-organizations-sharing-rules.md#global-sharing-rules) are applied when you create a new case. Here, you can modify these rules to apply local sharing settings to the case. You can modify local sharing rules for tasks and observables linked to the case after it is created. For more details, see the [Share a Case](../cases/share-a-case.md) topic.

4. Select **Confirm**.

## Create a case from a MISP event

!!! info "Data transfer"
    Data from the MISP event, such as observables, is automatically transferred to the case.

1. {!includes/create-a-case.md!}

2. In the **Create case** drawer, select **From MISP (.json)**.

3. In the **Import from MISP** drawer:

    **Attachment \***

    Drop a JSON file direclty into the **Attachment** section or select the JSON file from your computer. Refer to [the MISP documentation](https://github.com/MISP/misp-book) to see how to export an event.

    **[Tasks](../cases/adding_to_a_case.md)**  
    Tasks for the case.

    **[Custom fields](../cases/adding_to_a_case.md)**  
    Custom fields for the case, with or without predefined values.

    **Sharing**  
    By default, [global sharing rules set at the organization level](../../../administration/organizations/about-organizations-sharing-rules.md#global-sharing-rules) are applied when you create a new case. Here, you can modify these rules to apply local sharing settings to the case. You can modify local sharing rules for tasks and observables linked to the case after it is created. For more details, see the [Share a Case](../cases/share-a-case.md) topic.

4. Select **Confirm**.

## Create a case from an alert

{!includes/access-create-case-from-alert.md!}

!!! info "Data transfer"
    Data from the alert, including observables, TTPs, attachments, comments, and custom fields, is automatically transferred to the case.

1. [Locate the alert you want to convert into a case](../alerts/search-for-alerts/find-an-alert.md).

2. In the alert description, select the **Create case from alert** button.

    ![Create case from alert](/thehive/images/user-guides/analyst-corner/cases/create-case-from-alert.png)

3. In the **Create case** drawer, select either **Empty case** or **From template**.

4. Follow the instructions provided in the related sections:

    * [Create an empty case](#create-an-empty-case)
    * [Create a case from a template](#create-a-case-from-a-template)

## Next steps

* [Apply a Case Template](apply-a-case-template.md)
* [Adding to a Case](adding_to_a_case.md)