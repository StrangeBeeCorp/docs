# About Organizations Sharing Rules

Sharing rules define how cases are shared with linked organizations.

These rules also interact with the sharing rules for [tasks](../../user-guides/analyst-corner/tasks/about-a-task.md) and observables, which are configured when creating an organization.

This topic explains how these sharing rules function and work together.

## Global sharing rules

{!includes/administrator-access-manage-organizations.md!}

Global sharing rules set [at the organization level](create-an-organization.md) and when [linking organizations](link-an-organization.md) define how newly created cases, along with their related tasks and observables, are shared with linked organizations.

The configuration determines whether this sharing occurs automatically. For cases with automatic sharing enabled, you can assign a permission profile to linked organizations, selecting either analyst-type or read-only access.

!!! info "Managing sharing rules for existing cases"
    Global sharing rules apply only to newly created cases. Existing cases and their related tasks and observables remain unaffected. To apply sharing rules to existing cases, you must configure them manually, [one case at a time](#local-sharing-rules).

## Local sharing rules

Local sharing rules override the global sharing rules defined at the organization level and when linking organizations. This allows you to customize sharing settings for specific cases.

They are useful in the following scenarios:

* You have [global sharing rules](../../../administration/organizations/about-organizations-sharing-rules.md#global-sharing-rules) for newly created cases but want to apply the same rules to an existing case.
* You need to apply different sharing rules to one or more cases instead of following the global sharing rules.

{!includes/access-manage-case-sharing.md!}

### Sharing or unsharing an existing case

You can share or unshare an existing case by modifying its sharing rules directly within the case settings. 

Follow this step-by-step instructions to see [how to share or unshare an existing case](../../user-guides/analyst-corner/cases/share-a-case.md).

### Modify tasks and observables sharing rules for an existing case

You can modify the tasks and observables sharing rules for an existing case by updating the configuration directly within the case settings.

Follow this step-by-step instructions to see [how to share or unshare tasks on an existing case](../../user-guides/analyst-corner/tasks/share-unshare-a-task.md.md).

Follow this step-by-step instructions to see [how to share or unshare observables on an existing case](../../user-guides/analyst-corner/cases/share-unshare-an-observable.md).

!!! tip "Sharing rules override"
    The new local sharing rules defined for tasks and observables within a case will override the global configuration set at the organization level.

## How sharing rules work together

| Cases sharing rule ↓ \ Tasks and observables sharing rule → | *manual* | *autoShare* |
|----------------------------------------------------------|--------------------------------------|--------------------------------------|
| *default* | New cases are not automatically shared | New cases are not automatically shared, and neither are their tasks and observables |
| *supervised* | New cases are automatically shared without their linked tasks and observables| New cases are automatically shared with their linked tasks and observables |
| *notify* | New cases are automatically shared without their linked tasks and observables| New cases are automatically shared with their linked tasks and observables |

## Next steps

* [Link or Unlink an Organization](link-unlink-an-organization.md)
* [Share or Unshare a Case](share-unshare-a-case.md)
* [Share or Unshare a Task](../tasks/share-unshare-a-task.md)
* [Share or Unshare an Observable](share-unshare-an-observable.md)