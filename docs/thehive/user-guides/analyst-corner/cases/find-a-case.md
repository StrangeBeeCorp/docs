# Methods for searching a case

This topic provides an overview of the various search methods available in TheHive for finding cases, along with use cases for when to apply each method.

---

## Option 1: Enter a case number search box

### When to use it

If you already know the case number you're looking for.

### How to access

Simply enter the case number in the search box located at the top of the page, visible across all views.

Image

### Results

The case is displayed.

---

## Option 2: Filters in the case view

### When to use it

If you don't know the case number you're looking for or need to search for multiple cases to perform actions on them simultaneously.

### How to access

Filter cases in the case view, accessible directly from the sidebar menu.

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

* Select the value from a case field to use it as a filter criterion.

Image

### Results

Based on your inputs, the case view will display a list of results. A maximum of 300 results can be shown per page, and you can navigate through the results using **Previous** and **Next**.

---

## Option 3: Global Search feature

### When to use it

If you don't know the case number you're looking for or need to search for multiple cases without performing actions on them simultaneously.

### How to access

You can access the Search feature directly through the sidebar menu.

Image

Select the **Cases** item on the Search Scope pane.

Image

!!! tip
    Select the **All elements** item for a comprehensive tool-wide overview that encompasses all entity types (cases, alerts, observables, jobs, tasks, and task logs), to analyze cross-linked information, or to conduct a detailed investigation.

#### Search box

A search box is displayed by default, allowing you to enter the keywords you want to search for.

!!! warning
    Wildcard search has been available since version 5.4.7. Other advanced search options, such as Boolean and phrase searches, are not supported.

You can use the wildcard character *\** to broaden your searches and capture multiple variations.

Examples of use cases:

* Email domains: Entering *\*@gmail.com* will return entities containing the gmail.com domain
* IP subnets: Entering *192.168.\*.\** will return entities with IP addresses in the 192.168.x.x subnet
* URLs: Entering *https://malwaredomain.com/\** will return entities hosted under the malwaredomain.com directory

#### Filters

In addition to the search box, you can apply one or more filters by selecting **Add New Filter**. These filters refine your search results and act as an equivalent to the AND operator in Boolean search.

Filters are mandatory in the following cases:

* **Fields with specific date formats**: Ensures accurate data handling.
* **Custom fields**: Ensures the search engine interprets values correctly.

Image

### Results

Based on your inputs, the Search Results pane will display a list of results. A maximum of 300 results can be shown per page, and you can navigate through the results using **Previous** and **Next**.

## Troubleshooting

If you can't find what you're looking for using the Search feature and want to learn more about how fields are indexed for search, refer to the [Search indexation modes](thehive/user-guides/analyst-corner/search-methods/search-indexation-modes.md) topic.
