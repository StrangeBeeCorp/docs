# Create a Function

<!-- md:version 5.1 --> <!-- md:license Platinum -->

This topic provides step-by-step instructions for creating a [function](about-functions.md) in TheHive.

Functions automate workflows, process data, and enhance case management.

{% include-markdown "includes/access-functions.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

    ---

2. {% include-markdown "includes/functions-tab-go-to.md" %}

    ---

3. Select :fontawesome-solid-plus:.

    ---

4. In the **Create function** drawer:

    **- Name \***

    Enter the function name, which you will use in your HTTP call to invoke the function.

    **- Mode \***

    Select the mode you want to apply to the function. For more details on the available options, see [About Functions](about-functions.md#function-modes).

    **- Types \***

    Select the type of the function. For more details on the available options, see [About Functions](about-functions.md#function-types).

    **- Description**

    Enter a brief description of the function’s purpose.

    **- Definition \***

    {% include-markdown "includes/function-definition.md" %}
        
    ---

5. {% include-markdown "includes/test-function.md" %}

    ---

6. Select **Save**. 

<h2>Next steps</h2>

* [Invoke a Function](invoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)
* [Delete a Function](delete-a-function.md)