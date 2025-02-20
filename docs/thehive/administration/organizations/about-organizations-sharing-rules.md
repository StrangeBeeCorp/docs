# About Organizations Sharing Rules

Sharing rules determine how cases, along with their tasks and observables, are shared with linked organizations.

This topic explains how sharing rules work and interact.

## Global sharing rules

{!includes/administrator-access-manage-organizations.md!}

Global sharing rules define how newly created cases and their related tasks and observables are shared at the organization level with linked organizations. The configuration determines whether this sharing occurs automatically.

You must set global sharing rules:

* For cases when [linking organizations](link-an-organization.md)
* For tasks and observables when [creating an organization](create-an-organization.md)

!!! info "Managing sharing rules for existing cases"
    Global sharing rules apply only to newly created cases. Existing cases and their related tasks and observables remain unaffected. To apply sharing rules to existing cases, you must configure them manually, [one case at a time](#local-sharing-rules).

## Local sharing rules

Local sharing rules let you customize sharing settings with linked organizations for both new and existing cases, including their related tasks and observables. They override the global sharing rules set at the organization level when linking organizations and creating organizations.

Local sharing rules are useful in the following scenarios:

* You have defined [global sharing rules](#global-sharing-rules) for newly created cases but want to apply the same rules to an existing case.
* You need to apply different sharing rules to one or more cases instead of following the global sharing rules.

{!includes/access-manage-case-sharing.md!}

Follow these step-by-step instructions to see:

* [How to set up local sharing rules for an existing case](../../user-guides/analyst-corner/cases/share-a-case.md)
* [How to set up local sharing rules for a new case](../../user-guides/analyst-corner/cases/create-a-new-case.md)

## Manual sharing of tasks and observables in a shared case

You can manually share tasks and observables in a shared case. 

This is useful when task and observable sharing rules are set to *manual*, ensuring that users share only the relevant tasks and observables.

Follow these step-by-step instructions to learn how to:

* [Share a Task with Other Organizations](../../user-guides/analyst-corner/tasks/share-a-task.md)
* [Share an Observable with Other Organizations](../../user-guides/analyst-corner/cases/share-an-observable.md)

## How sharing rules work together

| Cases ↓ \ Tasks and observables → | *manual* | *autoShare* |
|----------------------------------------------------------|--------------------------------------|--------------------------------------|
| *default* | New cases aren't automatically shared. | New cases aren't automatically shared, and neither are their tasks and observables. |
| *supervised* | New cases are automatically shared without their linked tasks and observables.| New cases are automatically shared with their linked tasks and observables. |
| *notify* | New cases are automatically shared without their linked tasks and observables. | New cases are automatically shared with their linked tasks and observables. |

## Next steps

* [Link an Organization](link-an-organization.md)
* [Share a Case](../../user-guides/analyst-corner/cases/share-a-case.md)
* [Share a Task with Other Organizations](../../user-guides/analyst-corner/tasks/share-a-task.md)
* [Share an Observable with Other Organizations](../../user-guides/analyst-corner/cases/share-an-observable.md)