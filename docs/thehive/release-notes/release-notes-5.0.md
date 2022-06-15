# Release Notes of 5.0 series

## 5.0.8 - 15 June 2022

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
- Misp configuration: Fix organisation selection
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

