# Add a Link to a Case

<!-- md:version 5.5 --> <!-- md:permission `manageCase/update` -->

Add a [link to a case](../about-cases.md#linking-elements) in TheHive to connect it with another TheHive case or an external resource for reference and context.

!!! info "Not applicable to alert links"
    This procedure doesn't apply to alert links that are automatically created when [creating a case from an alert](../../alerts/create-a-case-from-an-alert.md) or [adding an alert to an existing case](../../alerts/add-an-alert-to-an-existing-case.md).

<h2>Procedure</h2>

1. [Find the case](../search-for-cases/find-a-case.md) where you want to add the link.

2. {% include-markdown "includes/linked-elements-section.md" %}

3. Select :fontawesome-solid-plus:.

4. Enter the following information:

    **- Link type**

    Link type specifies the category for the link. Existing categories appear when you click the field. Entering a new category automatically creates it when you add the link.

    If you don't specify a category, *Internal link* is applied by default when linking TheHive cases, and *External link* when linking external resources.

    **- Case or external URL**

    Search for the case by number or title, or paste an external URL.

    {% include-markdown "includes/elasticsearch-limitation.md" %}

5. Select :fontawesome-solid-check:.

<h2>Next steps</h2>

* [Remove a Link from a Case](remove-a-link-from-a-case.md)
* [View Links in a Case](view-links-in-a-case.md)