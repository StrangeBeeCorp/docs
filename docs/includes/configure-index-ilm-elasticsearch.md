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

#### ILM

ILM manages the storage, rollover, and deletion of audit logs over time, optimizing long-term storage.

Default ILM:

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

!!! example "Example"
    To create a new index every day or when it reaches 1 GB, and retain it for 7 days, use the following configuration:

    - Index template:

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

    - ILM:

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
    After migrating to Elasticsearch, the following API calls no longer work with audit logs stored in Elasticsearch:
    
    - `listAudit`
    - `listAuditFromObject`
    - `getAudit`
    
    Instead, use the following API calls:
    
    - `list`
    - `count`
    - `get`