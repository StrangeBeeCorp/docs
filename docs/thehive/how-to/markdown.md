# How to Markdown: A Comprehensive Guide

Welcome to the "How to Markdown" guide! In this comprehensive guide, we'll explore the powerful features and capabilities of Markdown – a lightweight markup language that simplifies text formatting while retaining its readability. Whether you're new to Markdown or looking to enhance your existing knowledge, this guide will walk you through each feature step by step, providing you with practical examples and clear explanations.

## Table of Contents

1. [`Heading`](#heading)
2. [`Horizontal Rules`](#horizontal-rules)
3. [`Emphasis`](#emphasis)
4. [`Blockquotes`](#blockquotes)
5. [`Lists`](#lists)
6. [`Code`](#code)
7. [`Tables`](#tables)
8. [`Links`](#links)
9. [`Images`](#images)


---
##Heading

###Code

    # h1 Heading
    ## h2 Heading
    ### h3 Heading
    #### h4 Heading
    ##### h5 Heading
    ###### h6 Heading


###Example

# h1 Heading
## h2 Heading
### h3 Heading
#### h4 Heading
##### h5 Heading
###### h6 Heading

---
# Horizontal Rules

###Code


    --- or *** or ___

###Example

---

---
## Emphasis

###Code

    **This is bold text** or __This is bold text__    
    *This is italic text* or _This is italic text_    
    ~~Strikethrough~~

###Example

**This is bold text**

*This is italic text*

~~Strikethrough~~

---
## Blockquotes

###Code

    > Blockquotes can also be nested...
    >> ...by using additional greater-than signs right next to each other...
    > > > ...or with spaces between arrows.

###Example

> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.

---
## Lists

###Unordered

####Code

    + Create a list by starting a line with `+`, `-`, or `*`
    + Sub-lists are made by indenting 2 spaces:
    - Marker character change forces new list start:
        * Ac tristique libero volutpat at
        + Facilisis in pretium nisl aliquet
        - Nulla volutpat aliquam velit
    + Very easy!

####Example

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

###Ordered

####Code

    1. Lorem ipsum dolor sit amet
    2. Consectetur adipiscing elit
    3. Integer molestie lorem at massa

####Example
1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

---
## Code

Inline `code` with `

Indented code with tab

    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code



Block code "fences" with ```

```
Sample text here...
```

---
## Tables

###Code

    | Option | Description |
    | ------ | ----------- |
    | data   | path to data files to supply the data that will be passed into templates. |
    | engine | engine to be used for processing templates. Handlebars is the default. |
    | ext    | extension to be used for dest files. |

###Example

| Option | Description |
| ------ | ----------- |
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |


###Right aligned columns

####Code

    | Option | Description |
    | ------:| -----------:|
    | data   | path to data files to supply the data that will be passed into templates. |
    | engine | engine to be used for processing templates. Handlebars is the default. |
    | ext    | extension to be used for dest files. |

####Example

| Option | Description |
| ------:| -----------:|
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |


---
## Links

###Code
    [link text](https://docs.strangebee.com/thehive/administration/organisations/)
    [link with title](https://docs.strangebee.com/thehive/administration/organisations/ "title text!")

###Example

[link text](https://docs.strangebee.com/thehive/administration/organisations/)

[link with title](https://docs.strangebee.com/thehive/administration/organisations/ "title text!")

---
## Images

###Code

    ![TheHive](https://www.strangebee.com/images/logos/theHivePlatformBlock.svg)
    ![Cortex](https://www.strangebee.com/images/logos/cortexPlatformBlock.svg "Cortex")

    Like links, Images also have a footnote style syntax

    ![Alt text][id]

    With a reference later in the document defining the URL location:

    [id]: https://www.strangebee.com/images/logos/theHiveCloudPlatformBlock.svg  "TheHive Cloud Platform"

###Example

![TheHive](https://www.strangebee.com/images/logos/theHivePlatformBlock.svg)
![Cortex](https://www.strangebee.com/images/logos/cortexPlatformBlock.svg "Cortex")

![Alt text][id]

With a reference later in the document defining the URL location:

[id]: https://www.strangebee.com/images/logos/theHiveCloudPlatformBlock.svg  "TheHive Cloud Platform"