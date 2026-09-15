# Configure a Flow Node

<!-- md:version 6.0 --> <!-- md:permission `manageOrchestrator/writeWorkflows` --> <!-- md:license One -->

Flow nodes control how workflows branch, loop, process multiple items, or pause in [TheHive Flow](about-flow.md). An execution path ends when it reaches a node with no next step.

## Configure a *For each* flow node

A *For each* flow node iterates over each item in an array or object that matches a [jq expression](https://jqlang.org/){target=_blank}, executing the same sequence of nodes for each entry.

Each iteration is independent. To collect results across iterations, declare [loop output variables](about-flow.md#variables) when configuring the node, or process each result directly within the loop.

!!! tip "Nested loops"

    *For each* nodes can be nested: a *For each* node can contain another *For each* node in its body, to iterate over multi-level data structures.

1. {% include-markdown "includes/flow-view-go-to.md" %}

2. Select a workflow from the list.

3. Drag the previous node connector to an empty area of the canvas.

    ![Drag a node connector to an empty area](../images/drag-node-empty-area.gif)

4. In the **What is the next step?** drawer, select **Flows**.

5. Select *For each*.

6. In the **For each** drawer, enter a [jq expression](https://jqlang.org/manual/){target=_blank} that selects the items to iterate over.

    The expression must return a JSON array or object. The node then iterates over each item in the result.

    You can select [variables](about-flow.md#variables) using the **$var** button.

    {% include-markdown "includes/variable-access-direct-flow.md" %}

    Use an online [jq playground](https://www.devtoolsdaily.com/jq_playground/){target=_blank} to validate your expressions before adding them to the workflow.

    !!! example "Examples"
    
        * `$<node_name>.body.items`: Iterates over each item in the `items` array from the node's response body.
        * `$<node_name>.output.tasks`: Iterates over each task returned by the node.
        * `$<node_name>.output.tasks | map(select(.status == "Waiting"))`: Filters tasks with status `"Waiting"`, then iterates over the result.

7. Optional: Turn on the **Parallel execution** toggle to run iterations simultaneously instead of one at a time, then enter a **Max parallelism** value to cap how many run concurrently.

    * In sequential mode (default), iterations run one at a time. The loop stops on the first error.
    * In parallel mode, iterations run concurrently up to the configured limit. The node waits for the running iterations to settle, then reports the errors from all failed iterations together.

8. Optional: To collect results across iterations, go to the **Loop output variables** section and select :fontawesome-solid-plus:.

    Enter a **Variable name** and a **JQ value** referencing an output of a node in the `Loop` branch. The expression is evaluated after each iteration, and the values are aggregated across all iterations and available as [loop output variables](about-flow.md#variables) in the nodes that follow the loop.

!!! note "Branches"

    The *For each* node has two branches:

    | Branch | Description |
    |--------|-------------|
    | `Loop` branch | Connects to nodes that execute for each item in the collection. The current item is available as `item` and its key as `idx` as output variables in all nodes on this branch. |
    | `Done` branch | Connects to nodes that execute once, after all iterations have completed. |

## Configure an *If* flow node

An *If* flow node evaluates a [jq expression](https://jqlang.org/){target=_blank} and directs execution down two branches based on the boolean result: `true` or `false`.

!!! tip "Multiple conditions"

    The *If* node evaluates a single condition. To implement switch/case logic with multiple possible values, chain several *If* nodes in sequence, each handling one case on its `false` branch.

1. {% include-markdown "includes/flow-view-go-to.md" %}

2. Select a workflow from the list.

3. Drag the previous node connector to an empty area of the canvas.

    ![Drag a node connector to an empty area](../images/drag-node-empty-area.gif)

4. In the **What is the next step?** drawer, select **Flows**.

5. Select *If*.

6. In the **If** drawer, enter your [jq expression](https://jqlang.org/manual/){target=_blank} for the condition.

    The expression must evaluate to a boolean.

    You can select [variables](about-flow.md#variables) using the **$var** button.

    {% include-markdown "includes/variable-access-direct-flow.md" %}

    Use an online [jq playground](https://www.devtoolsdaily.com/jq_playground/){target=_blank} to validate your expressions before adding them to the workflow.

    !!! example "Examples"

        * `$<node_name>.code == 200`: Returns `true` if the HTTP status code is 200.
        * `$<node_name>.output.severity == "High" or $<node_name>.output.severity == "Critical"`: Returns `true` if the severity is `"High"` or `"Critical"`.
        * `$<node_name>.output.id != null`: Returns `true` if the field is present.

!!! note "Branches"

    The *If* node has two branches:

    | Branch | Description |
    |--------|-------------|
    | `true` branch | Connects to nodes that execute when the condition evaluates to `true`. |
    | `false` branch | Connects to nodes that execute when the condition evaluates to `false`. |

    Both branches don't have to converge. The following are all valid:

    * Configure only the `true` branch and leave the `false` branch empty—the workflow ends silently on that branch.
    * Merge both branches into a common node.
    * End each branch on a completely separate path.

## Configure a *Sleep* flow node

A *Sleep* flow node pauses the execution path for a specified duration. When the duration elapses, execution continues with the next node.

Use it to wait between two actions, for example to let an external system finish processing before querying its result.

1. {% include-markdown "includes/flow-view-go-to.md" %}

2. Select a workflow from the list.

3. Drag the previous node connector to an empty area of the canvas.

    ![Drag a node connector to an empty area](../images/drag-node-empty-area.gif)

4. In the **What is the next step?** drawer, select **Flows**.

5. Select *Sleep*.

6. In the **Sleep** drawer, enter a **Duration** and select its unit: seconds, minutes, or hours.

    The minimum duration is 1 second.

    !!! warning "The duration can't exceed the timeouts"

        If the duration is longer than the node timeout or the [workflow timeout](manage-workflows.md#create-a-workflow), the shortest timeout takes precedence: the execution times out before the pause completes. The editor flags such a duration when configuring the node.

<h2>Next steps</h2>

* [Manage Global Variables](manage-global-variables.md)
* [Add a Trigger](add-trigger.md)
* [Configure a Transformation Node](configure-transformation-node.md)
* [Configure an Action Node](configure-action-node.md)
* [Configure an Integration Node](configure-integration-node.md)
* [Manually Run a Workflow](manually-run-workflow.md)