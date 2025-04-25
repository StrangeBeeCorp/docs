# How to Find Similar Alerts or Cases

This topic provides step-by-step instructions for finding similar alerts and cases in TheHive.

Similarity checks are performed through the [observables](../cases/observables/about-observables.md#similar-alerts-and-cases).

## Find similar alerts

1. [Find the alert](../alerts/search-for-alerts/find-an-alert.md) or [case](../cases/search-for-cases/find-a-case.md) you want to compare for similarity.

2. Select the **Similar alerts** tab.

    ![Similar alerts](/thehive/images/user-guides/analyst-corner/cases/similar-alerts.png)

3. Select **See all** in the **Matches** column to view the list of common observables.

## Find similar cases

1. [Find the alert](../alerts/search-for-alerts/find-an-alert.md) or [case](../cases/search-for-cases/find-a-case.md) you want to compare for similarity.

2. Select the **Similar cases** tab.

    ![Similar cases](/thehive/images/user-guides/analyst-corner/cases/similar-cases.png)

3. Select **See all** in the **Matches** column to view the list of common observables.

    !!! info "Performance optimization"
        To optimize performance, a maximum of 100 observables are displayed in the **Matches** drawer. Users with an admin-type profile can adjust this limit in the `application.conf` file. However, increasing it beyond 100 may impact application performance. Proceed with caution when modifying this setting, as performance can't be guaranteed if the limit is raised.

<h2>Next steps</h2>




Parler des linked elements dans les cases ?