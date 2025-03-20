# How to Create a Case Template

This topic provides step-by-step instructions for creating a [case template](about-case-templates.md) in TheHive.

!!! info "Duplicate an existing case template"
    Since version 5.4, you can duplicate an existing case template within your organization to quickly pre-fill fields and streamline the process.

To import an existing case template from another organization or TheHive instance, refer to the [Import a Case Template](import-a-case-template.md) topic.

{!includes/access-manage-case-templates.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/templates-go-to.md!}

    ---

3. {!includes/case-templates-go-to.md!}

    ---

4. Two options are available:

    * Create a case template from scratch by selecting :fontawesome-regular-square-plus:.

    * Duplicate an existing template by selecting :fontawesome-solid-ellipsis: next to the case template you want to duplicate, then select **Duplicate** (available since version 5.4).

    ---

5. In the **Adding a case template** drawer, enter values in some or all the following fields to pre-fill:

    **- Prefix**  
    A prefix that's automatically added to case titles. The prefix value isn't visible when creating a case from the template but applies after creation. Use it to categorize cases for reporting.
        
    **- Name \***  
    The name of the case template. This name identifies the case template in the API.
    
    **- Display name**  
    The name that appears when users select this template [to create a new case](../../../../analyst-corner/cases/create-a-new-case.md) or [to apply it to an existing case](../../../../analyst-corner/cases/apply-a-case-template.md). If you don't specify a display name, the case template name is used.
    
    **- [TLP](https://www.misp-project.org/taxonomies.html#_tlp) \***  
    The TLP level for the case. It guides analysts on how they can share case information.
    
    **- [PAP](https://www.misp-project.org/taxonomies.html#_pap) \***  
    The PAP level for the case. It guides analysts on how they can use case data.
    
    **- Severity**  
    The default severity level for cases.
    
    **- [Tags](../../../../analyst-corner/cases/tags/add-tags.md)**  
    One or more tags for labeling cases.
    
    **Description \***  
    A description for cases using [TheHive-flavored Markdown syntax](../../../../thehive-flavored-markdown.md).
    
    **- [Tasks](../../../../analyst-corner/cases/add-tasks-to-a-case.md)**  
    One or more tasks for cases.
    
    **- [Custom fields](../../../../analyst-corner/cases/add-custom-fields.md)**  
    One or more custom fields for cases, with or without predefined values.
    
    **- [Pages](../../../../knowledge-base/create-a-knowledge-base-page.md#create-a-page-at-the-case-level)**  
    A page template to document cases.

    ---

6. Select **Confirm case template creation**.

## Next steps

* [Edit a Case Template](edit-a-case-template.md)
* [Export a Case Template](export-a-case-template.md)
* [Create a Case](../../../../analyst-corner/cases/create-a-new-case.md)
* [Apply a Case Template](../../../../analyst-corner/cases/apply-a-case-template.md)