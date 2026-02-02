# Restrict Case Visibility

<!-- md:version 5.5 --> <!-- md:permission `manageCaseAccess/restrict` --> <!-- md:license Platinum -->

Restrict the [visibility of a case](../about-cases.md#case-visibility-restriction) in TheHive to limit access to specific authorized users for sensitive investigations.

!!! info "Limitation"
    [Cases shared with external users](../about-cases.md#thehive-portal-sharing) can't have their visibility restricted.

<h2>Procedure</h2>

1. [Find the case](../search-for-cases/find-a-case.md) you want to restrict.

2. {% include-markdown "includes/restrict-access-button.md" %}

3. In the **Case access management** drawer, select **Restricted**.

4. Select the authorized users.

    !!! warning "Mandatory authorized users"
        The case assignee and the user performing the action always have access and can't be removed.

5. Select **Confirm**.

    !!! info "Hang tight"
        It may take a few seconds to apply restricted visibility to all elements linked to the case, such as observables and tasks.

<h2>Next steps</h2>

* [Restore Case Visibility](restore-visibility-case.md)