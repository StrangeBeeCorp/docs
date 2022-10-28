# GDPR 

TheHive has a feature dedicated to manage data retention policy in the database, which is not enabled by default.

## Strategies

Two strategies are possibile: 

* Delete the data
* Replace sensitive values with `<redacted>`

### Replace values with `<redacted>`

For cases, the following fields are redacted:

* `summary` and `message` of the case
* `message` of comments
* `message` in task logs
* `message` of observables, for datatypes selected and filled in  the `gdpr.dataTypesToDelete` configuration property
* `content` of pages
* `description` of procedures in TTPs

 
For alerts, the following fields are redacted:

*  `message` of the alert
*  `message` of observables (cf. `gdpr.dataTypesToDelete` configuration property)
*  `description` of procedures (ttp)

For audits:

*  the field `details` is redacted

### Delete data

If the strategy `delete` is selected:

  * The case and its components - _tasks, task logs, procedures, comments, pages, custom events in timelines, values of custom field and observables_ -  are deleted
  * The alert and its components - _procedures, comments, values of custom field and observables_ -  are deleted.
  * The audit is deleted


## Configuration 

To enable it, the configuration file `/etc/thehive/application.conf` should be updated. Add the following configuration to the file: 

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
        
        retentionPeriod = 2 years
    
        ## Advanced parameters (should not be modified)
        
        jobTimeout = 24 jours ## maximum time the job is executed
        batchSizeCase = 5     ## how many cases if processed per transaction
        batchSizeAlert = 10   ## how many cases if processed per transaction
        batchSizeAudit = 100  ## how many cases if processed per transaction
    }
    ```

Then restart the application.
