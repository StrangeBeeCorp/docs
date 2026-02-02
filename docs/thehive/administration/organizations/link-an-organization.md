# Link an Organization

<!-- md:permission `[admin] manageOrganisation` -->

By default, organizations in TheHive aren't linked. Each organization operates independently and can't access others on the instance.

To allow case sharing with their related tasks and observables, link an [organization](about-organizations.md) to another and configure the corresponding global sharing rules at the organization level.

To learn more about how sharing rules function and interact, refer to [Organizations Sharing Rules](about-organizations-sharing-rules.md).

<h2>Procedure</h2>

1. Go to the **Organizations** view

    ![Organizations view](../../images/administration-guides/manage-organizations-organizations-view.png)

2. Select the organization to link to another, then select **Linked organizations**. Alternatively, hover over the organization and select :fontawesome-solid-eye:.

    ![Link an organization](../../images/administration-guides/link-an-organization.png)

3. Select **Manage linked organizations**.

4. Select the organizations you want to link to your organization.

5. Choose the case-sharing rules between the organizations in both directions using the **Choose a link type** dropdown lists.

    Options are the followings:  

    * **default**: Cases aren't automatically shared with the other organization. Users must [share them manually](../../user-guides/analyst-corner/cases/share-a-case.md).
    * **supervised**: Cases are automatically shared with the other organization with an analyst-type permission profile, which grants both read and write access to cases.
    * **notify**: Cases are automatically shared with the other organization with a read-only permission profile.

6. Select **Confirm**.
    
<h2>Next steps</h2>

* [Share a Case with Other Internal Organizations](../../user-guides/analyst-corner/cases/share-a-case.md)
* [Share a Task with Other Internal Organizations](../../user-guides/analyst-corner/tasks/share-a-task.md)
* [Share an Observable with Other Internal Organizations](../../user-guides/analyst-corner/cases/share-an-observable.md)