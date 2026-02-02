# Tutorial: Set Up TheHive Portal Access

<!-- md:version 5.6 --> <!-- md:license Platinum -->

We're going to set up access to [TheHive Portal](about-thehive-portal.md) in TheHive, enabling controlled collaboration with stakeholders outside your Security Operations Center (SOC) team. By the end, you'll have configured the necessary permissions and created external user accounts.

!!! warning "Before you begin"
    Ensure you have [configured an SMTP server](../../administration/smtp/configure-smtp-server.md) before starting. External users need to receive invitation emails to access the portal.

## Step 1: Verify external profiles

<!-- md:permission `[admin] manageProfile` -->

After upgrading to TheHive 5.6, the platform automatically creates [two external profiles](../../administration/profiles/about-profiles.md#predefined-profiles). Let's verify they're available and understand their purposes.

1. {% include-markdown "includes/entities-management-view-go-to.md" %}

2. Select the **Profiles** tab.

3. Locate the two new predefined profiles:

    * External-Reader: Provides read-only access to shared cases
    * External-Actor: Allows collaboration on the shared cases

    !!! info "Predefined profiles"
        You can't modify or delete these profiles.

4. Review the permissions assigned to each profile to understand what external users can do.

5. Optional: [Create additional custom external profiles](../../administration/profiles/create-a-profile.md) if your organization needs different permission combinations.

## Step 2: Create external user accounts

<!-- md:permission `[admin] manageUser` --> <!-- md:permission `manageUser` -->

Now we'll create accounts for external stakeholders who need portal access.

!!! note "Existing user accounts"
    You can't change user account types after creation. Converting a Normal user to an external user requires [deleting the existing account](../../user-guides/organization/configure-organization/manage-user-accounts/delete-a-user-account.md) and recreating it with the External type.

Follow the instructions in [Create a User Account](../../user-guides/organization/configure-organization/manage-user-accounts/create-a-user-account.md), selecting **External** as the account type.

When you create an external user account, TheHive automatically sends an invitation email that expires after 24 hours. This email explains the portal's purpose, why they've been granted access, and includes a secure link to set up their account. To modify the expiration period, see [Configure an SMTP Server](../../administration/smtp/configure-smtp-server.md).

## Step 3: Grant case access permissions

<!-- md:permission `[admin] manageProfile` -->

The default Org-Admin profile automatically receives the `manageCaseAccess/external` permission during the upgrade, allowing it to share cases with external stakeholders. For other profiles, you must add this permission manually.

Follow the instructions in [Add or Remove Permissions from a Profile](../../administration/profiles/add-remove-permissions-from-a-profile.md).

TheHive Portal access is now configured—your external stakeholders can receive invitations, set up their accounts, and begin collaborating on shared cases with your SOC team in a controlled environment.

<h2>Next steps</h2>

* [Share a Case with External Users](../../user-guides/analyst-corner/cases/case-thehive-portal/share-case-external-users.md)