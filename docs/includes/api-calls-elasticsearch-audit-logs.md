!!! warning "API calls changes"
    After migrating to Elasticsearch, the following API calls no longer work with audit logs stored in Elasticsearch:
    
    - `listAudit`
    - `listAuditFromObject`
    
    Instead, use the following API calls:
    
    - `list`
    - `count`
    - `get`