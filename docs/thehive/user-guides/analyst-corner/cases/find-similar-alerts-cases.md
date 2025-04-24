# How to Find Similar Alerts or Cases

This topic provides step-by-step instructions for finding similar alerts and cases in TheHive.

Similarity checks are performed through the [observables](../cases/observables/about-observables.md#similar-alerts-and-cases).

## Find similar alerts

1. [Find the alert](../alerts/search-for-alerts/find-an-alert.md) or [case](../cases/search-for-cases/find-a-case.md) you want to compare for similarity.

2. Select the **Similar alerts** tab.

    ![Similar alerts](/thehive/images/user-guides/analyst-corner/cases/similar-alerts.png)

3. Check how many observables are in common in the **Similarities** column.

4. Select **See all** in the **Matches** column to see the list of common observables.


<h2>Next steps</h2>

## Find similar cases

## Observable Preview Drawer

The Observable Preview Drawer allows you to view observables that are common between two events, such as alerts or cases. This feature is resource-intensive, and to optimize performance, there is a limit of 100 observables displayed in this drawer.

<img src="/thehive/images/user-guides/analyst-corner/alerts/observable-preview-drawer.png" alt="Observable Preview Drawer" width="700" height="700"/>

**Note:** This limit can be adjusted by the platform administrator in the `application.conf` file. However, modifying this limitation may affect the performance of the application. We cannot guarantee optimal performance if the limit is increased beyond 100 observables.

Parler des linked elements dans les cases ?