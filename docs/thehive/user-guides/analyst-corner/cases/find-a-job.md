# How to Find a Job

This topic provides step-by-step instructions for searching a job in TheHive.

A job is a task initiated by Cortex to run an [analyzer](../../../../cortex/installation-and-configuration/analyzers-responders.md) on an observable.

## Procedure

1. Go to the **Global Search** view from the sidebar menu.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-case-global-search-feature-sidebar-menu.png)

2. Select the **Jobs** item on the **Search scope** pane.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-job-global-search.png)

    !!! note "All elements"
        Select the **All elements** item for a comprehensive tool-wide overview that encompasses all entity types (cases, alerts, observables, jobs, tasks, and task logs), to analyze cross-linked information, or to conduct a detailed investigation.

3. {!includes/global-search-search-box.md!}

    !!! warning "Warning"
        The `workerDefinition` field and the `operations[]` array are not indexed for search.

4. {!includes/global-search-additional-filters.md!}

5. {!includes/search-results.md!}

## Next steps

* [Run Analyzers on Case](../cases-list/run-analyzer.md)
* [Run Responders on Case](../cases-list/run-responders.md)

