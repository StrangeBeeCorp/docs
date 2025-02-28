# How to Add a Microsoft Teams Endpoint

!!! warning "Migrating to the Workflows application for Microsoft Teams integration"
    With the 5.4.3 release, TheHive has updated the Microsoft Teams notifier in response to Microsoft's deprecation of the incoming webhooks. Users [must now migrate from the legacy webhook setup to a new configuration using the Workflows application](#migrate-to-the-latest-microsoft-teams-notifier-for-existing-users).

This topic provides step-by-step instructions for adding a Microsoft Teams [endpoint](../manage-endpoints/about-endpoints.md) in TheHive.

{!includes/access-endpoints.md!}

### Step 3: Enter the Required Information
Select *Teams* as the connector type and complete the necessary details.

<figure markdown>
  ![Teams endpoint configuration](../../../images/user-guides/organization/notifications/organization-endpoints-teams-configuration.png)
</figure>

- **Name**: Provide a unique name for the endpoint.
- **URL**: Enter the URL for connecting to Microsoft Teams. This URL should be the one copied from Power Automate when setting up the new workflow.
- **Auth Type**: Select an authentication method — *Basic Authentication*, *Key*, or *Bearer*.
- **Proxy settings**: Optionally, enable a web proxy to connect to this endpoint.
- **Certificate Authorities**: If required, add custom Certificate Authorities in PEM format.
- **SSL settings**: Optionally, disable Certificate Authority validation or hostname checks.

Once all fields are completed, click **Confirm** to create the endpoint.

---

!!! note "Migration from the legacy webhook setup"
      If you are using the legacy webhook setup, replace your current endpoint with the 

Migration Instructions for Current Users#
If you are currently using the legacy Teams webhook, follow these steps to migrate:

Complete the Create a New Power Automate Flow steps above to obtain the new HTTP POST URL.
Go to TheHive > Organization Admin > Endpoint > Connector Teams.
In the Teams webhook URL field, replace the existing webhook URL with the new HTTP POST URL from your Power Automate flow.
Click Save to apply the update.