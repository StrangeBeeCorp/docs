# Export or Import a Case Report Template

<!-- md:version 6.0 --> <!-- md:permission `manageCaseReportTemplate` --> <!-- md:license Platinum --> <!-- md:license One -->

Export a [case report template](about-case-report-templates.md) from TheHive to share it with another organization or TheHive instance, or import a case report template to reuse configurations created elsewhere.

Case report templates are exported as `.thtp` files. A `.thtp` file is a zip archive containing the template title, description, and definition as JSON, along with the template format version, the TheHive version that produced the file, and the export date. The archive is protected, so open it with TheHive rather than with an archive tool.

!!! warning "Images aren't included in the exported file"
    A `.thtp` file doesn't contain the images uploaded to [Image widgets](widgets-case-report-templates.md#image-widget). When you import the file into a different TheHive instance, the imported template still references images from the original instance, and these images may not display. Upload the images again in the imported template.

!!! info "Share case report templates"
    Contribute case report templates to our [public GitHub repository](https://github.com/StrangeBeeCorp/integrations/tree/main/integrations/generic){target=_blank}.

    Before submitting your pull request, remove any sensitive information.

    Each contribution is reviewed by StrangeBee before being published.

## Export a case report template

Share a case report template with another organization or TheHive instance. Exporting doesn't modify the original template.

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/templates-go-to.md" %}

3. {% include-markdown "includes/report-templates-go-to.md" %}

4. Select :fontawesome-solid-ellipsis: next to the case report template you want to export.

5. Select **Export report template**.

## Import a case report template

Use a case report template from another organization or TheHive instance. You can import one file at a time. Importing always creates a new template in the organization.

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/templates-go-to.md" %}

3. {% include-markdown "includes/report-templates-go-to.md" %}

4. Select **Import Report Template**.

5. In the **Importing a Report Template** drawer, drop the `.thtp` file directly into the **Attachment** section or select it from your computer. Use the file you obtained from [exporting the case report template](#export-a-case-report-template).

6. Optional: In the **Name of report template** field, edit the title of the imported template. This field is prefilled from the file name. If left empty, the title stored in the file is used.

7. Select **Import report template**.

<h2>Next steps</h2>

* [Create a Case Report Template](create-a-case-report-template.md)
* [Add or Remove Widgets in a Case Report Template](add-remove-widgets-case-report-template.md)
* [Save and Download a Case Report](../../../../analyst-corner/cases/case-reports/save-download-a-case-report.md)
