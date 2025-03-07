# Release Notes of 5.1 series

!!! danger
    The 5.1 release comes with some changes on the database schema that can't be reversed. Please make sure to make a backup of your database before upgrading.

    This release also comes with some breaking changes, please review them below

!!! info
    An [upgrade guide](../installation/upgrade-from-5.x.md) is available to help you migrate from TheHive 5.0

## 5.1.12 - 9th April 2024

- Fix a regression following a security fix that made the MFA authentication impossible.

## 5.1.11 - 4th April 2024

- Fix security vulnerability. An advisory will be published in the coming weeks.

## 5.1.10 - 21st December 2023

### Fixes

**Security:**

- Fix security vulnerabilities. Please read the [detailed advisories](https://github.com/StrangeBeeCorp/Security).


## 5.1.9 - 29th June 2023

### Fixes

**UI:**

- Fix display of task attachments in attachment listing
- Improve error message when merging cases

**Backend:**

- Fix error "Tag not Found" which could occur when creating alerts and cases
- Fix link duplication when importing several times a TTP catalog

### Improvements

**UI:**

- Improve form for SAML authentication

**Backend:**

- Add MISP event UUID to alert description in imported alerts
- Add validation for SAML configuration

## 5.1.8 - 20th June 2023

### Fixes

**UI:**

- Fix the order of Cortex job reports in observable page
- Add events related to case templates in live feed
- Change rules of user quota
- Display the callback URL in SAML configuration
- Fix icon in timeline
- Fix format of some old generated dashboard widgets

**Backend:**

- Change format of the date custom field values Ids
- Fix between filter on custom fields
- Ldap sync: add support of several mapping for the same group
- Ldap sync: fix conflict when several configurations exist with the same suffix
- Cortex job endDate is not set if the job is not finished
- Fix filter value when it contains only wilcards
- Make readonly profile not editable
- Add properties for alert KPIs

## 5.1.7 - 1st June 2023

### Fixes

**UI:**

- Fixes on long names

**Backend:**

- Link correctly task and assignee when updating a task
- Limit the size of cortex response
- Cortex: Fix sync issue when multiple jobs are submitted at the same time
- Fix full text filter for custom fields

### Improvements

**UI:**

- Allow search for task assignee input

**Backend:**

- Optimize resource usage when reading cortex jobs 
- Replace default "Job" dashboard with a better TTP dashboard
- Cortex:
    - Add timeout for jobs (3 hours by default)
- Deduplicate custom field values on case merge
- Increase observable data length in api v1 to 4096 chars

**Migration tool:**

- Improve mapping of TheHive 3 Alert status 

### Security

- Update libraries


## 5.1.6 - 15th May 2023

### Fixes

**UI:**

- Fix edition of property "includeInTimeline" for task activities
- Fix case template search when creating a new case
- Admin: show username and organization name as required in forms
- other small fixes

### Improvements

**API:**

- Improve performances in some areas
- Replace org default dashboard "jobs" with TTP
- Improve performance when running notifiers
- It's now possible to upload two attachments with the same name in a case (the second attachment will be renamed automatically)

### Security

- Update libraries and remove unused dependencies

## 5.1.5 - 27th April 2023

### Fixes

**UI:**

- Case template: fix issue where prefix was deleted when editing a template
- Sharing: Fix display of share options on small display
- Responder reports should now appear in the observable preview when triggered

**Backend:**

- Fix Case dates when creating a case with status "Closed"
- Fix issue that created phamtom tags on alerts or case
- Fix issue that removed field `_id` from audits sent via notifiers (like webhook)
- Fix empty response when using the extraData `similarAlerts` on case queries

### Improvements

**UI:**

- Better user selector
- Tasks: redirect to task list after deleting a task
- Change wording in search bar
- Alert list: add capability to filter by assignee when clicking on an assignee
- Filters: assignee field will filter the dropdown list when typing
- Functions: several improvments
- Comments: use "Enter" to save a comment
- Responders: Sort responder reports by startDate

**API:**

- Better error codes when making queries or when sending an http entity too large
- Allow attachment download using its `id` or `_id`
- Fix some errors in the documentation

**Backend:**

- Improve tag creation performances

## 5.1.4 - 13th April 2023

### Fixes

**UI:**

- Fix crash when live feed is opened and a case is deleted
- Pages: several images with the same name can now be added (also fixes an issue with pasted images)
- Hide locked users in task assignee
- Custom fields of type boolean now display a set of options
- You can now press `Enter` to save a comment
- Fix report template download link

**Backend:**

- Fix potential memory leak that could lead to a crash (from 5.1, issue not present in 5.0)
- Return error 413 when http input payload is too large
- Report error when email sending fails during password reset
- Fix api documentation for operator `_between` in queries
- Add field `_updatedBy` in comments
- Don't ignore cortex jobs when the report contains an unknown operation
- Deprecate page slugs (in api docs only)

!!! warning
    In our next major release 5.2, the field `slug` for object `Page` will be removed. We are starting to deprecate it starting from this release

## 5.1.3 - 29th March 2023

### Fixes

**UI:**

- Fix filtering of case templates when creating a case
- When importing a case template that already exists, ask for a new name
- In dashboard list, be able to filter on group name
- Fix task list not refreshed when applying a case template on a case
- Fix url of popup livefeed when the application uses an http context
- Avoid tags deletion when editing a case template

**Backend:**

- Improve error message when merging case
- Fix sharing not applied after merging cases

**Docker:**

- Fixes `--storage-directory` option
- Don't show cassandra password
- Correctly escape Elasticsearch password

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
    Our [setup guide](../installation/step-by-step-installation-guide.md) can help you on how to install a jvm

- Drop support for Lucene as index backend

    Former versions of TheHive supported lucene and elasticsearch as indexing engines for the data. We then encountered limitations while using the Lucene index (especially when making queries based on Custom Fields). With TheHive 5.0, we pushed users to install and migrate to Elasticsearch. Finally with TheHive 5.1, the support of Lucene index is removed: the application will start but queries involving Custom Fields will return wrong results.
    To migrate your index to Elasticsearch, follow [this guide](../operations/change-index.md).

### Main features

- Apply case template on existing case: enrich a case with tasks, custom fields, tags from other case templates

    This will allow your organization to create more reusable case templates and apply them during the lifecycle of a case

- KPIs

    Get more indicators about your organization response: Time to Respond, Time to Acknowledge ...

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

    See [dedicated page](../user-guides/organization/configure-organization/manage-functions/about-functions.md) for more information (requires platinum license)

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
