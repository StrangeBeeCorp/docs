# How to Manage Organizations

!!! warning "Administrator access required"
    Only users assigned to the Admin organization with a profile that includes the `manageOrganisation` permission can create an organization in TheHive.

## Add an organization

1. As an administrator, go to the **Organizations** view from the sidebar menu.

    ![Organizations view](../../images/administration-guides/manage-organizations-organizations-view.png)

2. Select :fontawesome-regular-square-plus:

3. Edit the required fields in the **Adding an organization** pane:

    **Name**

    Enter the name of your new organization.

    **Description**

    Enter the description of your new organization.

    **Tasks sharing rule**

    Define the sharing rule for tasks when a case is shared with another organization. (lier avec la page qui explique comment faire ça)

    Two values are available:
        * Manual (default): This means you will have to authorize manually the sharing when sharing a case and specify a profile with certain permissions
        * AutoShare: 

    **Observables sharing rule**

    Define the sharing rule for observables when a case is shared with another organization. (lier avec la page qui explique comment faire ça)

    Two values are available:
        * Manual (default)
        * AutoShare

4. Select **Confirm**.

5. On the organizations list, find your new organization, hover and select ![Eye](../../images/administration-guides/manage-organizations-eye.png).

6. Select the default organization logo to edit it.

7. Upload the image you want to use as the logo of your new organization.

Next steps: Add users to the organization
Link organizations

## Edit your organization

Once your organization is created:

* [users](./accounts.md) can be added
* [links](./organization-links.md) with other existing organizations created for the purpose of sharing cases.

## Lock an organization
An existing organization can be locked so that all users belonging to this one cannot log into it.