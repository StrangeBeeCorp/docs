# How to Add an Observable

This topic provides step-by-step instructions for adding an [observable](about-observables.md) to a case or alert in TheHive.

{!includes/access-manage-observables.md!}

<h2>Procedure</h2>

1. [Locate the case](../search-for-cases/find-a-case.md) or [alert](../../alerts/search-for-alerts/find-an-alert.md) where you want to add the observable.

    ---

2. {!includes/observables-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-plus:.

    ---

4. In the **Adding an observable** drawer, enter the following information:

    **- Type**

    The type of an observable determines which analyzers are available and whether it requires a value or an attachment. You can't change an observable’s type between one requiring a value and one requiring an attachment once it’s created.

    !!! tip "Can't find an observable type?"
        If you can't find the type you need, it might not exist yet, or someone may have deleted it. Contact someone with admin-level permissions to [create or restore it](../../../../administration/observable-types/create-an-observable-type.md).

    **- Value/attachment**

    Depending on the type of the observable, provide:

    * One or more values: To enter multiple values, place each value on a separate line and turn on the **One observable per line** toggle.
    * A file: Hashed automatically and available for download from the observable details.

    You can't change an observable's value or file once it's created.

    **- TLP (traffic light protocol) \***

    The TLP level for the observable. It indicates how you can share the observable's information with others. Refer to the [MISP taxonomy](https://www.misp-project.org/taxonomies.html#_tlp) for detailed definitions of TLP values.

    **- PAP (permissible actions protocol) \***

    The PAP level for the observable. It specifies which actions you can take with the observable data. Refer to the [MISP taxonomy](https://www.misp-project.org/taxonomies.html#_pap) for detailed definitions of PAP values.

    **- Is IOC**

    Turn on the toggle if you recognize the observable as related to suspicious or malicious activity.

    **- Has been sighted**

    Turn on the toggle when you detect or observe the observable in your environment.

    **- Ignore similarity**

    Turn on the toggle of you don't want to include the observable in the algorithm used to identify [similar alerts and cases](../find-similar-alerts-cases.md) based on observables. This can be useful for contextual observables, such as the company domain name, or for observables that aren't related to any potential threat.

    **- [Tags](../tags/add-remove-tags.md)**  
    
    One or more tags for labeling the observable.

    **- Description**

    A description of the observable using [TheHive-flavored Markdown syntax](../../../thehive-flavored-markdown.md).

    ---

5. Select **Confirm**.

<h2>Next steps</h2>

* [Remove an Observable](remove-an-observable.md)
* [Update the Status of an Observable](update-an-observable-status.md)
* [Edit Multiple Observables](edit-multiple-observables.md)
* [Pin an Observable](pin-an-observable.md)
* [Export Data from Observables](export-data-observables.md)
* [Run Analyzers on an Observable](run-analyzers-on-an-observable.md)
* [Run Responders on an Observable](run-responders-on-an-observable.md)
* [Import Observables from Analyzer Reports](import-observables-from-analyzer-reports.md)
* [Exclude an Observable from Similarity Checks](exclude-an-observable-from-similarity-checks.md)