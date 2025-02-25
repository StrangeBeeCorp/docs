# TheHive-Flavored Markdown Syntax Reference

This topic provides a reference for TheHive-flavored Markdown syntax.

Markdown is a lightweight markup language designed to format plain text using simple syntax. It allows users to create structured documents, including headings, lists, links, and code blocks, without relying on complex formatting tools.

TheHive uses a customized version of Markdown, known as TheHive-flavored Markdown. This tailored syntax extends the standard Markdown features to support additional formatting options and functionalities specific to TheHive.

## Table of contents

1. [`Headings`](#headings)
2. [`Horizontal rules`](#horizontal-rules)
3. [`Emphasis`](#emphasis)
4. [`Blockquotes`](#blockquotes)
5. [`Lists`](#lists)
6. [`Code`](#code)
7. [`Tables`](#tables)
8. [`Links`](#links)
9. [`Images`](#images)

## Headings

### Syntax

    # h1 Heading
    ## h2 Heading
    ### h3 Heading
    #### h4 Heading
    ##### h5 Heading
    ###### h6 Heading

### Rendering

# h1 Heading
## h2 Heading
### h3 Heading
#### h4 Heading
##### h5 Heading
###### h6 Heading

## Horizontal rules

### Syntax

    --- or *** or ___

### Rendering

---

***

___

## Emphasis

### Syntax

    **This is bold text** or __This is bold text__    
    *This is italic text* or _This is italic text_    
    ~~Strikethrough~~
    ++This is underlined text++

### Rendering

**This is bold text**

*This is italic text*

~~Strikethrough~~

++This is underlined text++

## Blockquotes

### Syntax

    > Blockquotes can also be nested...
    >> ...by using additional greater-than signs right next to each other...
    > > > ...or with spaces between arrows.

### Rendering

> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.

## Lists

### Unordered

#### Syntax

    + Create a list by starting a line with `+`, `-`, or `*`
    + Sub-lists are made by indenting 2 spaces:
    - Marker character change forces new list start:
        * Ac tristique libero volutpat at
        + Facilisis in pretium nisl aliquet
        - Nulla volutpat aliquam velit
    + Very easy!

#### Rendering

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

### Ordered

#### Syntax

    1. Lorem ipsum dolor sit amet
    2. Consectetur adipiscing elit
    3. Integer molestie lorem at massa

#### Rendering

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

## Code

#### Syntax

    Inline `code` with `

    Indented code with tab:

    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code

    Block code "fences" with ```:

    ```
    Sample code here...
    ```

#### Rendering

Inline `code` with `

 // Some comments
    line 1 of code
    line 2 of code
    line 3 of code

```
Sample code here...
```

## Tables

### Syntax

#### Alignment on the left

    | Option | Description |
    | ------ | ----------- |
    | data   | Path to data files to supply the data that will be passed into templates. |
    | engine | Engine to be used for processing templates. Handlebars is the default. |
    | ext    | Extension to be used for dest files. |

#### Alignment on the right

    | Option | Description |
    | ------:| -----------:|
    | data   | Path to data files to supply the data that will be passed into templates. |
    | engine | Engine to be used for processing templates. Handlebars is the default. |
    | ext    | Extension to be used for dest files. |

### Rendering

#### Alignment on the left

| Option | Description |
| ------ | ----------- |
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |

#### Alignment on the right

| Option | Description |
| ------:| -----------:|
| data   | Path to data files to supply the data that will be passed into templates. |
| engine | Engine to be used for processing templates. Handlebars is the default. |
| ext    | Extension to be used for dest files. |

## Links

### Syntax

    [Link text](https://docs.strangebee.com/thehive/overview/)
    [Link with title](https://docs.strangebee.com/thehive/overview/ "title text!")

### Rendering

[Link text](https://docs.strangebee.com/thehive/overview/)

[Link with title](https://docs.strangebee.com/thehive/overview/ "title text!")

## Images

### Syntax

    ![TheHive](https://docs.strangebee.com/thehive/images/user-guides/organization-view.png)
    ![Cortex](https://docs.strangebee.com/cortex/user-guides/images/update.png "Cortex")

    Like links, images also have a footnote style syntax:

    ![Alt text][id]

    With a reference later in the document defining the URL location:

    [id]: https://docs.strangebee.com/thehive/images/user-guides/organization-view.png  "Organization view"

### Rendering

![TheHive](https://docs.strangebee.com/thehive/images/user-guides/organization-view.png)
![Cortex](https://docs.strangebee.com/cortex/user-guides/images/update.png "Cortex")

![Alt text][id]

[id]: https://docs.strangebee.com/thehive/images/user-guides/organization-view.png  "Organization view"