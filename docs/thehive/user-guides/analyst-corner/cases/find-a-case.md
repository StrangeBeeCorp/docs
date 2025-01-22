# Methods for searching a case

You can search for cases in several ways within TheHive.

This topic provides an overview of the various search methods available in TheHive for finding cases.

---

## **Enter a case number** search box

When to use it: If you already know the case number you're looking for.

Simply enter it in the search box located at the top of the page, visible across all views. 

You can search for only one case at a time.

Image

---

## Filters in the case view

When to use it: If you don't know the case number you're looking for or need to search for multiple cases to perform actions on them simultaneously.

Filter cases in the case view, accessible directly from the sidebar menu.

You can search for one or more cases at a time.

Image

You have three options, which can be used together for more refined results:

* **Quick Filters** to access the following predefined filters:
    * Open cases
    * Closed cases
    * My open cases
    * My closed cases
    * Owned by my organization
    * Shared with my organization
    * Unassigned cases

Image

* **+ Add Filter** to add one or more filters of your choice

Image

* Select any value in a case field to use it as a filter criterion.

Image

---

## Global search

When to use it: If you don't know the case number you're looking for or need to search for multiple cases without performing actions on them simultaneously.

You can access the Search feature directly through the sidebar menu.

Image

Select the **Cases** item on the Search Scope pane.

Image

!!! tip
    Select the **All elements** item for a comprehensive tool-wide overview that encompasses all entity types (cases, alerts, observables, jobs, tasks, and task logs), to analyze cross-linked information, or to conduct a detailed investigation.

### Search box

A search box is displayed by default, allowing you to enter the keywords you want to search for.

!!! warning
    Advanced searches, such as Boolean search or phrase search, are currently not supported. Only wildcard search has been available since version 5.4.7.

You can use the wildcard character *\** to broaden your searches and capture multiple variations.

Examples of use cases:
* Email domains: Entering *\*@gmail.com* will return entities containing the gmail.com domain
* IP subnets: Entering *192.168.\*.\** will return entities with IP addresses in the 192.168.x.x subnet
* URLs: Entering *https://malwaredomain.com/\** will return entities hosted under the malwaredomain.com directory

### Filters

In addition to the search box, you can apply one or more filters by selecting **Add New Filter**. These filters refine your search results and act as an equivalent to the AND operator in Boolean search.

!!! warning
    Using a filter is required in the following cases:
    * For fields with specific date formats: This ensures accurate handling of the data during searches.
    * For custom fields: This ensures the search engine properly interprets the value.

### Results

Based on your inputs, the Search Results pane will display a list of results. A maximum of 300 results can be shown per page, and you can navigate through the results using **Previous** and **Next**.

If you can't find what you're looking for using the Search feature and want to learn more about how fields are indexed for search, refer to the [Search indexation modes](thehive/user-guides/analyst-corner/search-methods/search-indexation-modes.md) topic.
