# Find a Job

Search for a job in TheHive to locate tasks initiated by Cortex to run [analyzers](../../../../../cortex/installation-and-configuration/analyzers-responders.md) on observables.

!!! tip "Can't find a job?"
    <!-- md:version 5.5 --> [Case visibility](../about-cases.md#case-visibility) can be restricted to protect sensitive data. If you aren't an authorized user, its linked observables and any jobs launched on those observables won't appear in the list, search results, or dashboards.

<h2>Procedure</h2>

1. Go to the **Global Search** view from the sidebar menu.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-case-global-search-feature-sidebar-menu.png)

2. Select the **Jobs** item on the **Search scope** pane.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-job-global-search.png)

    {% include-markdown "includes/global-search-all-elements.md" %}

3. Enter the keywords you want to search for in the search box displayed by default.

    {% include-markdown "includes/wildcard-character.md" %}

    !!! warning "Unindexed fields"
        The `workerDefinition` field and the `operations[]` array aren't indexed for search.

    {% include-markdown "includes/elasticsearch-limitation.md" %}

4. {% include-markdown "includes/global-search-additional-filters.md" preserve-includer-indent=false %}

5. {% include-markdown "includes/search-results.md" %}

<h2>Next steps</h2>

* [Run Analyzers and Review Reports for an Observable](../observables/run-analyzers-on-an-observable.md)
* [Run Responders and Review Reports for an Observable](../observables/run-responders-on-an-observable.md)
* [Run Responders and Review Reports for a Case](../run-responders-on-a-case.md)