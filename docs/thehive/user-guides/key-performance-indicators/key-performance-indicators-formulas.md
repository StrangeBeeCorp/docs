# Key Performance Indicator Formulas

This topic outlines the formulas used to calculate key performance indicators (KPIs) for cases and alerts in TheHive.

## KPI formulas table

| KPI | Formula | Applied to cases | Applied to alerts |
|-----------|------------------|-------------------|--------------------|
| [Time to detect](about-key-performance-indicators.md#time-to-detect---tdd) (TDD) | = creation date - event date | = `case.newDate` - `case.startDate` | = `alert.newDate` - `alert.date` |
| [Time to triage](about-key-performance-indicators.md#time-to-triage---ttt) (TTT) | = date of status *In Progress* - creation date | = `case.inProgressDate` - `case.newDate` | = `alert.inProgressDate` - `alert.newDate` |
| [Time to qualify](about-key-performance-indicators.md#time-to-qualify---ttq) (TTQ) | = date of alert closure or merge into case - alert creation date | not applicable | = `max(alert.importedDate, alert.closedDate)` - `alert.newDate` |
| [Time to acknowledge](about-key-performance-indicators.md#time-to-acknowledge---tta) (TTA) | = date of status *In Progress* - event date | = `case.inProgressDate` - `case.startDate` | = `alert.inProgressDate` - `alert.date` |
| [Time to resolve](about-key-performance-indicators.md#time-to-resolve---ttr) (TTR) | = end of the incident date - date of status *In Progress* | = `case.endDate` - `min(alert.inProgress, case.inProgress)` | = `case.endDate` - `min(alert.inProgress, case.inProgress)` |

## Next steps

* [About Key Performance Indicators](about-key-performance-indicators.md)
* [Evaluate Case Performance]()
* [Evaluate Alert Performance]()
