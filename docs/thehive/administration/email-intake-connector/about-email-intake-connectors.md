# About Email Intake Connectors

This topic explains what email intake connectors are in TheHive.

Email intake connectors are useful when your organization receives alerts via email and you want to automatically convert them into alerts within TheHive.

## Usage

Email intake connectors integrate mailboxes that receive cybersecurity alerts. 

It automatically processes incoming emails, extracts relevant information, and creates alerts within TheHive platform. The email itself, its sender, and any attached files are automatically added as observables within the respective alerts.

!!! tip "Parsing emails"
    The content of the email itself isn't automatically parsed when creating the alert. To enable automatic parsing and extraction of potential observables, you must [create a notification](../../user-guides/organization/configure-organization/manage-notifications/create-a-notification.md) triggered by [a FilteredEvent](../../user-guides/organization/configure-organization/manage-notifications/write-filtered-event-trigger.md) that [runs the *EmlParser* analyzer](../../user-guides/organization/configure-organization/manage-notifications/notifiers/analyzers.md).

    Below is an example of the FilteredEvent trigger you can use:

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

## Data mapping

### Alerts

| Alert field API | Alert field UI | Alert value |
|---|---|---|
| `title` | Title | The subject of the email. If empty, displays *no subject*. |
| `type` | Type | *email-intake* |
| `source` | Source | The formatted name of the email intake connector. |
| `sourceRef` | Reference | `{message-id}`, or `{lastUidValidity}.{uidEmail}` if the `message-id` is inaccessible. |
| `date` | Occurred date | The date the email was received. |
| `severity` | Severity | *low* |
| `tlp` | TLP | *amber* |
| `pap` | PAP | *amber* |
| `follow` | Track new updates | *false* |
| `tags` | Tags | [*email-intake*, `{source}`, `{provider name}`, `{inbox folder name}`] |
| `status` | Status | *new* | 
| `description` | Description | The content of the email. |

!!! info "Modification restrictions"
    You can only change the prefilled data for the `tags`, `source`, and `type` fields. Changes to other fields are not allowed.

### Observables

| Observable field API | Observable field UI | Observable value |
|---|---|---|
| `message` | Description | *Automatically created from email* followed by `{alert.id}` and either `{sender}` or `{file}`. |
| `tlp` | TLP | `{alert.tlp}` |
| `pap` | PAP | `{alert.pap}` |
| `ioc` | IOC | *false* |   
| `sighted` | Sighted | *false* | 
| `ignoreSimilarity` | Ignore similarity | *false* | 
| `dataType` | Data type | *file* for the email or *mail* for the sender's email address. |
| `tags` | Tags | `{alert.tags}` |

## Authorized email providers

The following email providers are available in TheHive:

* Google Workspace
* IMAP server
* Microsoft 365
* <!-- md:version 5.5 --> Microsoft Graph API

## Permissions

{!includes/administrator-access-manage-email-intake-connectors.md!}

<h2>Next steps</h2>

* [Connect a Mailbox](connect-a-mailbox.md)
* [Delete a Mailbox](delete-a-mailbox-connection.md)
* [Manually Trigger Email Fetch in a Mailbox](fetch-emails.md)