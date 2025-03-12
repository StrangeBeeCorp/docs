# Variable Usage Examples

This topic provides examples of variable usage in the context of configuring [notifications](about-notifications.md) in TheHive.

## Examples

### EmailertoAddr notifier

**Subject**

*Case #{{object.number}} severity reached {{object.severity}}*

**From**

*thehive@strangebee.com*

**To**

*{{user.email}}*

**Template**

```
Hello,

The following case severity reached {{object.severity}}.

Case details:
Number: {{object.number}}
Title: {{object.title}}
Owner: {{object.assignee}}
Description: {{object.description}}

You can review the case by clicking the following URL:
{{url}}

Regards,

TheHive Notification System
```

## Next steps

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