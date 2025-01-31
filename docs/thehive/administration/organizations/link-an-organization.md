# How to Link an Organization

This topic provides step-by-step instructions for linking an [organization](about-organizations.md) to another in TheHive.

By default, organizations in TheHive are not linked. Each organization operates independently and cannot access others on the instance.

Link organizations to enable data sharing between them. You can define how cases are shared with the other organization and vice versa.

{!includes/administrator-access-manage-organizations.md!}

## Procedure

1. Select the organization to link to another, then select **Linked organizations**. Alternatively, hover over the organization and select ![Eye](../../images/administration-guides/manage-organizations-eye.png).

    ![Link an organization](../../images/administration-guides/link-an-organization.png)

2. Select **Manage linked organizations**.

3. Select the organizations you want to link to your organization.

4. Choose the case-sharing rules between the organizations in both directions using the **Choose a link type** dropdown lists.

    Options are the followings:
    - *default*: Cases will not automatically shared with the other organization. It will require a manual action from you to be shared.
    - *supervised*: Cases will automatically be shared with the other organization with an analyst-type permission profile.
    - *notify*: Cases will automatically be shared with the other organization with the read-only permission profile.

    !!! warning "Sharing rules"
        The case-sharing rule set when linking an organization overrides the task and observable sharing rules set when [creating the organization](add-an-organization.md).

        For example, if you select the *default* option, you will have to manually share the case afterwards even if you mentioned the *autoShare* option when defining the task and observable sharing rule when creating the organization.

        The same way, if you select the *supervised* or *notify* options, but selected the *manual* option when defining the task and observable sharing rule when creating the organization, you will have to share it manually from the task view.

        You can modify the task and observables rules at a case level from a case at any time so that new tasks or observables are automaticaaly shared.

        C'est seulement à la création que c'est automatique. Si cases déjà existants, il faut faire une action bulk pour les partager en masse. Expliquer la méthode la plus efficace.
    
