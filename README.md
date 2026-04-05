# codedocs.nvim

<!-- markdownlint-disable-next-line MD033 -->
<div align="center">

![Codedocs is built with lua](https://img.shields.io/badge/%20Lua-%23D0B8EB?style=for-the-badge&logo=lua)
![When was the last commit made](https://img.shields.io/github/last-commit/jeangiraldoo/codedocs.nvim?style=for-the-badge&labelColor=%232E3A59&color=%23A6D8FF)
![Neovim version 0.10+](https://img.shields.io/badge/v0.10%2B-%238BD5CA?style=for-the-badge&logo=neovim&label=Neovim&labelColor=%232E3A59&color=%238BD5CA)
![Neovim is under the MIT License](https://img.shields.io/badge/MIT-%232E3A59?style=for-the-badge&label=License&labelColor=%232E3A59&color=%23F4A6A6)
![Repository size](https://img.shields.io/github/repo-size/jeangiraldoo/codedocs.nvim?style=for-the-badge&logo=files&logoColor=yellow&label=SIZE&labelColor=%232E3A59&color=%23A8D8A1)

</div>

Codedocs.nvim automatically recognizes various language structures such as
functions, classes, variables, and more, and inserts appropriate documentation
strings based on the [programming language](#language-support) you are using.

You can easily modify the structure of the documentation strings to suit your
specific needs, add support for new languages by defining their documentation
formats, or just use codedocs as it is! :)

![Codedocs showcase](./.images/showcase.gif)

## 📖 Table of contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Language support](#language-support)
- [Annotation examples](#annotation-examples)
- [Roadmap](#roadmap)
- [Technical documentation](./lua/codedocs/README.md)
- [Contributing](#contributing)
- [Motivation](#motivation)
- [License](#license)

## Features

- Works out-of-the-box.
- Detects and documents code structures with a simple keybind.
- Supports multiple [languages and styles](#language-support).
- Easily customize existing formats or add new ones.
- Annotations use Neovim's built-in snippet engine.

## Requirements

Codedocs relies on Treesitter for its core functionality. Neovim includes
built-in Treesitter parsers for the following languages—meaning no extra setup
is needed for:

- Lua
- C

For any other language, you'll need to install the corresponding Treesitter
parser. The simplest way to do this is with
**[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**.

## Installation

Use the snippet for your plugin manager:

### [vim.pack](https://neovim.io/doc/user/pack.html#vim.pack)

```lua
vim.pack.add({
    { src = "https://github.com/jeangiraldoo/codedocs.nvim" }
})
```

### [lazy.nvim](http://www.lazyvim.org/)

```lua
{
    "jeangiraldoo/codedocs.nvim",
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    "jeangiraldoo/codedocs.nvim",
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'jeangiraldoo/codedocs.nvim'
```

### [mini.deps](https://github.com/echasnovski/mini.deps)

```lua
require("mini.deps").add({
    source = "jeangiraldoo/codedocs.nvim",
})
```

### [minpac](https://github.com/k-takata/minpac)

```vim
packadd minpac
call minpac#add('jeangiraldoo/codedocs.nvim')
```

### [paq-nvim](https://github.com/savq/paq-nvim)

```lua
require("paq") {
    "jeangiraldoo/codedocs.nvim",
}
```

## Configuration

> [!WARNING]
> Language, struct and style names must be spelled exactly as shown in the
> [supported languages section](#language-support).

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

### Change a language's default annotation style

Default styles are defined using the `default_styles` key:

```lua
require("codedocs").setup {
    languages = {
        <language name> = {
            styles = {
                default = <style name>
            }
        }
    },
}
```

For example, let's set the default styles for Python and Lua:

```lua
require("codedocs").setup {
    languages = {
        python = {
            styles = {
                default = "reST"
            }
        },
        lua = {
            styles = {
                default = "EmmyLua"
            }
        }
    },
}
```

### Customize an annotation style

You can customize almost (for now!) every aspect of an annotation
style. Whether you want to make a simple change, like modifying the characters
wrapping the parameter type:

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

- Increased spacing between items in the parameters section.
- Wrapped parameter types with two [Kaomojis](https://kaomoji.ru/en/).
- Added a third kaomoji to wrap the left side of the return type.
- Customized the titles for both the parameters and return sections.

To customize an annotation style, keep in mind that it is simply a regular Lua
table with the following options:

| Option Name         | Expected Value Type                                 | Behavior                                          |
| ------------------- | --------------------------------------------------- | ------------------------------------------------- |
| `relative_position` | `"above"` \| `"below"` \| `"empty_target_or_above"` | Where to insert the annotation                    |
| `indented`          | boolean                                             | Whether to indent the entire annotation one level |
| `sections`          | table (list)                                        | List of sections forming the annotation           |

Sections are the core of an annotation, they determine what it ultimately looks
like.

#### Sections

> [!WARNING]
> The `sections` option is a list, so you cannot override a single section on its
> own. Because your config is merged recursively with the defaults, any sections
> you do not explicitly include will be removed, even if they exist in the defaults.
>
> To customize just one section, you should copy the default sections list and then
> modify the specific section you want.
>
> Previously, `sections` was defined as a key value table, where the key represented
> the section name (equivalent to the `name` field) and the value contained its
> options (`layout`, `items`, etc.). While this made individual sections easier
> to override, it made ordering difficult without introducing an additional option
> (there used to be an option called `section_order` for this), and reduced composability.
>
> The current list based approach improves ordering and flexibility overall, at
> the cost of making single section customization less convenient.

| Option Name          | Expected Type | Behavior                                                        |
| -------------------- | ------------- | --------------------------------------------------------------- |
| `name`               | string        | The name of the section, useful for readability and for items\* |
| `layout`             | string[]      | List of lines that that make up the section                     |
| `insert_gap_between` | table         | Sets up a gap in between the current section/item and the next  |
| `ignore_prev_gap`    | boolean       | Skips the gap defined by the previous section (if enabled)      |
| `items`              | table?        | Sets up options for the section's items                         |

All options with the exception of `ignore_prev_gap` have some caveats that will
be explained below in detail.

##### `items` option

When a section uses the `items` option, it is considered an "item-based" section,
as it includes items extracted at runtime from a structure defined in its layout.
In contrast, non-item-based sections consist solely of the lines defined in their
`layout`.

An item represents a named component of a structure, defined by a `name` and a `type`.

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

The `insert_gap_between` and `layout` options can be reused as suboptions of the
`items` option; in such case the `layout` option would represent the lines that
make up each item and that will be appended to the section's `layout` option.

##### `insert_gap_between` option

The following suboptions are available:

| Name    | Expected Value Type | Behavior                                                   |
| ------- | ------------------- | ---------------------------------------------------------- |
| enabled | `boolean`           | Whether a gap is inserted in between two sections or items |
| text    | `string`            | String used as the gap                                     |

##### `layout` option

> [!INFO]
> The layout lines of all sections are concatenated in section order to form the
> final annotation.

The following string placeholders are predefined:

- `%snippet_tabstop_index`: Inserts a tabstop index for defining snippet tabstops
  (e.g., `$%snippet_tabstop_index` or `${%snippet_tabstop_index:default label}`).
- `%>`: Either a tab character or a number of spaces, based on your Neovim settings

When used under the `items` key the aforementioned placeholders are expanded
with the following ones:

- `%item_name`
- `%item_type`

When used, they get replaced by the item's name and type respectively.

##### `name` option

The `name` option serves two main purposes:

1. Identifies the section, making it easier to understand its role
2. Associates the section with a specific group of items extracted from a structure

The second purpose applies only to item-based sections. When items are extracted
from a structure, they are grouped by section name. For these items to be included,
the value of `name` must match the corresponding structure section.

The following structure sections are available:

| Structure | Sections                         |
| --------- | -------------------------------- |
| `func`    | `title`, `parameters`, `returns` |
| `class`   | `title`, `attributes`            |
| `comment` | `title`                          |

#### Customization example

Say we want to make the following changes to Python's Google annotation style
for functions:

- Add a gap in between all items.
- Add a gap in between sections (functions have a `parameters` and `returns`
  section)

This is what such customization would look like:

```lua
require("codedocs").setup({
    languages = {
        python = {
            styles = {
                definitions = {
                    Google = {
                        func = {
                            sections = {
                                 {
                                    name = "parameters",
                                    insert_gap_between = {
                                        enabled = true
                                    },
                                    items = {
                                        insert_gap_between = {
                                            enabled = true
                                        },
                                    },
                                },
                                {
                                    name = "returns",
                                    items = {
                                        insert_gap_between = {
                                            enabled = true
                                        }
                                    },
                                }
                            }
                        }
                    },
                },
            },
        },
    }
})
```

## Usage

When an annotation insertion is triggered, the plugin generates one for the
structure under the cursor. If no supported structure is detected, it inserts an
inline comment instead.

An annotation insertion can be triggered in the following ways:

### Command

The simplest way to use the plugin is with the following command:

```lua
:Codedocs
```

### Keymap

For a more convenient experience, you can bind the annotation insertion to a
keymap. For example:

```lua
vim.keymap.set(
    "n", "<leader>k", require('codedocs').insert_docs,
    { desc = "Insert annotation" }
)
```

## Language support

<!-- prettier-ignore -->
> [!NOTE]
> \* indicates the default style for that language

| Language   | Styles                | Structures                     |
| ---------- | --------------------- | ------------------------------ |
| Bash       | \*Google              | `comment`, `function`          |
| C          | \*Doxygen             | `comment`, `function`          |
| C++        | \*Doxygen             | `comment`, `function`          |
| Go         | \*Godoc               | `comment`, `function`          |
| JavaScript | \*JSDoc               | `comment`, `function`, `class` |
| Java       | \*JavaDoc             | `comment`, `function`, `class` |
| Kotlin     | \*KDoc                | `comment`, `function`, `class` |
| Lua        | \*EmmyLua, LDoc       | `comment`, `function`          |
| Python     | Google, NumPy, \*reST | `comment`, `function`, `class` |
| PHP        | \*PHPDoc              | `comment`, `function`          |
| Ruby       | \*YARD                | `comment`, `function`          |
| Rust       | \*RustDoc             | `comment`, `function`          |
| TypeScript | \*TSDoc               | `comment`, `function`, `class` |

## Annotation examples

Want to see what annotations look like across all languages and styles? Check out
[Annotation Examples](./ANNOTATION_EXAMPLES.md).

## Roadmap

You can see what's being worked on and which features are planned by checking
the
[GitHub Milestones](https://github.com/jeangiraldoo/codedocs.nvim/milestones).

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

TL;DR: I built Codedocs to improve productivity by automatically generating
documentation strings, allowing for easy customization, and providing a simple
yet powerful solution for both personal and community use. Plus, it is a fun
project to work on!

## License

Codedocs is licensed under the MIT License. This means you are free to download,
install, modify, share, and use the plugin for both personal and commercial
purposes.

The only requirement is that if you modify and redistribute the code, you must
include the same LICENSE file found in this repository.
