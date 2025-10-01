# About Custom Fields

Custom fields provide a way to extend the default set of fields available in [cases](../../user-guides/analyst-corner/cases/about-cases.md) and [alerts](../../user-guides/analyst-corner/alerts/about-alerts.md), allowing additional, organization-specific information to be recorded.

This topic provides a general overview of custom field usage in TheHive.

## Use cases

In TheHive, custom fields add structure and flexibility to cases and alerts in the following ways:

* Provide context to cases or alerts, such as the geographic location of an incident or its severity level
* Support organizational alignment by specifying the relevant business unit or team
* Enable integration with external tools by including identifiers, adding related data, or linking directly to external resources
* Streamline processes by indicating internal classification levels
* Manage checklists to validate specific steps when handling a case or alert
* Enhance data analysis through tagging, for example, identifying incidents involving VIPs

## Types

Custom fields support the following types:

{% include-markdown "includes/custom-fields-formats.md" %}

## Expected values

Custom fields support two types of input values:

* Free text: Accepts manually entered values without restrictions.
* Dropdown list: Offers a predefined set of selectable options.

## Completion rules

Custom fields can be configured as either optional or mandatory. Mandatory fields must be completed before a [case](../../user-guides/analyst-corner/cases/close-a-case.md) or an [alert](../../user-guides/analyst-corner/alerts/close-an-alert.md) can be closed.

## Permissions

{% include-markdown "includes/administrator-access-manage-custom-fields.md" %}

{% include-markdown "includes/access-manage-custom-fields.md" %}

<h2>Next steps</h2>

* [Create a Custom Field](create-a-custom-field.md)
* [Manage Custom Fields](manage-a-custom-field.md)
* [Delete a Custom Field](delete-a-custom-field.md)
* [Add Custom Fields](../../user-guides/analyst-corner/cases/custom-fields/add-custom-fields.md)
* [Remove Custom Fields](../../user-guides/analyst-corner/cases/custom-fields/remove-custom-fields.md)
* [Enter Values in Custom Fields](../../user-guides/analyst-corner/cases/custom-fields/enter-values-in-custom-fields.md)