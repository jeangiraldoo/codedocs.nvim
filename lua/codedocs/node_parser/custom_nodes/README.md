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

## Node Types

### **simple**

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

### **boolean**

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

### **accumulator**

Processes each child node and accumulates the values they return.

```lua
node_constructor({
    type = "accumulator",
    children = { node_a, node_b, ... }
})
```

### **finder**

Has two children:

1. The node type to find in a Treesitter tree.
2. A default value to return if the node is found.

```lua
node_constructor({
    type = "finder",
    children = {
        "<Treesitter node type>",
        "default value"
    }
})
```

### **double_recursion**

A recursive node that:  

1. Processes the **first query**.  
2. Recursively searches for nodes of a specified type.  
3. If matching nodes are found, it applies the **second query** to them.

```lua
node_constructor({
    type = "double_recursion",
    children = {
        first_query = <simple node goes here>,
        second_query = <simple node goes here>,
        target = <node type>
    }
})
```

### **chain**

Processes a sequence of queries in order, running the next query on the
results of the previous one.

```lua
node_constructor({
    type = "chain",
    children = {
        query_a, query_b, ...
    }
})
```

### **regex**

Runs a query but filters results based on a regular expression pattern.
The mode parameter determines whether it returns matches (true) or non-matches (false).

```lua
node_constructor({
    type = "regex",
    children = {
        pattern = "<ReGex pattern>",
        mode = true, -- or false
        query = [[<Treesitter query>]]
    }
})
```

### **group** (experimental)

Groups related items and assigns each one a specific type.
Currently, this is mainly used for Go functions to support type grouping.

```lua
node_constructor({
    type = "group",
    children = "<Treesitter query>"
})
```

## Important Note

There are no custom node validations at the moment.
If a node is set up incorrectly, it will result in an unhandled exception.
