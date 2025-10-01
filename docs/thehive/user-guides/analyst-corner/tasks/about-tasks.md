# About Tasks

This topic explains tasks, their components, and their behavior in TheHive.

## Definition

A task represents one or more actions, called [task logs](../tasks/about-task-logs.md)—also referred to as activities—that must be completed within a [case](../cases/about-cases.md).

* Tasks can be mandatory or optional.
* Tasks organize into groups to improve structure and management.

## Sources

Create tasks manually or automatically using [alert feeders](../../organization/configure-organization/manage-feeders/about-feeders.md).

## Statuses

The following task statuses are available in TheHive:

* *In progress*
* *Waiting*
* *Cancelled*
* *Completed*

Task statuses are hard-coded. They can't be modified, deleted, or extended.

Marking mandatory tasks as *Completed* requires [creating at least one task log](create-a-task-log.md).

## Behavior

### Requiring actions on a task

Require users in any organization to take action on a task. After completion, the task's status remains unchanged. This approach facilitates input or assistance from other teams or business units without impacting the task’s workflow.

### Highlighting important tasks

TheHive provides the following options to highlight important tasks:

* [Pin a task](manage-a-task.md#pin-a-task): Pin a task to access it from the **Tasks** tab within a case.
* [Flag a task](manage-a-task.md#flag-a-task): Flag a task to highlight it for all users in an organization, making it more visible in the task list.

### Closing a case with open tasks

* [Closing a case](../cases/close-a-case.md) automatically closes all associated tasks, even if some non-mandatory tasks remain incomplete or unassigned.

* However, the case can't be closed if any mandatory tasks remain incomplete.

## Permissions

{% include-markdown "includes/access-manage-tasks.md" %}

<h2>Next steps</h2>

* [Find a Task](../tasks/search-for-tasks/find-a-task.md)
* [Create a Task](create-a-task.md)
* [Share a Task](share-a-task.md)
* [Change a Task Status](change-task-status.md)
* [Manage Tasks](manage-a-task.md)
* [Delete a Task](delete-a-task.md)
* [Create a Task Log](../tasks/create-a-task-log.md)
* [Run Responders and Review Reports for a Task](../tasks/run-responders-on-a-task.md)