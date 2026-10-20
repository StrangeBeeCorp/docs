!!! tip "Variables"
    Insert a variable with the **$var** button, or enter `$` and select a variable from the suggestions. To access a field, select the variable to edit its jq expression, or use the **+** button to insert the variable and the field together.

    Inside the expression, jq functions transform the value before it's inserted in the field. The whole expression stays inside the blue reference, for example:

    * `$<node_name>.body.results[0].id`: Reads the first identifier of an API response.
    * `$<node_name>.body.items | map(.name) | join(", ")`: Turns a list of objects into a comma-separated text.
    * `$<node_name>.body.createdAt / 1000 | todate`: Formats a TheHive date, a Unix timestamp in milliseconds, as an ISO 8601 date.
    * `$<node_name>.output.title | ascii_upcase`: Converts a text to uppercase.

    See [Jq Functions](/flow/user-guides/jq-functions/) for the full list of available functions.
