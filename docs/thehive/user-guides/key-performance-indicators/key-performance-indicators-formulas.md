# Key Performance Indicator Formulas

This topic outlines the formulas used to calculate key performance indicators (KPIs) for [cases](../analyst-corner/cases/about-cases.md) and [alerts](../analyst-corner/alerts/about-alerts.md) in TheHive.

## Key performance indicator formulas table

| KPI | Formula | In case description | In alert description |
|-----------|------------------|-------------------|--------------------|
| [Time to detect](about-key-performance-indicators.md#time-to-detect---ttd) (TTD) | = creation date in TheHive - event date | = `case.newDate` - `case.startDate` | = `alert.newDate` - `alert.date` |
| [Time to triage](about-key-performance-indicators.md#time-to-triage---ttt) (TTT) | = date of status *In Progress* - creation date in TheHive| = `case.inProgressDate` - `case.newDate` | = `alert.inProgressDate` - `alert.newDate` |
| [Time to acknowledge](about-key-performance-indicators.md#time-to-acknowledge---tta) (TTA) | = date of status *In Progress* - event date | = `case.inProgressDate` - `case.startDate` | = `alert.inProgressDate` - `alert.date` |
| [Time to qualify](about-key-performance-indicators.md#time-to-qualify---ttq) (TTQ) | = date of alert closure or merge into case - alert creation date in TheHive| = `max(alert.importedDate, alert.closedDate)` - `alert.newDate` | not applicable |
| [Time to resolve](about-key-performance-indicators.md#time-to-resolve---ttr) (TTR) | = end of the incident date - date of status *In Progress* | = `case.endDate` - `min(alert.inProgress, case.inProgress)` | not applicable |

## Next steps

* [About Key Performance Indicators](about-key-performance-indicators.md)
* [Hide Key Performance Indicators](hide-key-performance-indicators.md)
* [Measure Case Performance](measure-case-management-performance.md)
* [Measure Alert Performance](measure-alert-management-performance.md)
