# Release Notes of 5.0 series

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

