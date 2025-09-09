Adjust the `application.conf` file to configure the index template and Index Lifecycle Management (ILM) policy for the `thehive-audits` index. These settings control how Elasticsearch stores, rolls over, and deletes audit logs.

Supported configuration keys:

* `index-name`: Name of the Elasticsearch index for audit logs (default: `thehive-audits`)
* `health-request-timeout`: Timeout for checking cluster health
* `create.ext.number_of_replicas`: Number of index replicas
* `create.ext.number_of_shards`: Number of index shards
* `request-timeout`: Timeout for Elasticsearch requests
* `hot.rollover.maxAge`: Maximum age of an index before rollover
* `hot.rollover.maxSize`: Maximum size of an index before rollover
* `delete.minAge`: Minimum age before an index is deleted

!!! example "Example"
    To create a new index every day or when it reaches 1 GB, and retain it for 7 days, use the following configuration:

    ```json
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

!!! warning "Index name conflict"
    The index name shouldn't be the same as the one used in JanusGraph. If you don’t configure a specific name, TheHive uses the JanusGraph index name appended with the suffix `-audits`.

Based on the configuration above, TheHive automatically generates the index template and ILM policy when it first writes audit data to Elasticsearch.

##### Index template

Default generated index template:

```json
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

##### ILM

Default generated ILM:

```json
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

!!! example "ILM generated from the example configuration"
    Based on the example configuration, TheHive will generate the following ILM policy:

    ```json
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

!!! warning "API calls changes"
    After migrating to Elasticsearch, the following Query API calls no longer work with audit logs stored in Elasticsearch:
    
    * `listAudit`
    * `listAuditFromObject`
    * `getAudit`
    
    Instead, use the following API endpoints:
    
    * `/api/v1/audit/list`
    * `/api/v1/audit/count`
    * `/api/v1/audit/$ID`
  
    These API calls are currently available but not yet officially documented and may change in future releases.