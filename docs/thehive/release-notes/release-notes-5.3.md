# Release Notes of 5.3 series

!!! danger
    The 5.3 release comes with some changes on the database schema that can't be reversed. Please make sure to make a backup of your database before upgrading.

    This release also comes with some breaking changes, please review them below


!!! warning
    Note: public API v0 is now considered as deprecated.

    The public API v0 is obsolete, and you should not be using it anymore. All the endpoints are available in the public API v1. That being said, it will be deactivated in a future version.

    The API v0 was initially developed for TheHive 3 and maintained for backward compatibility reasons only. 

    API v0 endpoints refer to APIs beginning with `/api/` or `/api/v0/` (but not with `/api/v1/`).

!!! info
    An [upgrade guide](../installation/upgrade-from-5.x.md) is available to help you migrate from TheHive 5.x

## 5.3.4 - 26th August 2024

### Improvements

#### Login Page:
- The text box now automatically gains focus when the page loads, allowing users to immediately begin typing their information.

### Fixes

#### Activity Timestamp in Timeline:
- Fixed an issue that occurred when editing activity dates in the timeline.

#### Index Engine Configuration:
- TheHive now prevents starting with an index engine that differs from the one specified in the configuration file.

#### Similar Alerts Display (Safari Only):
- Resolved a display issue in the search input field within the drawer on Safari.

#### Navigation Menu:
- Fixed a regression that prevented navigation menu links from opening in a new browser tab when using the mouse scroll button.

#### List Component Fixes:
- Corrected duration display in alert lists.
- Fixed status display in task lists.
- Resolved an issue where the "hide custom field" option was not functioning in case lists.
- Fixed the cropping of long custom field values to prevent display errors.

#### Case Reports:
- Users from locked organizations are no longer visible in the user list.

### Security fix

#### CVE vulnerability
- [CVE-2023-52428](https://www.cve.org/CVERecord?id=CVE-2023-52428 "https://www.cve.org/CVERecord?id=CVE-2023-52428") : This vulnerability has been resolved.

## 5.3.3 - 9th July 2024

### Improvements

#### UI Enhancements
- **List Display Improvements**: Various components within list displays have been updated to enhance the overall aesthetic and functional experience. These improvements include modifications to the design of status and other minor visual adjustments aimed at enhancing usability.

### Fixes
#### Sorting on Similar Cases/Alerts
- **Sorting Logic Correction**: Fixed an issue in the sorting logic of the similarities column to ensure that cases or alerts are first prioritized by the highest number of similar observables, and in cases where two or more entries have the same number, they are then ordered by the highest ratio of common to total observables.

#### DataType Filtering in Similar Cases/Alerts
- **Filtering Functionality Restoration**: Restored the ability to define and apply specific data types in the matches column that filter similar alerts and cases. This update ensures that only observables of the selected types are considered when displaying similar cases and alerts, thereby improving the relevance and accuracy of similarity matches.

#### User Count in Administration Section
- The user count is now immediately updated when an account is removed or locked.

#### API Case List
- Fixed a bug in the `query` API route that caused cases to be unobtainable when using the `caseid` filter.

#### Custom Tags
- Corrected an issue that generated an error when removing and re-adding a custom tag.

#### Dropdown Selectors
- Fixed a bug in dropdown menus that prevented the menu action from launching if the click was not on the text item.

## 5.3.2 - 14th June 2024

### Improvements

#### Similar Cases/Alerts

- Improved the queries to get and display the similar Cases & similar Alerts lists. Only useful information is now loaded, significantly speeding up the list display. A new query is performed when accessing the observable list drawer of a similar Case/Alert.

`To ensure performance, the observable list preview drawer can display up to 100 observables only.`

### Fixes

#### DirectQuery

- Fixed an issue that could cause platform instability due to the handling of empty array requests when DirectQuery is activated.

#### Arrow / end / home keys

- Resolved a regression that prevented the use of arrow, end, and home keys in the edit mode of various components: Tasklog, Dashboard, Endpoints, Custom fields, Report template, and Case template.

#### Notifications

- Corrected an issue in the httpRequest Notifier where the JSON mode was not properly applied when activated.

#### MISP Connector

- Fixed an issue that prevented the MISP connector from capturing all events during synchronization.

#### Case Creation

- Corrected a problem that prevented the selection of a custom Start Date when creating a case from an alert. Users can now select a custom Start Date for their cases.

- When multiple alerts are selected, the action button associated with a given alert now provides clearer information about the possible actions, like the creation of a case.

#### Tasks

- Locked users no longer appear in the assignable user list.

## 5.3.1 - 16th May 2024

### Improvements

#### Email Intake

- Added the possibility to specify the Microsoft Office365/Google Workspace host instead of the one provided by default.

### Fixes

#### Custom Fields

- Fixed a bug where merging of alerts and cases could generate duplicated customfields values in the index (invisible in the UI).

#### MISP Connector

- Resolved a problem that prevented alert deletion.

#### Alerts & Cases

- Fixed a bug related to assignable users.

#### Similar Alerts

- Fixed the counter in the pagination.
- Fixed the display of the pending status.

#### Dashboard

- Fixed an issue with the properties of the donut widget.
- Changed the list to display more than 30 dashboards.
- Improved the behavior of the diagram widget.

#### Notifications

- Fixed a problem with the recipent field of the email notifier.
- Solved an issue with the `{{ url }}` variable when it concerns a task.
- Fixed an issue that made it impossible to delete a webhook endpoint.
- An Event is now triggered when a Case is created from an Alert.

#### Responders

- Resolved a problem with the display of a responder report in the task preview. 

#### API

- Fixed an API error return code in the post `/case` route when the `status` value is `unknown`.

#### UI

- Renamed a field name in the SAML authentication configuration page for better understanding.
- Reviewed the breadcrumb to better manage long alert names.

### Security Fixes

- Embedded patches for the following vulnerability: CVE-2024-25710

## 5.3.0 - 24th April 2024

!!! info
    The licensing model for the community version has been updated. Users are now required to <a href="https://portal.apps.strangebee.com/account/register" target"_blank">register on our licensing portal</a> and request a community license to use TheHive in the community version. Additionally, TheHive will now include a default 14-day free Platinum trial license, allowing users to explore the full range of features offered by the platform.

### New features

#### Email intake

The Email Intake connector now fully automates the transformation of incoming emails into actionable alerts on TheHive platform. It supports Microsoft 365, Google Workspace, and IMAP-based email services. 

It automates the detection and processing of suspicious elements such as links, attachments and sender details, which it all adds to the list of observables.

#### New timeline widget

We've added a timeline widget to TheHive's Platinum case reports, allowing users to visually track attack and defense actions. This widget displays key events and indicators like IOCs and TTPs.

Only admins can customize these reports, choosing elements like alerts and tasks to include. This customization ensures the timeline meets the specific needs of each report, making it easier for everyone, including non-technical staff, to understand the sequence of security events.

#### Data List Export

We've improved the data export options across TheHive. Users can now select specific fields from application lists to export, making the data more relevant and manageable for analysis.

#### OpenSearch Support

OpenSearch is now available as an indexing option alongside Elasticsearch. This addition offers more choices for your indexing needs.

#### Dynamic Date Filtering

A new relative date filter on dashboards and search pages allows users to filter data based on specific time frames like the last few days or months.

#### Similar Case and Alert Enhancements

We've updated the similar cases and alerts pages to display more accurate data, adding a drawer for observables common to related cases and alerts and including additional details like case status for clearer insights.

#### Observable Export Improvements

The observable export feature now supports more formats, including JSON and customizable CSV, allowing users to select specific fields for export.

#### Elasticsearch performance and interface improvements

- Queries have been optimized for better dashboard and search performance.
- Full support for Elasticsearch 8.
- Improved handling of custom fields with new operators (isEmpty, nonEmpty, between).
- Users can now customize the number of segments in dashboard donuts.
- All data points are now included in category aggregations for donuts and charts, providing a complete view—in the past, it was capped at 100 displayed values.

### Bug Fixes

- Fixed the display issue with the number of open cases in quick filters.
- Corrected a merging bug for custom tags to prevent duplicates.
- Fixed a bug in markdown editor related to the `<` & `>` characters.

!!! info
    As we have updated some front-end components, please remember to refresh your browser page after upgrading to version 5.3 to prevent any UI issues.
