# How to Configure Audit Log Storage in Elasticsearch

[Badge version 5.5]

TheHive allows you to choose between storing audit logs in Apache Cassandra via JanusGraph or in [Elasticsearch](https://www.elastic.co/enterprise-search).

This topic provides step-by-step instructions for configuring TheHive's audit log storage in Elasticsearch, including the option to migrate historical logs from JanusGraph.

!!! info "Reasons to consider Elasticsearch"
    Elasticsearch is better suited for managing large volumes of audit logs. It enhances performance by efficiently handling data, reducing latency, and offering advanced search capabilities. If your organization generates a significant amount of audit logs, migrating to Elasticsearch can improve both data management and retrieval.

!!! warning "No rollback possible"
    TheHive doesn't support transferring audit logs back from Elasticsearch to JanusGraph. Since TheHive can only use one audit storage system at a time, when you switch to Elasticsearch, the audit logs stored in JanusGraph become unavailable.

!!! note "New installations"
    For new installations, refer to the [Step-by-Step Guide](../installation/step-by-step-installation-guide.md) for instructions.

## Prerequisites

### Use Elasticsearch 7.17 or later

Make sure you're using Elasticsearch version 7.17 or later to guarantee compatibility with TheHive's audit log storage.

### Back up Elasticsearch indices

Regularly [back up your Elasticsearch indices](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) to ensure that audit logs can be recovered in case of an incident. This is critical for maintaining the integrity and availability of your data.

## Step 1: Activate audit log storage in Elasticsearch

To activate audit log storage in Elasticsearch, update your TheHive configuration file with the following settings:

```bash
audit {
  storage = elasticsearch
}
```

## Step 2: Configure index template and Index Lifecycle Management (ILM)

Configure the default index template and Index Lifecycle Management (ILM) for `thehive-audits` using the following settings:

* `index-name`
* `health-request-timeout`
* `create.ext.number_of_replicas`
* `create.ext.number_of_shards`
* `request-timeout`
* `hot.rollover.maxAge`
* `hot.rollover.maxSize`
* `delete.minAge`

#### Index template

The index template ensures consistent storage and indexing of audit logs.

Default index template:

```bash
{
  "index": {
    "lifecycle": {
      "name": "thehive-audits"
    },
    "number_of_shards": "1",
    "number_of_replicas": "1"
  }
}
```

#### ILM

ILM manages the storage, rollover, and deletion of audit logs over time, optimizing long-term storage.

Default ILM:

```bash
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "set_priority": {
            "priority": 100
          }
        }
      }
    }
  }
}
```

!!! example "Configure rollover and retention"
    To create a new index every day or when it reaches 1 GB, and retain it for 7 days, use the following configuration:

    * Index template:

    ```bash
    audit {
        storage = elasticsearch
        elasticsearch {
            hot.rollover {
                maxAge = 1d
                maxSize = 1g
            }
            delete.minAge = 7d
        }
    }
    ```

    * ILM:

    ```bash
    {
        "policy": {
            "phases": {
                "hot": {
                    "min_age": "0ms",
                    "actions": {
                        "set_priority": {
                            "priority": 100
                        },
                        "rollover": {
                            "max_primary_shard_size": "1gb",
                            "max_age": "1d"
                        }
                    }
                },
                "delete": {
                    "min_age": "7d",
                    "actions": {
                        "delete": {
                            "delete_searchable_snapshot": true
                        }
                    }
                }
            }
        }
    }
    ```

{!includes/api-calls-elasticsearch-audit-logs.md!}

## (Optional) Step 3: Migrate historical audit logs to Elasticsearch

TheHive provides a tool to help migrate historical audit logs from JanusGraph to Elasticsearch. Proceed with these instructions only if you need to transfer historical audit logs to Elasticsearch.

!!! warning "JanusGraph audit log deletion"
    By default, when migrating audit logs from JanusGraph to Elasticsearch, the logs are deleted from JanusGraph. If you wish to keep the audit logs in JanusGraph while migrating to Elasticsearch, you can prevent their deletion by using a specific option.

Run the migrateAudits tool:

* If TheHive is manually installed on a server:

``` bash
./migrateAudits --audit-from-date <date> -c </etc/thehive/application.conf>
```

* If TheHive is deployed with a Docker image:

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