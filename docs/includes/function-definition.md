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
        * The `context` parameter: This provides access to TheHive’s environment, allowing your function to [interact with common TheHive actions](/thehive/user-guides/organization/configure-organization/manage-functions/functions-objects/).