!!! tip "Helpers using [Mustache syntax](https://mustache.github.io/)"

    ### **Data transformation helpers**

    | Helper | Description | Usage | Output |
    |---     |---          |---    |---     |
    | `tlpLabel` | Format the `tlp` field of the object | `{{ tlpLabel object.tlp }} ` | `Amber` |
    | `papLabel` | Format the `pap` field of the object | `{{ papLabel object.pap }} ` | `Amber` |
    | `severityLabel` | Format the `severity` field of the object | `{{ severityLabel object.severity }} ` | `Critical` |
    | `dateFormat` | Format a date field of the object using [Java date time patterns](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/SimpleDateFormat.html) | `{{dateFormat audit._createdAt "EEEEE dd MMMMM yyyy" "fr" }}` | `jeudi 01 septembre 2022` |

    Standard string helpers can be found in [the official Handlebars documentation](https://www.javadoc.io/static/com.github.jknack/handlebars/4.1.0/index.html?com/github/jknack/handlebars/helper/StringHelpers.html).

    ### **Conditional helpers**

    Examples:

    * Displays *Medium* if `case.severity` equals 2, otherwise displays *Other*:

    ```
    {{#if (eq case.severity 2) }}
        Medium
    {{else}}
        Other 
    {{/if}}
    ```

    * Displays the threat actor value only if `case.customFieldValues.threat-actor` is defined:

    ```
    {{#if case.customFieldValues.threat-actor}}
        Threat Actor: {{case.customFieldValues.threat-actor}}
    {{/if}}
    ```

    Find additional supported operators in [the official Handlebars documentation](https://www.javadoc.io/static/com.github.jknack/handlebars/4.1.0/com/github/jknack/handlebars/helper/ConditionalHelpers.html).