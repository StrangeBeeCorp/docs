# Release Notes of 5.2 series

!!! danger
    The 5.2 release comes with some changes on the database schema that can't be reversed. Please make sure to make a backup of your database before upgrading.

    This release also comes with some breaking changes, please review them below

!!! info
    An [upgrade guide](../setup/installation/upgrade-from-5.0.x.md) is available to help you migrate from TheHive 5.0



!!! Warning "UNDER CONSTRUCTION"

## 5.1.2 - 14th March 2023

### Fixes

**Backend:**

- Fix SSO user autocreate
- Improve the application behavior when Janusgraph configuration gets updated while another connection exists
- Fix permission checks for case template creation
- Fix permission checks on pages
- Improve the observable type length check

**Cortex connector:**

- Send the submit message to Cortex job actor when the transaction is committed
- Improve Cortex pending jobs recovery
- Fix: Recover only 100 jobs at startup. When the queue is empty, recover 100 more jobs.
- Updates of job with status “Deleted” are retried
- Improve logs

**MISP connector:**

- MISP synchronisation misses some events in case of timeouts during synchronization

**UI:**

- Refresh the task list when after bulk editing of assignee
- Fix tooltip overlap in some dashboard widgets
- Dashboard labels for cases/alerts are mixed
- Remove owner field from dashboard import drawer
- Fix the UI refresh when launching an analyzer job
- Fix incorrect search when click on donut due to persisting keyword "domain"
- Fix Customfield selector in case template editor
- Improve notifier name and suffix with using an existing endpoint

## 5.1.1 - 3rd March 2023

### Fixes

**API:**

- Fix a change in the observable creation API (regression from 5.0)

**UI:**

- Date fields can be set using keyboard input

## 5.1.0 - 1st March 2023

### Breaking changes

- Remove support for Hadoop for filestorage

    From this new release, Hadoop can no longer be used a file storage (it was removed from 5.0 documentation but could still be used)

- Drop support for java 8

    Java 8 version is no longer supported by TheHive. Please update to java 11 at least
    Our [setup guide](../setup/installation/step-by-step-guide.md) can help you on how to install a jvm

- Drop support for Lucene as index backend

    Former versions of TheHive supported lucene and elasticsearch as indexing engines for the data. We then encountered limitations while using the Lucene index (especially when making queries based on Custom Fields). With TheHive 5.0, we pushed users to install and migrate to Elasticsearch. Finally with TheHive 5.1, the support of Lucene index is removed: the application will start but queries involving Custom Fields will return wrong results.
    To migrate your index to Elasticsearch, follow [this guide](../setup/operations/change-index.md).

### Main features

- Apply case template on existing case: enrich a case with tasks, custom fields, tags from other case templates

    This will allow your organisation to create more reusable case templates and apply them during the lifecycle of a case

- KPIs

    Get more indicators about your organisation response: Time to Respond, Time to Acknowledge ...

- Global search

    You can now search on all elements of the database instead of choosing a scope

- Custom Field db model update

    Database model was updated to be able to better support dashboard and queries based on custom fields. Now dashboard using filters or aggregation on custom fields should be way faster

- New permissions

    Split some permissions to make them more granular. For instance `manageAlert` was split into 4 permissions: `manageAlert/create`, `manageAlert/delete`, `manageAlert/update`, `manageAlert/import`. Case permissions were also split

- History list for object

    Added a new tab in the UI to list the changes made on an Alert or Case.

- Mandatory Tasks

    Some tasks can be defined as mandatory. To close a case, those tasks need to be closed and contain at least one activity.

- SAML Support

    You can now use SAML as an SSO source for your users (requires platinum license)

- Functions (Beta)

    See [dedicated page](../user-guides/organisation/functions.md) for more information (requires platinum license)

### Other features

- New type of custom fields: url
- Change case ownership
- Similarity between observable now works with observable of kind attachment
- Improve Cortex connector resources usage
- Dashboards on org creation: default dashboards are now provided to new orgs
- Add cache for dashboard
- Auto import observables from Cortex: when an analyzer extract observables into its report, it can flag some observable to be automatically imported into the case/alert
- Experimental support for Elasticsearch 8
- Rework UX to add TTP
- Move interface date format to user settings (and localstorage) instead of org settings

### Fixes

- Notifications improvement: notifications are now triggered for each observable when creating an alert with multiple observables
- Several other fixes in the application and UI
