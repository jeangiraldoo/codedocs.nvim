# Technical documentation

Welcome! This document provides an overview of the Codedocs codebase to help you contribute to the project, understand how it works internally, or—let's be honest—to help me when I inevitably forget how things are wired together.

Codedocs is a plugin focused on generating and inserting docstrings for programming language structures. In the context of this plugin, a "structure" refers to any language construct such as functions, methods, classes, or variables.

## Table of contents
- [Components](#components)
- [Logic flow](#logic-flow)

## Components

This a detailed representation of the components and subcomponents that form the plugin:

```mermaid
architecture-beta
    group components(cloud)[Components]

    group node_parser(server)[node_parser] in components
    service parser(server)[parser] in node_parser
    service struct_finder(server)[struct_finder] in node_parser
    service query_processor(server)[query_processor] in node_parser
    group custom_nodes(server)[custom_nodes] in node_parser
    service nodes(server)[nodes] in custom_nodes

    group docs_gen(server)[docs_gen] in components
    service builder(server)[builder] in docs_gen

    group specs(server)[specs] in components
    service paths(database)[paths] in specs
    group manager(server)[manager] in specs
    service customizer(server)[customizer] in manager
    service reader(server)[reader] in manager
    group validators(server)[validators] in specs
    service structs(server)[structs] in validators
    service style(server)[style] in validators
    service basic(server)[basic] in validators
    group langs(database)[langs] in specs
    service style_opts(database)[style_opts] in langs
    service lang_specs(database)[lang_specs] in langs

    service writer(server)[writer] in components
    lang_specs:L --> T:reader
    paths:L --> R:reader
    reader:L --> R:builder
    parser:T --> B:builder
    builder:L --> R:writer
```

Here is the documentation for the main components:

- [specs](./specs/README.md)
- [node_parser](./node_parser/README.md)
- docs_gen

## Logic flow

The following diagram provides a visual representation of the logic flow that takes place each time docstring generation is triggered, whether through a Codedocs command or a keymap.

```mermaid
flowchart TB
    1((Codedocs<br>triggered)) --> 2
    2[Detect filetype] --> 3
    3{Is there a Treesitter<br>parser installed<br>for the filetype?}
    3 -- No ---> 4[/Inform the user with a message/]
    3 -- Yes ---> 5{Is there a style<br>for the filetype?}
    5 -- No ---> 6[/Inform the user with a message/]
    5 -- Yes ---> 7{Is there a supported<br>structure node<br>under the cursor?}
    7 -- No ---> 8[Insert a generic docstring]
    7 -- Yes ---> 9[Extract data using<br>the appropriate<br>Struct Parser module]
    9 ---> 10[Build the docstring<br>using the corresponding<br>Docstring Builder module]
    10 --> 11((Docstring<br>inserted))
```
