# How to Create a Case

This topic provides step-by-step instructions for creating a [case](../cases/about-a-case.md) in TheHive.

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
    The start date and time of the case. It indicates when the incident occured. By default, this field is prefilled with the current date and time. This information is used to calculate [KPIs](../../../user-guides/indicators.md).

    **Severity \***  
    The severity level for the case.

    **TLP \***  
    The TLP level for the case.

    **PAP \***  
    The PAP level for the case.

    **[Tags](../../organization/configure-organization/manage-custom-tags/about_custom_tags.md)**  
    Relevant tags to categorize the case.

    **Description \***  
    A description of the case.

    **[Tasks](../tasks/about-tasks.md)**  
    Tasks for the case.

    **[Custom fields](../../../administration/custom-fields/about-custom-fields.md)**  
    Custom fields for the case, with or without predefined values.

    **[Pages](../../../../thehive/how-to/knowledge-base.md#case-pages)**  
    Pages to document the case.

    **Sharing**  
    By default, [global sharing rules set at the organization level](../../../administration/organizations/about-organizations-sharing-rules.md#global-sharing-rules) are applied when you create a new case. Here, you can modify these rules to apply local sharing settings to the case. You can modify local sharing rules for tasks and observables linked to the case after it is created. For more details, see the [Share a Case](../cases/share-a-case.md) topic.

4. Select **Confirm**.

!!! info "Case template"
    If needed, you can apply [a case template](../../organization/configure-organization/manage-templates/case-templates/about-case-templates.md) after creating the case. For more details, see the [Apply a Case Template](../cases/apply-a-case-template.md) topic.

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
    Drop a THAR file direclty into the **Attachment** section or click to select the THAR file from your computer. THAR files are TheHive archive files. For instructions on exporting a case as an archive, see the [Export a Case](export-a-case.md) topic.

    **Password \***
    Enter the archive password that was set during the case export.

    **Sharing**
    By default, [global sharing rules set at the organization level](../../../administration/organizations/about-organizations-sharing-rules.md#global-sharing-rules) are applied when you create a new case. Here, you can modify these rules to apply local sharing settings to the case. You can modify local sharing rules for tasks and observables linked to the case after it is created. For more details, see the [Share a Case](../cases/share-a-case.md) topic.

4. Select **Confirm**.

## Create a case from a MISP event

1. {!includes/create-a-case.md!}

2. In the **Create case** drawer, select **From MISP (.json)**.

3. In the **Import from MISP** drawer:

    **Attachment \***

    Drop a JSON file direclty into the **Attachment** section or click to select the JSON file from your computer. Refer to [the MISP documentation](https://github.com/MISP/misp-book) to see how to export an event.

    **[Tasks](../tasks/about-tasks.md)**  
    Tasks for the case.

    **[Custom fields](../../../administration/custom-fields/about-custom-fields.md)**  
    Custom fields for the case, with or without predefined values.

    **Sharing**
    By default, [global sharing rules set at the organization level](../../../administration/organizations/about-organizations-sharing-rules.md#global-sharing-rules) are applied when you create a new case. Here, you can modify these rules to apply local sharing settings to the case. You can modify local sharing rules for tasks and observables linked to the case after it is created. For more details, see the [Share a Case](../cases/share-a-case.md) topic.

4. Select **Confirm**.

## Create a case from an alert

1. [Locate the alert you want to convert into a case](../alerts/search-for-alerts/find-an-alert.md).

2. In the alert description, select ![Convert an alert into a case](/thehive/images/user-guides/analyst-corner/cases/convert-alert-into-case.png).

3. In the **Create case** drawer, select either **Empty case** or **From template**.

4. Follow the instructions provided in the related sections:

    * [Create an empty case](#create-an-empty-case)
    * [Create a case from a template](#create-a-case-from-a-template)

## Next steps

* []()
* []()




![case details](../images/how-to/case-management/case-details.png)

### Case tasks

![case-tasks](../images/how-to/case-management/case-tasks.png)

![case-task-details](../images/how-to/case-management/case-task-details.png)

### Case observables

![case-observables](../images/how-to/case-management/case-observables.png)
![case-observable-details](../images/how-to/case-management/case-observable-details.png)
![case-observable-analysis](../images/how-to/case-management/case-observable-analysis.png)
![case-observable-report](../images/how-to/case-management/case-observable-report.png)

### Case TTPs

![case-ttps](../images/how-to/case-management/case-ttps.png)

### Case timeline

![case-timeline-1](../images/how-to/case-management/case-timeline-1.png)
![case-timeline-2](../images/how-to/case-management/case-timeline-2.png)

### Case correlations

Case correlations with existing cases and alert are based on the common observables

![case-related-cases](../images/how-to/case-management/case-related-cases.png)
![case-similar-alerts](../images/how-to/case-management/case-similar-alerts.png)

## Case export

Cases can be exported as password protected archives or as a MISP event

![case-export](../images/how-to/case-management/case-export.png)