# Widgets in Dashboards

Several widget types are available for dashboards in TheHive.

This topic describes each widget type and its attributes.

## Row widget

A row widget is a prerequisite for adding other types of widgets. Each row can contain up to three widgets. If a row already exists, you can add more widgets to it.

## Bar widget

Displays grouped data in a vertical bar chart. Useful for comparing categories over time or by type.

Bar widget configuration includes:

**- Title**

A title to define the widget’s name.

**- Interval**

A data grouping interval to structure the visualization.

**- Entity**

The specific entity the widget applies to.

**- Category field**

The field used for categorizing data.

**- Date**

The date field displayed on the chart.

**- Period field**

The date field that controls how filters from the **Period** dropdown at the top of the page apply to the data.

**- Stack by type**

The option to stack data in a single bar instead of displaying separate bars.

**- Logarithmic scale for y-axis**

The option to apply a logarithmic scale for better visualization of large value differences.

**- Filters**

Filters to refine and customize the displayed data.

**- Customize**

For certain category fields, you can customize the label and color of each possible value.

## Donut widget

Visualizes categorical data as a segmented ring. Ideal for showing proportions or distributions within a dataset.

Donut widget configuration includes:

**- Title**

A title to define the widget’s name.

**- Entity**

The specific entity the widget applies to.

**- Category field**

The field used for categorizing data.

**- Period field**

The date field that controls how filters from the **Period** dropdown at the top of the page apply to the data.

**- Max fragments**

The maximum number of segments in the donut chart. When the specified number is lower than the total data categories, the system combines the remaining values into an *Other* segment.

**- Filters**

Filters to refine and customize the displayed data.

**- Display values as percentage?**

The option to display values as percentages instead of absolute values.

**- Customize**

For certain category fields, you can customize the label and color of each possible value.

## Line widget

Plots one or more data series as lines across a time axis. Useful for identifying trends and comparisons over time.

Line widget configuration includes:

**- Title**

A title to define the widget’s name.

**- Interval**

A data grouping interval to structure the visualization.

**- Series**

One or more datasets plotted as visual elements on the chart. Select multiple series to compare different data points over time.

Enter the following details:

* Entity: The specific entity the series applies to.
* Date: The date field displayed on the chart.
* Period field: The date field that controls how filters from the **Period** dropdown at the top of the page apply to the data.
* Aggregation: The method used to aggregate data values.
* Field: Aggregation applies to this data field.
* Label: The text used to identify the data series in the chart.
* Type: The visualization style for the series.
* Color: The color assigned to the data series.
* Filters: Criteria to refine and customize the displayed data.

**- Stack by type**

The option to stack data in a single bar instead of displaying separate bars.

**- Logarithmic scale for y-axis**

The option to apply a logarithmic scale for better visualization of large value differences.

## Radar widget

Displays data across multiple categories in a radial chart. Good for comparing multiple variables on the same scale.

Radar widget configuration includes:

**- Title**

A title to define the widget’s name.

**- Entity**

The specific entity the widget applies to.

**- Category field**

The field used for categorizing data.

**- Period field**

The date field that controls how filters from the **Period** dropdown at the top of the page apply to the data.

**- Filters**

Filters to refine and customize the displayed data.

## Counter widget

Shows numeric values with optional thresholds. Useful for displaying KPIs or status metrics at a glance.

Counter widget configuration includes:

**- Title**

A title to define the widget’s name.

**- Entity**

The specific entity the widget applies to.

**- Period field**

The date field that controls how filters from the **Period** dropdown at the top of the page apply to the data.

**- Filters**

Filters to refine and customize the displayed data.

**- Series**

The counter widget displays one or more datasets. Select multiple series to compare different data points over time.

Enter the following details:

* Aggregation: The method used to aggregate data values.
* Label: The text used to identify the data series in the counter widget.
* Threshold: A reference value to compare the data against.
* Orientation: Determines how the threshold affects the data display:
    * Minimum: The data appears in green if it meets or exceeds the threshold.
    * Maximum: The data appears in green if it meets or falls below the threshold.
* Filters: Criteria to refine and customize the displayed data.

## Text widget

Displays rich text or aggregated data using TheHive-flavored Markdown. Useful for contextual notes, summaries, or custom metrics.

Text widget configuration includes:

**- Title**

A title for the text block.

**- Template**

The content of the text block, formatted using [TheHive-flavored Markdown syntax](../../thehive-flavored-markdown.md).

**- Series**

The text block displays one or more datasets. Select multiple series to compare different data points over time.

Enter the following details:

* Entity: The specific entity the series applies to.
* Period field: The date field that controls how filters from the **Period** dropdown at the top of the page apply to the data.
* Aggregation: The method used to aggregate data values.
* Label: The text used to identify the data series in the chart.
* Filters: Criteria to refine and customize the displayed data.

## Gauge widget

Visualizes a single value against a scale using a circular gauge. Ideal for tracking performance against defined thresholds.

Gauge widget configuration includes:

**- Title**

A title to define the widget’s name.

**- Entity**

The specific entity the widget applies to.

**- Period field**

The date field that controls how filters from the **Period** dropdown at the top of the page apply to the data.

**- Min**

The minimum value displayed on the gauge. This defines the starting point of the scale.

**- Medium**

An intermediate reference value, used to indicate a midpoint in the gauge.

**- Max**

The maximum value displayed on the gauge. This defines the upper limit of the scale.

**- Filters**

Filters to refine and customize the displayed data.

## Table widget

!!! note "Available from version 5.5"
    Table widgets are available starting in version 5.5.

Displays data in a tabular format. Useful for listing critical in-progress cases, alerts, or tasks.

Table widget configuration includes:

**- Title**

A title to define the widget’s name.

**- Entity**

The specific entity the widget applies to. Only cases, alerts, and tasks are supported.

**- Max elements in the table**

The maximum number of elements to display in the table.

**- Period field**

The date field that controls how filters from the **Period** dropdown at the top of the page apply to the data.

**- Columns**

The data fields to display in each column of the table. For optimal visual clarity on a one-third width layout, we recommend using no more than three columns. You can configure up to nine columns in total.

!!! info "Excluded data fields"

    Some data fields are excluded and can't be selected:

    * For cases: `description`, `customFields`, `tags`, `userPermissions`, `extraData`, `summary`, and any computed fields.
    * For alerts: `description`, `customFields`, `tags`, `userPermissions`, `extraData`, `externalLink`, `summary`, and any computed fields (for example, handlingDuration).
    * For tasks: `description` and `extraData`.

**- Filters**

Filters to refine and customize the displayed data.

**- Sort**

Sorting rules to refine the displayed data.

## Next steps

* [About Dashboards](about-dashboards.md)
* [Create a Dashboard](create-a-dashboard.md)
* [Edit a Dashboard](edit-a-dashboard.md)