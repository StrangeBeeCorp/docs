# Find a Comment

<!-- md:version 5.8 -->

Search for comments in TheHive using the search bar or the Global Search feature.

## Method 1: Search bar

*Quick searches without filters.*

1. In the search bar at the top of the page, enter your search text.

    ![Search bar](../../../../images/user-guides/analyst-corner/cases/search-bar.png)

    {% include-markdown "includes/wildcard-character.md" %}

    {% include-markdown "includes/elasticsearch-limitation.md" %}

2. Select a result from the list, or choose **All results** to view the full set of matches.

!!! note "Refine results"
    The search bar searches across all element types—cases, alerts, observables, tasks, task logs, jobs, comments, and pages—but it doesn't support filters.

    Use the [Global Search feature](#method-2-global-search-feature) when you need to refine results more precisely.

---

## Method 2: Global Search feature

*Complex searches with filters.*

1. Go to the **Global Search** view from the sidebar menu.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-case-global-search-feature-sidebar-menu.png)

2. Select the **Comments** item on the **Search scope** pane.

    ![Global Search Comments](../../../../images/user-guides/analyst-corner/cases/find-a-comment-global-search.png)

    !!! note "All elements"
        Select the **All elements** item for a comprehensive tool-wide overview that includes all entity types, such as cases, alerts, observables, jobs, tasks, task logs, comments, and pages. Use this option to analyze cross-linked information or to conduct a detailed investigation.

3. Enter the keywords you want to search for in the search box displayed by default.

    {% include-markdown "includes/wildcard-character.md" %}

    {% include-markdown "includes/elasticsearch-limitation.md" %}

4. {% include-markdown "includes/global-search-additional-filters.md" preserve-includer-indent=false %}

5. {% include-markdown "includes/search-results.md" %}

<h2>Next steps</h2>

* [Comment on a Case](comment-on-case.md)
* [Comment on an Alert](../../alerts/comment-on-alert.md)
* [Share a Comment](share-a-comment.md)
