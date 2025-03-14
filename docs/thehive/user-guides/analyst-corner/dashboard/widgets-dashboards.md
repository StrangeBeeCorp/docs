# Widgets in Dashboards

Several widget types are available for dashboards in TheHive.

This topic describes each widget type and its attributes.

## Row widget

A row widget is a prerequisite for adding other types of widgets. Each row can contain up to three widgets. If a row already exists, you can add more widgets to it.

## Bar widget

Add a bar widget to your dashboards.

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

Add a donut widget to your dashboards.

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

Add a line widget to your dashboards.

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

Add a radar widget to your dashboards.

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

Add a counter widget to your dashboards.

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

Add a text block to your case report template.

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

Add a gauge widget to your dashboards.

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

## Next steps

* [About Dashboards](about-dashboards.md)
* [Create a Dashboard](create-a-dashboard.md)
* [Edit a Dashboard](edit-a-dashboard.md)