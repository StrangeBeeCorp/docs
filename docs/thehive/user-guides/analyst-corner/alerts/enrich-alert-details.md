# How to Enrich Alert Details

This topic provides step-by-step instructions for enriching [alert](about-alerts.md) details in TheHive.

!!! info "Status update"
    When you enrich a new alert, its status automatically changes from one linked to the *New* stage to one linked to the *In progress* stage. To choose a different status within the *In progress* stage, see [Change an Alert Status](change-status-alert.md).

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

    **- [Custom fields](../cases/custom-fields/add-custom-fields.md)**  

    Custom fields for the alert, with or without predefined values.

    ---

3. Select **Confirm**.

<h2>Next steps</h2>

* [Change an Alert Status](change-status-alert.md)
* [Close an Alert](close-an-alert.md)
* [Start Investigating an Alert](../alerts/start-investigating-an-alert.md)
* [Assign an Alert](assign-an-alert.md)
* [Ignore Alert Updates from MISP](ignore-alert-updates-misp.md)
* [Add an Alert to an Existing Case](add-an-alert-to-an-existing-case.md)
* [Create a Case from an Alert](create-a-case-from-an-alert.md)
* [Run Responders](../alerts/alerts-description/run-responders.md)