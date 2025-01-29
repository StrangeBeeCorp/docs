# How to Find an Observable

This topic provides step-by-step instructions for searching an observable in TheHive.

Observables are discrete pieces of technical evidence related to incidents. They can represent stateful properties, such as an MD5 hash or an IP address, or measurable events, such as the creation of a registry key or the execution of a file.

## Method 1: Observables tab in cases and alerts descriptions

*Use this method if you know the case or alert containing the observable you're looking for and if you need to perform actions on multiple observables simultaneously.*

1. Open a case or an alert, and select the **Observables** tab.

    ![Observables tab](../../../../images/user-guides/analyst-corner/cases/find-an-observable-observables-tab.png)

2. {!includes/apply-filters-light.md!}

3. {!includes/search-results.md!}

---

## Method 2: Global Search feature

*Use this method if you’re unsure where to find the observable you’re looking for or if you need to conduct advanced searches for multiple observables without requiring simultaneous actions.*

1. Go to the **Global Search** view from the sidebar menu.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-case-global-search-feature-sidebar-menu.png)

2. Select the **Observables** item on the **Search scope** pane.

    ![Global Search Observables item](../../../../images/user-guides/analyst-corner/cases/find-an-observable-global-search.png)

    !!! note "All elements"
        Select the **All elements** item for a comprehensive tool-wide overview that encompasses all entity types (cases, alerts, observables, jobs, tasks, and task logs), to analyze cross-linked information, or to conduct a detailed investigation.

3. {!includes/global-search-search-box.md!}

4. {!includes/global-search-additional-filters.md!}

5. {!includes/search-results.md!}

## Next steps

* [View Observables](../alerts/view-observables.md)


