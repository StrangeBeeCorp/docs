# How to Create a Custom Field

This topic provides step-by-step instructions for creating a [custom field](../custom-fields/about-custom-fields.md) in TheHive.

!!! warning "Administrator access required"
    Only administrators have the ability to create custom fields in TheHive.

## Procedure

1. As an administrator, go to the **Entities management** view from the sidebar menu.

    ![Entities management](../../images/administration-guides/create-a-custom-field-entities-management.png)

2. Select the **Custom fields** tab.

    ![Custom fields tab](../../images/administration-guides/create-a-custom-field-custom-fields.png)

3. Select :fontawesome-regular-square-plus:.

4. Enter the following information:

    **Display name**

    Enter the name users will see when adding this custom field to their cases or alerts.

    **Technical name**

    By default, this is automatically generated from the display name but can be adjusted if needed. The technical name is not visible to users when adding a custom field but is used when accessing the custom field via the API.

    **Description**

    Provide a description to help users understand and use this custom field appropriately.

    **Group name**

    Choose an existing group name or type a new one to create a new group.

    **Data type**

    Specify the type of data the custom field will contain:

    {!includes/custom-fields-formats.md!}

    !!! info "Predefined values"
        For the string, integer, and float formats, you can define predefined values by entering each value on a separate line. If you choose to do this, users will only be able to select from the predefined values you specify.

    **If this custom field must be filled by users, turn on the Mandatory toggle.**

5. Select **Confirm custom field creation**.

## Next steps

* [Add Custom Fields](../../user-guides/analyst-corner/cases-list/add-custom-fields.md)
