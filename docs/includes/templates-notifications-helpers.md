!!! tip "Conditional helpers using [Mustache syntax](https://mustache.github.io/)"
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