# Release Notes of 6.0 Series

{% include-markdown "includes/api-public-v0-deprecation.md" %}

!!! warning "Java 17 required"
    TheHive 6.0 runs on Java 17 instead of Java 11. Package installations must [set up Java 17](../installation/upgrade-from-5.x.md#optional-step-3-set-up-java-17) before upgrading. Docker Compose and Kubernetes deployments with Helm charts aren't affected, because the image ships its own runtime. Cassandra 4.0.x to 4.1.x still requires Java 11, so where it shares the host with TheHive, [run both Java versions side by side](../operations/thehive-6-cassandra-same-host.md).

!!! warning "Database evolution on upgrade"
    Upgrading to TheHive 6.0 triggers a database evolution on first launch. This version includes the following schema change:

    * Adds a `requiresImpact` field to existing case statuses, set to `true` for the *True Positive* status only

    Upgrading from a version earlier than 5.8 also applies the schema changes of the intermediate versions. This includes the [5.8 changes on comments, pages, and tags](release-notes-5.8.md), which may take some time to complete, depending on the number of these items in your database. Plan a maintenance window accordingly.

## 6.0.0 - October 20, 2026

Last update: November 19, 2026

### 6.0.0-3 packaging revision - November 19, 2026

This [packaging revision](../installation/thehive-packages.md#understanding-packaging-revisions) of TheHive 6.0.0 doesn't change TheHive application code.

* Docker image: Updated the bundled Java 17 runtime to fix [CVE-2026-114938](https://nvd.nist.gov/vuln/detail/CVE-2026-114938){target=_blank}, known as Java4Shell, and the other vulnerabilities fixed by the November 2026 Java update. Due to a build issue, the `6.0.0-2` Docker images pulled on November 19, 2026, between 8:50 AM and 1:57 PM UTC, didn't include this update. The `6.0.0`, `6.0`, and `6` tags pointed to these images during the same period. To apply the fixes to Docker Compose deployments, [upgrade TheHive](../installation/upgrade-from-6.x.md#step-3-install-the-new-version): pull the latest version of the StrangeBee Docker Compose profiles, set the `thehive_image_version` variable to `6.0.0-3` in the `.env` file, and redeploy. For containers run from the public image directly, update the image tag to `strangebee/thehive:6.0.0-3` and recreate TheHive containers. For Kubernetes deployments, upgrade the release to version 2.1.3 of the `thehive` Helm chart, which uses this image.

!!! warning "Package installations: update Java 17"
    TheHive packages don't include a Java runtime, so upgrading to the `6.0.0-3` packages doesn't fix these vulnerabilities. On each TheHive node, update Java 17 to a version that includes the November 2026 Java update, as listed in the security advisory of your Java vendor, then restart TheHive. With Amazon Corretto set up as described in the [installation guide](../installation/installation-guide-linux-standalone-server.md#step-2-set-up-the-java-virtual-machine-jvm), upgrade the `java-17-amazon-corretto-jdk` package on DEB systems or the `java-17-amazon-corretto-devel` package on RPM systems.

### 6.0.0-2 packaging revision - November 19, 2026

This [packaging revision](../installation/thehive-packages.md#understanding-packaging-revisions) of TheHive 6.0.0 doesn't change TheHive application code.

* Docker image: Updated the bundled Java 17 runtime with the November 2026 Java update. Due to a build issue, the `6.0.0-2` Docker images pulled on November 19, 2026, between 8:50 AM and 1:57 PM UTC, didn't include the updated runtime. The `6.0.0`, `6.0`, and `6` tags pointed to these images during the same period. [Upgrade to 6.0.0-3](#600-3-packaging-revision-november-19-2026).

### New features

#### ONE plan

The new [ONE plan](../installation/licenses/about-licenses.md#plans-and-pricing) includes every Platinum capability, plus [TheHive Flow](#thehive-flow). It's available for TheHive On-prem only.

#### TheHive Flow <!-- md:license ONE --> {#thehive-flow}

[TheHive Flow](../../flow/user-guides/about-flow.md) is the workflow orchestrator integrated with TheHive. In a visual editor, users chain triggers, conditions, scripts, and actions into workflows that operate on TheHive, Cortex, large language models (LLMs), and third-party products such as Splunk, Microsoft Sentinel, or VirusTotal. Where notifications, alert feeders, functions, and responders each handle a single event or action, a workflow chains several steps and branches on their results. TheHive Flow runs as a separate component, deployed with Docker Compose or on Kubernetes.

* [Deploy TheHive Flow with Docker Compose](../../flow/installation/docker.md) or [on Kubernetes](../../flow/installation/kubernetes.md)
* [Perform the initial setup](../../flow/installation/perform-initial-setup-as-admin.md)
* [Build your first workflow](../../flow/user-guides/build-your-first-workflow.md)

#### Automation Center

Cases and alerts have a new **Automations** tab listing the responders, functions, and <!-- md:license ONE --> TheHive Flow workflows run on them. Each list can be filtered and sorted, and responders, functions, and workflows can be run directly from the tab.

* [Review responder reports](../user-guides/analyst-corner/cases/run-responders-on-a-case.md#review-responder-reports-for-a-case)
* [Review function execution results](../user-guides/organization/configure-organization/manage-functions/run-a-function-case-alert.md#review-function-execution-results)
* [Display workflow execution logs](../../flow/user-guides/display-execution-logs.md#display-execution-logs-from-a-case-or-alert)
* [Run a workflow from a case or alert](../../flow/user-guides/manually-run-workflow.md#run-a-workflow-from-a-case-or-alert)

### Improvements

#### Impact requirement on closing statuses <!-- md:license Gold --> <!-- md:license Platinum --> <!-- md:license ONE -->

Administrators can now [require an impact](../administration/status/require-an-impact-for-a-status.md) for any case status linked to the *Closed* stage. Previously, only the *True Positive* status required an impact, and it still always does.

#### Case report template export and import <!-- md:license Platinum --> <!-- md:license ONE -->

Case report templates can now be [exported to a file and imported](../user-guides/organization/configure-organization/manage-templates/case-report-templates/export-import-a-case-report-template.md) into another organization or TheHive instance. Images uploaded to Image widgets aren't included in the exported file.

### Fixes

* Audit: Corrected [audit log storage in Elasticsearch](../operations/configure-audit-logs-storage-elasticsearch.md) when the connection uses a trust store. The trust store location and password were swapped, which prevented the storage from starting. An audit storage that fails to start is now reported in the logs.
* Markdown: Restored the spacing between paragraphs in rendered Markdown, so line breaks entered in a Markdown editor now show in descriptions, comments, and task logs.

### Security

* Dependencies: Patched several CVEs reported in third-party libraries.
