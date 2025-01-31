# How to Link an Organization

This topic provides step-by-step instructions for linking an [organization](about-organizations.md) to another in TheHive.

By default, organizations in TheHive are not linked. Each organization operates independently and cannot access others on the instance.

Link organizations to enable data sharing and define the applicable sharing rules.

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
    
