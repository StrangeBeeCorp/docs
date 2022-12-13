# How to write filtered events for notifications ?

<figure markdown>
  ![Filtered Event](./images/organisation-notifications-filteredevent.png){ width="500" }
  <figcaption>Filtered event example: "Case severity has been updated to Hight or Critical</figcaption>
</figure>

Selecting “FilteredEvent” opens an empty field where we set our custom filter. The filters will apply to the audit of every actions that are happening in your organization. When there is a match, a notification is sent. 

## Operators

Filters must be JSON formatted and can use following operators:

* `and`
* `or`
* `_not`
* `_any`
* `_lt`
* `_gt`
* `_lte`
* `_gte`
* `_ne`
* `_eq`
* `_is`
* `_startsWith`
* `_endsWith`
* `_id`
* `_between`
* `_in`
* `_contains`
* `_like`
* `_match`