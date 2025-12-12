# Find an Alert

Search for [alerts](../about-alerts.md) in TheHive using different methods depending on your needs—from quick searches to advanced filtering.

If you’re unsure which method to use, refer to the [Overview of Search Methods for Alerts](overview-search-methods-alert.md) topic.

!!! tip "Can't find an alert?"
    Ensure [autorefresh](../../about-autorefresh.md) is turned on to automatically display new alerts in lists.

## Method 1: Similar alerts

*Use this method if you want to find one or more alerts similar to a known alert and need to perform actions on them simultaneously.*

{% include-markdown "includes/similar-cases-alerts-filters.md" %}

1. Open a case, an alert, or a task, and select the **Similar alerts** tab.

    ![Similar alerts](../../../../images/user-guides/analyst-corner/cases/similar-alerts.png)

2. {% include-markdown "includes/apply-filters.md" %}

3. {% include-markdown "includes/search-results.md" %}

For more information, see the [Find Similar Alerts and Cases](../../cases/find-similar-alerts-cases.md) topic.

---

## Method 2: Filters in the Alerts view

*Use this method if you need to search for one or more alerts to perform actions on them simultaneously.*

1. Go to the **Alerts** view from the sidebar menu.

    ![Filters in Alerts view](../../../../images/user-guides/analyst-corner/alerts/find-an-alert-alerts-view.png)

2. {% include-markdown "includes/apply-filters.md" %}

    {% include-markdown "includes/views-filters-sorts.md" %}

    !!! info "Beta feature available for filters and views"
        <!-- md:version 5.5.6 --> A beta feature to enhance user experience for filters and views is available for testing on lists of cases, alerts, tasks, and observables. For detailed instructions on how to activate this beta feature, see [Activate the Beta of Filters and Views](../../../../user-guides/manage-user-settings.md#activate-the-beta-of-filters-and-views).

3. {% include-markdown "includes/search-results.md" %}

---

## Method 3: Global Search feature

*Use this method if you need to conduct advanced searches for one or more alerts without requiring simultaneous actions.*

1. Go to the **Global Search** view from the sidebar menu.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-case-global-search-feature-sidebar-menu.png)

2. Select the **Alerts** item on the **Search scope** pane.

    ![Global Search Alerts item](../../../../images/user-guides/analyst-corner/alerts/find-an-alert-global-search.png)

    {% include-markdown "includes/global-search-all-elements.md" %}

3. Enter the keywords you want to search for in the search box displayed by default.

    {% include-markdown "includes/wildcard-character.md" %}

    {% include-markdown "includes/elasticsearch-limitation.md" %}

4. {% include-markdown "includes/global-search-additional-filters.md" preserve-includer-indent=false %}

5. {% include-markdown "includes/search-results.md" %}

<h2>Next steps</h2>

* [Start Working on an Alert](../start-investigating-an-alert.md)
* [Assign an Alert](../assign-an-alert.md)
* [Ignore Alert Updates from MISP](../ignore-alert-updates-misp.md)
* [Add an Alert to an Existing Case](../add-an-alert-to-an-existing-case.md)
* [Create a Case from an Alert](../create-a-case-from-an-alert.md)
* [Run Responders and Review Reports for an Alert](../run-responders-on-an-alert.md)
* [Find Similar Alerts or Cases](../../cases/find-similar-alerts-cases.md)
* [Close an Alert](../close-an-alert.md)
* [Reopen an Alert](../reopen-an-alert.md)
