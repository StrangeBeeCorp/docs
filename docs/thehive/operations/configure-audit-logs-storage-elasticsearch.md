# How to Configure Audit Log Storage in Elasticsearch

<!-- md:version 5.5 -->

You can choose to store audit logs in either Apache Cassandra via JanusGraph or in [Elasticsearch](https://www.elastic.co/enterprise-search) in TheHive.

By default, TheHive stores audit logs in Apache Cassandra via JanusGraph.

This topic provides step-by-step instructions for configuring TheHive's audit log storage in Elasticsearch for existing instances, including the option to migrate historical logs from JanusGraph.

!!! info "Reasons to consider Elasticsearch"
    Elasticsearch is better suited for managing large volumes of audit logs. It enhances performance by efficiently handling data, reducing latency, and offering advanced search capabilities. If your organization generates a significant amount of audit logs, migrating to Elasticsearch can improve both data management and retrieval.

!!! warning "Audit logs visibility"
    With Elasticsearch, audit logs retain the visibility they had at the time of creation, regardless of the current visibility of the case. This means that even if [you set restricted visibility for a case](../user-guides/analyst-corner/cases/case-visibility/restrict-visibility-case.md), audit logs remain visible to all users.

!!! warning "No rollback possible"
    Since TheHive can only use one audit storage system at a time, when you switch to Elasticsearch, the audit logs stored in JanusGraph become unavailable. TheHive doesn't support transferring audit logs back from Elasticsearch to JanusGraph. 

!!! note "New installations"
    For new installations, refer to the [Step-by-Step Guide](../installation/step-by-step-installation-guide.md) for instructions.

## Prerequisites

### Use Elasticsearch 7.17 or later

Make sure you're using Elasticsearch version 7.17 or later to guarantee compatibility with TheHive's audit log storage.

### Back up Elasticsearch indices

Regularly [back up your Elasticsearch indices](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) to ensure you can recover audit logs in the event of an incident. This is critical for maintaining the integrity and availability of your data.

## Step 1: Activate audit log storage in Elasticsearch

{!includes/activate-audit-log-storage-elasticsearch.md!}

## Step 2: Configure index template and Index Lifecycle Management (ILM)

{!includes/configure-index-ilm-elasticsearch.md!}

## (Optional) Step 3: Migrate historical audit logs to Elasticsearch

TheHive provides a script to assist with migrating historical audit logs from JanusGraph to Elasticsearch. Run the script only if you need to transfer historical audit logs to Elasticsearch.

!!! warning "JanusGraph audit log deletion"
    By default, when migrating audit logs from JanusGraph to Elasticsearch, the logs are deleted from JanusGraph. If you wish to keep the audit logs in JanusGraph while migrating to Elasticsearch, you can prevent their deletion by using a specific option.

Run the `migrateAudits` script:

* If you installed TheHive on a server:

  ``` bash
  ./migrateAudits --audit-from-date <date> -c </etc/thehive/application.conf>
  ```

* If you deployed TheHive with a Docker image:

  ``` bash
  docker run --network host --rm -ti -v </path/to/your/application.conf>:/etc/thehive/application.conf:ro -v </path/to/your/logback.xml>:/etc/thehive/logback.xml:ro strangebee/thehive:5.5.0-1-SNAPSHOT  migrateAudits -Dlogback.configurationFile=/etc/thehive/logback.xml -- --audit-from-date <date> -c /etc/thehive/application.conf
  ```

Available options are:

```
-v, --version: Displays the version of the migration tool.
-h, --help: Displays help information.
-c, --config <file> : Specifies the global configuration file for TheHive.
-y, --transaction-pagesize <value>: Defines the page size for each transaction during the migration.
-n, --no-deletion: Prevents the deletion of audit logs from JanusGraph after they are migrated to Elasticsearch.
--audit-from-date <date>: Migrates only the audit logs created from the specified date. The date format is yyyyMMdd[HH[mm[ss]]] or yyyy/MM/dd HH:mm:ss.
--audit-until-date <date>: Migrates only the audits created until the specified date. The date format is yyyyMMdd[HH[mm[ss]]] or yyyy/MM/dd HH:mm:ss.
```

<h2>Next steps</h2>

* [Back up and restore](../operations/backup-restore/overview.md)
* [Monitoring](monitoring.md)
* [Troubleshooting](troubleshooting.md)