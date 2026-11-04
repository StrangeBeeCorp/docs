# FilteredEvent Trigger Operators

Several operators are available for the [FilteredEvent trigger](write-filtered-event-trigger.md).

!!! warning "Deprecated shorthand"
    <!-- md:version 5.4 --> The shorthand `{ "_operator": { "field": value } }` is deprecated and logs a warning when used. For all comparison and string operators, the explicit `_field`/`_value` form replaces it:

    ```json
    { "_eq": { "_field": "action", "_value": "create" } }
    ```

## Logical operators

* `_and`: Matches when all conditions are met

This operator requires all filters in the array to be true to include an event.

```
{"_and": [
  { ... filterA },
  { ... filterB }
]}
```

* `_or`: Matches when at least one condition is met

This operator returns events that match any of the given filters.

```
{"_or": [
  { ... filterA },
  { ... filterB }
]}
```

* `_not`: Excludes results that match the given filter

This operator inverts the condition. It returns events that don't match the specified filter.

```
{"_not": {... filterA} }
```

## Comparison operators

* `_lt`, `_gt`, `_lte`, and `_gte`: Compare numerical values

These operators filter events based on a numeric condition: `_lt` for less than, `_gt` for greater than, `_lte` for less than or equal, and `_gte` for greater than or equal.

```json
{ "_lt": { "_field": "foo", "_value": 42 } }
```

* `_eq` and `_is`: Match an exact value

`_eq` is an alias for `_is`. Both check for exact matches.

```json
{ "_eq": { "_field": "foo", "_value": 42 } }
```

```json
{ "_eq": { "_field": "foo", "_value": "LOW" } }
```

On an array field, both match when one of the elements equals the value:

```json
{ "_eq": { "_field": "tags", "_value": "foo" } }
```

* `_ne`: Matches a different value

This operator filters events where a field doesn't equal a given value. It doesn't match events where the field is missing.

```json
{ "_ne": { "_field": "foo", "_value": "LOW" } }
```

On an array field, `_ne` matches when at least one element differs from the value. For example, `{ "_ne": { "_field": "tags", "_value": "foo" } }` matches an event whose tags are `["foo", "bar"]`.

The following filter matches events whose tags don't include `foo`:

```json
{ "_not": { "_eq": { "_field": "tags", "_value": "foo" } } }
```

## String operators

* `_startsWith` and `_endsWith`: Match strings that begin or end with a specific sequence of characters

These operators filter events based on whether a string starts with or ends with a given value. The comparison is case-sensitive.

```json
{ "_startsWith": { "_field": "foo", "_value": "LOW" } }
```

* `_like`: Matches a substring

This operator filters events where a string contains a given value. The comparison is case-sensitive.

For a field whose value is `Alice`, the following filters match:

```json
{ "_like": { "_field": "foo", "_value": "Ali" } }
```

```json
{ "_like": { "_field": "foo", "_value": "ice" } }
```

* `_match`: Matches a word

This operator filters events where a string contains a given word. The value must be a single word, and it must match a whole word in the string. The comparison isn't case-sensitive.

```json
{
  "_match": { "_field": "foo", "_value": "alice" }
}
```

## Range and inclusion operators

* `_between`: Matches values within a range

This operator returns events where a numeric field falls within a specified range. The range includes the `_from` value and excludes the `_to` value.

```json
{ "_between": { "_field": "foo", "_from": 0, "_to": 2 } }
```

This operator only works when `foo` is a number.

* `_in`: Matches one of several values

This operator checks whether a field's value is one of the values in a predefined list. On an array field, it matches when at least one element is in the list.

It works with numbers:

```json
{ "_in": { "_field": "foo", "_values": [1, 42] } }
```

It works with strings:

```json
{ "_in": { "_field": "tags", "_values": ["foo", "bar"] } }
```

## Existence and content operators

* `_contains`: Checks whether a field contains a specific value

This operator filters events where a string contains a given value. On an array field, it matches when one of the elements contains the value. The comparison is case-sensitive.

```json
{ "_contains": { "_field": "foo", "_value": "LOW" } }
```

!!! warning "Deprecation"
    The `_contains` operator is deprecated. It's replaced by [`_eq`](#comparison-operators) for exact values in arrays and by [`_like`](#string-operators) for substrings.

* `_has`: Checks whether a field is present

This operator filters events that contain a specific field.

```json
{ "_has": "foo" }
```

* `_empty`: Checks whether a field is empty

This operator filters events where a field is empty. A field is empty when it contains `""`, an empty array `[]`, or `null`.

```json
{ "_empty": "foo" }
```

The following filter matches events where a field doesn't exist:

```json
{ "_not": {"_has": "foo"} }
```

* `_id`: Matches an event by its unique identifier

This operator filters events based on the top-level `_id` field. This field identifies the event itself, not the object affected by the event.

```json
{
  "_id": "~327925760"
}
```

The following filter matches events on a specific object:

```json
{ "_eq": { "_field": "object._id", "_value": "~327925760" } }
```

* `_arrayMatch`: Checks whether any element within an array field satisfies a specified condition

This operator only works when the target field is an array of objects.

```json
{
    "_arrayMatch": {
        "_field": "foo",
        "_filter": {
            "_and": [
                {
                    "_eq": {
                        "_field": "name",
                        "_value": "bar"
                    }
                },
                {
                    "_eq": {
                        "_field": "value",
                        "_value": "LOW"
                    }
                }
            ]
        }
    }
}
```

<h2>Next steps</h2>

* [Write a FilteredEvent Trigger](write-filtered-event-trigger.md)