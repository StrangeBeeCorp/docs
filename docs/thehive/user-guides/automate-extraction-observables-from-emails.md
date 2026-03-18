# Tutorial: Automate Extraction of Observables from Emails

<!-- md:permission `manageConfig` --> <!-- md:license Gold --> <!-- md:license Platinum -->

When an [email intake connector](../administration/email-intake-connector/about-email-intake-connectors.md) processes an incoming email, it creates an alert in TheHive with several observables, including the email file itself. However, the email body isn't parsed for observables by default—you need to run the *EmlParser* analyzer to extract them.

In this tutorial, we're going to set up an automation in TheHive that runs the *EmlParser* analyzer automatically each time an email intake alert is created.

!!! warning "Prerequisites"
    This tutorial assumes you've already [configured an email intake connector](../administration/email-intake-connector/connect-a-mailbox.md) for your TheHive instance.

By the end, you'll have a working configuration that:

* Detects when an observable is created from an email intake connector alert
* Automatically runs the *EmlParser* analyzer to extract observables from the email body

This eliminates the need to manually run the analyzer for each email alert.

## Step 1: Create a notification triggered by email intake alerts

1. {% include-markdown "includes/organization-view-go-to.md" %}

2. {% include-markdown "includes/notifications-tab-go-to.md" %}

3. Select :fontawesome-solid-plus:.

4. In the **Add notification** drawer, enter the name of the notification: `EmailObservableExtractionNotification`

5. Select the *FilteredEvent* trigger.

6. Enter the following custom filter to match observable creation events from email intake alerts:

    ```json
    {
        "_and": [
            {
                "_is": {
                    "action": "create"
                }
            },
            {
                "_is": {
                    "objectType": "Observable"
                }
            },
            {
                "_is": {
                    "object.alert.type": "email-intake"
                }
            }
        ]
    }
    ```

## Step 2: Configure a *RunAnalyzer* notifier

1. In your current notification, select the [*RunAnalyzer* notifier](./organization/configure-organization/manage-notifications/notifiers/analyzers.md).

2. In the **RunAnalyzer** drawer, select **EmlParser**.

3. Select **Confirm**.

That's it—every time a new email intake observable is created, TheHive will automatically run the *EmlParser* analyzer to extract observables from the email content.

<h2>Next steps</h2>

* [About Email Intake Connectors](../administration/email-intake-connector/about-email-intake-connectors.md)
* [Connect a Mailbox](../administration/email-intake-connector/connect-a-mailbox.md)
* [Manually Trigger Email Fetch in a Mailbox](../administration/email-intake-connector/fetch-emails.md)
