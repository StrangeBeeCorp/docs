# About Email Intake Connectors

<!-- md:license Gold --> <!-- md:license Platinum -->

This topic explains what email intake connectors are in TheHive.

Organizations that receive alert data by email can use email intake connectors to automate the creation of alerts in TheHive.

## Usage

Email intake connectors integrate mailboxes that receive alerts. 

It automatically processes incoming emails, extracts relevant information, and creates alerts within TheHive platform. The email itself, its sender, and any attached files are automatically added as observables within the respective alerts.

!!! tip "Parsing emails"
    The content of the email itself isn't automatically parsed when creating the alert. To enable observable extraction, a [notification](../../user-guides/organization/configure-organization/manage-notifications/create-a-notification.md) must trigger [a FilteredEvent](../../user-guides/organization/configure-organization/manage-notifications/write-filtered-event-trigger.md) that [runs the *EmlParser* analyzer](../../user-guides/organization/configure-organization/manage-notifications/notifiers/analyzers.md).

    Below is an example of the FilteredEvent trigger:

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
    Only the prefilled values for the `tags`, `source`, and `type` fields allow modification. Changes to other fields aren't allowed.

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

Only users with an admin-type profile that has the `managePlatform` permission can manage email intake connectors in TheHive.

<h2>Next steps</h2>

* [Connect a Mailbox](connect-a-mailbox.md)
* [Delete a Mailbox](delete-a-mailbox-connection.md)
* [Manually Trigger Email Fetch in a Mailbox](fetch-emails.md)