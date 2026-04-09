# Create a Function

<!-- md:version 5.1 --> <!-- md:permission `manageFunction/create` --> <!-- md:license Platinum -->

Create a [function](about-functions.md) to automate workflows, process data, and enhance case management in TheHive.

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

5. In the **Test function** section, you can test your function as follows:

      * Enter input data by selecting *input*.

      * Select one of the following:

          * **Run function (dry-run)** to simulate the function without sending data.
          * **Run function** to execute the function with actual data.

      * After running the function, select one of the following to view results:

          * *result* to view the function’s output
          * *stdout* to display standard output from the function
          * *stderr* to display errors and warnings

    ---

6. Select **Save**. 

<h2>Next steps</h2>

* [Invoke a Function](invoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)
* [Delete a Function](delete-a-function.md)