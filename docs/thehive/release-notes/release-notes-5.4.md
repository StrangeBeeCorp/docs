# Release Notes of 5.4 series

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
Last update: 17th of October 2024

#### Public API - Query boolean parameters case sensitive

TheHive 5.4.0 introduced a non expected breaking change related to the query boolean parameters.
The values passed in the query URL, with upper case (ex: `True` or `False`) are not accepted anymore. It does not concern the parameters passed in the body/payload.
It impacts the endpoints listed below, and the tools that use those endpoints (like TH4Py 2.0). A fix version will be delivered soon.

The following endpoints are impacted:

- Download Attachment from observable: GET /api/v1/observable/$id/attachment/id/download with the asZip param
- Delete CustomField: `DELETE /api/v1/customField/$id` with `force` flag
- Invoke Function: `POST /api/v1/function/$id` with `dryRun` flag
- Invoke Function on an object: `POST /api/v1/function/$id/$objectType/$objectId` with `dryRun` and `sync` params
- Test Function: `POST /api/v1/function/_test` with `dryRun` param
- Get platform status: `GET /api/v1/status` with `verbose` param
