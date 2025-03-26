# How to Write a FilteredEvent Trigger

This topic provides step-by-step instructions for writing a *FilteredEvent* [trigger](../manage-notifications/about-notifications.md#triggers) in TheHive.

!!! info "Capabilities of the *FilteredEvent* trigger"
    Read this [StrangeBee blog post](https://blog.strangebee.com/leveraging-thehive5-notification-capabilities-2-2/) for an introduction to the capabilities of *FilteredEvent* trigger.

{!includes/access-notifications.md!}

<h2>Procedure</h2>

1. {!includes/organization-view-go-to.md!}

    ---

2. {!includes/notifications-tab-go-to.md!}

    ---

3. Select :fontawesome-solid-plus: or **Add a new notification**.

    ---

4. Select the *FilteredEvent* trigger.

    Selecting *FilteredEvent* opens a field where you can define a custom filter. These filters apply to all actions recorded in the organization's [audit logs](../../about-audit-logs.md). When an action matches the filter criteria, a notification is triggered.

    ---
    
5. Write your filter.

    !!! tip "Operators"
        To learn more about using operators, see the [About FilteredEvent Trigger Operators](about-filtered-event-trigger-operators.md) topic.

    To access a specific field within a JSON object, use dot (`.`) notation to navigate through nested properties.

    For example `object.severity` retrieves the `severity`field from the following JSON structure:

    ```json
    {
    "object": {
        "severity": 3
    }
    }
    ```

    ---

6. Select the relevant notifiers to configure them:
    * [Configure the EmailerToAddr Notifier](../manage-notifications/notifiers/email-to-addr.md)
    * [Configure the HttpRequest Notifier](../manage-notifications/notifiers/http-request.md)
    * [Configure the Mattermost Notifier](../manage-notifications/notifiers/mattermost.md)
    * [Configure the Slack Notifier](../manage-notifications/notifiers/slack.md)
    * [Configure the Teams Notifier](../manage-notifications/notifiers/teams.md)
    * [Configure the webhook Notifier](../manage-notifications/notifiers/webhook.md)
    * [Configure the Kafka Notifier](../manage-notifications/notifiers/kafka.md)
    * [Configure the Redis Notifier](../manage-notifications/notifiers/redis.md)
    * [Configure the RunAnalyzer Notifier](../manage-notifications/notifiers/analyzers.md)
    * [Configure the RunResponder Notifier](../manage-notifications/notifiers/responders.md)
    * [Configure the Function Notifier](../manage-notifications/notifiers/function.md)

## Examples

* An case severity has been updated to High or Critical:

```json
{
    "_and": [
        {
            "_is": {
                "action": "update"
            }
        },
        {
            "_is": {
                "objectType": "Case"
            }
        },
        {
            "_gte": {
                "details.severity": 3
            }
        }
    ]
}
```

* An alert has been closed without an assigned user:

```json
{
    "_and": [
        {
            "_is": {
                "objectType": "Alert"
            }
        },
        {
            "_is": {
                "details.stage": "Closed"
            }
        },
        {
            "_not": {
                "_has": "object.assignee"
            }
        },
        {
            "_not": {
                "_has": "details.assignee"
            }
        }
    ]
}
```

* An observable was updated with a report from analyzer `Crt_sh_Transparency_Logs_1_0`:

```json
{
    "_and": [
        {
            "_is": {
                "action": "update"
            }
        },
        {
            "_is": {
                "objectType": "Observable"
            }
        },
        {
            "_has": "details.reports.Crt_sh_Transparency_Logs_1_0"
        }
    ]
}
```

* The responder has finished:

```json
{
    "_and": [
        {
            "_is": {
                "action": "update"
            }
        },
        {
            "_is": {
                "objectType": "Action"
            }
        },
        {
            "_or": [
                {
                    "_is": {
                        "details.status": "Success"
                    }
                },
                {
                    "_is": {
                        "details.status": "Failure"
                    }
                }
            ]
        }
    ]
}
```

* The case is updated with a status of `TruePositive` or `FalsePositive`, and the custom field `business-unit` is set to either `Sales` or `Marketing`:

```json
{
    "_and": [
        {
            "_is": {
                "action": "update"
            }
        },
        {
            "_is": {
                "objectType": "Case"
            }
        },
        {
            "_or": [
                {
                    "_is": {
                        "details.status": "TruePositive"
                    }
                },
                {
                    "_is": {
                        "details.status": "FalsePositive"
                    }
                }
            ]
        },
        {
            "_or": [
                {
                    "_is": {
                        "object.customFieldValues.business-unit": "Sales"
                    }
                },
                {
                    "_is": {
                        "object.customFieldValues.business-unit": "Marketing"
                    }
                }
            ]
        }
    ]
}
```

* Analyzer `EmlParser_2_1` completed with a success status:

```json
{
    "_and": [
        {
            "_is": {
                "objectType": "Job"
            }
        },
        {
            "_is": {
                "object.analyzerName": "EmlParser_2_1"
            }
        },
        {
            "_is": {
                "object.status": "Success"
            }
        }
    ]
}
```

<h2>Next steps</h2>

* [Configure the EmailerToAddr Notifier](../manage-notifications/notifiers/email-to-addr.md)
* [Configure the HttpRequest Notifier](../manage-notifications/notifiers/http-request.md)
* [Configure the Mattermost Notifier](../manage-notifications/notifiers/mattermost.md)
* [Configure the Slack Notifier](../manage-notifications/notifiers/slack.md)
* [Configure the Teams Notifier](../manage-notifications/notifiers/teams.md)
* [Configure the webhook Notifier](../manage-notifications/notifiers/webhook.md)
* [Configure the Kafka Notifier](../manage-notifications/notifiers/kafka.md)
* [Configure the Redis Notifier](../manage-notifications/notifiers/redis.md)
* [Configure the RunAnalyzer Notifier](../manage-notifications/notifiers/analyzers.md)
* [Configure the RunResponder Notifier](../manage-notifications/notifiers/responders.md)
* [Configure the Function Notifier](../manage-notifications/notifiers/function.md)