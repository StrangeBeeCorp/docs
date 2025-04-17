# How to Migrate Audit Log Storage to Elasticsearch

[Badge version 5.5]

TheHive allows you to choose between storing audit logs in Apache Cassandra via JanusGraph or in [Elasticsearch](https://www.elastic.co/enterprise-search).

This topic provides step-by-step instructions for migrating TheHive's audit log storage to Elasticsearch.

!!! info "Reasons to consider Elasticsearch"
    Elasticsearch is better suited for managing large volumes of audit logs. It enhances performance by efficiently handling data, reducing latency, and offering advanced search capabilities. If your organization generates a significant amount of audit logs, migrating to Elasticsearch can improve both data management and accessibility.

!!! warning "No rollback possible"
    TheHive doesn't support transferring audit logs back from Elasticsearch to JanusGraph. Once migrated, the audit logs in Elasticsearch can't be rolled back.

!!! note "New installations"
    For new installations, refer to the [Step-by-Step Guide](../installation/step-by-step-installation-guide.md) for instructions.

Two options are possible depending on your organization's requirements and needs:

* [Migrate without historical audit logs](#migrate-without-historical-audit-logs)
* [Migrate with historical audit logs](#migrate-with-historical-audit-logs)

## Prerequisites

### Use Elasticsearch 7.17 or later

Make sure you're using Elasticsearch version 7.17 or later to guarantee compatibility with TheHive's audit log storage.

### Back up Elasticsearch indices

Regularly [back up your Elasticsearch indices](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) to ensure that audit logs can be recovered in case of an incident. This is critical for maintaining the integrity and availability of your data.

### Activate audit log storage in Elasticsearch

To activate audit log storage in Elasticsearch, update your TheHive configuration file with the following settings:

```bash
audit {
  storage = elasticsearch
}
```
By default, the index is created as follows:

* Index template: `thehive-audits`
* Index lifecycle policy (ILM): `thehive-audits` (the datastream, template, and ILM always share the same name)

## Migrate without historical audit logs

## Migrate with historical audit logs

<h2>Next steps</h2>