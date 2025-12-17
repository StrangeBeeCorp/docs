# Customize an Analyzer Template

<!-- md:permission `[admin] managePlatform` -->

[Cortex analyzers](../cortex/about-cortex.md) enrich observables with detailed, contextual intelligence, generating a report with the results.

Customize [analyzer templates](about-analyzer-templates.md) in TheHive to modify how reports appear after [running an analyzer on an observable](../../user-guides/analyst-corner/cases/observables/run-analyzers-on-an-observable.md).

<h2>Procedure</h2>

1. {% include-markdown "includes/entities-management-view-go-to.md" %}

2. {% include-markdown "includes/analyzer-templates-tab-go-to.md" %}

3. Select :fontawesome-solid-ellipsis: next to the analyzer template you want to customize.

    !!! tip "Can't find an analyzer template?"
        Analyzer templates are displayed only if the corresponding analyzer is activated in Cortex and available from TheHive.

4. Select **Edit**.

5. Modify the HTML code as needed.

6. Select **Confirm**.

<h2>Next steps</h2>

* [Import Analyzer Templates](import-analyzer-templates.md)