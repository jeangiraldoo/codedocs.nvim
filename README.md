# codedocs.nvim

<p align="center">
    <img src="https://img.shields.io/badge/%20Lua-%23D0B8EB?style=for-the-badge&logo=lua"
        alt="Codedocs is built with Lua"
    />
    <img src="https://img.shields.io/github/last-commit/jeangiraldoo/codedocs.nvim?style=for-the-badge&labelColor=%232E3A59&color=%23A6D8FF"
        alt="When was the last commit made"/>
    <img src="https://img.shields.io/badge/v0.10%2B-%238BD5CA?style=for-the-badge&logo=neovim&label=Neovim&labelColor=%232E3A59&color=%238BD5CA"
        alt="Neovim version 0.10.0 and up"/>
    <a href = "https://github.com/jeangiraldoo/codedocs.nvim/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/MIT-%232E3A59?style=for-the-badge&label=License&labelColor=%232E3A59&color=%23F4A6A6"
            alt="Latest version"/>
    </a>
    <img src="https://img.shields.io/github/repo-size/jeangiraldoo/codedocs.nvim?style=for-the-badge&logo=files&logoColor=yellow&label=SIZE&labelColor=%232E3A59&color=%23A8D8A1"
        alt="Repository size in KB"/>
</p>

Codedocs.nvim automatically recognizes various language structures such as
functions, classes, variables, and more, and inserts appropriate documentation
strings based on the [programming language](#language-support) you are using.

You can easily modify the structure of the documentation strings to suit your
specific needs, add support for new languages by defining their documentation
formats, or just use codedocs as it is! :)

## 📖 Table of contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Language support](#language-support)
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

### Change a language's default annotation style

Default styles are defined using the `default_styles` key:

```lua
require("codedocs").setup {
    default_styles = {
        --- Default styles definitions
    }
}
```

For example, let's set the default styles for Python and Lua:

```lua
require("codedocs").setup {
    default_styles = {
        lua = "EmmyLua",
        python = "reST"
    }
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
table with two top-level keys: `sections` and `settings`.

#### Layout option

The `layout` option accepts a `table` type and defines the base lines that
compose an annotation section, item, or the base annotation layout. It can
be used both in the `settings` and `sections` tables.

Additionally, since a layout is just a list of strings, the following string
placeholders are predefined:

- `%snippet_tabstop_index`: Inserts a tabstop index for defining snippet tabstops
  (e.g., `$%snippet_tabstop_index` or `${%snippet_tabstop_index:default label}`).
- `%>`: Either a tab character or a number of spaces, based on your Neovim settings

#### Settings

All structures have a `settings` field as it is used for configuring
fundamental aspects of an annotation style

| Option Name         | Expected Value Type                                 | Behavior                                              |
| ------------------- | --------------------------------------------------- | ----------------------------------------------------- |
| `relative_position` | `"above"` \| `"below"` \| `"empty_target_or_above"` | Where to insert the annotation                        |
| `insert_at`         | boolean                                             | Position in `layout` to insert the annotation content |
| `section_order`     | table                                               | Order in which sections are added                     |
| `item_extraction`   | table                                               | How items are parsed for a given section              |
| `indented`          | boolean                                             | Whether to indent the entire annotation one level     |

The `item_extraction` option has the following suboptions for class attributes
under the `attributes` key:

| Name       | Expected Value Type                    | Behavior                                    |
| ---------- | -------------------------------------- | ------------------------------------------- |
| `static`   | boolean                                | Include static attributes in the annotation |
| `instance` | `"none"` \| `"constructor"` \| `"all"` | Which instance attributes to include        |

#### Sections

Sections are configured under the `sections` key. The following sections are available:

| Structure | Sections                         |
| --------- | -------------------------------- |
| `func`    | `title`, `parameters`, `returns` |
| `class`   | `title`, `attributes`            |
| `comment` | `title`                          |

All sections except `title` are **item-based**. Item-based sections are focused
on styling and laying out their items. An item represents a named component of
a structure, defined by a `name` and a `type`.

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

##### Options

All sections support the `layout` and `insert_gap_between` options.

The `insert_gap_between` sets up a gap in between the current section/item and
the one below. The following suboptions are available:

| Name    | Expected Value Type | Behavior                                                   |
| ------- | ------------------- | ---------------------------------------------------------- |
| enabled | `boolean`           | Whether a gap is inserted in between two sections or items |
| text    | `string`            | String used as the gap                                     |

Additionally, Item-based sections have a `items` option where both the `layout`
and `insert_gap_between` options can be used again to control the appearance of
each individual item rather than the section as a whole. When used under the
`items` key the `layout` option's placeholders are expanded with the `%item_name`
and `%item_type` placeholders, which will be replaced by a given item's name and
type respectively.

#### Customization example

Say we want to make the following changes to Python's Google annotation style
for functions:

- Add a gap in between all items.
- Add a gap in between sections (functions have a `parameters` and `returns`
  section)

This is what such customization would look like:

```lua
require("codedocs").setup({
    styles = { -- Modifications to styles are done in the `styles` key
        python = { -- language name
            Google = { -- name of the style to customize
                func = { -- structure name
                    sections = {
                        parameters = {
                            insert_gap_between = {
                                enabled = true
                            },
                            items = {
                                insert_gap_between = {
                                    enabled = true
                                },
                            },
                        },
                        returns = {
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

> [!TIP]
> Want to see how annotations look by default? Take a look at the [Annotation Examples](./ANNOTATION_EXAMPLES.md)

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
