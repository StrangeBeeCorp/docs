# Release Notes of 5.4 Series

!!! warning
    Backend framework upgraded to Pekko/Play3

    We upgraded our backend framework from Play 2 (also known as Akka) to Play 3 (also known as Pekko). **While there are no functional changes**, if you use TheHive in cluster mode, your configuration file will need to be modified when upgrading to TheHive 5.4. [Please refer to this guide for the necessary changes](https://docs.strangebee.com/thehive/configuration/pekko/).

    Please also note that the `play.http.secret.key` parameter requires now at least a 32 character value. [See more details](https://docs.strangebee.com/thehive/configuration/secret/) about secret configuration.

!!! info
    The following API endpoints will no longer be accessible via GET requests. You will now need to use POST requests to access them:

      - api/v1/admin/log/set/
      - api/v1/admin/check/_all/trigger
      - api/v1/admin/check/{name}/trigger

    For more details, please refer to the [public API documentation](https://docs.strangebee.com/thehive/api-docs/).

!!! info
    An [upgrade guide](../installation/upgrade-from-5.x.md) is available to help you migrate from TheHive 5.x

## 5.4.10 - April 24, 2025

Last update: May 14, 2025

### Security fixes

* This update includes four patches addressing vulnerabilities identified as [CVE-2025-48738](https://nvd.nist.gov/vuln/detail/CVE-2025-48738), [CVE-2025-48739](https://nvd.nist.gov/vuln/detail/CVE-2025-48739), [CVE-2025-48740](https://nvd.nist.gov/vuln/detail/CVE-2025-48740), and [CVE-2025-48741](https://nvd.nist.gov/vuln/detail/CVE-2025-48741). None have been exploited in the wild. Further details are provided in our [security bulletin](https://github.com/StrangeBeeCorp/Security?tab=readme-ov-file#2025), in line with our [Responsible Vulnerability Disclosure Policy](https://github.com/StrangeBeeCorp/Security/blob/main/Policies/Vulnerability%20Disclosure%20policy.md).
* JSON endpoints now strictly validate the `Content-Type` header. Requests must explicitly include `Content-Type: application/json`. If not, the server returns a `400 Bad Request` response.
    * A temporary compatibility mode is available to support legacy clients or scripts that don't set the `Content-Type` header properly. To enable it, add the following line to your `application.conf` file: `ignoreCSRFProtection = true`.
    * After enabling compatibility mode, update all clients to send `Content-Type: application/json`. Once all clients are updated, remove this override to re-enable full validation.

## 5.4.9 - March 25, 2025

### Fixes

* Resolved a potential deadlock when invoking functions, depending on the cache state (related to the Query API).
* Eliminated redundant `/status` API calls triggered on each keystroke in the user creation form.

## 5.4.8 - February 24, 2025

### Fixes

#### Dark mode
* Improved the visibility of the :fontawesome-solid-xmark: button in notification messages for better readability.
* Enhanced hover state contrast in analyzer reports for better accessibility.
* Increased the visibility of error messages when a dashboard widget fails.

#### Other fixes
* Fixed an issue in notifications where endpoints with names ending in a space character were not handled correctly.
* Fixed incorrect counter widget behavior when used with the `closeDate` field.
* Fixed an issue preventing scrolling in the case template selection menu when creating a case from templates.
* Added more detailed error messages for issues related to attached file storage.
* Fixed an issue with Email Intake synchronization when TheHive is configured in a cluster environment.

### Known issues

Last update: April 3, 2025

#### Merged alert audits

A regression related to the JSON audit object of merged alerts was introduced. This has been fixed in [version 5.5](release-notes-5.5.md).

## 5.4.7 - 16th of January 2025

### Fixes

#### Global Search
- Added support for wildcard searches using the * operator.
  Example for a case named Phishing incident on BU-FR45, will be returned by searching BU-F* or BU*..

#### UI
- Impact field is now more readable in dark theme after case closure.
- Fixed an issue on avatar change in the user profile page.
- Removed an incorrect message displayed when launching a responder on an observable.
- Fixed a display issue occurring when the function/responder list is excessively long.
- Enhanced handling for overly long function names during input.

#### Dashboard
- Corrected the display of text color in the donut and bar charts for the dark theme.
- Removed the “_total” value from the radar widget display.
- Removed cache option in UI configuration when DirectQuery is activate.
- Ensured that customized date formats are now consistently applied in dashboards.

### Docker configuration file
- The entry point docker parameter --cql-cluster is replaced by --cql-datacenter. This parameter, used in cluster configuration, allows to define the name of the Cassandra datacenter used by the TheHive node.

## 5.4.6 - 12th of December 2024

### Security fix
- This update contains a patch for a vulnerability (CVSS 6.9) non-exploited in the wild. More details will come in a further security bulletin, as per our responsible disclosure policy.

### Fixes
#### Unlicensed users
- Unlicensed profiles can now be assigned even when the quota is full.
#### UI
- Fixed readability issues with Analyzer reports and list export previews in dark mode.
- Solved an issue in the similar observable detailed view: similar observables spotted in other cases can now be opened in a blank tab.
#### Dashboards
- Removed a useless parameter when DirectQuery / ESChart options are enabled.
- Fixed a problem that could generate an error during the agregation query. 
#### Other fixes
- Fixed a regression introduced in 5.4.5 version; a route was missing in the OpenAPI documentation.
- Fixed an issue related to uppercase characters in logins and LDAP synchronization module. 
- Corrected a log formatting issue from notifiers.

## 5.4.5 - 21st of November 2024

### Fixes
#### Cortex
- Resolved an issue causing incorrect differentiation between "In Progress" Cortex analyzers and responders during TheHive startup process, that was causing some Responder jobs to never cleaned up.
#### Dashboard
- Fixed an issue related to Custom Field and negative filter on some dashboard widgets: gauge, text, and counter.
#### Index ES
- Fixed index deactivation during a global reindex request. Double reindexation is not required anymore.

## 5.4.4 - 8th of November 2024

### Fixes
- Resolved a display issue with the status component in cases and alerts, which was not rendering correctly on Safari and Firefox.

## 5.4.3 - 7th of November 2024

### Improvements

#### Microsoft teams Notifier Update
Updated the Microsoft Teams notifier to use Power Automate as Microsoft has deprecated the webhook used previously. A guide to updating your notifier is available [here](../user-guides/organization/configure-organization/manage-notifications/notifiers/teams.md).
#### Cases/Alerts status visibility
Added a colored background to the stage icon in status components for better visibility in case and alert lists.
#### License Check Improvements
Improved display of permissions and profiles that consume licenses for clearer management by administrators. The “Manage Dashboard” permission no longer consumes a license.
#### Task title Limit
Added a character limit check for task titles to notify users when their input exceeds the allowed length.
#### Edit Alert title
Adding the ability to edit alert title directly from the general tab.

### Fixes

#### Cortex job queue
- Enhanced the handling of concurrent job submissions to the Cortex server for better efficiency and stability.
- Fixed an issue related to job status recovery in TheHive when the Cortex server crashes.

#### Live feed display
Fixed issues with overly long text and tags in the live feed display.

#### Observables list loading
Optimized the rendering speed for the observables tab to improve performance.

#### App default language
Fixed default language selection to use the browser’s language on first connection.

#### Improved Case Closure Error Handling
Modified case closure behavior: if a backend error occurs, the case closure window now remains open to prevent data loss.

#### Tasklog Display in Timeline
When adding a tasklog with the option "display in the timeline", the tasklog now appears in the timeline view from the task preview after the preview drawer is closed.

## 5.4.2 - 21st of October 2024
### Fix
- This version fixes a regression related to the query boolean parameters in the public API. These parameter values are case insensitive again.

## 5.4.1 - 11th of October 2024

### Fix
- We fixed an issue related to our backend framework configuration (pekko). This problem impacted the generated configuration file for a new installation of TheHive on Kubernetes.

### Improvements
#### Cortex Job Queue
We have made two improvements to the management of Cortex job queues from TheHive to:

- Prevent spamming the Cortex server when a large number of jobs are submitted.
- Reduce the latency in retrieving completed job reports, even when the job queue is highly loaded.

## 5.4.0 - 26th of September 2024
### New Features

#### Dark Mode

We have introduced a Dark Mode option to enhance user comfort during low-light or night-time usage. This feature is accessible via the theme settings and provides a dark-themed interface for reduced eye strain and improved visibility.

#### Report Tab in case details

A new "Report" tab has been added to the case detail screen, allowing users to access and generate case reports directly from a case. This feature utilizes the existing Case Report Templates, enabling customization and configuration of reports based on the templates set by organization administrators. The Report Tab supports multiple formats (HTML, Markdown, Word) and offers dynamic previews for quick and informed decision-making.

#### Comment and Page Widgets in Case Report Templates

Two new widgets—Comments and Pages—have been added to case report templates. These widgets allow users to include comments and documentation directly in case reports. Administrators can configure these widgets in the template section under org admin settings, ensuring richer reports with relevant context.

#### Functions as notifiers, can be automatically triggered

A new notifier is available: function notifier. You can now write TheHive functions that can be triggered by an internal event, and then perform automated actions in TheHive. This new feature opens up a wide range of new automation possibilities within TheHive.

#### Functions can be performed manually, like responders

TheHive functions can now be manually triggered directly from a Case or an Alert, just like responders. It allows you to save time by  automating some repetitive tasks. The functions must be written and assigned with the corresponding type in order to be visible in a Case or Alert.

#### Duplicate a case template

Creating a case template can be very time effective, we now offer  the ability to duplicate a case template, instead of creating each one from scratch or from an import.

#### Hide some time metrics

We have introduced the option for the OrgAdmin to hide some of (or all) time metrics. It makes the user interface lighter if these metrics are not used.

### Improvements

#### Restrict Dashboard Editing for Read-Only Users

A new permission system has been introduced to restrict read-only users from editing dashboards. However, read-only users retain the ability to adjust settings like the refresh rate and cache values. This helps maintain dashboard integrity by limiting editing capabilities to authorized users only.

#### Enhanced display of time metrics (TTx)

We changed the display format of time metrics in Alert & Case pages, and made it more accurate for the users.

#### Backend framework upgraded to Pekko/Play3

We upgraded our backend framework to Play 2 (also named Akka) to Play 3 (also named Pekko). While there is no functional changes,  if you use TheHive in a cluster mode, your configuration will need to be changed when upgrading to TheHive 5.4. Please refer to [this guide](https://docs.strangebee.com/thehive/configuration/pekko/) for further details.

#### Elasticsearch query optimisations: DirectQuery & ESChart

A new query optimisation system enables the union of the best aspects of both graph and search engine data models. Dashboards will fully delegate data processing to Elasticsearch, resulting in an effective and precise output. Search filters will also benefit from the performance and precision of Elasticsearch.

Those two options DirectQuery & ESChart are enabled by default, but can be deactivated through API configuration.

#### New logo and favicon

As part of our recent brand visual identity update, TheHive logo has been updated throughout the entire application. This includes changes on the login page, favicon, and navigation bar.

### Fixes

#### Time metrics
We resolved an issue with the "Time to Detect" metric during alert creation.


### Known issues
Last update: 21st of October 2024

#### Public API - Query boolean parameters case sensitive

TheHive 5.4.0 introduced a non expected breaking change related to the query boolean parameters.
The values passed in the query URL, with upper case (ex: `True` or `False`) are not accepted anymore. It does not concern the parameters passed in the body/payload.
It impacts the endpoints listed below, and the tools that use those endpoints (like TH4Py 2.0). **The 5.4.2 version fixes this issue**.

The following endpoints are impacted:

- Download Attachment from observable: GET /api/v1/observable/$id/attachment/id/download with the asZip param
- Delete CustomField: `DELETE /api/v1/customField/$id` with `force` flag
- Invoke Function: `POST /api/v1/function/$id` with `dryRun` flag
- Invoke Function on an object: `POST /api/v1/function/$id/$objectType/$objectId` with `dryRun` and `sync` params
- Test Function: `POST /api/v1/function/_test` with `dryRun` param
- Get platform status: `GET /api/v1/status` with `verbose` param
