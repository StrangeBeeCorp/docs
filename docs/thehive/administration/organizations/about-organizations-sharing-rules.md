# About Organizations Sharing Rules

Sharing rules define how cases are shared with linked organizations.

These rules also interact with the sharing rules for [tasks](../../user-guides/analyst-corner/tasks/about-tasks.md) and observables, which are configured when creating an organization.

This topic explains how these sharing rules function and work together.

## Global sharing rules

{!includes/administrator-access-manage-organizations.md!}

Global sharing rules, set when [linking organizations](link-an-organization.md) for cases and [creating an organization](create-an-organization.md) for tasks and observables, define how newly created cases and their related tasks and observables are shared at the organization level with linked organizations.

The configuration determines whether this sharing occurs automatically.

!!! info "Managing sharing rules for existing cases"
    Global sharing rules apply only to newly created cases. Existing cases and their related tasks and observables remain unaffected. To apply sharing rules to existing cases, you must configure them manually, [one case at a time](#local-sharing-rules).

## Local sharing rules

Local sharing rules allow you to customize sharing settings with linked organizations for a case. They override the global sharing rules set at the organization level when linking organizations and creating organizations.

Local sharing rules are useful in the following scenarios:

* You have defined [global sharing rules](#global-sharing-rules) for newly created cases but want to apply the same rules to an existing case.
* You need to apply different sharing rules to one or more cases instead of following the global sharing rules.

{!includes/access-manage-case-sharing.md!}

### Sharing an existing case

You can share an existing case by modifying its sharing rules directly within the case settings.

Follow this step-by-step instructions to see [how to share an existing case](../../user-guides/analyst-corner/cases/share-a-case.md).

### Modify tasks and observables sharing rules for an existing case

You can modify the tasks and observables sharing rules for an existing case by updating the configuration directly within the case settings.

Follow this step-by-step instructions to see [how to share tasks on an existing case](../../user-guides/analyst-corner/tasks/share-a-task.md).

Follow this step-by-step instructions to see [how to share observables on an existing case](../../user-guides/analyst-corner/cases/share-an-observable.md).

!!! tip "Sharing rules override"
    The new local sharing rules defined for tasks and observables within a case override the global configuration set when creating an organization.

## How sharing rules work together

| Cases ↓ \ Tasks and observables → | *manual* | *autoShare* |
|----------------------------------------------------------|--------------------------------------|--------------------------------------|
| *default* | New cases are not automatically shared. | New cases are not automatically shared, and neither are their tasks and observables. |
| *supervised* | New cases are automatically shared without their linked tasks and observables.| New cases are automatically shared with their linked tasks and observables. |
| *notify* | New cases are automatically shared without their linked tasks and observables. | New cases are automatically shared with their linked tasks and observables. |

## Next steps

* [Link an Organization](link-an-organization.md)
* [Share a Case](../../user-guides/analyst-corner/cases/share-a-case.md)
* [Share a Task](../../user-guides/analyst-corner/tasks/share-a-task.md)
* [Share an Observable](../../user-guides/analyst-corner/cases/share-an-observable.md)