# FilteredEvent Trigger Operators

This topic lists the available operators for use with the [FilteredEvent trigger](write-filtered-event-trigger.md).

## Operators

You can use the following operators to filter events.

### Logical operators

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

This operator inverts the condition, returning events that don't match the specified filter.

```
{"_not": {... filterA} }
```

* `_any`: Matches any event (useful for wildcard filtering)

This operator removes all filtering and returns all events.

```json
{  "_any": "" }
```

### Comparison operators

* `_lt`, `_gt`, `_lte`, and `_gte`: Compare numerical values

These operators filter events based on less than (`_lt`), greater than (`_gt`), less than or equal (`_lte`), or greater than or equal (`_gte`) conditions.

```json
{ "_lt": { "foo" : 42 } }
```

* `_eq` and `_is`: Matches an exact value

`_eq` is an alias for `_is`. Both check for exact matches.

```json
{ "_eq": { "foo": 42 } }
```

```json
{ "_eq": { "foo": "LOW" } }
```

Also works with arrays:

```json
{ "_eq": { "tags": ["foo", "bar"] } }
```

### String operators

* `_startsWith` and `_endsWith`: Matches strings that begin or end with a specific sequence of characters

These operators filter events based on whether a string starts with or ends with a given value.

```json
{ "_startsWith": { "foo": "LOW" } }
```

* `_like`: Matches a string using wildcards (*)

This operator performs pattern matching using wildcards (*).

```json
{ "_like": { "foo": "*ice" } }
```

```json
{ "_like": { "foo": "ali*" } }
```

```json
{ "_like": { "foo": "*lce*" } }
```

### Range and inclusion operators

* `_between`: Matches values within a range

This operator returns events where a numeric field falls within a specified range.

```json
{ "_between": { "_field": "foo", "_from": 0, "_to": 2 } }
```

Only works when `foo` is a number.

* `_in`: Matches when a value exists in an array

This operator checks if a field’s value is one of the values in a predefined list.

Works with numbers:

```json
{ "_in": { "_field": "foo", "_values": [1, 42] } }
```

Works with strings:

```json
{ "_in": { "_field": "tags", "_values": ["foo", "bar"] } }
```

### Existence and content operators

* `_contains`: Checks if a field contains a specific value

This operator searches within strings or arrays of strings.

```json
{ "_contains": { "foo": "LOW" } }
```

* `_has`: Checks if a field is present

This operator filters events that contain a specific field.

```json
{ "_has": "foo" }
```

* `_empty`: Checks if a field is empty

This operator filters events where a field is empty (contains `""`, an empty array `[]`, or `null`).

```json
{ "_empty": "foo" }
```

To check if a field doesn't exist, use:

```json
{ "_not": {"_has": "foo"} }
```

* `_arrayMatch`: Checks if any element within an array field satisfies a specified condition

```json
{
    "_arrayMatch": {
        "_field": "foo",
        "_filter": {
            "_and": [
                {
                    "_eq": {
                        "name": "bar"
                    }
                },
                {
                    "_eq": {
                        "value": "LOW"
                    }
                }
            ]
        }
    }
}
```

## Next steps

* [Write a FilteredEvent Trigger](write-filtered-event-trigger.md)