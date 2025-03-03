# How to Edit a Case Template

This topic provides step-by-step instructions for editing a [case template](about-case-templates.md) in TheHive.

{!includes/access-manage-case-templates.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/templates-go-to.md!}

    ---

3. {!includes/case-templates-go-to.md!}

    ---

4. Select :fontawesome-solid-ellipsis: next to the case template you want to edit.

    ---

5. Select **Edit**.

    ---

6. In the **Editing a case template** drawer, enter your new values in the following fields:

    **Prefix**  
    A prefix that's automatically added to case titles. The prefix value isn't visible when creating a case from the template but applies after creation. Use it to categorize cases for reporting.
            
    **Name \***  
    The name of the case template. This name identifies the case template in the API.
    
    **Display name**  
    The name that appears when users select this template [to create a new case](../../../../analyst-corner/cases/create-a-new-case.md) or [to apply it to an existing case](../../../../analyst-corner/cases/apply-a-case-template.md). If you don't specify a display name, the case template name is used.
    
    **[TLP](https://www.misp-project.org/taxonomies.html#_tlp) \***  
    The TLP level for the case. It guides analysts on how they can share case information.
    
    **[PAP](https://www.misp-project.org/taxonomies.html#_pap) \***  
    The PAP level for the case. It guides analysts on how they can use case data.
    
    **Severity**  
    The default severity level for cases.
    
    **[Tags](../../../../analyst-corner/cases/adding_to_a_case.md)**  
    One or more tags to categorize cases. Only tags defined in the [taxonomies](../../../../../administration/taxonomies.md#view-a-taxonomie) are available for selection.
    
    **Description \***  
    A description for cases using [TheHive-flavored Markdown syntax](../../../../thehive-flavored-markdown.md).
    
    **[Tasks](../../../../analyst-corner/cases/adding_to_a_case.md)**  
    One or more tasks for cases.
    
    **[Custom fields](../../../../analyst-corner/cases/adding_to_a_case.md)**  
    One or more custom fields for cases, with or without predefined values.
    
    **[Pages](../../../../knowledge-base/create-a-knowledge-base-page#create-a-page-at-the-case-level.md)**  
    A page template to document cases.

    ---

7. Select **Confirm case template creation**.

## Next steps

* [Export a Case Template](export-a-case-template.md)
* [Create a Case](../../../../analyst-corner/cases/create-a-new-case.md)
* [Apply a Case Template](../../../../analyst-corner/cases/apply-a-case-template.md)