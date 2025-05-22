# About Tasks

This topic explains tasks, their components, and their behavior in TheHive.

## Definition

A task represents one or more actions, called [task logs](../tasks/about-task-logs.md)—also referred to as activities—that must be completed within a [case](../cases/about-cases.md).

* Tasks can be mandatory or optional.
* Tasks are organized into groups for better structure and management.

## Sources

Tasks can be created manually or automatically through [alert feeders](../../organization/configure-organization/manage-feeders/about-feeders.md).

## Statuses

The following task statuses are available in TheHive:

* *In progress*
* *Waiting*
* *Cancelled*
* *Completed*

Task statuses are hard-coded. They can't be modified, deleted, or extended.

Mandatory tasks can’t be marked as *Completed* unless at least [one task log has been created](create-a-task-log.md).

## Behavior

### Requiring actions on a task

You can require users in any of your organizations to take action on a task. However, once the action is completed, the task's status remains unchanged. This is useful when you need input or assistance from someone in another team or business unit without affecting the task’s workflow.

### Highlighting important tasks

In TheHive, you can make important tasks stand out using the following options:

* [Pin a task](manage-a-task.md#pin-a-task): Pin a task to access it from the **Tasks** tab within a case.
* [Flag a task](manage-a-task.md#flag-a-task): Flag a task to highlight it for all users in your organization, making it more visible in the task list.

### Closing a case with open tasks

* When you [close a case](../cases/close-a-case.md), all associated tasks are automatically closed, even if some non-mandatory tasks are still incomplete or unassigned.

* However, if any mandatory tasks aren't completed, you won't be able to close the case.

## Permissions

{!includes/access-manage-tasks.md!}

<h2>Next steps</h2>

* [Find a Task](../tasks/search-for-tasks/find-a-task.md)
* [Create a Task](create-a-task.md)
* [Share a Task](share-a-task.md)
* [Change a Task Status](change-task-status.md)
* [Manage Tasks](manage-a-task.md)
* [Delete a Task](delete-a-task.md)
* [Create a Task Log](../tasks/create-a-task-log.md)
* [Run Responders and Review Reports for a Task](../tasks/run-responders-on-a-task.md)