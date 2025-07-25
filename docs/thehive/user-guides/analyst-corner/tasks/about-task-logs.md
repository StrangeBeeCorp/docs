# About Task Logs

This topic explains what task logs are and how they're used in TheHive.

## Definition

A task log—also referred to as an activity—is where analysts record their actions, observations, and decisions in response to a [task](about-tasks.md).

## Sources

Analysts should create a task log whenever they perform or complete a meaningful action, observation, or decision related to the task. Certain task logs can be automated, but analytical insights and contextual observations typically require manual input.

## Examples

!!! warning "No observables allowed"
    Task logs should never include observables. Doing so can make data unsearchable, disorganized, and prevent export to MISP. Additionally, links within task logs are clickable, which can be risky.

Tasks logs can include actions such as:

* Investigating authentication, VPN, or endpoint activity
* Reviewing system or script execution logs
* Identifying signs of lateral movement or account compromise
* Running targeted scans for potential exposures

* Applying network or system-level containment measures

* Providing awareness or policy guidance to employees
* Implementing or reinforcing data protection policies

* Tuning detection rules for improved accuracy
* Updating workflows or processes based on incident findings

* Documenting insights or lessons learned

## Format

Task logs can include text using [TheHive-flavored Markdown syntax](../../thehive-flavored-markdown.md) or images.

Adding an image to a task log automatically saves it in the [**Attachments** tab of the case](../cases/attachments/about-attachments.md#cases).

## Permissions

{!includes/access-manage-tasks.md!}

<h2>Next steps</h2>

* [Create a Task Log](create-a-task-log.md)
* [Delete a Task Log](delete-a-task-log.md)
* [Find a Task Log](../tasks/search-for-tasks/find-a-task-log.md)
* [Find a Task](../tasks/search-for-tasks/find-a-task.md)