# How to Find a Task

This topic provides step-by-step instructions for using various methods to search for a [task](../about-tasks.md) in TheHive.

If you’re unsure which method to use, refer to the [Overview of Search Methods for Tasks](overview-search-methods-task.md) topic.

!!! tip "Can't find a task?"
    Since TheHive 5.5, [case visibility](../../cases/about-cases.md#case-visibility) can be restricted to protect sensitive data. If you aren't an authorized user, its linked tasks won't appear in the list, search results, or dashboards.

## Method 1: Tasks tab in cases descriptions

*Use this method if you want to find one or more tasks related to a case and want to perform actions on them simultaneously.*

1. Open a case and select the **Tasks** tab.

    ![Tasks tab](../../../../images/user-guides/analyst-corner/tasks/find-a-task-tasks-tab.png)

2. {!includes/apply-filters.md!}

3. {!includes/search-results.md!}

---

## Method 2: Filters in the Tasks view

*Use this method if you need to search for one or more tasks without requiring simultaneous actions.*

1. Go to the **Tasks** view from the sidebar menu.

    ![Tasks view](../../../../images/user-guides/analyst-corner/tasks/find-a-task-tasks-view.png)

2. {!includes/apply-filters.md!}

3. {!includes/search-results.md!}

---

## Method 3: Global Search feature

*Use this method if you need to conduct advanced searches for one or more tasks without requiring simultaneous actions.*

1. Go to the **Global Search** view from the sidebar menu.

    ![Global Search feature sidebar menu](../../../../images/user-guides/analyst-corner/cases/find-a-case-global-search-feature-sidebar-menu.png)

2. Select the **Tasks** item on the **Search scope** pane.

    ![Global Search Tasks](../../../../images/user-guides/analyst-corner/tasks/find-a-task-global-search.png)

    {!includes/global-search-all-elements.md!}

3. Enter the keywords you want to search for in the search box displayed by default.

    !!! tip "<!-- md:version 5.4 --> Wildcard character"
        You can use the wildcard character *\** to broaden your searches.

        The wildcard character acts as a placeholder that matches zero or more characters, helping you find variations of a term or incomplete information.
        
        Examples of use cases:  
        - Email domains: Entering *\*@gmail.com* will return entities containing the gmail.com domain.  
        - IP subnets: Entering *192.168.\*.\** will return entities with IP addresses in the 192.168.x.x subnet.  
        - URLs: Entering *https://malwaredomain.com/\** will return entities hosted under the malwaredomain.com directory.

        Other advanced search options, such as Boolean and phrase searches, are not currently supported.

4. {!includes/global-search-additional-filters.md!}

5. {!includes/search-results.md!}

<h2>Next steps</h2>

* [Actions on Tasks](../preview-task-details/actions.md)
* [Run Responders From Task](../preview-task-details/run-responders.md)
