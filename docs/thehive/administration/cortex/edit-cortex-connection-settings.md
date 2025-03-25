# How to Edit Cortex Connection Settings

This topic provides step-by-step instructions for editing [Cortex](about-cortex.md) connection settings in TheHive.

!!! info "Global settings"
    Editing Cortex connection settings applies to all Cortex servers.

{!includes/cortex-support-thehive-55.md!}

{!includes/administrator-access-manage-cortex-connection.md!}

## Procedure

1. {!includes/platform-management-view-go-to.md!}

2. {!includes/connectors-tab-go-to.md!}

3. Select the **Cortex** tab.

4. Enter the following information:

    **- Max retries on error**

    The number of times TheHive retries a failed request before stopping.

    **- Refresh delay**

    The time interval between refresh attempts for ongoing tasks.

    **- Frequency of status checks**

    How often TheHive checks the status of a running job.

    **- Maximum time TheHive waits for the job to complete**

    The longest duration TheHive waits before timing out a job.

## Next steps

* [Add a Cortex Server](add-a-cortex-server.md)