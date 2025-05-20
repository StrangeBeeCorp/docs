# Date Field Definitions for Alerts and Cases

This topic defines each date field used in alerts and cases.

## Date field definitions for alerts

| API field |  Definition        |
|-----------|-------------------|
| `date`       | The time the event occurred. Corresponds to the **Occurred date** field in the UI.     |
| `_createdAt`       | The time the alert was created in TheHive. |
| `_updatedAt`       |  The last time the alert was modified.  |
| `newDate`       |  The first time the alert entered a status linked to the *New* stage.               |
| <code style="white-space: nowrap;">inProgressDate</code>  |  The first time the alert entered a status linked to the *In progress* stage. |
| `closedDate`  |  The first time the alert entered a status linked to the *Closed* stage because no further investigation was required.  |
| `importedDate`  | The first time the alert entered the *Imported* status after being merged into a new or existing case for investigation.  |

## Date field definitions for cases

| API field        | Definition        |
|------------------|-------------------|
| `startDate`       | The time the event occurred. Corresponds to the **Start date** field in the UI.   |
| `_createdAt`       | The time the case was created in TheHive. |
| `_updatedAt`       | The last time the case was modified.      |
| `newDate`       | The first time the case entered a status linked to the *New* stage. |
| <code style="white-space: nowrap;">inProgressDate</code>       | The first time the case entered a status linked to the *In progress* stage.   |
| `closedDate`       | The first time the case entered a status linked to the *Closed* stage because the investigation was completed. |
| `endDate`       | The time the event actually ended. By default, this corresponds to the last time the case entered a status linked to the *Closed* stage. You can modify this value via the API to reflect the actual end time of the incident. We may add UI support for editing this field in a future version. |

<h2>Next steps</h2>

* [Key Performance Indicators](./key-performance-indicators/key-performance-indicators.md)
* [Measure Case Performance](./key-performance-indicators/measure-case-management-performance.md)
* [Measure Alert Performance](./key-performance-indicators/measure-alert-management-performance.md)

