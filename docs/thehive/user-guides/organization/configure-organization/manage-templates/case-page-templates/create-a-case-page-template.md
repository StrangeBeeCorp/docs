# Create a Case Page Template

<!-- md:permission `managePageTemplate` -->

Create a [case page template](about-case-page-templates.md) in TheHive to streamline page creation within cases by automatically prefilling content.

To import an existing case template from another organization or TheHive instance, refer to [Import a Case Page Template](import-a-case-page-template.md).

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/templates-go-to.md" %}

3. {% include-markdown "includes/case-page-templates-go-to.md" %}

4. Select :fontawesome-solid-plus:.

5. In the **Adding a page template** drawer, enter the following fields:

    **Title**  
    The case page template title. It's used to identify the template in the API and serves as the default page title when [creating a page based on the template](../../../../knowledge-base/create-a-case-page.md).

    **Category**  
    The default category the pages belongs to. Pages are visually grouped by category for easier navigation. If the category doesn't exist, it will be created automatically.

    **Content**  
    The default page content using [TheHive-flavored Markdown syntax](../../../../thehive-flavored-markdown.md).

6. Select **Add page template**.

<h2>Next steps</h2>

* [Delete a Case Page Template](delete-a-case-page-template.md)
* [Create a Case Page](../../../../knowledge-base/create-a-case-page.md)
