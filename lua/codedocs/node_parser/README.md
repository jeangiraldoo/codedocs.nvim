# Node Parser

This component is responsible for parsing a structure's custom node tree
and extracting the data needed to generate a docstring.

```mermaid
architecture-beta
    group node_parser(server)[node_parser]
    service parser(server)[parser] in node_parser
    service struct_finder(server)[struct_finder] in node_parser
    service query_processor(server)[query_processor] in node_parser
    group custom_nodes(server)[custom_nodes] in node_parser
    service nodes(server)[nodes] in custom_nodes
```

## What is a Custom Node Tree?

A **custom node tree** is a tree containing multiple nested **custom nodes**
—special constructs designed for Codedocs to enhance the capabilities of
Treesitter queries.

For more details, check out the [technical documentation on custom nodes](./custom_nodes/README.md).

## Parsing Workflow

The process of parsing a structure's custom node tree follows these steps:

1. The **struct_finder** receives a table containing the supported
    structures for a language, along with their associated Treesitter
    node types.
2. If the node under the cursor matches any of the identifiers for
    a structure, the corresponding structure name is returned.
3. The **parser module** takes in the relevant settings and the
    structure's tree, then processes it.
4. After processing the custom node tree, the query_processor runs the
    Treesitter query found in simple nodes.
5. Finally, the processed tree is returned as a table containing
    the extracted data.
