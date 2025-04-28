# TheHive-Flavored Markdown Syntax Reference

This topic provides a reference for TheHive-flavored Markdown syntax.

Markdown is a lightweight markup language designed to format plain text using simple syntax. It allows users to create structured documents, including headings, lists, links, and code blocks, without relying on complex formatting tools.

TheHive uses a customized version of Markdown, known as TheHive-flavored Markdown. This tailored syntax extends the standard Markdown features to support additional formatting options and functionalities specific to TheHive.

## Table of contents

1. [`Headings`](#headings)
2. [`Horizontal rules`](#horizontal-rules)
3. [`Emphasis`](#emphasis)
4. [`Admonition blocks`](#admonition-blocks)
5. [`Blockquotes`](#blockquotes)
6. [`Lists`](#lists)
7. [`Code`](#code)
8. [`Tables`](#tables)
9. [`Links`](#links)
10. [`Images`](#images)

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

## Admonition blocks

<!-- md:version 5.5 -->

### Syntax

    ::: error
    This block highlights critical information or errors that require immediate attention.
    :::

    ::: warning
    This block alerts users to potential issues or important precautions to consider.
    :::

    ::: success
    This block confirms that an action was completed successfully.
    :::

    ::: info
    This block provides additional information or helpful tips.
    :::

### Rendering

![Admonitions rendering Markdown](/thehive/images/user-guides/admonitions-rendering-markdown.png)

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
    1. Consectetur adipiscing elit
    3. Integer molestie lorem at massa
    42. Fusce lobortis nisi nec mi scelerisque, at tincidunt nisi ullamcorper

#### Rendering

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa
42. Fusce lobortis nisi nec mi scelerisque, at tincidunt nisi ullamcorper

## Code

### Syntax

    Inline `code` with `

    ```
    Sample code here...
    ```

### Rendering

Inline `code` with `

```
Sample code here...
```

!!! tip "<!-- md:version 5.5 --> Code block with syntax highlighting"
    You can enable syntax highlighting by specifying the language name after the opening backticks.

    Syntax

        ``` python
        print("Hello, bees!")
        ```

    Rendering

    ``` python
    print("Hello, bees!")
    ```
    See [the Highlight.js documentation](https://highlightjs.readthedocs.io/en/latest/supported-languages.html?highlight=languages) for a list of supported languages.

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

!!! tip "<!-- md:version 5.5 --> Breaking lines in tables"
    You can break lines within table cells by using the `<br />`, `<br/>`, or `<br>` HTML tags. This feature is limited to table cells and doesn't work elsewhere.

## Links

### Syntax

    [Link text](https://docs.strangebee.com/thehive/overview/)
    [Link with title](https://docs.strangebee.com/thehive/overview/ "title text!")

### Rendering

[Link text](https://docs.strangebee.com/thehive/overview/)

[Link with title](https://docs.strangebee.com/thehive/overview/ "title text!")

## Images

### Syntax

    ![TheHive](https://docs.strangebee.com/thehive/images/user-guides/organization/configure-organization/organization-view.png)
    ![Cortex](https://docs.strangebee.com/cortex/user-guides/images/update.png "Cortex")

    Similar to links, images can also use footnote-style syntax:
    ![Alt text][id]

    With a reference later in the document to define the URL location:
    [id]: https://docs.strangebee.com/thehive/images/user-guides/organization/configure-organization/organization-view.png  "Organization view"

### Rendering

![TheHive](https://docs.strangebee.com/thehive/images/user-guides/organization/configure-organization/organization-view.png)
![Cortex](https://docs.strangebee.com/cortex/user-guides/images/update.png "Cortex")

![Alt text][id]

[id]: https://docs.strangebee.com/thehive/images/user-guides/organization/configure-organization/organization-view.png  "Organization view"

<h2>Next steps</h2>

* [About the Knowledge Base](../user-guides/knowledge-base/about-knowledge-base.md)