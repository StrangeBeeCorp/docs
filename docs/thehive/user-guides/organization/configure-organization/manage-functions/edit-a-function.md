## How to Edit a Function

This topic provides step-by-step instructions for editing a [function](about-functions.md) in TheHive.

{!includes/access-functions.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/functions-tab-go-to.md!}

    ---

3. Select the function you want to edit, or select :fontawesome-solid-ellipsis: and then **Edit**.

    ---

4. In the **Edit function** drawer:

    **- Name \***

    Enter the function name, which you will use in your HTTP call to invoke the function.

    **- Mode \***

    Select the mode you want to apply to the function. For more details on the available options, see [About Functions](about-functions.md#function-modes).

    **- Types \***

    Select the type of the function. For more details on the available options, see [About Functions](about-functions.md#function-types).

    **- Description**

    Enter a brief description of the function’s purpose.

    **- Definition \***

    Enter the JavaScript code for your function. If you need inspiration, refer to our [GitHub repository with function examples]().

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

* [Revoke a Function](revoke-a-function.md)
* [Manually Run a Function on a Case or an Alert](run-a-function-case-alert.md)
* [Delete a Function](delete-a-function.md)