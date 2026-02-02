# Find a Case

Search for [cases](../about-cases.md) in TheHive using different methods depending on your needs—from quick searches to advanced filtering.

If you’re unsure which method to use, refer to the [Overview of Search Methods for Cases](overview-search-methods-case.md) topic.

!!! tip "Can't find a case?"

    * Ensure [autorefresh](../../about-autorefresh.md) is turned on to automatically display new cases in lists.
    * <!-- md:version 5.5 --> <!-- md:license Platinum --> [Case visibility](../about-cases.md#case-visibility-restriction) can be restricted to protect sensitive data. If you aren't an authorized user, it won't appear in the case list, search results, or dashboards.

## Method 1: Search bar

*Simple searches for one or more cases without requiring simultaneous actions.*

1. In the search bar at the top of the page, enter the case number or <!-- md:version 5.6 --> any relevant text.

    ![Search bar](../../../../images/user-guides/analyst-corner/cases/search-bar.png)

    {% include-markdown "includes/wildcard-character.md" %}

    {% include-markdown "includes/elasticsearch-limitation.md" %}

2. Select a result from the list, or choose **All results** to view the full set of matches.

!!! note "Refine results"
    The search bar searches across all element types—cases, alerts, observables, tasks, task logs, and jobs. It also doesn't support filters.  

    Use the [Global Search feature](#method-4-global-search-feature) when you need to refine results more precisely.

---

## Method 2: Similar cases

*If you want to find one or more cases similar to a known case without needing to perform actions on them simultaneously.*

{% include-markdown "includes/similar-cases-alerts-filters.md" %}

1. Open a case, an alert, or a task, and select the **Similar cases** tab.

    ![Similar cases](../../../../images/user-guides/analyst-corner/cases/similar-cases.png)

2. {% include-markdown "includes/apply-filters.md" %}

3. {% include-markdown "includes/search-results.md" %}

For more information, see the [Find Similar Alerts and Cases](../find-similar-alerts-cases.md) topic.

---

## Method 3: Filters in the Cases view

*If you want to find one or more cases to perform actions on them simultaneously.*

1. {% include-markdown "includes/cases-view-go-to.md" %}

2. {% include-markdown "includes/apply-filters.md" %}

    {% include-markdown "includes/views-filters-sorts.md" %}

3. {% include-markdown "includes/search-results.md" %}

---

## Method 4: Global Search feature

*Advanced searches for one or more cases without requiring simultaneous actions.*

1. Go to the **Global Search** view from the sidebar menu.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-case-global-search-feature-sidebar-menu.png)

2. Select the **Cases** item on the **Search scope** pane.

    ![Global Search feature cases item](../../../../images/user-guides/analyst-corner/cases/find-a-case-global-search-feature-cases-item.png)

    {% include-markdown "includes/global-search-all-elements.md" %}

3. Enter the keywords you want to search for in the search box displayed by default.

    {% include-markdown "includes/wildcard-character.md" %}

    {% include-markdown "includes/elasticsearch-limitation.md" %}

4. {% include-markdown "includes/global-search-additional-filters.md" preserve-includer-indent=false %}

5. {% include-markdown "includes/search-results.md" %}

<h2>Next steps</h2>

* [Merge Cases](../merge-cases.md)
* [Restrict Case Visibility](../case-visibility/restrict-visibility-case.md)
* [Restore Case Visibility](../case-visibility/restore-visibility-case.md)
* [Add Tasks to a Case](../add-tasks-to-a-case.md)
* [Add Custom Fields](../custom-fields/add-custom-fields.md)
* [Find Similar Alerts or Cases](../find-similar-alerts-cases.md)
* [Add TTPs](../ttps/add-ttps.md)
* [Add an Attachment](../attachments/add-an-attachment-case-alert.md)
* [View a Case Timeline](../case-timelines/view-case-timeline.md)
* [View a Case Page](../../../../user-guides/knowledge-base/view-a-case-page.md)
* [Run Responders and Review Reports for a Case](../run-responders-on-a-case.md)
