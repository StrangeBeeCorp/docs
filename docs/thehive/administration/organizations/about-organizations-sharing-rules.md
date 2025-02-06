# About Organizations Sharing Rules

Sharing rules define how cases are shared with linked organizations.

Sharing rules for [tasks](../../user-guides/analyst-corner/tasks/about-tasks.md) and observables are also set when you create an organization.

This topic explains how these sharing rules function and work together.

## Global sharing rules

{!includes/administrator-access-manage-organizations.md!}

Global sharing rules are set when [linking organizations](link-an-organization.md) for cases and [creating an organization](create-an-organization.md) for tasks and observables. They define how newly created cases and their related tasks and observables are shared at the organization level with linked organizations.

The configuration determines whether this sharing occurs automatically.

!!! info "Managing sharing rules for existing cases"
    Global sharing rules apply only to newly created cases. Existing cases and their related tasks and observables remain unaffected. To apply sharing rules to existing cases, you must configure them manually, [one case at a time](#local-sharing-rules).

## Local sharing rules

Local sharing rules let you customize sharing settings with linked organizations for an existing case and its related tasks and observables. They override the global sharing rules set at the organization level when linking organizations and creating organizations.

Local sharing rules are useful in the following scenarios:

* You have defined [global sharing rules](#global-sharing-rules) for newly created cases but want to apply the same rules to an existing case.
* You need to apply different sharing rules to one or more cases instead of following the global sharing rules.

{!includes/access-manage-case-sharing.md!}

Follow these step-by-step instructions to see [how to modify the sharing rules of an existing case](../../user-guides/analyst-corner/cases/share-a-case.md).

## Manual sharing of tasks and observables in a shared case

You can manually share tasks and observables in a shared case. 

This is useful when task and observable sharing rules are set to *manual* to ensure that users manually select which tasks and observables to share.

Follow these step-by-step instructions to learn how to:

* [Share a Task](../../user-guides/analyst-corner/tasks/share-a-task.md)
* [Share an Observable](../../user-guides/analyst-corner/cases/share-an-observable.md)

## How sharing rules work together

| Cases ↓ \ Tasks and observables → | *manual* | *autoShare* |
|----------------------------------------------------------|--------------------------------------|--------------------------------------|
| *default* | New cases aren't automatically shared. | New cases aren't automatically shared, and neither are their tasks and observables. |
| *supervised* | New cases are automatically shared without their linked tasks and observables.| New cases are automatically shared with their linked tasks and observables. |
| *notify* | New cases are automatically shared without their linked tasks and observables. | New cases are automatically shared with their linked tasks and observables. |

## Next steps

* [Link an Organization](link-an-organization.md)
* [Share a Case](../../user-guides/analyst-corner/cases/share-a-case.md)
* [Share a Task](../../user-guides/analyst-corner/tasks/share-a-task.md)
* [Share an Observable](../../user-guides/analyst-corner/cases/share-an-observable.md)