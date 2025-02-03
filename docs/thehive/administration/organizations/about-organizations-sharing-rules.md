# About Organizations Sharing Rules

When [linking organizations](link-an-organization.md), you must define sharing rules for [cases](../../user-guides/analyst-corner/cases/about-a-case.md). Additionally, sharing rules for [tasks](../../user-guides/analyst-corner/tasks/about-a-task.md) and observables within cases are set when [creating an organization](create-an-organization.md).

This topic explains how sharing rules work and interact with each other.

{!includes/administrator-access-manage-organizations.md!}

## How sharing rules apply

When you define a sharing rule for cases, tasks, or observables, it applies only to new cases created after the rule takes effect.

You can [modify sharing rules for tasks and observables individually](../../user-guides/analyst-corner/cases/modify-task-observable-sharing-rules-for-a-case.md) fo each case that will apply for each new case only. 

Si on s'est trompé en mettant qu'on voulait pas partager les tasks et observables, impossible de les partager manuellement. Il faut départager le case, enregistrer, puis repartager le case en modificant la task et observable sharing rule sur le case en question.

To share existing cases, tasks, or observables created before the rule was implemented, you must share them manually by sharing a case and select the autoShare opion for task and observable:
* [Share a Case](../../user-guides/analyst-corner/cases/share-a-case.md)
* Share a Task
* Share an Observable

Voir autorisation demandée pour share un case : manageShare ou juste manageCase

## How sharing rules work together

| Cases sharing rule ↓ \ Tasks and observables sharing rule → | *manual* | *autoShare* |
|----------------------------------------------------------|--------------------------------------|--------------------------------------|
| *default* | New cases are not shared | New cases are shared with linked tasks and observables |
| *supervised* | New cases are shared without linked tasks and observables| New cases are shared with linked tasks and observables |
| *notify* | New cases are shared without linked tasks and observables| New cases are shared with linked tasks and observables |

The case-sharing rule set when linking an organization overrides the task and observable sharing rules set when [creating the organization](add-an-organization.md).

For example, if you select the *default* option, you will have to manually share the case afterwards even if you mentioned the *autoShare* option when defining the task and observable sharing rule when creating the organization.

The same way, if you select the *supervised* or *notify* options, but selected the *manual* option when defining the task and observable sharing rule when creating the organization, you will have to share it manually from the task view.

You can modify the task and observables rules at a case level from a case at any time so that new tasks or observables are automaticaaly shared.

C'est seulement à la création que c'est automatique. Si cases déjà existants, il faut faire une action bulk pour les partager en masse. Expliquer la méthode la plus efficace.