# Find a Task Log

Search for a task log in TheHive to locate specific actions, updates, or decisions recorded for a task. Task logs provide a detailed audit trail that helps track investigation progress, accountability, and compliance.

!!! tip "Can't find a task log?"
    <!-- md:version 5.5 --> [Case visibility](../../cases/about-cases.md#case-visibility-restriction) can be restricted to protect sensitive data. If you aren't an authorized user, its linked tasks and task logs won't appear in the list, search results, or dashboards.

## Method 1: Search bar

<!-- md:version 5.6 -->

*Simple searches for one or more task logs without requiring simultaneous actions.*

1. In the search bar at the top of the page, enter your search text.

    ![Search bar](../../../../images/user-guides/analyst-corner/cases/search-bar.png)

    {% include-markdown "includes/wildcard-character.md" %}

    {% include-markdown "includes/elasticsearch-limitation.md" %}

2. Select a result from the list, or choose **All results** to view the full set of matches.

!!! note "Refine results"
    The search bar searches across all element types—cases, alerts, observables, tasks, task logs, and jobs. It also doesn't support filters.  

    Use the [Global Search feature](#method-2-global-search-feature) when you need to refine results more precisely.

---

## Method 2: Global Search feature

*Advanced searches for one or more task logs without requiring simultaneous actions.*

1. Go to the **Global Search** view from the sidebar menu.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-case-global-search-feature-sidebar-menu.png)

2. Select the **Task logs** item on the **Search scope** pane.

    ![Global Search Task logs](../../../../images/user-guides/analyst-corner/tasks/find-a-task-log-global-search.png)

    {% include-markdown "includes/global-search-all-elements.md" %}

3. Enter the keywords you want to search for in the search box displayed by default.

    {% include-markdown "includes/wildcard-character.md" %}

    {% include-markdown "includes/elasticsearch-limitation.md" %}

4. {% include-markdown "includes/global-search-additional-filters.md" preserve-includer-indent=false %}

5. {% include-markdown "includes/search-results.md" %}

<h2>Next steps</h2>

* [Delete a Task Log](../delete-a-task-log.md)
* [Run Responders and Review Reports for a Task Log](../../tasks/run-responders-on-a-task-log.md)