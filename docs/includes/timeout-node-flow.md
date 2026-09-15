If no timeout is configured, the node runs until it completes or the workflow-level timeout is reached. If the timeout is reached, the node fails.

!!! tip "Global timeout vs. local timeout"
    A timeout for the entire workflow is defined when [creating the workflow](/flow/user-guides/manage-workflows/). When both a node timeout and a workflow-level timeout are defined, the shortest timeout value is applied.

| Field      | Description |
|------------|-------------|
| Timeout   | Maximum allowed execution time for the node, in seconds, minutes, or hours. The minimum value is 30 seconds. |
| Retry attempts   | Number of times the node is retried on failure. |
| Retry delay      | Time to wait between retry attempts, in seconds, minutes, or hours. Always set it when retry attempts are configured: without a delay, retries are effectively never scheduled. |
| Backoff      | Coefficient applied to the retry delay to increase the wait time after each failed attempt. |

!!! info "Retries and timeouts"
    If the node includes retry settings, the timeout applies to each attempt, not to the total duration of all attempts.