# How to Create a Case Template

### Add a case template

To Add a case template: 

1. Click the **+** , to **Add** a case template. 

<img src="/thehive/images/user-guides/organization/configure-organization/add-a-case-template.png" alt=" add case templates" width="700" height="700"/>

A new window opens. 

1. Enter the case title prefix in the **Prefix**.
1. Enter the case template **Name**. 
1. Enter the case template **Display Name**. 
1. Select **TLP**, (White/Green/Amber/Red).
1. Select **PAP**, (White/Green/Amber/Red).
1. Select **Severity**, (Low/Medium/High/Critical).
1. Click **+** to add **Tags**. (Refer to [`Add tags`](/thehive/analyst-corner/cases/adding_to_a_case.md#add-tags)).
1. Enter the case description in the **Description**. 
1. Click **+** to Add Tasks. (Refer to [`Add tasks`](/thehive/analyst-corner/cases/adding_to_a_case.md#add-tasks)).
1. Click **+** to Add Custom Fields. (Refer to [`Add custom field values`](/thehive/analyst-corner/cases/adding_to_a_case.md#add-custom-field-values)).
1. Click the **Confirm case template creation** button. 

<img src="/thehive/images/user-guides/organization/configure-organization/adding-a-case-template.png" alt="adding a case templates" width="1000" height="1000"/>


### Edit a case template

To Edit a case template: 

<img src="/thehive/images/user-guides/organization/configure-organization/edit-case-templates.png" alt=" edit case templates" width="700" height="700"/>

1. Click the **Edit** option from the list. 

A new window opens. 

1. Edit the required fields.    
1. Click the **Confirm case template edition** button. 

<img src="/thehive/images/user-guides/organization/configure-organization/edit-a-case-template.png" alt=" edit case templates" width="700" height="700"/>



### Delete a case template

To Delete a case template: 

1. Click the **Delete** option from the list.

<img src="/thehive/images/user-guides/organization/configure-organization/delete-case-templates.png" alt=" delete case templates" width="700" height="700"/>

A new message pops-up.

1. Click **OK** to delete the case template from the list.

<img src="/thehive/images/user-guides/organization/configure-organization/delete-case-template-popup.png" alt=" delete case templates" width="300" height="300"/>



### Import a case template

To Import a case template: 

<img src="/thehive/images/user-guides/organization/configure-organization/import-case-templates.png" alt=" import case templates" width="700" height="700"/>

1. Click the **Import Case Template** option. 

A new window opens. 

1. Click the **Drop file or Click** option in attachment. 
2. Click the **Confirm** button. 

> NOTE: The file must be a valid JSON file. You can use the exported case template directly from theHive platform. 

<img src="/thehive/images/user-guides/organization/configure-organization/import-a-case-template.png" alt=" import case templates" width="700" height="700"/>

### Export a case template

To Export a case template: 

1. Click the **Export Case Template** option.
1. A file is downloaded, that can be exported/sent.

<img src="/thehive/images/user-guides/organization/configure-organization/export-case-templates.png" alt=" export case templates" width="700" height="700"/>

# Define Case templates

This section contains the Case templates you prepare for your organization.

## List of Case Templates

Access to the list by opening the *Organization* menu, then the *Templates* tab, and the *Cases* tab.


<figure markdown>
  ![List of Case templates](../../../images/user-guides/organization/templates/organization-case-templates.png){ width="450" }
  <figcaption>List of Case templates</figcaption>
</figure>

Click the :fontawesome-regular-square-plus: button to create a new *Case template*.


## New Case template


<figure markdown>
  ![Create a Case template](../../../images/user-guides/organization/templates/organization-case-templates-2.png){ width="450" }
  <figcaption>Create a case template</figcaption>
</figure>

### Configuration parameters

Prefix
  : String that will be prepended to the title of a Case when created with this template

Name
  : Name of the Case template. Used to identify the Case template with the API

Display Name
  : Name of the Case template displayed in the UI

TLP
  : Default TLP of the Case when created with this template

PAP
  : Default PAP of the Case when created with this template


Severity
  : Default Severity of the Case when created with this template

Tags
  : List of tags that will be added to the Cases created with this template

Description
  : Default description of Cases created with this template if not modified.

Tasks
  : Add tasks to the templates. They will be automatically added to the Case when created with this template

Custom Fields
  : Add Custom fields to the template. Default value can be set for Custom fields as well.

Pages
  : Add pages template to the template. They will be automatically added to the Case when created with this template

## Import/Export

#### Export a *Case template* 
*Case templates* can be exported and stored as JSON files by clicking on the option icon :fontawesome-solid-ellipsis: and selecting :fontawesome-solid-file-export: *Export case template*

<figure markdown>
![](../../../images/user-guides/organization/templates/organization-case-templates-3.png){ width="500" }
<figcaption>Export a case template</figcaption>
</figure>

#### Import a *Case template*
Click on the button *Import Case Template* and select the JSON formatted file to import.

<figure markdown>
![](../../../images/user-guides/organization/templates/organization-case-templates-4.png){ width="500" }
<figcaption>Import a case template</figcaption>
</figure>