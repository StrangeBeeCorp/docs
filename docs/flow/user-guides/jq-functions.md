# Jq Functions

<!-- md:version 6.0 --> <!-- md:license One -->

[TheHive Flow](about-flow.md) evaluates [jq expressions](https://jqlang.org/manual/){target=_blank} with [gojq](https://github.com/itchyny/gojq){target=_blank}, a Go implementation of jq.

The following fields accept jq expressions:

| Field | What the expression must return |
| ----- | ------------------------------- |
| The condition of an [*If* flow node](configure-flow-node.md#configure-an-if-flow-node) | A single boolean, `true` or `false` |
| The **Field to iterate over** of a [*For each* flow node](configure-flow-node.md#configure-a-for-each-flow-node) | An array or an object to iterate over |
| The **JQ value** of a loop output variable of a *For each* flow node | Any value, collected at each iteration |
| The expression of an input variable in the **Workflow input** section of a [*Webhook* trigger](add-trigger.md#add-a-webhook-trigger) | Any value, assigned to the input variable |
| The [exit variables](manage-input-exit-variables.md) of a workflow | Any value, stored with the run |
| Any node field where an inserted [variable reference](about-flow.md#variables) is displayed as a blue jq expression | Any value, inserted in the field |

In these fields, entering the first characters of a function name displays a list of matching functions with a short description. The **JQ** button next to **$var** opens a searchable list of all functions. Selecting a function inserts only its name: the parentheses and arguments must be added by hand, as shown in the **Function** column of each table.

## Write a jq expression

An expression receives no input: `.` alone evaluates to `null`. Always start from a [variable](about-flow.md#variables), inserted with the **$var** button or by entering `$` and selecting a suggestion, for example `$input.payload.body.host.name | ascii_downcase`.

* `|` passes the result on its left as the input of the expression on its right.
* Function arguments are separated by `;`, not by `,`: `sub("a"; "b")`. A comma produces several values.
* In a string, double each backslash: the regular expression `\d` is written `"\\d"`, and the domain prefix `ACME\` is written `"ACME\\"`.

## How to read the examples

Examples use literal values so the result can be checked. In a workflow, a [variable reference](about-flow.md#variables) replaces the literal, for example `$alert.title | ascii_downcase` instead of `"Phishing" | ascii_downcase`.

Functions that produce several outputs, such as `range` or `scan`, are wrapped in `[ ]` in the examples to collect the outputs into an array.

In the function signatures, `filter` is a jq expression evaluated by the function, such as `.severity > 2` in `select(.severity > 2)`. `path` is a path expression, such as `.password` in `del(.password)`. The other argument types are plain values.

## TheHive Flow functions

These functions are specific to TheHive Flow and aren't part of standard jq.

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `uuid` | Generates a time-ordered UUID version 7 | `uuid` | `"0192a3b4-5c6d-7e8f-9a0b-1c2d3e4f5a6b"` |
| `containsany(string)` | Returns `true` if the string contains any character from the given set | `"team" | containsany("aeiou")` | `true` |
| `trimleft(string)` | Removes leading characters that belong to the given set | `"007" | trimleft("0")` | `"7"` |
| `trimright(string)` | Removes trailing characters that belong to the given set | `"end..." | trimright(".")` | `"end"` |
| `trim(string)` | Removes leading and trailing characters that belong to the given set. Standard jq `trim` takes no argument and removes whitespace only | `"--x--" | trim("-")` | `"x"` |

## Core

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `length` | Returns the length of a string, array, or object, or the absolute value of a number | `"phishing" | length` | `8` |
| `utf8bytelength` | Returns the number of bytes needed to encode the string in UTF-8 | `"café" | utf8bytelength` | `5` |
| `keys` | Returns the sorted keys of an object, or the indices of an array | `{"title": "Login", "severity": 3} | keys` | `["severity", "title"]` |
| `type` | Returns the type of the input as a string: `"null"`, `"boolean"`, `"number"`, `"string"`, `"array"`, or `"object"` | `[1, 2] | type` | `"array"` |
| `empty` | Produces no output. In an *If* condition, the condition evaluates to `false` | `[1, empty, 2]` | `[1, 2]` |
| `not` | Returns the boolean negation of the input | `false | not` | `true` |
| `env` | Returns the environment variables. TheHive Flow turns this off and returns an empty object | `env` | `{}` |
| `transpose` | Transposes an array of arrays, padding shorter rows with `null` | `[[1, 2], [3]] | transpose` | `[[1, 3], [2, null]]` |
| `builtins` | Returns the names of all built-in functions with their number of arguments | `builtins` | An array of names such as `"map/1"` |
| `modulemeta` | Returns metadata about a module. Fails in TheHive Flow | `"m" | modulemeta` | Error |

## Type selection

Each function returns the input unchanged when it has the expected type, and produces no output otherwise. Combined with `map`, they filter an array by type.

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `arrays` | Selects arrays | `[1, "a", [2]] | map(arrays)` | `[[2]]` |
| `objects` | Selects objects | `[{"a": 1}, "b"] | map(objects)` | `[{"a": 1}]` |
| `iterables` | Selects arrays and objects | `[1, [2], {"a": 3}] | map(iterables)` | `[[2], {"a": 3}]` |
| `booleans` | Selects booleans | `[true, 1, false] | map(booleans)` | `[true, false]` |
| `numbers` | Selects numbers | `[1, "2", 3] | map(numbers)` | `[1, 3]` |
| `strings` | Selects strings | `["a", 1, null] | map(strings)` | `["a"]` |
| `nulls` | Selects `null` values | `[1, null, 2] | map(nulls)` | `[null]` |
| `values` | Selects values that aren't `null` | `[1, null, "a"] | map(values)` | `[1, "a"]` |
| `scalars` | Selects values that aren't arrays or objects | `[1, "a", [2], {"b": 3}] | map(scalars)` | `[1, "a"]` |
| `normals` | Selects normal numbers: finite, non-zero, and not subnormal | `[0, 1.5, infinite] | map(normals)` | `[1.5]` |
| `finites` | Selects numbers that aren't infinite. `nan` is kept | `[1, infinite, nan] | map(finites)` | `[1, null]` |

## Objects and arrays

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `has(any)` | Returns `true` if the object has the given key, or the array has the given index | `{"title": "Login"} | has("title")` | `true` |
| `in(object)` | Returns `true` if the input key exists in the given object | `"title" | in({"title": "Login"})` | `true` |
| `map(filter)` | Applies the filter to each element of an array | `[1, 2, 3] | map(. * 2)` | `[2, 4, 6]` |
| `map_values(filter)` | Applies the filter to each value of an object, or each element of an array | `{"a": 1, "b": 2} | map_values(. + 1)` | `{"a": 2, "b": 3}` |
| `select(filter)` | Returns the input unchanged if the filter is `true`, and produces no output otherwise | `[1, 5, 8] | map(select(. > 4))` | `[5, 8]` |
| `del(path)` | Removes a key from an object, or an element from an array | `{"user": "alice", "password": "x"} | del(.password)` | `{"user": "alice"}` |
| `add`, `add(filter)` | Adds the elements of an array together: sums numbers, concatenates strings and arrays, merges objects. With a filter, adds the outputs of the filter | `[1, 2, 3] | add` | `6` |
| `any`, `any(filter)`, `any(filter; filter)` | Returns `true` if any element of the array is `true`, or satisfies the condition | `[1, 5] | any(. > 4)` | `true` |
| `all`, `all(filter)`, `all(filter; filter)` | Returns `true` if all elements of the array are `true`, or satisfy the condition | `[1, 5] | all(. > 4)` | `false` |
| `sort` | Sorts the elements of an array. Mixed types sort in this order: `null`, booleans, numbers, strings, arrays, objects | `[3, 1, 2] | sort` | `[1, 2, 3]` |
| `sort_by(filter)` | Sorts the elements of an array by the result of the filter | `[{"s": 3}, {"s": 1}] | sort_by(.s)` | `[{"s": 1}, {"s": 3}]` |
| `group_by(filter)` | Groups the elements of an array by the result of the filter | `[{"t": "ip"}, {"t": "url"}, {"t": "ip"}] | group_by(.t)` | `[[{"t": "ip"}, {"t": "ip"}], [{"t": "url"}]]` |
| `unique` | Returns the sorted elements of an array without duplicates | `[3, 1, 3] | unique` | `[1, 3]` |
| `unique_by(filter)` | Returns one element per distinct result of the filter | `[{"id": 1, "v": "a"}, {"id": 1, "v": "b"}] | unique_by(.id)` | `[{"id": 1, "v": "a"}]` |
| `min` | Returns the smallest element of an array | `[3, 1, 2] | min` | `1` |
| `max` | Returns the largest element of an array | `[3, 1, 2] | max` | `3` |
| `min_by(filter)` | Returns the element with the smallest result of the filter | `[{"s": 3}, {"s": 1}] | min_by(.s)` | `{"s": 1}` |
| `max_by(filter)` | Returns the element with the largest result of the filter | `[{"s": 3}, {"s": 1}] | max_by(.s)` | `{"s": 3}` |
| `reverse` | Reverses the elements of an array. Fails on a string: use `explode | reverse | implode` instead | `[1, 2, 3] | reverse` | `[3, 2, 1]` |
| `flatten`, `flatten(number)` | Flattens nested arrays, fully or down to the given depth | `[1, [2, [3]]] | flatten(1)` | `[1, 2, [3]]` |
| `contains(any)` | Returns `true` if the input completely contains the argument. For strings, tests for a substring, also inside arrays: `["tor-exit"] | contains(["tor"])` is `true` | `"phishing" | contains("ish")` | `true` |
| `inside(any)` | Returns `true` if the input is completely contained in the argument | `["a"] | inside(["a", "b"])` | `true` |
| `to_entries` | Converts an object to an array of `{key, value}` objects | `{"a": 1} | to_entries` | `[{"key": "a", "value": 1}]` |
| `from_entries` | Converts an array of `{key, value}` objects to an object | `[{"key": "a", "value": 1}] | from_entries` | `{"a": 1}` |
| `with_entries(filter)` | Applies the filter to each `{key, value}` entry of an object | `{"a": 1} | with_entries(.value += 1)` | `{"a": 2}` |
| `pick(path)` | Keeps only the given paths of the input | `{"a": 1, "b": {"c": 2, "d": 3}} | pick(.b.c)` | `{"b": {"c": 2}}` |
| `bsearch(any)` | Returns the index of the value in a sorted array. If the value is missing, returns `-1 - i` where `i` is the position where it would be inserted | `[1, 3, 5] | bsearch(3)` | `1` |

## Paths

A path is an array of keys and indices that locates a value, such as `["a", "b"]` for `.a.b`.

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `path(filter)` | Returns the path of the value selected by the filter | `{"a": {"b": 1}} | path(.a.b)` | `["a", "b"]` |
| `paths`, `paths(filter)` | Returns all paths of the input, or only the paths of values matching the filter | `{"a": {"b": 1}} | [paths]` | `[["a"], ["a", "b"]]` |
| `getpath(array)` | Returns the value at the given path | `{"a": {"b": 1}} | getpath(["a", "b"])` | `1` |
| `setpath(array; any)` | Sets the value at the given path | `{} | setpath(["a", "b"]; 1)` | `{"a": {"b": 1}}` |
| `delpaths(array)` | Deletes the values at the given paths | `{"a": 1, "b": 2} | delpaths([["a"]])` | `{"b": 2}` |

## Strings

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `startswith(string)` | Returns `true` if the string starts with the given prefix | `"INC-42" | startswith("INC-")` | `true` |
| `endswith(string)` | Returns `true` if the string ends with the given suffix | `"report.pdf" | endswith(".pdf")` | `true` |
| `ltrimstr(string)` | Removes the prefix if present | `"INC-42" | ltrimstr("INC-")` | `"42"` |
| `rtrimstr(string)` | Removes the suffix if present | `"report.pdf" | rtrimstr(".pdf")` | `"report"` |
| `trimstr(string)` | Removes the given string from both ends if present | `"--x--" | trimstr("--")` | `"x"` |
| `ltrim` | Removes leading whitespace | `"  a  " | ltrim` | `"a  "` |
| `rtrim` | Removes trailing whitespace | `"  a  " | rtrim` | `"  a"` |
| `trim`, `trim(string)` | Removes leading and trailing whitespace. With an argument, removes the given characters instead. See [TheHive Flow functions](#thehive-flow-functions) | `"  a  " | trim` | `"a"` |
| `split(string)`, `split(string; string)` | Splits a string on a separator. With two arguments, the first is a regular expression and the second its flags | `"a,b,c" | split(",")` | `["a", "b", "c"]` |
| `join(string)` | Joins the elements of an array into a string with the given separator | `["a", "b"] | join(", ")` | `"a, b"` |
| `ascii_downcase` | Converts ASCII letters to lowercase | `"Phishing" | ascii_downcase` | `"phishing"` |
| `ascii_upcase` | Converts ASCII letters to uppercase | `"Phishing" | ascii_upcase` | `"PHISHING"` |
| `explode` | Converts a string to an array of Unicode code points | `"AB" | explode` | `[65, 66]` |
| `implode` | Converts an array of Unicode code points to a string | `[65, 66] | implode` | `"AB"` |
| `index(any)` | Returns the index of the first occurrence of the argument in a string or array | `"a,b,c" | index(",")` | `1` |
| `rindex(any)` | Returns the index of the last occurrence of the argument | `"a,b,c" | rindex(",")` | `3` |
| `indices(any)` | Returns the indices of all occurrences of the argument | `"a,b,c" | indices(",")` | `[1, 3]` |
| `combinations`, `combinations(number)` | Returns all combinations of the elements of the input arrays. With a number, combinations of the input array with itself that many times | `[[1, 2], [3, 4]] | [combinations]` | `[[1, 3], [1, 4], [2, 3], [2, 4]]` |

## Regular expressions

Regular expressions use the [RE2 syntax](https://github.com/google/re2/wiki/Syntax){target=_blank}. The optional flags argument accepts `g` for all matches, `i` for case-insensitive matching, `x` for extended mode, `n` to ignore empty matches, and `s` for single-line mode.

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `test(string)`, `test(string; string)` | Returns `true` if the string matches the regular expression | `"INC-42" | test("^INC-[0-9]+$")` | `true` |
| `match(string)`, `match(string; string)` | Returns a match object with `offset`, `length`, `string`, and `captures` | `"INC-42" | match("[0-9]+") | .string` | `"42"` |
| `capture(string)`, `capture(string; string)` | Returns an object of the named capture groups | `"INC-42" | capture("(?<id>[0-9]+)")` | `{"id": "42"}` |
| `scan(string)`, `scan(string; string)` | Returns all non-overlapping matches | `"a1b22" | [scan("[0-9]+")]` | `["1", "22"]` |
| `splits(string)`, `splits(string; string)` | Splits the string on a regular expression, producing one output per part | `"a1b22c" | [splits("[0-9]+")]` | `["a", "b", "c"]` |
| `sub(string; string)`, `sub(string; string; string)` | Replaces the first match with the replacement string | `"a-b-c" | sub("-"; "_")` | `"a_b-c"` |
| `gsub(string; string)`, `gsub(string; string; string)` | Replaces all matches with the replacement string | `"a-b-c" | gsub("-"; "_")` | `"a_b_c"` |

## Conversion and formatting

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `tonumber` | Converts a string to a number | `"42" | tonumber` | `42` |
| `tostring` | Converts the input to a string. Arrays and objects are encoded as JSON | `42 | tostring` | `"42"` |
| `toboolean` | Converts the strings `"true"` and `"false"` to booleans | `"true" | toboolean` | `true` |
| `tojson` | Encodes the input as a JSON string | `{"a": 1} | tojson` | `"{\"a\":1}"` |
| `fromjson` | Parses a JSON string into a value | `"{\"a\":1}" | fromjson` | `{"a": 1}` |
| `format(string)` | Formats the input with the named format: `base64`, `base64d`, `csv`, `html`, `json`, `sh`, `text`, `tsv`, `uri`, or `urid`. Same as the `@base64` shorthand syntax | `"hi" | format("base64")` | `"aGk="` |

A format can precede a string: only the `\(...)` parts are encoded. A typical use is building a pivot URL, for example `$input.payload.body.source.ip | @uri "https://www.virustotal.com/gui/ip-address/\(.)"`.

## Dates and times

Timestamps are Unix timestamps, in seconds. A broken-down time is an array of `[year, month, day, hours, minutes, seconds, day of week, day of year]`, with the month, day of week, and day of year starting at 0.

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `now` | Returns the current Unix timestamp, with decimals | `now | floor` | `1790812800` |
| `todate` | Formats a Unix timestamp as an ISO 8601 date string | `1700000000 | todate` | `"2023-11-14T22:13:20Z"` |
| `fromdate` | Parses an ISO 8601 date string into a Unix timestamp. Fails on fractions of seconds: remove them first with `sub("\\.[0-9]+"; "")` | `"2023-11-14T22:13:20Z" | fromdate` | `1700000000` |
| `todateiso8601` | Same as `todate` | `1700000000 | todateiso8601` | `"2023-11-14T22:13:20Z"` |
| `fromdateiso8601` | Same as `fromdate` | `"2023-11-14T22:13:20Z" | fromdateiso8601` | `1700000000` |
| `gmtime` | Converts a Unix timestamp to a broken-down time in UTC | `1700000000 | gmtime` | `[2023, 10, 14, 22, 13, 20, 2, 317]` |
| `localtime` | Converts a Unix timestamp to a broken-down time in the time zone of the server running TheHive Flow | `1700000000 | localtime` | `[2023, 10, 14, 22, 13, 20, 2, 317]` on a UTC server |
| `mktime` | Converts a broken-down time to a Unix timestamp | `[2023, 10, 14, 22, 13, 20, 2, 317] | mktime` | `1700000000` |
| `strftime(string)` | Formats a Unix timestamp or broken-down time with a [format string](https://man7.org/linux/man-pages/man3/strftime.3.html){target=_blank} | `1700000000 | strftime("%Y-%m-%d")` | `"2023-11-14"` |
| `strptime(string)` | Parses a string into a broken-down time with a format string | `"2023-11-14" | strptime("%Y-%m-%d")` | `[2023, 10, 14, 0, 0, 0, 2, 317]` |
| `strflocaltime(string)` | Formats a Unix timestamp or broken-down time with a format string, in the time zone of the server running TheHive Flow | `1700000000 | strflocaltime("%H:%M")` | `"22:13"` on a UTC server |

## Control flow

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `range(number)`, `range(number; number)`, `range(number; number; number)` | Generates numbers up to a limit, from a start, with a step | `[range(1; 4)]` | `[1, 2, 3]` |
| `while(filter; filter)` | Repeats an update while the condition is `true`, producing each value | `[1 | while(. < 10; . * 2)]` | `[1, 2, 4, 8]` |
| `until(filter; filter)` | Repeats an update until the condition is `true`, producing the final value | `1 | until(. > 10; . * 2)` | `16` |
| `repeat(filter)` | Applies the filter to the input again and again, producing the same result endlessly. Wrap it in `limit`. To update a value at each step, use `while` or `range` | `[limit(3; 1 | repeat(. * 2))]` | `[2, 2, 2]` |
| `recurse`, `recurse(filter)`, `recurse(filter; filter)` | Produces the input and all its nested values. With a filter, follows the filter instead, optionally while a condition holds | `{"a": [1]} | [recurse]` | `[{"a": [1]}, [1], 1]` |
| `walk(filter)` | Applies the filter to every nested value, bottom up | `[1, [2]] | walk(if type == "number" then . + 1 else . end)` | `[2, [3]]` |
| `limit(number; filter)` | Produces at most the given number of outputs of the filter | `[limit(2; range(10))]` | `[0, 1]` |
| `skip(number; filter)` | Skips the given number of outputs of the filter | `[skip(2; range(4))]` | `[2, 3]` |
| `first`, `first(filter)` | Returns the first element of an array, or the first output of the filter | `[3, 1] | first` | `3` |
| `last`, `last(filter)` | Returns the last element of an array, or the last output of the filter | `[3, 1] | last` | `1` |
| `nth(number)`, `nth(number; filter)` | Returns the element at the given index of an array, or the output at that position of the filter | `[3, 1, 2] | nth(1)` | `1` |
| `isempty(filter)` | Returns `true` if the filter produces no output | `[] | isempty(.[])` | `true` |

## Error handling

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `error`, `error(string)` | Fails the expression, with the input or the argument as the error message. Wrap the expression in `try` and `catch` to get a fallback value instead: `try ("abc" | tonumber) catch "not a number"` | `{"a": 1} | .b // error("Missing b")` | Error `Missing b` |
| `halt` | Stops the expression without an error. Values already produced are kept, and the following ones are dropped. Inside `[ ]`, the array is never produced, so the example isn't wrapped. An *If* condition using it evaluates to `false` | `1, 2, halt, 3` | `1` and `2` |
| `halt_error`, `halt_error(number)` | Fails the expression with the input as the error message. Stops like `halt` when the input is `null`. The exit code argument is ignored | `"Unexpected status" | halt_error` | Error `Unexpected status` |

## Streaming

A stream represents a value as a sequence of `[path, value]` pairs.

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `tostream` | Converts the input to a stream | `{"a": [1]} | [tostream]` | `[[["a", 0], 1], [["a", 0]], [["a"]]]` |
| `fromstream(filter)` | Rebuilds a value from a stream | `fromstream({"a": [1]} | tostream)` | `{"a": [1]}` |
| `truncate_stream(filter)` | Removes the given number of leading path levels from a stream | `[1 | truncate_stream([[0], 1], [[1, 0], 2], [[1, 0]], [[1]])]` | `[[[0], 2], [[0]]]` |

## Numbers

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `infinite` | Returns positive infinity | `infinite` | `1.7976931348623157e+308` |
| `nan` | Returns the not-a-number value, encoded as `null` in JSON | `nan | isnan` | `true` |
| `isinfinite` | Returns `true` if the input is infinite | `infinite | isinfinite` | `true` |
| `isnan` | Returns `true` if the input isn't a number | `nan | isnan` | `true` |
| `isfinite` | Returns `true` if the input is a number that isn't infinite. `nan` returns `true` | `1 | isfinite` | `true` |
| `isnormal` | Returns `true` if the input is a normal number: finite, non-zero, and not subnormal | `0 | isnormal` | `false` |
| `floor` | Rounds down to the nearest integer | `3.7 | floor` | `3` |
| `ceil` | Rounds up to the nearest integer | `3.2 | ceil` | `4` |
| `round` | Rounds to the nearest integer, with halves rounded away from zero | `2.5 | round` | `3` |
| `trunc` | Truncates toward zero | `-3.7 | trunc` | `-3` |
| `rint` | Rounds to the nearest integer, with halves rounded to the nearest even integer | `2.5 | rint` | `2` |
| `nearbyint` | Same as `rint` | `2.5 | nearbyint` | `2` |
| `abs` | Returns the absolute value | `-5 | abs` | `5` |
| `fabs` | Returns the absolute value as a floating-point number | `-5 | fabs` | `5` |
| `sqrt` | Returns the square root | `16 | sqrt` | `4` |
| `cbrt` | Returns the cube root | `27 | cbrt` | `3` |
| `pow(number; number)` | Returns the first argument raised to the power of the second | `pow(2; 10)` | `1024` |

## Exponentials and logarithms

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `exp` | Returns e raised to the power of the input | `1 | exp` | `2.718281828459045` |
| `exp2` | Returns 2 raised to the power of the input | `3 | exp2` | `8` |
| `exp10` | Returns 10 raised to the power of the input | `2 | exp10` | `100` |
| `expm1` | Returns e raised to the power of the input, minus 1, accurate for small inputs | `0 | expm1` | `0` |
| `log` | Returns the natural logarithm | `1 | log` | `0` |
| `log2` | Returns the base-2 logarithm | `8 | log2` | `3` |
| `log10` | Returns the base-10 logarithm | `1000 | log10` | `3` |
| `log1p` | Returns the natural logarithm of 1 plus the input, accurate for small inputs | `0 | log1p` | `0` |
| `logb` | Returns the binary exponent of the input | `8 | logb` | `3` |

## Floating-point operations

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `frexp` | Splits the input into a normalized fraction and a power of 2 exponent | `8 | frexp` | `[0.5, 4]` |
| `modf` | Splits the input into its fractional and integer parts | `3.75 | modf` | `[0.75, 3]` |
| `ldexp(number; number)` | Multiplies the first argument by 2 raised to the second | `ldexp(3; 2)` | `12` |
| `scalb(number; number)` | Same as `ldexp` | `scalb(3; 2)` | `12` |
| `scalbln(number; number)` | Same as `ldexp` | `scalbln(3; 2)` | `12` |
| `significand` | Returns the significand of the input, between 1 and 2 | `8 | significand` | `1` |
| `fmod(number; number)` | Returns the remainder of the division, with the sign of the first argument | `fmod(7; 3)` | `1` |
| `remainder(number; number)` | Returns the IEEE remainder of the division | `remainder(7; 3)` | `1` |
| `drem(number; number)` | Same as `remainder` | `drem(7; 3)` | `1` |
| `fdim(number; number)` | Returns the positive difference between the arguments, or `0` if the first is smaller | `fdim(5; 3)` | `2` |
| `fma(number; number; number)` | Returns `x * y + z` computed as a single operation | `fma(2; 3; 4)` | `10` |
| `fmax(number; number)` | Returns the larger argument | `fmax(2; 5)` | `5` |
| `fmin(number; number)` | Returns the smaller argument | `fmin(2; 5)` | `2` |
| `copysign(number; number)` | Returns the first argument with the sign of the second | `copysign(3; -1)` | `-3` |
| `hypot(number; number)` | Returns the square root of the sum of the squares of the arguments | `hypot(3; 4)` | `5` |
| `nextafter(number; number)` | Returns the next representable number after the first argument, toward the second | `nextafter(1; 2)` | `1.0000000000000002` |
| `nexttoward(number; number)` | Same as `nextafter` | `nexttoward(1; 2)` | `1.0000000000000002` |

## Special functions

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `gamma` | Returns the gamma function. Same as `tgamma` | `5 | gamma` | `24` |
| `tgamma` | Returns the gamma function | `5 | tgamma` | `24` |
| `lgamma` | Returns the natural logarithm of the absolute value of the gamma function | `5 | lgamma` | `3.1780538303479458` |
| `erf` | Returns the error function | `0 | erf` | `0` |
| `erfc` | Returns the complementary error function | `0 | erfc` | `1` |
| `j0` | Returns the Bessel function of the first kind of order 0 | `0 | j0` | `1` |
| `j1` | Returns the Bessel function of the first kind of order 1 | `0 | j1` | `0` |
| `jn(number; number)` | Returns the Bessel function of the first kind of the given order | `jn(2; 0)` | `0` |
| `y0` | Returns the Bessel function of the second kind of order 0 | `1 | y0` | `0.08825696421567697` |
| `y1` | Returns the Bessel function of the second kind of order 1 | `1 | y1` | `-0.7812128213002887` |
| `yn(number; number)` | Returns the Bessel function of the second kind of the given order | `yn(1; 1)` | `-0.7812128213002887` |

## SQL-style functions

| Function | Description | Example | Result |
| -------- | ----------- | ------- | ------ |
| `IN(filter)`, `IN(filter; filter)` | Returns `true` if the input, or the outputs of the first filter, appear in the outputs of the last filter | `2 | IN(1, 2, 3)` | `true` |
| `INDEX(filter)`, `INDEX(filter; filter)` | Builds an object indexed by the result of the filter applied to each element | `[{"id": "a", "v": 1}] | INDEX(.id)` | `{"a": {"id": "a", "v": 1}}` |
| `JOIN(filter; filter)`, `JOIN(filter; filter; filter)`, `JOIN(filter; filter; filter; filter)` | Pairs each element with the entry of an index object matching the result of the filter | `[{"id": "a"}] | JOIN({"a": "Alpha"}; .id)` | `[[{"id": "a"}, "Alpha"]]` |

## Common pitfalls

| Pitfall | What happens | What to do |
| ------- | ------------ | ---------- |
| Comparing a string to a number | `"73" > 70` and `"5" > 70` both return `true`: any string is greater than any number | Convert first: `$<node_name>.body.risk_score | tonumber > 70` |
| Separating arguments with `,` | `sub("a", "b")` doesn't pass two arguments: the comma produces two values | Separate arguments with `;`: `sub("a"; "b")` |
| A condition that returns several values | `$<node_name>.body.observables[] | .dataType == "ip"` returns one boolean per observable, and the *If* node fails with *too many jq values* | Reduce the result to a single boolean with `any`, `all`, or `length > 0` |
| A condition that returns nothing | An empty result, from a `select` that keeps nothing or from `halt`, evaluates to `false` | Make the case explicit with `isempty` when needed |
| A condition that doesn't return a boolean | A number or a string makes the *If* node fail with *did not yield a boolean* | End the condition with a comparison |
| Starting from `.` | `.` evaluates to `null`: `.alert.id` returns `null`, and `split(",")` fails | Start from a variable |
| Fractions of seconds in a date | `"2026-09-29T08:12:31.482Z" | fromdate` fails | Use `sub("\\.[0-9]+"; "") | fromdate` |
| Timestamps in milliseconds | TheHive, Elastic, and many APIs return milliseconds: `todate` then returns a date in the year 58709 | Divide by 1000 |
| Months in a broken-down time | Months range from 0 to 11: September is `8` | Add 1 for display, or use `strftime` |
| `localtime` and `strflocaltime` | They use the time zone of the server running TheHive Flow, not the time zone of the analyst | Prefer `gmtime` and `strftime`, and state UTC in the text |
| `contains` on an array of strings | `["tor-exit"] | contains(["tor"])` returns `true`, because strings match as substrings | Use `any(.[]; . == "tor")` for a strict match |
| Single backslashes in strings | `"ACME\j"` is invalid | Double backslashes: `"ACME\\j"`, and in a regular expression `"\\d"` or `"\\."` |
| Endless generators | `repeat` or `range(1e12)` stop after 100,000 results, and the expression fails | Wrap generators in `limit(<number>; <stream>)` |
| Secret variables in a *For each* node | The workflow validation rejects `$secret` in the **Field to iterate over**, because the iterated list is stored as is | Use secret variables in the fields of action and integration nodes |

## Unavailable functions

The following standard jq functions aren't available in TheHive Flow. An expression using them fails.

| Function | Error message |
| -------- | ------------- |
| `input`, `inputs` | *input(s)/0 is not allowed*. TheHive Flow evaluates each expression on a single value, without an input stream |
| `debug`, `stderr`, `input_filename`, `input_line_number`, `keys_unsorted`, `toarray`, `have_literal_numbers`, `have_decnum`, `get_search_list`, `get_jq_origin`, `get_prog_origin` | *function not defined* |

## Functions that behave differently

The following standard jq functions are available but don't behave as in standard jq:

| Function | Behavior in TheHive Flow |
| -------- | ------------------------ |
| `env` | Returns an empty object |
| `modulemeta` | Fails. TheHive Flow loads no jq module |
| `halt_error(number)` | The exit code argument is ignored |

<h2>Next steps</h2>

* [Configure a Flow Node](configure-flow-node.md)
* [Add a Trigger](add-trigger.md)
* [Manage Input and Exit Variables](manage-input-exit-variables.md)
* [jq manual](https://jqlang.org/manual/){target=_blank}
