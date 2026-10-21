# Release Notes of 6.0 Series

{% include-markdown "includes/api-public-v0-deprecation.md" %}

!!! warning "Java 17 required"
    TheHive 6.0 runs on Java 17 instead of Java 11. Package installations must [set up Java 17](../installation/upgrade-from-5.x.md#optional-step-3-set-up-java-17) before upgrading. Docker Compose and Kubernetes deployments with Helm charts aren't affected, because the image ships its own runtime. Cassandra 4.0.x to 4.1.x still requires Java 11, so where it shares the host with TheHive, [run both Java versions side by side](../operations/thehive-6-cassandra-same-host.md).

!!! warning "Database evolution on upgrade"
    Upgrading to TheHive 6.0 triggers a database evolution on first launch: schema and data updates whose duration depends on your database size and on the version you upgrade from. Plan a maintenance window accordingly.

## 6.0.0 - October 20, 2026

### New features

#### One license

The new [One license](../installation/licenses/about-licenses.md#types-and-pricing) includes every Platinum capability, plus [TheHive Flow](#thehive-flow). It's available for TheHive On-prem only.

#### TheHive Flow <!-- md:license One --> {#thehive-flow}

[TheHive Flow](../../flow/user-guides/about-flow.md) is the workflow orchestrator integrated with TheHive. In a visual editor, users chain triggers, conditions, scripts, and actions into workflows that operate on TheHive, Cortex, large language models (LLMs), and third-party products such as Splunk, Microsoft Sentinel, or VirusTotal. Where notifications, alert feeders, functions, and responders each handle a single event or action, a workflow chains several steps and branches on their results. TheHive Flow runs as a separate component, deployed with Docker Compose or on Kubernetes.

* [Deploy TheHive Flow with Docker Compose](../../flow/installation/docker.md) or [on Kubernetes](../../flow/installation/kubernetes.md)
* [Perform the initial setup](../../flow/installation/perform-initial-setup-as-admin.md)
* [Build your first workflow](../../flow/user-guides/build-your-first-workflow.md)

#### Automation Center

Cases and alerts have a new **Automations** tab listing the responders, functions, and <!-- md:license One --> TheHive Flow workflows run on them. Each list can be filtered and sorted, and responders, functions, and workflows can be run directly from the tab.

* [Review responder reports](../user-guides/analyst-corner/cases/run-responders-on-a-case.md#review-responder-reports-for-a-case)
* [Review function execution results](../user-guides/organization/configure-organization/manage-functions/run-a-function-case-alert.md#review-function-execution-results)
* [Display workflow execution logs](../../flow/user-guides/display-execution-logs.md#display-execution-logs-from-a-case-or-alert)
* [Run a workflow from a case or alert](../../flow/user-guides/manually-run-workflow.md#run-a-workflow-from-a-case-or-alert)

### Improvements

#### Impact requirement on closing statuses <!-- md:license Gold --> <!-- md:license Platinum --> <!-- md:license One -->

Administrators can now [require an impact](../administration/status/require-an-impact-for-a-status.md) for any case status linked to the *Closed* stage. Previously, only the *True Positive* status required an impact, and it still always does.

#### Case report template export and import <!-- md:license Platinum --> <!-- md:license One -->

Case report templates can now be [exported to a file and imported](../user-guides/organization/configure-organization/manage-templates/case-report-templates/export-import-a-case-report-template.md) into another organization or TheHive instance. Images uploaded to Image widgets aren't included in the exported file.

### Fixes

* Audit: Corrected [audit log storage in Elasticsearch](../operations/configure-audit-logs-storage-elasticsearch.md) when the connection uses a trust store. The trust store location and password were swapped, which prevented the storage from starting. An audit storage that fails to start is now reported in the logs.
* Markdown: Restored the spacing between paragraphs in rendered Markdown, so line breaks entered in a Markdown editor now show in descriptions, comments, and task logs.

### Security

* Dependencies: Patched several CVEs reported in third-party libraries.
