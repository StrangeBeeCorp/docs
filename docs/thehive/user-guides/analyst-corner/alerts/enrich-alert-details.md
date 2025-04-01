# How to Enrich Alert Details

This topic provides step-by-step instructions for enriching [alert](about-alerts.md) details in TheHive.

{!includes/access-update-an-alert.md!}

<h2>Procedure</h2>

1. [Find the alert](../alerts/search-for-alerts/find-an-alert.md) you want to enrich.

    ---

2. Update the following fields:

    **- Title**

    The title of the alert.

    **- [Tags](../cases/tags/about-tags.md)**

    Relevant tags for labeling the alert.

    **- Description**

    A description of the alert using [TheHive-flavored Markdown syntax](../../thehive-flavored-markdown.md).

    <!-- md:version 5.5 --> You can add a full-size image by dropping it into the **Description** field or selecting the :fontawesome-solid-image: symbol.

    !!! warning "Wait for the upload to complete"
        Wait until the image path appears in parentheses. If it doesn’t, the upload is still in progress, and the image won’t display as expected.

    **- [Custom fields](../cases/add-custom-fields.md)**  

    Custom fields for the alert, with or without predefined values.

    ---

3. Select **Confirm**.

<h2>Next steps</h2>

* [Change an Alert Status](change-status-alert.md)
* [Close an Alert](close-an-alert.md)
* [Actions](../alerts/alerts-description/actions.md)
* [Merge Alerts](../alerts/alerts-description/merge-alerts.md)
* [Run Responders](../alerts/alerts-description/run-responders.md)