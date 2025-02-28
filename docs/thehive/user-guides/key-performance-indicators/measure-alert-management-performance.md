# Measuring Alert Management Performance

This guide provides step-by-step instructions for measuring **alert management performance** in **TheHive**.

You can measure performance for **all alerts in your organization** or analyze a **specific alert**.

For an overview of **Key Performance Indicators (KPIs)** in **TheHive**, refer to the [About Key Performance Indicators](about-key-performance-indicators.md) topic.

!!! info "Automated Actions"
    If alerts are created or updated through automated actions (e.g., API, functions, or external services), some indicators may have identical or very close values, particularly if multiple operations occur within the same second.

---

## Measuring the Performance of All Alerts

{!includes/dashboard-access.md!}

### 1. Access Dashboards

1. Navigate to the **Dashboards** view from the sidebar menu.

    ![Measure case management performance](../../images/user-guides/measure-case-management-performance.png)

### 2. Configure the Dashboard

2. Select a dashboard related to alerts.

3. Click :fontawesome-solid-pen: and select **Edit** on the section where you want to add alert management KPIs.

4. Add any value that begins with **timeTo** to a **Filters** box.

{!includes/units-time-to.md!}

---

## Measuring the Performance of a Specific Alert

### 1. Locate the Alert

1. [Search for the alert you want to analyze](../analyst-corner/cases/search-for-cases/find-a-case.md).

### 2. Review Time Metrics

2. In the **alert description**, navigate to the **Time Metrics** section in the left pane.

    ![Alert description metrics](../../images/user-guides/alert-description-metrics.png)

3. Review the available indicators for the alert.

---

## Next Steps

- [Measure Case Performance](measure-case-management-performance.md)
