# Widgets in Case Report Templates

Several widget types are available for [case report templates](about-case-report-templates.md) in TheHive.

This topic describes each widget type and its attributes.

## Text widget

Displays formatted text, with support for case variables and TheHive-flavored Markdown.

Text widget configuration includes:

* A title for the text block
* The content of the text block, with the option to include case variables

Format your text block using [TheHive-flavored Markdown syntax](../../../../thehive-flavored-markdown.md).

## Image widget

Displays an image to visually support the report content.

!!! warning "Supported image formats"
    Image widgets only support JPG, JPEG, and PNG formats.

Image widget configuration includes:

* A title for the image
* An image that you can upload by dragging and dropping or selecting from your computer

## Table widget

Displays structured data in a tabular format, based on selected case elements.

Table widget configuration includes:

* A title for the table
* A parameter selection to choose from observables, tasks, TTPs, alerts, or [custom fields](../../../../../administration/custom-fields/about-custom-fields.md), along with the data to display
{% include-markdown "includes/protect-observable-urls.md" %}
* Sorting rules and filters to refine the displayed data

## List widget

Displays a simplified list of observables, tasks, TTPs, or alerts.

List widget configuration includes:

* A title for the list
* A parameter selection to choose from observables, tasks, TTPs, or alerts, along with the data to display
{% include-markdown "includes/protect-observable-urls.md" %}
* Sorting rules and filters to refine the displayed data

## Timeline widget

Displays case activity in a chronological list format.

Timeline widget configuration includes:

* A title for the timeline
* A selection of multiple parameters, allowing you to choose from alerts, case events, tasks, task logs, sighted indicators of compromise (IOCs), and TTPs
* [Custom events](../../../../analyst-corner/cases/case-timelines/add-custom-event-timeline.md)  
<!-- md:version 5.5 --> You can choose if you want to display custom events with or without their descriptions.

## Comments widget

<!-- md:version 5.4 -->

Displays case comments with optional filters and a maximum display limit.

Comments widget configuration includes:

* A title for the comments widget
* The maximum number of comments to display
* Filters to refine the displayed comments

## Pages widget

<!-- md:version 5.4 -->

Displays selected [case pages](../../../../knowledge-base/about-knowledge-base.md).

Pages widget configuration includes:

* A title for the pages widget
* Filters to refine the displayed pages

<h2>Next steps</h2>

* [About Case Report Templates](about-case-report-templates.md)
* [Create a Case Report Template](create-a-case-report-template.md)
* [Add or Remove Widgets in a Case Report Template](add-remove-widgets-case-report-template.md)
* [Save and Download a Case Report](../../../../analyst-corner/cases/case-reports/save-download-a-case-report.md)