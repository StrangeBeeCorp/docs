# GDPR Compliance in TheHive 5.x

TheHive includes a specialized feature for managing data retention policies within the database. By default, this feature is not enabled and must be configured based on your organisation's GDPR compliance needs.

!!! Info
    This feature is exclusively available with TheHive 5.x Platinum plan.


---

## Strategies

There are two primary strategies available:

* [Replace Sensitive Values with `<redacted>`](#replace-values-with-redacted)
* [Delete Data](#delete-data)

&nbsp;

### Replace Sensitive Values with `<redacted>`

Under this strategy, sensitive information is redacted from specific fields within TheHive, including:

&nbsp;

For cases, the following fields are redacted:

* `summary` and `message` of the case
* `message` of comments
* `message` in task logs
* `message` of observables, for datatypes selected and filled in the `gdpr.dataTypesToDelete` configuration property
* `content` of pages
* `description` of procedures in TTPs

&nbsp;

For alerts, the following fields are redacted:

*  `message` of the alert
*  `message` of observables (`gdpr.dataTypesToDelete` configuration property)
*  `description` of procedures (TTP)

&nbsp;

For audits:

*  the field `details` is redacted

&nbsp;

### Delete Data

Selecting the `delete` strategy will permanently remove the following components:

* Cases and associated components (tasks, task logs, procedures, comments, pages, custom events in timelines, custom field values, and observables)
* Alerts and associated components (procedures, comments, custom field values, and observables)
* Audits

---

## Retention

The `retentionPeriod` parameter specifies the minimum age of data subject to deletion or redaction. The GDPR process is applied to data older than this specified period, calculated based on the last update date (or creation date if never updated). The format for `retentionPeriod` supports various time units:

  * day:         `d`, `day`
  * hour:        `h`, `hr`, `hour`
  * minute:      `m`, `min`, `minute`
  * second:      `s`, `sec`, `second`
  * millisecond: `ms`, `milli`, `millisecond`

For example, 365 days denotes a retention period of 1 year.

---

## Configuration 

To enable GDPR compliance, follow these steps:

1. Update the configuration file /etc/thehive/application.conf with the following settings:

!!! Example ""

    ```
    gdpr {
        enabled = true
    
        ## Format http://www.quartz-scheduler.org/documentation/quartz-2.3.0/tutorials/crontrigger.html
        ## Every Sunday at 02:30
        
        schedule = "0 30 2 ? * SUN"
    
        ## Possible GDPR strategies:
        ##   delete: remove the documents
        ##   redact: replace sensitive values by "<redacted>" (cf. dataTypesToDelete)
        
        strategy = "delete"
        
        ## if the strategy is "redacted", the observable with dataType in 
        ## "dataTypesToDelete" will be removed
        ## for other observables, message will be "<redacted>", not the data
        ## Uncomment following line to select datatypes
        
        # dataTypesToDelete = [] ## ["ip", "domain"]
    
        ## only documents older than the "retentionPeriod" will be processed

        retentionPeriod = 730 days # 2 years
    
        ## Advanced parameters (should not be modified)
        
        jobTimeout = 24 days ## maximum time the job is executed
        batchSizeCase = 5     ## how many cases is processed per transaction
        batchSizeAlert = 10   ## how many cases is processed per transaction
        batchSizeAudit = 100  ## how many cases is processed per transaction
    }
    ```

2. Save the changes to the configuration file.

3. Restart TheHive application to apply the new settings.

By following these steps, you can effectively implement GDPR-compliant data retention policies within TheHive 5.x. Adjust the configuration parameters as per your organisation's specific requirements and compliance standards.

&nbsp;