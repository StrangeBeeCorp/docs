# Key Performance Indicator Formulas

This document outlines the formulas used to calculate **Key Performance Indicators (KPIs)** for [cases](../analyst-corner/cases/about-cases.md) and [alerts](../analyst-corner/alerts/about-alerts.md) in **TheHive**.

## KPI Calculation Formulas

The table below details the formulas used to compute each KPI:

| **KPI** | **Formula** | **In Case Description** | **In Alert Description** |
|-----------|------------------|-------------------|--------------------|
| [Time to Detect (TTD)](about-key-performance-indicators.md#time-to-detect---ttd) | `Creation date in TheHive - Event date` | `case.newDate - case.startDate` | `alert.newDate - alert.date` |
| [Time to Triage (TTT)](about-key-performance-indicators.md#time-to-triage---ttt) | `Date of status *In Progress* - Creation date in TheHive` | `case.inProgressDate - case.newDate` | `alert.inProgressDate - alert.newDate` |
| [Time to Acknowledge (TTA)](about-key-performance-indicators.md#time-to-acknowledge---tta) | `Date of status *In Progress* - Event date` | `case.inProgressDate - case.startDate` | `alert.inProgressDate - alert.date` |
| [Time to Qualify (TTQ)](about-key-performance-indicators.md#time-to-qualify---ttq) | `Date of alert closure or merge into case - Alert creation date in TheHive` | `max(alert.importedDate, alert.closedDate) - alert.newDate` | Not applicable |
| [Time to Resolve (TTR)](about-key-performance-indicators.md#time-to-resolve---ttr) | `End of the incident date - Date of status *In Progress*` | `case.endDate - min(alert.inProgress, case.inProgress)` | Not applicable |

{!includes/units-time-to.md!}

---

## Next Steps

- [About Key Performance Indicators](about-key-performance-indicators.md)
- [Hide Key Performance Indicators](hide-key-performance-indicators.md)
- [Measure Case Performance](measure-case-management-performance.md)
- [Measure Alert Performance](measure-alert-management-performance.md)
