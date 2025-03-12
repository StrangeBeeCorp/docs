## How to Create a Function

This topic provides step-by-step instructions for creating a [function](about-functions.md) in TheHive.

{!includes/access-functions.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/functions-tab-go-to.md!}

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

    Enter the JavaScript code for your function. If you need inspiration, check out the [GitHub repository with function examples]().

    !!! tip "Basic function structure"
        In TheHive, a function follows this basic structure:

        ``` javascript
        function handle(input, context) {
            // Your function logic goes here
        }
        ```

        * The `handle` function: This is where you write your script. Your function must be placed inside this structure.
        * The `input` parameter: This represents the data passed into the function. Its content depends on how the function is triggered.
        * The `context` parameter: This provides access to TheHive’s environment, allowing your function to [interact with common TheHive actions](functions-objects.md).
        
    ---

5. Select the **Test function** section to test your function.

    Enter input data in the **Input** field. 

    Select:  
        - *result* to view the output of your function  
        - *stdout* to display standard program output  
        - *stderr* to display errors and warnings

    ---

6. Select **Save**. 

## Next steps

* [Edit a Function](edit-a-function.md)
* [Revoke a Function](revoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)
* [Delete a Function](delete-a-function.md)