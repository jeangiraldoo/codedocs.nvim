<!-- markdownlint-disable-next-line MD033 MD041 -->
<div align="center">

![Codedocs is built with lua](https://img.shields.io/badge/%20Lua-%23D0B8EB?style=for-the-badge&logo=lua)
![When was the last commit made](https://img.shields.io/github/last-commit/jeangiraldoo/codedocs.nvim?style=for-the-badge&labelColor=%232E3A59&color=%23A6D8FF)
![Neovim version 0.10+](https://img.shields.io/badge/v0.10%2B-%238BD5CA?style=for-the-badge&logo=neovim&label=Neovim&labelColor=%232E3A59&color=%238BD5CA)
![Neovim is under the GPL 3.0 License](https://img.shields.io/badge/GPL3.0-%232E3A59?style=for-the-badge&label=License&labelColor=%232E3A59&color=%23F4A6A6)

# codedocs.nvim

<!-- markdownlint-disable-next-line -->

_A simple, customizable, yet powerful Annotation Framework_

</div>

![Codedocs showcase](./.images/showcase.gif)

## Table of contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Generate an annotation](#generate-an-annotation)
  - [Delete an annotation](#delete-an-annotation)
  - [Lua API](#lua-api)
- [Configuration](#configuration)
  - [Languages](#languages)
    - [Targets](#targets)
    - [Annotations](#annotations)
- [Language support](#language-support)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Motivation](#motivation)
- [Comparison with alternatives](#comparison-with-alternatives)

## Features

- Autodetects functions, classes, or other code targets under the cursor and
  generates the appropriate annotation.
- Generates annotations beyond code, including in markup and other text-based
  filetypes
- Supports multiple [languages and styles](#language-support).
- Easily customize existing annotations or add new ones.
- All built-in annotations use Neovim's built-in snippet engine.
- Works out-of-the-box.

## Requirements

No requirements are needed if you’re only using annotations unrelated to code
(such as comments) and aren’t using the autodetection feature.

To use the full feature set, Codedocs relies on Treesitter for its core
functionality. Neovim includes built-in Treesitter parsers for the following
languages, so no additional setup is required:

- Lua
- C
- Markdown

For any other language, you'll need to install the corresponding Treesitter
parser. The simplest way to do this is with
**[nvim-treesitter][nvim-treesitter]**.

## Installation

<!-- prettier-ignore -->
> [!WARNING]
> Development is done using [Trunk Based
> Development][trunk-based-dev], meaning all new changes are merged into `main`,
> making it the equivalent of `nightly`; versions are done through Git tags.
>
> All changes are thoroughly tested before merging, but it is still recommended
> to pin to a specific tag unless you wish to be constantly up to date.

Use the snippet for your plugin manager:

### [vim.pack][vim.pack]

```lua
vim.pack.add({
    { src = "https://github.com/jeangiraldoo/codedocs.nvim" }
})
```

### [lazy.nvim][lazy.nvim]

```lua
{
    "jeangiraldoo/codedocs.nvim",
}
```

### [packer.nvim][packer]

```lua
use {
    "jeangiraldoo/codedocs.nvim",
}
```

### [mini.deps][mini.deps]

```lua
require("mini.deps").add({
    source = "jeangiraldoo/codedocs.nvim",
})
```

## Usage

### Generate an annotation

An annotation insertion can be triggered using the `:Codedocs` command. There
are two ways to use the command:

- **Without arguments**: The plugin attempts to detect the code target under the
  cursor, determines the default style for the current file’s language, and
  applies the corresponding annotation. If no target is recognized under the
  cursor, an inline comment is inserted. By default, a matching annotation
  exists for each target unless you’ve customized the configuration.

- **With an annotation name**: You can pass the name of any annotation
  definition defined in the language’s default style. The plugin will generate
  and insert the annotation using that definition.

For a more convenient experience, you can bind the command to a keymap. For
example:

```lua
vim.keymap.set(
    "n", "<leader>k", "<cmd>Codedocs<CR>",
    { desc = "Insert annotation" }
)
```

### Delete an annotation

Although it is not actually a Codedocs feature but a Neovim one, you should know
that any comment can be deleted by placing your cursor on it and pressing `dgc`.

### Lua API

<!-- prettier-ignore -->
> [!TIP]
> You can check the function signatures using a LSP such as
> [LuaLS][luals]

A Lua API is provided in case you find any of the already existing functionality
useful. The API can be accessed by requiring the `codedocs` module:

```lua
local Codedocs = require("codedocs")
```

The following functions are available:

- `generate`: Triggers an annotation generation (it's what `:Codedocs` uses
  under the hood)

## Configuration

All options can be customized using the setup function. Here are most of the
default options:

```lua
require("codedocs").setup {
    logging = {
        level = vim.log.levels.INFO,
        path = (vim.fn.stdpath "log") .. "/codedocs.log",
    },
    languages = {
        --- The `languages` table is too big to be displayed here.
        --- See the `languages` configuration section
    },
    annotation_builder = { -- Options for the component that builds annotations
        state = {
            lines = {}, -- Starter annotation lines
            snip_idx_counter = 1, -- Counter for the `snip_idx` placeholder
        },
        placeholders = { -- Placeholders for the annotation `layout` option
            general = { -- Placeholders available to any `layout` line
                ["%%>"] = function(_)
                    -- One level of indentation based on the Neovim settings
                end,
                ["%%snip_idx"] = function(state)
                    -- Tabstop index for Neovim snippets
                    -- Counter is increased by 1 after each use
                end,
            },
            items = { -- Item-exclusive placeholders
                ["%%item_name"] = function(_, item)
                    -- Item name
                end,
                ["%%item_type"] = function(_, item)
                    -- Item type
                end,
            },
        },
    },
}
```

### Languages

All language definitions follow the same structure, so only the `python`
configuration is shown below. Configurations for other languages use the same
fields with different values. See [language support](#language-support).

```lua
require("codedocs").setup {
    languages = {
        python = {
            filetypes = { -- Neovim filetypes associated with this language
                "python",
            },
            default_style = "reST", -- Default style used when generating annotations

            -- Annotation style definitions
            styles = {
                -- Style name
                reST = {
                    default_annot = "comment",
                    annots = { --- See the `annotations` section below
                        func = {}, -- `func` annotation
                        class = {}, -- `class` annotation
                        comment = {} -- `comment` annotation
                    }
                },
            },
            targets = {
                --- See the `targets` section below
            },
        },
    },
}
```

#### Targets

A target is a code structure, such as a function or class, we extract units of
data called `items` from.

Ultimately, an item is a table with a `name` and `type` fields.

For example, the following function:

```python
def foo(a: int, b: string) -> int:
    ...
```

has the following items:

```lua
{
    parameters = { -- List of parameter items
        {
            name = "a",
            type = "int"
        },
        {
            name = "b",
            type = "string"
        },
    },
    returns = {
        {
            name = "",
            type = "int"
        }
    }
}
```

Since the plugin relies on Treesitter for extraction, a target is identified by
one or more Treesitter node types.

This is what the `targets` field looks like for `python`:

```lua
require("codedocs").setup {
    languages = {
        python = {
            targets = {
                --- See the targets section below
                func = {
                    -- Tree-sitter node types recognized as functions
                    node_identifiers = {
                        "function_definition",
                    },

                    -- Functions responsible for extracting items from the target
                    extractors = {
                        parameters = function()
                            -- ...
                        end,
                        returns = function()
                            -- ...
                        end
                    },
                },
            }
        }
    }
}
```

When the target is processed the result is a table where each key corresponds to
one of the keys under `extractors`, and the values are the list of items
returned by each function.

#### Annotations

Annotations are defined as a table with specific options.

| Option Name | Type   | Behavior                                                 |
| ----------- | ------ | -------------------------------------------------------- |
| `placement` | string | What line to place the annotation relative to the cursor |
| `blocks`    | list   | List of blocks forming the annotation                    |

##### Blocks

Blocks define the structure and rendering of an annotation.

The `blocks` option is a list of block definitions. Each block is responsible
for rendering a specific section, such as parameters, returns, attributes, etc.

<!-- prettier-ignore -->
> [!IMPORTANT]
> `blocks` is a list, so overriding it replaces the default list entirely.
>
> To modify a single block, see
> [Customizing blocks](#customizing-blocks).

###### Block options

| Option Name  | Type     | Description                                                      |
| ------------ | -------- | ---------------------------------------------------------------- |
| `name`       | string   | Block identifier used by `gap_before` and item groups            |
| `layout`     | string[] | Block lines. Supports [layout placeholders](#configuration)      |
| `gap_before` | table    | Inserts spacing before another block                             |
| `items`      | `table?` | Defines item rendering and spacing. See [`items`](#items-option) |

###### `items` option

The `items` option controls how extracted items are rendered inside a block.

| Name                 | Expected Value Type                 | Behavior                                              |
| -------------------- | ----------------------------------- | ----------------------------------------------------- |
| `layout`             | `string[]`                          | Same as `layout`, but with item-specific placeholders |
| `insert_gap_between` | `{text: string, enabled = boolean}` | Whether to insert a gap between items                 |

###### `gap_before`

Each key in `gap_before` is a block name, and its value supports the following
suboptions:

| Name      | Expected Value Type | Behavior                                           |
| --------- | ------------------- | -------------------------------------------------- |
| `enabled` | `boolean`           | Whether the gap is inserted before the named block |
| `text`    | `string`            | The string used as the gap                         |

For example, to insert a gap before the `parameters` block:

```lua
gap_before = {
    parameters = {
        enabled = true,
        text = " *",
    },
},
```

###### `name` option

The `name` option serves two purposes:

1. Links the block to a specific group of items extracted from a target
2. Used as a key in other blocks' `gap_before` tables

When items are extracted from a target, they are grouped by block name. For a
block to access those items, its `name` must match the corresponding group in
the target.

For example, given a `func` target with `parameters` and `returns` item groups,
a block named `parameters` will automatically have access to those items and can
render them via `items.layout`, with support for placeholders.

The following target blocks are available:

| Target  | Blocks                           |
| ------- | -------------------------------- |
| `func`  | `title`, `parameters`, `returns` |
| `class` | `title`, `attributes`            |

A block named `parameters` automatically receives the extracted parameter items
for rendering through `items.layout`.

###### Customizing blocks

Because `blocks` replaces the entire default list, modifying a single block
requires copying the original list first.

```lua
local original_blocks =
    require("codedocs.config").languages.python.styles.Google.func.blocks

local new_blocks = vim.deepcopy(original_blocks)

-- Enable gaps between parameter items
new_blocks[2].items.insert_gap_between.enabled = true

require("codedocs").setup({
    languages = {
        python = {
            styles = {
                Google = {
                    func = {
                        blocks = new_blocks,
                    },
                },
            },
        },
    },
})
```

Printing the copied list with `vim.inspect()` can help identify which block you
want to modify.

```lua
print(vim.inspect(new_blocks))
```

##### Annotation example

The following is the `func` annotation for the `reST` style in `python`:

```lua
require("codedocs").setup {
    languages = {
        python = {
            styles = {
                reST = {
                    func = {
                        placement = "below",
                        blocks = {
                            {
                                name = "header",
                                layout = {
                                    '%>"""',
                                    "%>${%snip_idx:title}",
                                },
                                gap_before = {
                                    parameters = {
                                        enabled = true,
                                        text = "",
                                    },
                                    returns = {
                                        enabled = true,
                                        text = "",
                                    },
                                },
                            },
                            {
                                name = "parameters",
                                gap_before = {
                                    returns = {
                                        enabled = false,
                                        text = "",
                                    },
                                },
                                items = {
                                    layout = {
                                        "%>:param %item_name: ${%snip_idx:description}",
                                        "%>:type %item_name: ${%snip_idx:%item_type}",
                                    },
                                },
                            },
                            {
                                name = "returns",
                                gap_before = {
                                    footer = {
                                        enabled = false,
                                        text = "",
                                    },
                                },
                                items = {
                                    layout = {
                                        "%>:return: ${%snip_idx:description}",
                                        "%>:rtype: ${%snip_idx:%item_type}",
                                    },
                                },
                            },
                            {
                                name = "footer",
                                layout = {
                                    '%>"""',
                                },
                            },
                        },
                    },
                }
            }
        }
    }
}
```

## Language support

<!-- prettier-ignore -->
> [!NOTE]
> The `Codedocs` style is not an official style. It exists to provide
> annotations for languages without native styles or to offer a custom
> alternative.

### Global annotations

The following annotations are available in all languages and styles:

- `comment`

### Language-specific annotations

| Language   | Styles (\* = default)                                   | Annotations                           |
| ---------- | ------------------------------------------------------- | ------------------------------------- |
| bash       | \*[Google][Google bash]                                 | `func`, `shebang`                     |
| c          | \*[Doxygen][Doxygen]                                    | `func`                                |
| cpp        | \*[Doxygen][Doxygen]                                    | `func`                                |
| go         | \*[Godoc][Godoc]                                        | `func`                                |
| gdscript   | \*[Codedocs][GDScript]                                  | `export`, `onready`, `warning_ignore` |
| html       | \*Codedocs                                              | Only global annotations               |
| javascript | \*[JSDoc][JSDoc]                                        | `func`, `class`                       |
| java       | \*[JavaDoc][JavaDoc]                                    | `func`, `class`                       |
| kotlin     | \*[KDoc][KDoc]                                          | `func`, `class`                       |
| lua        | \*[EmmyLua][EmmyLua], [LDoc][LDoc]                      | `func`                                |
| markdown   | \*Codedocs                                              | Only global annotations               |
| python     | [Google][Google python], [NumPy][Numpy], \*[reST][reST] | `func`, `class`                       |
| php        | \*[PHPDoc][PHPDoc]                                      | `func`, `phptag`                      |
| ruby       | \*[YARD][YARD]                                          | `func`                                |
| rust       | \*[RustDoc][RustDoc]                                    | `func`                                |
| sql        | \*Codedocs                                              | Only global annotations               |
| typescript | \*[TSDoc][TSDoc]                                        | `func`, `class`                       |
| toml       | \*Codedocs                                              | Only global annotations               |
| treesitter | \*Codedocs                                              | Only global annotations               |

## Roadmap

You can see what's being worked on and which features are planned by checking
the [GitHub Milestones][codedocs-milestones].

## Contributing

Thank you for your interest in contributing to **Codedocs**! Feel free to read
the [Contribution guide](./CONTRIBUTING.md) to get started.

## Motivation

I started working on Codedocs because I wanted to enhance my experience with
Neovim, which I started using daily for my side projects and university
assignments. I wanted a tool to make documenting my code easier and to
contribute something useful to the community! :D

While I found a few plugins with similar functionality, none of them offered the
level of customization and simplicity I was looking for. Sometimes, I feel that
apps and plugins could be more intuitive and user-friendly while still providing
the same powerful features.

## Comparison with alternatives

| Project              | Editor       | Written in      | Treesitter Usage                              |
| -------------------- | ------------ | --------------- | --------------------------------------------- |
| Codedocs             | Neovim       | Lua             | Optional (only required for code annotations) |
| [Neogen][neogen]     | Neovim       | Lua             | Required                                      |
| [vim-doge][vim-doge] | Neovim / Vim | Rust, Vimscript | Required                                      |

All of the aforementioned plugins fulfill the same core goal: annotating code
structures. The main differences are regarding how the plugins are configured,
and functional differences such as:

- Codedocs goes beyond annotating code as you can create annotations that aren't
  tied to some code structure (like a function or class), which is why
  Treesitter parsers aren't an absolute requirement.
- Since Codedocs goes beyond annotating code structures, it supports more
  languages and annotations per language.

The other projects likely support features that Codedocs doesn't, and viceversa,
so it's still a good idea to check them out as they are great projects too!

[Doxygen]: https://www.doxygen.nl/manual/commands.html
[GDScript]:
  https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#annotations
[EmmyLua]: https://emmylua.github.io/annotation.html
[YARD]: https://rubydoc.info/gems/yard/file/docs/GettingStarted.md
[PHPDoc]: https://docs.phpdoc.org/guide/references/phpdoc
[LDoc]: https://stevedonovan.github.io/ldoc/manual/doc.md.html
[TSDoc]: https://tsdoc.org/
[Godoc]: https://go.dev/doc/comment
[JSDoc]: https://jsdoc.app/
[KDoc]: https://kotlinlang.org/docs/kotlin-doc.html
[Google bash]: https://google.github.io/styleguide/shellguide.html
[Google python]: https://google.github.io/styleguide/pyguide.html
[Numpy]: https://numpydoc.readthedocs.io/en/latest/format.html
[reST]: https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html
[RustDoc]: https://doc.rust-lang.org/rustdoc/what-is-rustdoc.html
[JavaDoc]:
  https://www.oracle.com/latam/technical-resources/articles/java/javadoc-tool.html
[codedocs-milestones]: https://github.com/jeangiraldoo/codedocs.nvim/milestones
[luals]: https://luals.github.io/
[mini.deps]: https://github.com/echasnovski/mini.deps
[packer]: https://github.com/wbthomason/packer.nvim
[lazy.nvim]: http://www.lazyvim.org/
[vim.pack]: https://neovim.io/doc/user/pack.html#vim.pack
[trunk-based-dev]: https://trunkbaseddevelopment.com
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[Neogen]: https://github.com/danymat/neogen
[vim-doge]: https://github.com/kkoomen/vim-doge
