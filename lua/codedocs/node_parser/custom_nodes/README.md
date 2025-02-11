# Custom Nodes

Custom nodes are wrappers around Treesitter queries that add
logic and customization options.  

Vanilla Treesitter queries are designed to retrieve specific nodes,
which works well for most applications. However, Codedocs aims to offer
more advanced and customizable functionality. This means we either:  

- Write a lot of language-specific logic.
- Implement language-agnostic logic in a structured way.  

By introducing recursion and nesting into the second approach, we arrive
at the **custom node system**.

## Node Categories

Nodes are divided into two main categories:

- Branch Nodes: Can have child nodes or queries and process them.
- Leaf Nodes: Do not have children but are used inside branch nodes
to perform specific tasks.

### Branch

A branch node can have nested children or queries when defined.
It processes them using a common function shared across all branch
nodes.

#### **simple (branch)**

A basic node that contains a regular Treesitter query, parsed as usual.

```lua
node_constructor({
    type = "simple",
    children = {
        [[
            <Treesitter query>
        ]]
    }
})
```

#### **boolean (branch)**

Contains two child nodes and selects one based on a boolean setting passed
to the parser.
This is useful for adding conditional logic to specs, such as determining
whether class attributes should be included.

```lua
node_constructor({
    type = "boolean",
    children = { first_node, second_node }
})
```

If a boolean node is intended to process a child node only when its condition
is true (and remain inactive when false), simply define the child node in the
children field. When the condition evaluates to false, no action is performed.

```lua
node_constructor({
    type = "boolean",
    children = { node }
})
```

#### **accumulator (branch)**

Processes a sequence of queries or nodes and accumulates their returned
values.

```lua
node_constructor({
    type = "accumulator",
    children = { child_a, child_b, ... }
})
```

#### **chain (branch)**

Processes a sequence of queries or nodes in order, passing the results
of each step to the next.

```lua
node_constructor({
    type = "chain",
    children = {
        child_a, child_b, ...
    }
})
```

#### **regex (branch)**

Runs a query but filters results based on a regular expression pattern.
The mode parameter determines whether it returns matches (true) or
non-matches (false).

```lua
node_constructor({
    type = "regex",
    data = {
        pattern = "<ReGex pattern>",
        mode = true, -- or false
        query = [[<Treesitter query>]]
    }
})
```

#### **group** (branch/experimental node)

Groups related items and assigns each one a specific type.
Currently, this is mainly used for Go functions to support type grouping.

```lua
node_constructor({
    type = "group",
    children = "<Treesitter query>"
})
```

---

### Leaf

Leaf nodes are self-contained and do not require user-defined children.
Instead, they are nested within other nodes, which provide them with
specific nodes*. Think of them as functions that always return a value
based on the data they receive.

*At the moment, the only branch node capable of passing nodes to a leaf
node is the chain node.

#### **finder (leaf)**

It's focused on finding a specific type of node in a Treesitter node tree,
and either return a default value if it finds at least one node, or return
all found nodes.

1. node_type – The Treesitter node type to search for.
2. mode – true to return all found nodes, false to return a default value
    if at least one node is found.
3. def_val – Returned if the mode is false and a node is found.

```lua
node_constructor({
    type = "finder",
    data = {
        node_type = "<Treesitter node type>",
        mode = false -- Or true
        def_val = "<default value if found>"
    }
})
```

## Important Note

There are no custom node validations at the moment.
If a node is set up incorrectly, it will result in an unhandled exception.
