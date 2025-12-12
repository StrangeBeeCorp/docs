# Add a Local Slack Endpoint

<!-- md:permission `manageConfig` -->

Add a local *Slack* [endpoint](../manage-endpoints/about-endpoints.md) in TheHive to send messages to your Slack workspace.

{% include-markdown "includes/local-global-endpoints.md" %}

<h2>Procedure</h2>

1. {% include-markdown "includes/organization-view-go-to.md" %}

    ---

2. {% include-markdown "includes/endpoints-tab-go-to.md" %}

    ---

3. Select :fontawesome-solid-plus:.

    ---

4. In the **Endpoint creation** drawer, select *Slack*.

    ---

5. Enter the following information:

    **- Name**

    The endpoint name, used to identify this Slack integration in TheHive. This name must be unique, as two endpoints can't have the same name.

    **- Token**

    The authentication token required to connect to Slack.

    ---

6. {% include-markdown "includes/proxy-settings.md" %}

    ---

7. {% include-markdown "includes/certificate-authority.md" %}

    ---

8. {% include-markdown "includes/host-name-verification.md" %}

    ---

9. Select **Confirm**.

<h2>Next steps</h2>

* [Configure the Slack Notifier](../manage-notifications/notifiers/slack.md)