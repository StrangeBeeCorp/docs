## How to Create a Function

This topic provides step-by-step instructions for creating a [function](about-functions.md) in TheHive.

{!includes/access-functions.md!}

## Procedure

1. {!includes/organization-view-go-to.md!}

2. Select the **Functions** tab.

    ![Functions tab](../../images/user-guides/organization/configure-organization/manage-functions/functions-tab.png)

3. Select :fontawesome-solid-plus:.

4. In the **Create function** drawer:

    **Name**

    Enter the function name, which you will use in your HTTP call to invoke the function.

    **Mode**

    Select the mode you want to apply to the function. For more details on the available options, see [About Functions](about-functions#function-modes).

    **Types**

    Select the type of the function. For more details on the available options, see [About Functions](about-functions#function-types).

    **Description**

    Enter a brief description of the function’s purpose.

    **Definition**

    Enter the JavaScript code for your function. If you need inspiration, refer to our [GitHub repository with function examples]().

5. Select **Test function** to test your function.

    Input data 

6. 

## Next steps

    - **Definition**: Write or paste the function's JavaScript code.
    - **Test Function**: You can test the function using input data.
    - **How to Call the Function**: Provides an example command for calling the function.
5. **Save the Function**: After completing the form, click **Save** to create the function.

&nbsp;

![Create function](../../images/user-guides/organization/functions_create.png)

---

## Call a Function

Once saved, the function can then be called with an http call from your system:

!!! Example ""

    ```bash
    curl -X POST -H 'Authorization: Bearer $API_KEY' https://<thehive_url>/api/v1/function/<function_name> -H 'Content-Type: application/json' --data '
    {
        "eventId": "d9ec98b1-410f-40eb-8634-cfe189749da6",
        "date": "2021-06-05T12:45:36.698Z",
        "title": "An intrusion was detected",
        "details": "An intrusion was detected on the server 10.10.43.2",
        "data": [
            {"kind": "ip", "value": "10.10.43.2", "name": "server-ip" },
            {"kind": "name", "value": "root", "name": "login" },
            {"kind": "ip", "value": "92.43.123.1", "name": "origin" }
        ]
    }
    '
    ```

TheHive will take your input (the body of the http call), the definition of your function and execute the function with the input.
It will respond to the HTTP call with the data returned by the function.