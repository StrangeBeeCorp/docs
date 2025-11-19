# Key Performance Indicators

<!-- md:version 5.1 -->

TheHive provides valuable insights into event and incident time metrics, enabling you to track key performance indicators (KPIs) for [cases](../analyst-corner/cases/about-cases.md) and [alerts](../analyst-corner/alerts/about-alerts.md).

These KPIs are displayed by default on all cases and alerts in TheHive. However, you can [hide some or all indicators](../organization/configure-organization/manage-ui-configuration/hide-key-performance-indicators.md) if they're not useful or may be misleading for your organization.

You can also include these KPIs in dashboards and case reports.

{% include-markdown "includes/units-time-to.md" %}

## Time to detect (TTD)

The time it takes to set the status of a case or alert to one linked to the *New* stage in TheHive after the event occurs. This metric helps assess the effectiveness of your monitoring tools and detection capabilities.

| KPI | Formula | In case description | In alert description |
|-----------|------------------|-------------------|--------------------|
| Time to detect (TTD) | = date of status *New* - event date | = `case.newDate` - `case.startDate` | = `alert.newDate` - `alert.date` |

## Time to triage (TTT)

The time it takes for your security team to acknowledge a case or alert by changing its status to one linked to the *In Progress* stage in TheHive. It reflects how efficiently alerts and cases are reviewed and escalated for investigation.

| KPI | Formula | In case description | In alert description |
|-----------|------------------|-------------------|--------------------|
| Time to triage (TTT) | = date of status *In Progress* - date of status *New* | = `case.inProgressDate` - `case.newDate` | = `alert.inProgressDate` - `alert.newDate` |

## Time to acknowledge (TTA)

The time it takes for your security team to acknowledge a case or alert by changing its status to one linked to the *In Progress* stage after the event occurs. This measures the responsiveness of your team after detecting a potential security incident.

| KPI | Formula | In case description | In alert description |
|-----------|------------------|-------------------|--------------------|
| Time to acknowledge (TTA) | = date of status *In Progress* - event date | = `case.inProgressDate` - `case.startDate` | = `alert.inProgressDate` - `alert.date` |

## Time to qualify (TTQ)

The time it takes for your security team to analyze an alert and determine whether it is a true positive or false positive, resulting in case closure or merging into a case. This metric helps measure the accuracy and speed of the qualification process.

| KPI | Formula | In case description | In alert description |
|-----------|------------------|-------------------|--------------------|
| Time to qualify (TTQ) | = date of alert closure or merge into case - date of status *New* | = `max(alert.importedDate, alert.closedDate)` - `alert.newDate` | not applicable |

## Time to resolve (TTR)

The time it takes for your security team to fully resolve an incident after its status is set to one linked to the *In Progress* stage. This includes investigation, remediation, and closure, indicating the efficiency of your incident response process.

| KPI | Formula | In case description | In alert description |
|-----------|------------------|-------------------|--------------------|
| Time to resolve (TTR) | = end of the incident date - date of status *In Progress* | = `case.endDate` - `min(alert.inProgressDate, case.inProgressDate)` | not applicable |

!!! note "handlingDuration"
    The `handlingDuration` field is available for cases and alerts in the API. The calculation is based on the difference between the end of the case date or the alert merge into case date, and the incident creation date in TheHive.  

    This field is a relic from older TheHive versions and can be slow to calculate. Use the time to resolve metric instead.

---

For more information on these KPIs, consult this [SecurityScorecard blog post](https://securityscorecard.com/blog/kpis-for-security-operations-incident-response/){target=_blank}.

<h2>Next steps</h2>

* [Date Field Definitions for Alerts and Cases](../date-field-definitions-alerts-cases.md)
* [Hide Key Performance Indicators](../organization/configure-organization/manage-ui-configuration/hide-key-performance-indicators.md)
* [Measure Case Performance](measure-case-management-performance.md)
* [Measure Alert Performance](measure-alert-management-performance.md)
