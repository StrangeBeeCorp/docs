# How to Add an Observable

This topic provides step-by-step instructions for adding an [observable](../../user-guides/analyst-corner/cases/observables/about-observables.md) to a case or an alert in TheHive.

{!includes/access-manage-observables.md!}

<h2>Procedure</h2>

1. [Locate the case](../search-for-cases/find-a-case.md) or [alert](../../alerts/search-for-alerts/find-an-alert.md) where you want to add the observable.

2. {!includes/observables-tab-go-to.md!}

3. Select :fontawesome-solid-plus:.

4. In the **Adding an observable** drawer, enter the following information:

    **- Type**

    The type of the observable determines which analyzers are available and whether a value or an attachment is required.

    **- Value/attachment**

    Depending on the type of the observable, provide:

    * One or more values: If you want to enter multiple values, ensure each value is on a separate line and the **One observable per line** toggle is turned on.
    * A file: The file will be hashed and can be downloaded from the observable details if needed.

    **- [TLP](https://www.misp-project.org/taxonomies.html#_tlp)**

    The TLP level for the observable. It indicates how the observable information can be shared with others.

    **- [PAP](https://www.misp-project.org/taxonomies.html#_pap) \***

    The PAP level for the observable. It defines the permitted actions that can be taken with the observable data.

    **- Is IOC**

    Turn on the toggle if the observable is identified as being linked to suspicious or malicious activity.

    **- Has been sighted**

    Turn on the toggle if the observable has been detected or observed in the environment.

    **- Ignore similarity**

    Turn on the toggle of you don't want to include the observable in the algorithm used to identify similar alerts and cases based on observables. This can be useful for contextual observables, such as the company domain name, or for observables that aren't related to any potential threat.

    **- [Tags](../tags/add-remove-tags.md)**  
    
    One or more tags for labeling the observable.

    **- Description**

    A description of the observable using [TheHive-flavored Markdown syntax](../../../thehive-flavored-markdown.md).

5. Select **Confirm**.

<h2>Next steps</h2>

* [Remove an Observable](remove-an-observable.md)
* [Edit Multiple Observables](edit-multiple-observables.md)
* [Pin or Unpin an Observable](pin-unpin-an-observable.md)
* [Export a List of Observables](export-list-observables.md)
* [Copy Observable Data](copy-observable-data.md)
* [Run Analyzers on an Observable](run-analyzers-on-observables.md)
* [Run Responders on an Observable](run-responders-on-an-observable.md)
* [Download an Observable File](download-an-observable-file.md)
* [Update an Observable Status](update-status-of-an-observable.md)
* [Import Observables from Analyzer Reports](import-observables-from-analyzer-reports.md)