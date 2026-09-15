Configure whether the node fails on error responses.

By default, the node fails when the response returns a `4xx` or `5xx` error status code. Turn on **Ignore error status codes** to make the node succeed regardless of the response status code, then handle errors in the workflow, for example with an [*If* flow node](/flow/user-guides/configure-flow-node/#configure-an-if-flow-node) evaluating the `code` output. Error responses aren't retried when the option is on.

Transport failures, such as DNS, connection, TLS, or timeout errors, still fail the node.
