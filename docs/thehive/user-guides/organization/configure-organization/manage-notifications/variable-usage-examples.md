# Variable Usage Examples

This topic provides examples of variable usage in the context of configuring [notifications](about-notifications.md) in TheHive.

## Examples

### EmailertoAddr notifier

**Subject**

*Case #{{object.number}} serverity reached {{object.severity}}*

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

!!! tip "Conditional helpers"
    Example: 
    ```
    {{#if (eq object.severity 2) }}MEDIUM {{else}}Other {{/if}}
    ```
    Find additional supported operators in [the official Handlebars documentation](https://www.javadoc.io/static/com.github.jknack/handlebars/4.1.0/com/github/jknack/handlebars/helper/ConditionalHelpers.html).

!!! tip "Data formatting helpers"
    The following helpers are available to format your data:
    | Helper | Description | Usage | Output |
    |---     |---          |---    |---     |
    | `tlpLabel` | Format the `tlp` field of the object | `{{ tlpLabel object.tlp }} ` | `Amber` |
    | `papLabel` | Format the `pap` field of the object | `{{ papLabel object.pap }} ` | `Amber` |
    | `severityLabel` | Format the `severity` field of the object | `{{ severityLabel object.severity }} ` | `Critical` |
    | `dateFormat` | Format a date field of the object using [Java date time patterns](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/SimpleDateFormat.html) | `{{dateFormat audit._createdAt "EEEEE dd MMMMM yyyy" "fr" }}` | `jeudi 01 septembre 2022` |

    **String helpers**
    Standard string helpers can be found in [the official Handlebars documentation](https://www.javadoc.io/static/com.github.jknack/handlebars/4.1.0/index.html?com/github/jknack/handlebars/helper/StringHelpers.html).

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