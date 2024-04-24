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
    An [upgrade guide](../setup/installation/upgrade-from-5.x.md) is available to help you migrate from TheHive 5.x

## 5.3.0 - 24th April 2024

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