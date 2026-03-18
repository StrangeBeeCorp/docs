# About Email Intake Connectors

<!-- md:license Gold --> <!-- md:license Platinum -->

Organizations that receive alert data by email can use email intake connectors to automate alert creation in TheHive.

## Usage

Email intake connectors automatically processes incoming emails and creates alerts in TheHive.

Each alert includes the following observables:

* The email file (`.eml`)
* The sender's email address
* Any file attachments

The email body isn't parsed for observables by default. To extract them, run the *EmlParser* analyzer manually, or [automate extraction using a notification](../../user-guides/automate-extraction-observables-from-emails.md).

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
* [Automate Extraction of Observables from Emails](../../user-guides/automate-extraction-observables-from-emails.md)