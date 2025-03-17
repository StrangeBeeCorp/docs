# How to Edit an Alert Feeder

This topic provides step-by-step instructions for editing an [alert feeder](about-feeders.md) in TheHive.

{!includes/access-feeders.md!}

## Procedure

!!! warning "Names of the alert feeder and the function can't be changed after creation"
    You can't change the alert feeder name or the feeder function name after they are created. To modify them, you must [delete](delete-a-feeder.md) the existing alert feeder and [create](create-a-feeder.md) a new one.

1. {!includes/organization-view-go-to.md!}

    ---

2. Select the **Connectors** tab.

    Image

    ---

3. Select the alert feeder you want to edit, or select :fontawesome-solid-ellipsis: next to the alert feeder and then select **Edit**.

    ---

4. In the **General settings** section, enter the following information:

    **- Interval**

    How often the alert feeder sends requests to the external system. Make sure the interval is shorter than the processing time to avoid potential issues.

    **- Request timeout time**

    The maximum time, in seconds, the alert feeder waits for a response before timing out.

    **- Request response max size**

    The maximum response size, in megabytes, that the alert feeder accepts from the external system.

    **- Description**

    A description to provide additional context or notes about the alert feeder configuration.

    ---

5. In the **HTTP request** section, enter the following information:

    **- Method**

    The HTTP method to use when requesting data from the external system.

    **- URL**

    The endpoint URL of the external system.

    ---

6. {!includes/headers.md!}

    ---

7. {!includes/authentication-type.md!}

    ---

8. {!includes/proxy-settings.md!}

    ---

9. {!includes/certificate-authority.md!}

    ---

10. {!includes/host-name-verification.md!}

    ---

11. Select **Test connection** to verify the connection to the external system.

    ---

12. Create a function to map fields from the external system to TheHive’s format:

    **- Description**

    Describe what the function does.

    **- Definition**

    {!includes/function-definition.md!}

    ---

13. {!includes/test-function.md!}

    ---

14. Select **Confirm**.

## Next steps

* [Create an Alert Feeder](create-a-feeder.md)
* [Turn Off an Alert Feeder](turn-off-a-feeder.md)
* [Delete an Alert Feeder](delete-a-feeder.md)