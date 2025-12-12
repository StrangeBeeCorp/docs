# Ignore Alert Updates from MISP

<!-- md:permission `manageAlert/update` -->

Ignore alert updates from the Malware Information Sharing Platform [(MISP)](../../../administration/misp-integration/about-misp-integration.md) in TheHive to prevent automatic changes to specific alerts.

MISP is an open-source threat intelligence platform that integrates with TheHive to retrieve events from MISP servers and convert them into alerts. By default, TheHive automatically updates these alerts when the corresponding MISP events change, which may also update the alerts’ statuses.

!!! warning "Requirements"
    Automatic alert updates are available only for alerts created through [MISP server integrations](../../../administration/misp-integration/connect-a-misp-server.md).

<h2>Procedure</h2>

1. [Find the alert](./search-for-alerts/find-an-alert.md) you want to exclude from automatic updates.

2. In the alert, select **Ignore new updates**.

    ![Ignore MISP updates](../../../images/user-guides/analyst-corner/alerts/alert-ignore-misp-updates.png)

<h2>Next steps</h2>

* [Change an Alert Status](change-status-alert.md)
* [Start Working on an Alert](start-investigating-an-alert.md)
* [Assign an Alert](assign-an-alert.md)