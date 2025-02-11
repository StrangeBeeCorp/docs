# How to Create a Case

This topic provides step-by-step instructions for creating a [case](../cases/about-a-case.md) in TheHive.

Several options are offered to create a case in TheHive:

* [Create an empty case]()

* [Create a case from a template]()

* [Create a case from an archived case]()

* [Create a case from a MISP event]()

* [Create a case from an alert]()

## Create an empty case

1. {!includes/create-a-case.md!}

2. In the **Create case** drawer, select **Empty case**.

3. Enter the following fields:

    **Title \***

    The title of the case.

    **Date \***

    The date and time of creation of the case. By default, it is set up with the current date and time.

    **Severity \***

    The severity level of the case.

    **TLP \***

    The TLP of the case.

    **PAP \***

    The PAP of the case.

    **Tags**

    **Description**

    **Tasks**

    **Custom fields**

    **Pages**

    **Sharing**

You can still apply a case template after creation if needed.

## Create a case from a template

## Create a case from an archived case

## Create a case from a MISP event

## Create a case from an alert

## Next steps





A user can create new cases using templates.

1. Click **Create Case +** on the header.

<img src="/thehive/images/user-guides/analyst-corner/cases/create_case_header.png" alt="create case on header" width="500" height="200"/>

A new screen opens. A user can create cases by selecting any one of the following options: 

Click the below links to create each type of new case. 

1. [`Empty Case`](../cases/create-empty-case.md)
1. [`EDR / Phishing Template`](../cases/create-case-from-template.md)
1. [`Archive`](../cases/create-case-from-archive.md)
1. [`MISP`](../cases/create-case-from-misp.md)

<img src="/thehive/images/user-guides/analyst-corner/cases/create_case.png" alt="create case" width="500" height="500"/>

# From archive (.thar)

Create a new case from archive.

1. Upload **File** as Attachment.
1. Enter the **Password**. 
1. Click the **Confirm case creation** button. 

    <img src="/thehive/images/user-guides/analyst-corner/cases/create_case_from_archive.png" alt="create case from archive" width="500" height="500"/>

# From MISP(.json)

Create a new case from MISP.

1. Upload **File** as Attachment.(import from MISP).
1. Add Tasks. (Refer to [`Add tasks`](../cases/adding_to_a_case.md#add-tasks)).
1. Add Custom Fields. (Refer to [`Add custom field values`](../cases/adding_to_a_case.md#add-custom-field-values)).

1. Click the **Confirm case creation** button. 

    <img src="/thehive/images/user-guides/analyst-corner/cases/create_case_from_misp.png" alt="create case from misp" width="500" height="500"/>

# From template
Create a new case from templates

## 1. Create a new case from EDR template.

1. Enter the case title in the **Title**.
1. Select the date from the **Date**. 
1. Select **Severity**, (Low/Medium/High/Critical).
1. Select **TLP**, (White/Green/Amber/Red).
1. Select **PAP**, (White/Green/Amber/Red).
1. Click **+** to add **Tags**. (Refer to [`Add tags`](#add-tags).)
1. Enter the case description in the **Description**. 
1. Choose a **Task rule** from the list, (manual/existingOnly/upcommingOnly/all).
1. Choose an **Observable rule** from the list, (manual/existingOnly/upcommingOnly/all).
1. Add Tasks. (Refer to [`Add tasks`](#add-tasks). / [`Edit tasks`](#edit-tasks). /[`Delete tasks`](#delete-tasks).) 
1. Add Custom Fields. (Refer to [`Add custom field values`](#add-custom-field-values). /[`Edit custom field values`](#edit-custom-field-values). /[`Delete custom field values`](#delete-custom-field-values).)
1. Add Pages. (Refer to [`Add pages`](#add-pages). /[`Delete pages`](#delete-pages).)
1. Sharing (Refer to [`Sharing`](#Sharing).)
1. Click the **Confirm case creation** button. 

<img src="/thehive/images/user-guides/analyst-corner/cases/create_case_edr_template.png" alt="create case from edr template" width="500" height="500"/>


## 2. Create a new case from Phishing template.

1. Enter the case title in the **Title**.
1. Select the date from the **Date**. 
1. Select **Severity**, (Low/Medium/High/Critical).
1. Select **TLP**, (White/Green/Amber/Red).
1. Select **PAP**, (White/Green/Amber/Red).
1. Click **+** to add **Tags**. (Refer to [`Add tags`](#add-tags).)
1. Enter the case description in the **Description**. 
1. Choose a **Task rule** from the list, (manual/existingOnly/upcommingOnly/all).
1. Choose an **Observable rule** from the list, (manual/existingOnly/upcommingOnly/all).
1. Add Tasks. (Refer to [`Add tasks`](#add-tasks). /[`Edit tasks`](#edit-tasks). /[`Delete tasks`](#delete-tasks).) 
1. Add Custom Fields. (Refer to [`Add custom field values`](#add-custom-field-values). /[`Edit custom field values`](#edit-custom-field-values). /[`Delete custom field values`](#delete-custom-field-values).)
1. Add Pages. (Refer to [`Add pages`](#add-pages). /[`Edit pages`](#edit-pages). /[`Delete pages`](#delete-pages).)
1. Sharing (Refer to [`Sharing`](#Sharing).) 
1. Click the **Confirm case creation** button. 

<img src="/thehive/images/user-guides/analyst-corner/cases/create_case_phishing_template.png" alt="create case from phishing template" width="500" height="500"/>

## Add tags 
1. Choose tags from the Taxonomy.
The selected tag will appear in the **Selected Tags** box
1. Click the **Add selected tags** button.

<img src="/thehive/images/user-guides/analyst-corner/cases/select_tags.png" alt="select tags" width="500" height="500"/>


## Add tasks 
The task **Group** is default. 

1. Enter the task **Title**.
1. Enter the task description in the **Description**. 
1. Select the **Due date**. 
1. Click **Confirm**.
1. Click **Save and add another**, to add another task. 

<img src="/thehive/images/user-guides/analyst-corner/cases/adding_a_task.png" alt="add tasks" width="500" height="500"/>


## Add custom field values 
1. Select custom field value from the given list. (location/business-unit/detection-source/test).
1. Click **Confirm custom field value creation**.

<img src="/thehive/images/user-guides/analyst-corner/cases/adding_a_custom_field_value.png" alt="custom field values" width="500" height="500"/>

## Add pages
By selecting **Create new page**

1. Enter the page **Title**.
1. Enter or select the **Category**. 
1. Enter the page content in the **content**. 
1. Click **Confirm**.
1. Click **Save and add another**, to add another task. 

<img src="/thehive/images/user-guides/analyst-corner/cases/adding_a_new_page.png" alt="page" width="500" height="500"/>

By selecting **Use an existing page template**

1. Choose template(s) from those available in the list of existing templates
1. Click **Confirm**.
1. Click **Save and add another**, to add another task. 

<img src="/thehive/images/user-guides/analyst-corner/cases/adding_a_existng_page.png" alt="page" width="500" height="500"/>

## Edit tasks 
1. Click the edit link.

<img src="/thehive/images/user-guides/analyst-corner/cases/edit_task_option.png" alt="edit task" width="500" height="500"/>

A new window opens. 

1. Edit the required values 
1. Click the **Confirm edition** button.

<img src="/thehive/images/user-guides/analyst-corner/cases/editing_a_task.png" alt="edit task" width="500" height="500"/>

## Edit custom field values 
1. Click the edit link.

<img src="/thehive/images/user-guides/analyst-corner/cases/edit_custom_field_option.png" alt="edit custom field values" width="500" height="500"/>

A new window opens.

1. Edit the required custom field values 
1. Click the **Confirm custom field value edition** button.

<img src="/thehive/images/user-guides/analyst-corner/cases/edit_custom_field_value.png" alt="edit custom field values" width="500" height="500"/>

## Delete tasks
1. Click the delete link beside the value that has to be deleted. 

<img src="/thehive/images/user-guides/analyst-corner/cases/delete_task_option.png" alt="delete tasks" width="500" height="500"/>

## Delete custom field values
1. Click the delete link beside the custom field value that has to be deleted. 

<img src="/thehive/images/user-guides/analyst-corner/cases/delete_custom_field_option.png" alt="delete custom field values" width="500" height="500"/>

## Delete pages
1. Click the delete link beside the value that has to be deleted. 

<img src="/thehive/images/user-guides/analyst-corner/cases/delete_page_option.png" alt="delete page" width="500" height="500"/>

# From an empty case

Create a new case from an empty case. 

1. Enter the case title in the **Title**.
1. Select the date from the **Date**. 
1. Select **Severity**, (Low/Medium/High/Critical).
1. Select **TLP**, (White/Green/Amber/Red).
1. Select **PAP**, (White/Green/Amber/Red).
1. Click **+** to add **Tags**. (Refer to [`Add tags`](../cases/adding_to_a_case.md#add-tags)).
1. Enter the case description in the **Description**. 
1. Choose a **Task rule** from the list, (manual/existingOnly/upcommingOnly/all).
1. Choose an **Observable rule** from the list, (manual/existingOnly/upcommingOnly/all).
1. Add Tasks. (Refer to [`Add tasks`](../cases/adding_to_a_case.md#add-tasks)).
1. Add Custom Fields. (Refer to [`Add custom field values`](../cases/adding_to_a_case.md#add-custom-field-values)).
1. Click the **Confirm case creation** button. 

<img src="/thehive/images/user-guides/analyst-corner/cases/create_empty_case.png" alt="create empty case" width="500" height="500"/>


# Case Management

Case Management is the main purpose of TheHive. Handling incidents with predefined tasks or manually added tasks, assiging a case owner, adding observables and enrich them, looking for correlations with existing cases and alert, prioritising incidents and classifying them... those are few of the case management capabilities in TheHive.

![case-list](../images/how-to/case-management/case-list.png)
![case-preview](../images/how-to/case-management/case-preview.png)

## Creating case

Cases can be created in various ways:

- Manually from scratch
- Manually using a case template
- Importing a TheHive archive generated from another TheHive instance
- Converting one or many alerts into a incident

![case-create-options](../images/how-to/case-management/case-create-options.png)

### Creating a case from a case template

Case templates are models of cases, including predefined and documented tasks as well as custom fields

![case-create](../images/how-to/case-management/case-create.png)

### Applying case template on ongoing investigations

Case templates can also be used to enrich a case with additional tasks, tags and custom field during open investigations:

![case-apply-template](../images/how-to/case-management/case-apply-template.png)

## Anatomy of a case

A case in TheHive is defined by:

- A set of predefined properties: Title, tags, assignee, TLP, PAP, severity, description, status
- A set of custom fields (optional or mandatory) 
- A set of tasks, defined by a title, assignee, status, description and a set of task logs and attachements
- A set of observables, of predefined or custom data types, defined by a value, IoC and Sighted flags, sighting date, tags and a description
- A set of TTPs related to MITRE ATT&CK
- A set of attachments
- A set of pages as a wiki
- A set of comments

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