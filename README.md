<!-- markdownlint-disable-next-line MD033 MD041 -->
<div align="center">

![Codedocs is built with lua](https://img.shields.io/badge/%20Lua-%23D0B8EB?style=for-the-badge&logo=lua)
![When was the last commit made](https://img.shields.io/github/last-commit/jeangiraldoo/codedocs.nvim?style=for-the-badge&labelColor=%232E3A59&color=%23A6D8FF)
![Neovim version 0.10+](https://img.shields.io/badge/v0.10%2B-%238BD5CA?style=for-the-badge&logo=neovim&label=Neovim&labelColor=%232E3A59&color=%238BD5CA)
![Neovim is under the MIT License](https://img.shields.io/badge/MIT-%232E3A59?style=for-the-badge&label=License&labelColor=%232E3A59&color=%23F4A6A6)
![Repository size](https://img.shields.io/github/repo-size/jeangiraldoo/codedocs.nvim?style=for-the-badge&logo=files&logoColor=yellow&label=SIZE&labelColor=%232E3A59&color=%23A8D8A1)

# codedocs.nvim

_A simple, customizable, yet powerful Annotation
Framework_

</div>

![Codedocs showcase](./.images/showcase.gif)

## 📖 Table of contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Language support](#language-support)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Motivation](#motivation)
- [License](#license)

## Features

- Autodetects functions, classes, or other code targets under the cursor and
  generates the appropriate annotation.
- Generates annotations beyond code, including in markup and other text-based filetypes
- Supports multiple [languages and styles](#language-support).
- Easily customize existing annotations or add new ones.
- All built-in annotations use Neovim's built-in snippet engine.
- Works out-of-the-box.

## Requirements

No requirements are needed if you’re only using annotations unrelated to code
(such as comments) and aren’t using the autodetection feature.

To use the full feature set, Codedocs relies on Treesitter for its core functionality.
Neovim includes built-in Treesitter parsers for the following languages, so no
additional setup is required:

- Lua
- C
- Markdown

For any other language, you'll need to install the corresponding Treesitter
parser. The simplest way to do this is with
**[nvim-treesitter][nvim-treesitter]**.

## Installation

> [!WARNING]
> Development is done using [Trunk Based Development][trunk-based-dev],
> meaning all new changes are merged into `main`, making it the equivalent of `nightly`;
> versions are done through Git tags.
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

### [vim-plug][vim-plug]

```vim
Plug 'jeangiraldoo/codedocs.nvim'
```

### [mini.deps][mini.deps]

```lua
require("mini.deps").add({
    source = "jeangiraldoo/codedocs.nvim",
})
```

### [minpac][minpac]

```vim
packadd minpac
call minpac#add('jeangiraldoo/codedocs.nvim')
```

### [paq-nvim][paq-nvim]

```lua
require("paq") {
    "jeangiraldoo/codedocs.nvim",
}
```

## Usage

### Generate an annotation

An annotation insertion can be triggered using the `:Codedocs` command. There are
two ways to use the command:

- **Without arguments**: The plugin attempts to detect the code target under
  the cursor, determines the default style for the current file’s language, and
  applies the corresponding annotation. If no target is recognized under the
  cursor, an inline comment is inserted. By default, a matching annotation exists
  for each target unless you’ve customized the configuration.

- **With an annotation name**: You can pass the name of any annotation definition
  defined in the language’s default style. The plugin will generate and insert the
  annotation using that definition.

For a more convenient experience, you can bind the command to a keymap. For example:

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

> [!TIP]
> You can check the function signatures using a LSP such as [LuaLS][luals]

A Lua API is provided in case you find any of the already existing functionality
useful. The API can be accessed by requiring the `codedocs` module:

```lua
local Codedocs = require("codedocs")
```

The following functions are available:

- `generate`: Triggers an annotation generation (it's what `:Codedocs` uses under
  the hood)

## Configuration

All options can be customized using the setup function. Here are most of the
default options:

```lua
require("codedocs").setup {
    debug = false,
    languages = {
        --- This table is too big to be displayed here
        --- The path to the config file is `codedocs/config/init.lua`
    },
    aliases = {
        sh = "bash"
    }
}
```

### Change a language's default style

Default styles are defined using the `default_style` key. For example, let's set
the default styles for Python and Lua:

```lua
require("codedocs").setup {
    languages = {
        python = {
            default_style =  "reST"
        },
        lua = {
            default_style = "EmmyLua"
        }
    },
}
```

### How annotations work

> [!CAUTION]
> All annotations are expected to include all the options, using any of the valid
> values, for the plugin to work properly

An annotation is a Lua table that defines its structure through configuration
options and can interact with code items; once evaluated, it produces text that
is inserted into the buffer.

#### Items

An item is a unit of data that can be extracted from a code structure (referred
to as a `target`), such as a function or class.

Ultimately, an item is a table with a `name` and `type` keys.

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

For example, this is what the `targets` key of the default Lua configuration looks
like:

```lua
local default_config = {
    languages = {
        lua = {
            default_style = "EmmyLua",
            styles = {
                --Style/annotation data
            },
            targets = {
                func = {
                    node_identifiers = { ---Determines what Treesitter node types identify the target
                        "function_definition",
                        "function_declaration",
                    },
                    extractors = {
                        parameters = function()
                            ---Some logic that eventually returns a list of items
                        end,
                        returns = function()
                            ---Some logic that eventually returns a list of items
                        end
                    }
                }
            }
        }
    }
}
```

When the target is processed the result is a table where each key corresponds to
one of the keys under `extractors`, and the values are the list of items returned
by each function.

#### Annotation options

| Option Name | Expected Value Type                   | Behavior                              |
| ----------- | ------------------------------------- | ------------------------------------- |
| `placement` | `"above"` \| `"below"` \| `"current"` | Where to insert the annotation        |
| `blocks`    | table (list)                          | List of blocks forming the annotation |

##### Blocks

> [!IMPORTANT]
> The `blocks` option is a list, so you cannot override a single block on its
> own. Because your config is merged recursively with the defaults, any blocks
> you do not explicitly include will be removed, even if they exist in the defaults.
>
> To customize just one block, copy the default `blocks` list and modify the
> specific block you want.

Blocks are the core of an annotation, they determine what it ultimately looks
like.

| Option Name  | Type     | Behavior                                                                                           |
| ------------ | -------- | -------------------------------------------------------------------------------------------------- |
| `name`       | string   | Identifies the block; used for item group linking and `gap_before` keys                            |
| `layout`     | string[] | Lines that that make up the block. See the available [layout placeholders](#layout-placeholders)   |
| `gap_before` | table    | Inserts a gap before a block when it follows the current one. See [gap_before](#gap_before-option) |
| `items`      | `table?` | Options for the block's items. See [`name` and `items`](#name-and-items-options)                   |

###### `layout` placeholders

| Placeholder  | Expands to                                                                      |
| ------------ | ------------------------------------------------------------------------------- |
| `%snip_idx`  | Tabstop index for snippets (e.g., `$%snip_idx` or `${%snip_idx:default label}`) |
| `%>`         | Tab or spaces, based on your Neovim settings                                    |
| `%item_name` | Item name (`items` layouts only)                                                |
| `%item_type` | Item type (`items` layouts only)                                                |

###### `gap_before` option

Each key in `gap_before` is a block name, and its value supports the following suboptions:

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

###### `name` and `items` options

The `name` option serves two purposes:

1. Links the block to a specific group of items extracted from a target
2. Used as a key in other blocks' `gap_before` tables

When items are extracted from a target, they are grouped by block name. For a block
to access those items, its `name` must match the corresponding group in the target.

The `items` option supports the following suboptions:

| Name         | Type       | Description                                                                          |
| ------------ | ---------- | ------------------------------------------------------------------------------------ |
| `layout`     | `string[]` | How each item is rendered; appended to the block's `layout`                          |
| `gap_before` | `table`    | Keyed by block name; inserts a gap before that block when it follows the current one |

For example, given a `func` target with `parameters` and `returns` item groups,
a block named `parameters` will automatically have access to those items and can
render them via `items.layout`.

The following target blocks are available:

| Target  | Blocks                           |
| ------- | -------------------------------- |
| `func`  | `title`, `parameters`, `returns` |
| `class` | `title`, `attributes`            |

### Customize an annotation

You can customize almost (for now!) every aspect of an annotation. Whether you
want to make a simple change, like modifying the characters wrapping the parameter
type:

```python
def cool_function_with_type_hints(a: int, b: bool) -> str:
    """
    <title goes here>

    Args:
        a <int>:
        b <bool>:
    Returns:
        str:
    """
    self.sum = 1 + 1
    return <value>
```

Or if you want to go all out with customization:

```python
def cool_function_with_type_hints(a: int, b: bool) -> str:
        """
        <title goes here>

        Some cool customized title!:
            a (づ ◕‿◕ )づ int ⊂(´• ω •`⊂):

            b (づ ◕‿◕ )づ bool ⊂(´• ω •`⊂):
        This is some return type...:
            (￢_￢;) str:
        """
        self.sum = 1 + 1
        return <value>
```

In this case, we:

- Increased spacing between items in the parameters block.
- Wrapped parameter types with two [Kaomojis][kaomojis].
- Added a third kaomoji to wrap the left side of the return type.
- Customized the titles for both the parameters and return blocks.

The [How annotations work](#how-annotations-work) section covers everything you
need to know about annotations. Since all built-in annotations are implemented this
way, you can customize them using the same principles.

With that in mind, suppose we want to make the following changes to the `func` annotation
for Python's Google style:

- Add a gap in between parameters.
- Add a gap in between blocks

As mentioned earlier, the blocks option is a list, so you can’t override a single
block in isolation; you have to redefine the entire list. That’s fine if you
intend to change the whole annotation, but if you only need to adjust one block,
it’s better to copy the annotation and modify only the blocks you need.

```lua
local original_blocks_list = require("codedocs.config").languages.python.styles.Google.func.blocks
local new_func_blocks = vim.deepcopy(original_blocks_list) -- We copy the original annotation blocks list
print(vim.inspect(new_func_blocks)) -- It's helpful to print the list to check what it looks like before modifying it

local second_block = new_func_blocks[2] -- In this specific case the second block is the parameters one
second_block.items.insert_gap_between.enabled = true -- We enable the insertion of a gap in between items (parameters in this case)

for _, block in ipairs(new_func_blocks) do -- We iterate over each block
    block.insert_gap_between.enabled = true -- We enable the insertion of a gap in between the current block and the next
end

require("codedocs").setup({
    languages = {
        python = {
            styles = {
                Google = {
                    func = { -- The func annotation key
                        blocks = new_func_blocks -- We assign the new list which will replace the default one
                    }
                },
            },
        },
    }
})
```

### Add a new language

> [!IMPORTANT]
> Check the [How annotations work](#how-annotations-work) section to understand
> how annotations work, how they are defined, and their relationship with the
> `targets` key.

To add support for a new language, simply add a key under `languages` with the name
of that language. For example, to add support for `Cobol` with a default style called
`cobolito`:

```lua
require("codedocs").setup {
    languages = {
        cobol = {
            default_style = "cobolito",
            styles = {
                cobolito = {
                    --The annotations contained in the `cobolito` style should be defined  here
                }
            },
            targets = {
                --The target definitions
            }
        }
    }
}
```

### Add a new annotation

> [!IMPORTANT]
> Check the [How annotations work](#how-annotations-work) section to see what
> annotation options are available and how they work

To add a new annotation for an existing language, simply add the annotation name
as a key under the desired style. The value of that key should be a table containing
the annotation options.

For example, to add a new annotation called `deprecated` under the EmmyLua style
in Lua:

```lua
require("codedocs").setup {
    languages = {
        lua = {
            styles = {
                EmmyLua = {
                    deprecated = {
                        --Annotation options go here
                    }
                }
            }
        }
    }
}
```

## Language support

> [!NOTE]
> The `Codedocs` style is not an official style. It exists to provide annotations
> for languages without native styles or to offer a custom alternative.

### Global annotations

The following annotations are available in all languages and styles:

- `comment`

### Language-specific annotations

| Language   | Styles (\* = default)                                   | Annotations                           |
| ---------- | ------------------------------------------------------- | ------------------------------------- |
| bash       | \*[Google][Google bash]                                 | `func`, `shebang`                     |
| c          | \*[Doxygen][Doxygen]                                    | `func`                                |
| c++ (cpp)  | \*[Doxygen][Doxygen]                                    | `func`                                |
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
the
[GitHub Milestones][codedocs-milestones].

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

## License

Codedocs is licensed under the MIT License. This means you are free to download,
install, modify, share, and use the plugin for both personal and commercial
purposes.

The only requirement is that if you modify and redistribute the code, you must
include the same LICENSE file found in this repository.

[Doxygen]: https://www.doxygen.nl/manual/commands.html
[GDScript]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#annotations
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
[JavaDoc]: https://www.oracle.com/latam/technical-resources/articles/java/javadoc-tool.html
[codedocs-milestones]: https://github.com/jeangiraldoo/codedocs.nvim/milestones
[kaomojis]: https://kaomoji.ru/en/
[luals]: https://luals.github.io/
[paq-nvim]: https://github.com/savq/paq-nvim
[minpac]: https://github.com/k-takata/minpac
[mini.deps]: https://github.com/echasnovski/mini.deps
[vim-plug]: https://github.com/junegunn/vim-plug
[packer]: https://github.com/wbthomason/packer.nvim
[lazy.nvim]: http://www.lazyvim.org/
[vim.pack]: https://neovim.io/doc/user/pack.html#vim.pack
[trunk-based-dev]: https://trunkbaseddevelopment.com
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
