# Measuring Case Management Performance

This guide provides step-by-step instructions for measuring **case management performance** in **TheHive**.

You can measure performance for **all cases in your organization** or analyze a **specific case**.

For an overview of **Key Performance Indicators (KPIs)** in **TheHive**, refer to the [About Key Performance Indicators](about-key-performance-indicators.md) topic.

!!! info "Automated Actions"
    If cases are created or updated through automated actions (e.g., API, functions, or external services), some indicators may have identical or very close values, particularly if multiple operations occur within the same second.

---

## Measuring the Performance of All Cases

{!includes/dashboard-access.md!}

### 1. Access Dashboards

1. Navigate to the **Dashboards** view from the sidebar menu.

    ![Measure case management performance](../../images/user-guides/measure-case-management-performance.png)

### 2. Configure the Dashboard

2. Select a dashboard related to cases.

3. Click :fontawesome-solid-pen: and select **Edit** on the section where you want to add case management KPIs.

4. Add any value that begins with **timeTo** to a **Filters** box.

{!includes/units-time-to.md!}

---

## Measuring the Performance of a Specific Case

There are two ways to measure case performance:

### 1. In a Case Description

1. [Search for the case you want to analyze](../analyst-corner/cases/search-for-cases/find-a-case.md).

2. In the **case description**, navigate to the **Time Metrics** section in the left pane.

    ![Case description metrics](../../images/user-guides/case-description-metrics.png)

3. Review the available indicators for the case.

---

### 2. In a Case Report Template

{!includes/access-manage-case-reports.md!}

1. {!includes/organization-view-go-to.md!}

2. {!includes/templates-go-to.md!}

3. {!includes/report-templates-go-to.md!}

4. Select a **case report template**.

5. Click :fontawesome-solid-pen: on the section where you want to add case management KPIs.

6. Select **Add Variable**.

7. Add any value that begins with **timeTo**.

{!includes/units-time-to.md!}

---

## Next Steps

- [Measure Alert Performance](measure-alert-management-performance.md)
