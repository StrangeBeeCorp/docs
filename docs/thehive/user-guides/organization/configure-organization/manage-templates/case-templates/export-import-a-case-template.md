# Export or Import a Case Template

<!-- md:permission `manageCaseTemplate` -->

Export a [case template](about-case-templates.md) from TheHive to share it with another organization or TheHive instance, or import a case template to reuse configurations created elsewhere.

!!! info "Share and discover case templates"
    Contribute to and find case templates in our [public GitHub repository](https://github.com/StrangeBeeCorp/thehive-templates/tree/main/Case%20Templates){target=_blank}.  

    Before submitting your pull request:

    * Remove any sensitive information.
    * Exclude custom fields.
    
    Each contribution is reviewed by StrangeBee before being published.

## Export a case template

Use this procedure to share a case template with another organization or TheHive instance.

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/templates-go-to.md" %}

3. {% include-markdown "includes/case-templates-go-to.md" %}

4. Select :fontawesome-solid-ellipsis: next to the case template you want to export.

5. Select **Export case template** to export the case template in JSON format.

## Import a case template

Use this procedure to use a case template from another organization or TheHive instance.

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/templates-go-to.md" %}

3. {% include-markdown "includes/case-templates-go-to.md" %}

4. Select **Import case template**.

5. In the **Importing a case template** drawer, drop a JSON file directly into the **Attachment** section or select it from your computer. Use the file you obtained from [exporting the case template](#export-a-case-template).

6. Select **Confirm case template import**.

<h2>Next steps</h2>

* [Create a Case](../../../../analyst-corner/cases/create-a-new-case.md#create-a-case-from-a-template)
* [Apply a Case Template](../../../../analyst-corner/cases/apply-a-case-template.md)