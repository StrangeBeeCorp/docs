## How to Create a Function

This topic provides step-by-step instructions for creating a [function](about-functions.md) in TheHive.

{!includes/access-functions.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

2. Select the **Functions** tab.

    ![Functions tab](../../images/user-guides/organization/configure-organization/manage-functions/functions-tab.png)

3. Select :fontawesome-solid-plus:.

4. In the **Create function** drawer:

    **Name \***

    Enter the function name, which you will use in your HTTP call to invoke the function.

    **Mode \***

    Select the mode you want to apply to the function. For more details on the available options, see [About Functions](about-functions#function-modes).

    **Types \***

    Select the type of the function. For more details on the available options, see [About Functions](about-functions#function-types).

    **Description**

    Enter a brief description of the function’s purpose.

    **Definition \***

    Enter the JavaScript code for your function. If you need inspiration, refer to our [GitHub repository with function examples]().

5. Select the **Test function** section to test your function.

    Enter input data in the **Input** field. 

    Select:
    * **Result** to view the output of your function
    * **stdout** to display standard program output
    * **stderr** to display errors and warnings

6. Select **Save**. 

## Next steps

* [Revoke a Function](revoke-a-function.md)