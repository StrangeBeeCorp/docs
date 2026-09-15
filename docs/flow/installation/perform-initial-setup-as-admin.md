# Perform TheHive Flow Initial Setup as an Admin

<!-- md:version 6.0 --> <!-- md:permission `[admin] manageProfile` --> <!-- md:license One -->

After [deploying TheHive Flow](docker.md), complete the setup in TheHive as an administrator by granting users access to the **Flow** view. Users with the predefined Org-Admin or Analyst profile have access automatically: for all other users, grant the permissions through a custom profile.

!!! warning "Requirement"
    This procedure assumes that TheHive Flow is [deployed](docker.md) and running.

Access to TheHive Flow is controlled by six permissions, grouped under **Manage Flow** in the [profile](../../thehive/administration/profiles/about-profiles.md) editor.

| Permission | Grants |
| ---------- | ------ |
| **Read Flow workflows** | Displaying the **Flow** view and the workflow pages |
| **Write Flow workflows** | Creating, editing, and running workflows |
| **Delete Flow workflows** | Deleting workflows |
| **Read Flow variables** | Displaying the [global variables](../user-guides/glossary-flow.md#global-variable) page |
| **Write Flow variables** | Creating and editing global variables |
| **Delete Flow variables** | Deleting global variables |

The permissions are independent: a write or delete permission doesn't include the matching read permission. Grant the matching read permission alongside write or delete, because a user with **Write Flow workflows** alone can't display the workflow pages or run a workflow.

!!! note "Predefined profiles"
    The predefined Org-Admin and Analyst profiles include all six permissions. The other [predefined profiles](../../thehive/administration/profiles/about-profiles.md#predefined-profiles) include none of them. To grant access to users with another profile, [create](../../thehive/administration/profiles/create-a-profile.md) or [edit a custom profile](../../thehive/administration/profiles/add-remove-permissions-from-a-profile.md).

<h2>Procedure</h2>

1. {% include-markdown "includes/entities-management-view-go-to.md" %}

2. In the **Profiles** tab, select :fontawesome-solid-ellipsis: next to the profile you want to update.

3. Select **Edit**.

4. In the **Editing a profile** drawer, select the relevant permissions in the **Manage Flow** group.

5. Select **Confirm profile edition**.

<h2>Next steps</h2>

* [Build Your First Workflow](../user-guides/build-your-first-workflow.md)
* [Manage Workflows](../user-guides/manage-workflows.md)
* [Manage LLM Providers](../../thehive/administration/manage-llm-providers.md)
* [Deploy TheHive Flow with Docker Compose](docker.md)
