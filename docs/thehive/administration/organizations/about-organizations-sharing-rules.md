# About Organizations Sharing Rules

Sharing rules determine how cases, along with their tasks and observables, are shared with linked organizations.

## Global sharing rules

Global sharing rules define how newly created cases and their related tasks and observables are shared at the organization level with linked organizations. The configuration determines whether this sharing occurs automatically.

TheHive requires setting these rules:

* For cases when [linking organizations](link-an-organization.md)
* For tasks and observables when [creating an organization](create-an-organization.md)

!!! info "Managing sharing rules for existing cases"
    Global sharing rules apply only to newly created cases. Existing cases and their related tasks and observables remain unaffected. Applying sharing rules to existing cases requires manual configuration for each case. See [Local sharing rules](#local-sharing-rules) for details.

## Local sharing rules

Local sharing rules customize how cases and their associated tasks and observables are shared at the case level with linked organizations. They apply to both new and existing cases and override global sharing rules defined when linking and creating organizations. The configuration determines whether this sharing occurs automatically.

Local sharing rules are useful in the following scenarios:

* [Global sharing rules](#global-sharing-rules) are already defined for newly created cases, but the same rules need to apply to an existing case.
* One or more cases require different sharing settings that don't follow the global sharing rules.

Follow these step-by-step instructions to:

* [Set up local sharing rules for an existing case](../../user-guides/analyst-corner/cases/share-a-case.md)
* [Set up local sharing rules when creating a case](../../user-guides/analyst-corner/cases/create-a-new-case.md)

## Manual sharing of tasks and observables in a shared case

Manual sharing allows selective sharing of tasks and observables within a shared case. This approach is useful when task and observable sharing rules are set to *manual*, enabling users to share only the content that is relevant.

Follow these step-by-step instructions to learn how to:

* [Share a Task with Other Organizations](../../user-guides/analyst-corner/tasks/share-a-task.md)
* [Share an Observable with Other Organizations](../../user-guides/analyst-corner/cases/share-an-observable.md)

## How sharing rules work together

| Cases ↓ \ Tasks and observables → | *manual* | *autoShare* |
|----------------------------------------------------------|--------------------------------------|--------------------------------------|
| *default* | Cases aren't automatically shared. | Cases aren't automatically shared, and neither are their tasks and observables. |
| *supervised* | Cases are automatically shared with an analyst-type permission profile without their linked tasks and observables.| Cases are automatically shared with an analyst-type permission profile with their linked tasks and observables. |
| *notify* | Cases are automatically shared with a read-only permission profile without their linked tasks and observables. | Cases are automatically shared with a read-only permission profile with their linked tasks and observables. |

## Deletion behavior

Only the organization that owns a shared case can delete it and its tasks or observables. When a shared case is deleted, it's automatically removed from all organizations it was shared with. The same applies when individual tasks or observables are deleted.

<h2>Next steps</h2>

* [Link an Organization](link-an-organization.md)
* [Share a Case](../../user-guides/analyst-corner/cases/share-a-case.md)
* [Share a Task with Other Organizations](../../user-guides/analyst-corner/tasks/share-a-task.md)
* [Share an Observable with Other Organizations](../../user-guides/analyst-corner/cases/share-an-observable.md)