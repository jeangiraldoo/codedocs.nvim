# Codedocs under the hood

Welcome! This document provides an overview of the Codedocs codebase to help you contribute to the project, understand how it works internally, or—let's be honest—to help me when I inevitably forget how things are wired together.

Codedocs is a plugin focused on generating and inserting docstrings for programming language structures. In the context of this plugin, a "structure" refers to any language construct such as functions, methods, classes, or variables.

## Table of contents
- [Logic flow](#logic-flow)

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
