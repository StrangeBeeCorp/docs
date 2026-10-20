Configure whether the node fails on error responses.

By default, the node fails when the response returns a `4xx` or `5xx` error status code. Turn on **Ignore error status codes** to make the node succeed regardless of the response status code. Then handle errors in the workflow, for example with an [*If* flow node](/flow/user-guides/configure-flow-node/#configure-an-if-flow-node) evaluating the `code` output. Error responses aren't retried when the option is on.

Two cases still fail the node:

* A transport failure, such as a DNS, connection, TLS, or timeout error. The node sets no output.
* A response announced as JSON that can't be parsed. The node sets the `code` and `headers` outputs but no `body`, and isn't retried.

When **Ignore error status codes** is off, the node retries a `408`, `429`, or `5xx` response up to the number of times set in **Retry attempts**. Any other `4xx` response fails the node immediately, without retrying. When the called service includes a `Retry-After` header in its response, the node waits that long before the next attempt, up to a maximum of 5 minutes. This wait replaces the delay set by **Retry delay** and **Backoff**.
