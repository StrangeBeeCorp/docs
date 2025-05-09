# Release Notes of 5.0 Series

## 5.0.26 - 27th February 2023

### Fixes

**UI:**

- Fix issue that prevented closing a case when a custom field was not set
- Fix indentation issue in TTP list
- Fix overflow in pages with long content
- Fix loading of multiple comments
- Allow importing observables from analyzers when running on an alert
- Improve error message when closing a case with mandatory custom field
- Fix style for custom field input
- Typo fixes

**Backend:**

- Fix v1 api for page which used the former v0 style: new fields were added and some fields are now marked as deprecated and will be removed in the future
- Add caseId in analyer input: field `message` should now contain the observable's parent id (alert or case)
- Fix a message serialization error when running in cluster

## 5.0.25 - 2nd February 2023

### Fixes

**Backend:**

 - Fix TLP and PAP of MISP events
 - Fix download of attachment when content type is malformed
 - TheHive 3 migration: Fix parsing of old format of Cortex jobs
 - Fix serialisation of configuration that contains a pipe character

**UI:**

 - Remove the limit on the number of techniques when selecting a TTP tactic

**Docker:**

 - Add parameter for Elasticsearch authentication


## 5.0.24 - 9th January 2023

### Fixes

**UI:**

- Fix issue in slack notifier form
- Fix colored tags in several parts of the UI: tags should now be more colorful

**Backend:**

- When changing a tag name, the name is also changed in the cases and alerts
- When an alert or case changes of stage, the stage is added to the audit details
- Slack notifier now correctly sends the username
- Update analyzer reports
- Improve api docs

## 5.0.23 - 20th December 2022

### Fixes

- Downgrade logback library to version 1.3.5 which still supports Java 8

## 5.0.22 - 19th December 2022

### Fixes

**UI:**

- Fix: "Add share" window is empty when no target org
- Search: Observables search result direct link not working
- Search: results for Task Logs do not show a link to the case
- Markdown table issue with vertical bar: add support for `&vert;` in cell tables
- Dashboard:
    - Bar Chart with tasks by status all have same colors
    - Bar chart: add an option to display or not empty values
- Long alert titles cut off other UI fields
- Bad cache when listing similar alerts
- Wrong drawer title when editing a case template

**Backend:**

- Update dependencies
- API Query filter _startsWith don't work on customFields
- Pages in knowledge base incorrectly display pages from cases too
- Search on absent field does not use index
- Changing auth configuration does not work for v1 routes

### Improvements

- LDAP/AD: add option to ignore the realm/domain of the login
- Cortex: Send observable attribute `sightedAt` to Cortex
- UI: in a task preview, add the possibility to edit or delete a task log
- UI: standardize disposition of TLP, PAP and SEV across forms and elements.

## 5.0.21 - 2nd December 2022

### Fixes

**UI:**

- Fix JavaScript error

## 5.0.20 - 1st December 2022

### Fixes

**UI:**

- Dashboard:
    - Fix broken export as CSV for bar chart widget
    - Remove some entities (patterns) that are not useful in dashboard view
    - add live feed for dashboard
    - re-enable aggregation on some fields and display a warning if the query is slow
    - In widgets mark mandatory fields
    - Some filter queries on string field (like title) were not correctly built
- Admin: be less restrictive for urls (cortex and misp)
- Case sharing:
    - Fix request timing issue when sharing a case that prevented from sharing the tasks
    - Update wording when sharing a case
- When a customfield has options, prevent the user from selecting an other value
- Fix issue when updating custom fields in case templates
- Fix count of similar alerts 
- When creating an observable the option "one observable per line" is now the default
- Fix duplicated refetch when updating an entity
- Fix live feed when updating a case

**Backend:**

- Oauth2 connector will read the value for its proxy from `application.conf` > `wsConfig.proxy`
- Create audit logs when tasks are cancelled when closing a case
- In API allow status length of 64 chars for case and alerts (was wrongly 32 chars previously)
- Fix GDPR service that did not include all the tasks, task logs and observables
- Fix permission issue where analysts could no longer generate their Api Key (regression introduced in 5.0.19)

## 5.0.19 - 16th November 2022

### Fixes

**UI:**

- Fix urls in mardown that contain `&` character
- Platform configuration: 
    - Webhook version was always set to 1
    - Global endpoints can now be edited
- Dashboards:
    - Fix issue with dashboards using relative times (like "last 3 months")
    - Fix crash when deleting a widget in certain conditions
    - Improve conversion of TheHive 4 dashboards
- Display sightedAt date when an observable is set as sighted

**Backend:**

- Fix permission issue for user edition
- Fix issue when trying to repair the index with a vertex containing non indexed fields
- Refresh license quotas faster after an organization is locked

### Security Updates

- Update dependency on org.apache.commons:commons-text to 1.10.0
- Remove dependency on org.apache.ivy:ivy

## 5.0.18 - 27th October 2022

### Updates

- Update Cortex analyzer templates

### Fixes

**UI:**

- Dashboard:
    - Fix counter widget not working with observables
    - Fix entity change not updating form changes
    - Fix legends in dashboard that may be truncated
- Custom fields options are shown even if the field is not empty
- Fix icons in analyser reports when serving TheHive on a non root path
- Fix issue when creating a case template with an already existing name
- Fix bad autocompletion on non tag fields
- Markdown tables now respect the alignment
- Fix drawer title when editing a dashboard
- Fix rare issue where the observable counter was not refreshed when an observable was added

**API docs**

- Field `date` in Alert is now corectly marked as optional
- Add api docs for observable types

### Improvements

**UI:**

- Faster load of analyzer templates when viewing an analyzer report
- Sort search results by `_createdAt` date
- Sort analyzer list
- Dashboard:
    - color can now be customized for the field status

**Backend:**

- Make alert merging faster
- Fix chart time interval when empty series
- Set size limit on custom field values (8191 chars)

## 5.0.17 - 11th October 2022

### Fixes

**UI:**

- Fix the search field in alert and case merging drawer
- Add missing validation button on the UI settings when choosing a date format
- Fix case export button when MISP is available

- Dashboard:
    - Fix filters during the import of dashboards, they was ignored
    - Fix text and counter widget serie filters. They was ignored in 5.0.16

### Improvements

**Backend:**

- Use index to count the number of waiting tasks

## 5.0.16 - 7th October 2022

### Fixes

**UI:**

- Removed clickable description
- Fixed crash on alert merge in a new case
- Fixed rule to enable/disable button for the case export (MISP and archive capability)

**API:**

- startDate in task set even if we go from Waiting to Completed
- Notify user when Cortex requires admin actions to update analyzers

### Improvements

**UI:**

- Dashboard:
    - Added time selection in custom period picker
    - Improved performances of Text and Counter widgets

## 5.0.15 - 30th Septembre 2022

### Fixes

**API:**

- Fix "none of" filter which could return wrong result when using in dashboards
- Fix result of dashboard based on custom fields

**UI:**

- Case count now takes filters into account
- Array and title panel in markdown edition was disappearing
- Deleting a filter had a weird behavior before (going back to the previous applied state), it now only deletes the selected filter
- Border for cortex/misp logo fixed for Safari 14
- Task completion bar is now refreshed when a task status is updated
- Fixed empty page sometimes when login
- Webhook endpoint version is now editable

### Improvements

**API:**

- Add "alertsCount" extraData in case list

**UI:**

- Dashboard duplication feature has been added
- Count and link for similar cases/alert has been added to alert preview

Description:

- textarea for edition is now resizable
- linebreak in text renders with a newline in markdown
- we can now click on the description to edit it
- font size when editing is now monospace

## 5.0.14 - 19th September 2022

### Fixes

**API:**

- Fix an issue where case template prefix was duplicated in case title
- Observables with files were not linked correctly to their attachments which impacted the merge of observables

### Improvements

**UI:**

- Notifications: display the name of the webhook
- Ability to filter users by profile when listing the users of an organization
- In search page, add link to observable parent (case or alert)
- In live stream, display full date instead of 'x seconds ago'
- Dashboard:
    - Display users name instead of login
    - Make time intervals aware of user timezone and locale, so that months and weeks aggregation behave correctly

## 5.0.13 - 8th September 2022

### Fixes

**UI:**

- Dashboard:
    - Remove some entities from the entity list for which dashboards were not usefull or working (like comments or actions)
    - Clicking on a counter or donut now correctly sets the filters in the search page
    - conversion of v4 dashboards failed with `not` operator
- Improvement around time filters (custom and periods)
- Assignees from other organizations are visible and searchable in case assignment
- Fix bad date format when using am/pm
- Case sharing displayed an empty list of organization
- Quote in the markdown editor only worked for the first line
- On small screen preview button was not visible when using Firefox
- Fix bug in list of TTP tactics

**API:**

- Fix issue with integrity check of Observable
- Fix issues around Case Number Actor (responsible to give a sequential number for cases)
- Avoid locks when trying to fix inconsistencies in index
- Fix an issue that could happend during schema evolution
- Fix parsing of Cortex information (analyzers without dataType)
- Notifications: Email will now be sent in the format set by the text template (html or plain text)
- Prevent user ldap synchronisation if license is incompatible

### Improvements

**UI:**

- Notify user when an update in Cortex is available
- Dashboard:
    - Default period is now 3 months instead of "All"
    - Remove some entities from the entity list for which dashboards were not usefull or working (like comments or actions)
    - An org admin can disallow the "All" period in the dasboards (organization settings > UI Configuration)
    - Widgets legends now show fully
- Add an indicator on the number of open requests made by the browser
- Admin can now configure the default user domain from the admin settings
- Admin can change the type of a user (Service or Normal users)
- Improvements around the Proxy and SSL forms (used in misp, cortex or endpoints definition)

**API:**

- Add the ability to log the content of query request
- Admin can now write in the knowledge base (the permission `manageKnowledgeBase` was added to the `admin` profile)
- Improve templating capabilites in notifiers:
    - Add `dateFormat` helper (`{{dateFormat audit._createdAt "EEEEE dd MMMMM yyyy" "fr" }}` => `jeudi 01 septembre 2022`)
    - Helper `eq` now supports numbers: `{{#if (eq object.severity 2) }}MEDIUM {{else}}Other {{/if}}`
    - Add helpers `tlpLabel`, `papLabel`, `severityLabel`: `{{tlpLabel object.tlp}}` => `Amber`

## 5.0.12 - 16th August 2022

### Fixes

**UI:**

- Fix issue where case assignee was not displayed (because user was in an other organization)
- Fix org switch not working when using http context (bug introduced in 5.0.11)

**API:**

- Don't fail integrityChecks if field `_createdAt` is missing
- Sync cortex jobs with status `Deleted`
- Don't fail queries if a phamtom vertex is encountered

**Migration:**

- Fix issue where users could be duplicated by the migration 3->5 process

### Improvements

**UI:**

- Add field to set the expiration token duration for reset password links
- In Proxy forms, add input field to set the port of the proxy

**API:**

- Alert can be created even if they contain duplicated observables of type files. Before it triggered an "AlreadyExits" error.
- Remove orphan cortex jobs (when observable was deleted)


## 5.0.11 - 5th August 2022

### Fixes

**UI:**

- Fix import of .thar files
- When switching of organization, the user is redirected to her homepage.
- Filters on number types showed `-1` in the preview
- In endpoints configuration, the setting "Do not check Certificate Authority" was not sent correctly
- Fix filters when using between dates with an hour or minute precision

**API:**

- Cases created from an alert with a case template could have duplicated custom fields
- Cases created from an alert with a case template had duplicated tasks and prefix (from 5.0.10)
- Prevent failures during migration from v4 to v5: 
    - TheHive will automatically reindex its data when a change in the index is detected (change from lucene to elasticsearch)
    - TheHive will no longer try to run migrations when the setting `db.janusgraph.index.search.elasticsearch.bulk-refresh = false` is present
- Fix issue where uploaded files like observable attachments were deleted from the server before being processed, resulting in "File Not Found" errors

### Improvements

**UI:**

- Improve the search experience when merging a case 
- Ctrl+click on a case title in the list view will open the case in a new tab

**API:**

- TheHive will try to fix ghost vertices when encountering one (a vertex that is present in the index but not in the database)
- a new field `extendedStatus` is passed to Cortex responders which represents the status of the Case which can be customized. The field `status` is still a fixed enumeration.
- Add integrity checks for `Share`s and `Role`s entities
- Some cortex jobs could be stuck in "Waiting" status: now when TheHive starts it will try to fix those jobs.


## 5.0.10 - 21st July 2022

### Fixes

**UI:**

- Dashboard:
    - fix style issue when loading the knowledge base at the same time
    - update api used by bar widget to fix issues with custom fields query
- Markdown preview in full screen mode now uses the full height of the screen
- Fix a filter when using enumeration (severity, pap)
- MISP: add settings in the UI to be able to export tags on Case and Observable from TheHive to MISP
- Cortex: 
    - UI is notified when an analyzer has finished adding all the observables to a report
    - Fix report view for Spamhaus analyzer

**API:**

- Fix issue that caused the user `system@thehive.local` to be deleted by the user integrity check: this could cause issues with MISP or Cortex synchronization (Cortex jobs triggered by notifiers were left in "Waiting" state). If the user was missing from your instance, it will be recreated after an update of TheHive. 
- Increase the timeout for count requests to 10s and add a config to increase this value (`db.limitedCountTimeout`). If a count takes longer that this duration, a truncated result is returned.
- Dashboard queries: Filter on custom fields was not applied on the name of the custom field (only on the value)
- Fix an issue that prevented TheHive from starting when misp or cortex were not configured correctly (missing `http` scheme in url for instance)

**Docker:**

- Fix issue with argument `--no-cql-wait` that caused the next argument to be ignored

### Improvements

**UI:**

- Responder jobs list are now sorted by start date 
- Users in Assignee field are now sorted by alphabetical order
- When showing an observable, prevent from loading all the reports details when loading the job list. Report details are now loaded only when opening the report drawer.

**API:**

- Add new parameters to the endpoint "create a case from an alert".
- When creating a case from an alert, the events `CaseCreated` and `AlertImported` are triggered once all the alert observables are imported inside the case.
- When merging alerts inside a case, triggger the event `AlertImported` once all observables for an alert are imported inside the case.
- Emailer will now send html emails instead of text emails. This means that you use advanced formatting and styles in your emails.
- Cortex job reports are not included in the list anymore. An extra data needs to be used to retrieve them.

**Docker:**

- Misp and Cortex modules are enabled by default when using the entrypoint. (They are not enabled if you use `--no-config`)

## 5.0.9 - 1st July 2022

### Fixes

**UI:**

- Dashboard:
    - Fix radar when aggregating on custom fields
    - Radar widget now uses a more efficient query
    - Clicks on donut and counter widgets correctly sets the filters on the search page
- Reset scroll when page is changed
- In alert observable list, remove the share column
- Fix french translation in quick views
- Fix links in search results for observables

**API:**

- When merging an alert in a case, merge the tag reports for the observable

### Improvements

**UI:**

- In analyzer reports, add the tags on the observables
- Sort case template by name when creating a case
- Add support for cortex entities in charts and dashboard
- Related case view: sort cases by matching percentage

**API:**

- Limit the duration of count queries not using the index to 5 seconds
- Add support for cortex entities for charts api
- Add TheHive version in logs

## 5.0.8 - 15 June 2022

### Security

Fix issue related to AD/LDAP module.

If you are using the ad/ldap authentification, you should update to TheHive 5.0.8 or later

### Fixes

**UI:**

- Fixes issues around importing observables from an analyzer report
- Analyzer template list was not be exhaustive in certain cases
- Fix pagination and sorting when listing similar cases
- In related cases list, show several matching observables instead of only one

**API:**

- Removed full text search on tags: that caused slow queries as the index cannot be used here
- Fixed regression from TH4: when merging alerts into a case, observables could be duplicated if they appeared in several alerts
- Add ability to filter and sort by case/alert status/stage on api v0

**Docker:**

- Fix entrypoint for s3 configuration

### Improvements

**API:**

- Log login success and failures: those logs are useful for auditing purpose, to detect password guessing attacks via large unsuccessful logon attempts
- Prevent duplication of custom fields values
- Improve queries when filtering on a custom field with a high number of matches

## 5.0.7 - 31 May 2022

### Fixes

**UI:**

- When creating a case from an alert, the correct case template is selected if the field was set in the alert
- Dashboard: fix an issue when converting a v4 dashboard
- Case count was not refreshed when adding a case
- Refresh comment section
- Misp configuration: Fix organization selection
- Analyzer reports:
    - in an alert, display the extractable observables
    - can now import an observable of type file
- Custom Fields:
    - Limit the size of custom fields in list views
    - use the display name in list views
- When closing a case, custom fields are no longer deleted

**API:**

- Fix breaking change in api V0: don't limit the size of observable data in json. This prevented the creation of files in observables. Note: with v1 the prefered way is to use a multipart request.

**Migration 3 to 5**

- Fix migration of custom fields of type number

### Improvements

**UI:**

- Add ability to manually refresh a list when auto-refresh is disabled
- Notifications: Add a json validator when creating a custom filter
- Prevent automatic scroll when an entity is updated
- Fix flickering of updated data fields when updating an entity
- Other UI improvements

**API:**

- Check for duplicated files (by filename) when attaching a file to a case or to a log
- Add field `stage` to alert and case in api v0
- Users can manage their own api key without the permission `manageUsers`
- Add new auth mecanism based on htpasswd file

## 5.0.6 - 17 May 2022

### Fixes

**UI:**

- List of analyzers did not refresh correctly for alert observables
- Fix error when trying to download a task log attachment with the char `{` in the name
- logout popin remained open after a reconnection
- API docs did not appear when setting an http context
- Fix an issue where breadcrumps were not displayed correctly

### Improvements

**UI:**

- Faster render of big markdown section: use `marked-react` library instead of `react-markdown`
- Adjust fanged message
- Improve sorting of tasks when in group mode
- Update observable count when an observable is added or removed
- Improvements for "Required Action" on tasks

**Migration 4 to 5:**

- Improve migration for custom fields where previous script could overload the application

## 5.0.5 - 5 May 2022

### Fixes

**UI:**

- Analyzer templates: optimize rendering time
- Fixed SSO login when using an http context

**API:**

- Dashboard: increase number of retrieved values for aggregations (eg. chart on custom field values)
- Fix for permission `manageConfig`
- Improve support for AWS Keyspace: add retries on some failed queries
- Fix endpoint for deletion of catalog of ttp

## 5.0.4 - 3 May 2022

### Fixes

**UI:**

- Tasks are now displayed by their order
- Changed color of field for search by case id
- Fixed an issue where custom fields were deleted when editing a case template
- Fix download link of attachments when http context is set
- Update of vulnerable libraries
- When using bulk edit, "Add tags" and "Remove tags" now work

**API:**

- Fixed bug introduced in 5.0.3 where TTPs were not linked to their tactics and reported `<unknown>`
- It's now possible to delete the title prefix in a case template

## 5.0.3 - 15 April 2022

### New Features

**API:**

- Add support to procedures (TTPs) when creating alerts in TheHive

### Fixes

**UI:**

- When importing a case from misp: additional parameters (custom fields, shares) are correctly sent
- When converting an alert to case, custom fields are no longer lost during the process
- Update moment.js library

**Migration tool:**

- Fix typo in migration tool configuration

## 5.0.2 - 8 April 2022

We found a bug that prevents a user from using the reset pasword flow (present in 5.0.0).
We recommend all 5.0.x users to update to this version.

**Fixes:**

- Fix 404 page during the reset password flow
- Dashboard: include end date in time interval
- Fix detached live feed when using an http context

## 5.0.1 - 7 April 2022

TheHive 5.0.1 is the first patch release in the 5.0 series. It contains fixes and improvements for the UI and some small changes for the API compared to 5.0.0.

We recommend all 5.0.0 users to update to this version.

### Notables changes

**UI:**

- fix description display on search page
- display org admin tabs only with required permissions
- fix permissions checks in the application
- improve case sharing user experience
- notifications - fix urls of http endpoints
- notifications - improve editor when using template variables
- be able to download a file attachment for an alert
- forms and drawers don't lose user data when the entity is refreshed by the feed
- improve live feed for cortex jobs on observables

**API:**

- add ability to create alert with observables (of type string and files), see. API docs for more information
- rename field user to assignee in case creation
- rename field customFieldValues to customFields in alert creation

**Backend:**

- fix tag edition
- fix permissions check for observables in case of sharing
- fix user deletion (user could be left without org)
- fix license reload on cluster nodes
- add more check to ensure uniqueness of data
- increase quotas for service users (set to unlimited) and cluster nodes (unlimited for platinum plan)
- update of dependencies

**Docs:**

- fix url to website
- add documentation for MISP endpoints
