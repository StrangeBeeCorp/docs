# Enable the GDPR Compliance Feature

<!-- md:version 5.0 --> <!-- md:license Platinum -->

We're going to configure TheHive to automatically manage data retention according to GDPR requirements. By the end, you'll have automated data cleanup running on a schedule, ensuring your organization maintains compliance with data protection regulations.

{% include-markdown "includes/maintenance-window-required.md" %}

## Step 1: Choose your GDPR strategy

Let's decide how TheHive should handle data that exceeds your retention period. We've two strategies available, each suited to different compliance needs.

### Option 1: Delete strategy

This strategy permanently removes documents older than the retention period.

It affects:

* [Cases](../user-guides/analyst-corner/cases/about-cases.md) and associated components (tasks, task logs, procedures in TTPs, comments, pages, custom events in timelines, custom field values, attachments, and observables)
* [Alerts](../user-guides/analyst-corner/alerts/about-alerts.md) and associated components (procedures in TTPs, comments, custom field values, attachments, and observables)
* [Audit logs](../user-guides/organization/about-audit-logs.md)

Choose this strategy if you need complete data removal for compliance.

### Option 2: Redact strategy

This strategy replaces sensitive values with `<redacted>`.

For cases, it redacts:

* `summary` and `message` of the case
* `message` of comments
* `message` in task logs
* `message` of observables: deleted if they belong to the data type included in the `gdpr.dataTypesToDelete` configuration property, otherwise replaced with `<redacted>`.
* `content` of pages
* `description` of procedures in TTPs

!!! danger "Attachments not redacted"
    Attachments remain visible and accessible. You must manually delete them to fully remove sensitive data.

For alerts, it redacts:

* `message` of the alert
* `message` of observables: deleted if they belong to the data type included in the `gdpr.dataTypesToDelete` configuration property, otherwise replaced with `<redacted>`.
* `description` of procedures in TTPs

!!! danger "Attachments not redacted"
    Attachments remain visible and accessible. You must manually delete them to fully remove sensitive data.

For audit logs, it redacts:

* `details`

## Step 2: Stop TheHive service

Stop TheHive before applying changes to avoid conflicts.

!!! info "Service commands"
    For stop/restart commands depending on your installation method, refer back to the relevant installation guide.

## Step 3: Configure GDPR settings in TheHive

Now we'll add the GDPR configuration.

1. Open the `application.conf` file using a text editor.

2. Add the GDPR configuration block.

    Here's an example using the `delete` strategy:

    ```yaml
    gdpr {
      enabled = true
      schedule = "0 30 2 ? * SUN"
      strategy = "delete"
      # dataTypesToDelete = [] ## ["ip", "domain"]
      retentionPeriod = 730 days
  
      ## Advanced parameters (modify only if needed)
      
      jobTimeout = 24 days ## Maximum time the job can run before being stopped
      batchSizeCase = 5     ## How many cases are processed per transaction
      batchSizeAlert = 10   ## How many alerts are processed per transaction
      batchSizeAudit = 100  ## How many audit logs are processed per transaction
    }
    ```

3. Customize the configuration for your needs.

    a. Adjust the schedule of the job.

    Use this [Cron tutorial](https://www.quartz-scheduler.org/documentation/quartz-2.3.0/tutorials/crontrigger.html) for more information.

    b. Choose your strategy.

    Keep `delete` for complete removal. Change to `redact` for sensitive data replacement.

    If you've chosen `redact`, uncomment the `dataTypesToDelete` parameter and enter the observable data types you want to delete. Other data types will be replaced with `<redacted>`.

    c. Set your retention period.

    It's calculated based on the last update date, or creation date if never updated.

    The format for `retentionPeriod` supports various time units:

    * day:         `d`, `day`
    * hour:        `h`, `hr`, `hour`
    * minute:      `m`, `min`, `minute`
    * second:      `s`, `sec`, `second`
    * millisecond: `ms`, `milli`, `millisecond`

4. Save your modifications in the `application.conf` file.

## Step 4: Restart TheHive service

Restart TheHive to apply the new configuration.

## Step 5: Verify GDPR job scheduling

Let's check TheHive logs for GDPR initialization:

```bash
grep -i "gdpr" /var/log/thehive/application.log
```

You should see confirmation that GDPR is enabled and scheduled.

<h2>Next steps</h2>

* [Perform Initial Login and Setup as an Admin](../administration/perform-initial-setup-as-admin.md)