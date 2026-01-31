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
strings based on the [programming language](#supported-languages) you are using.

You can easily modify the structure of the documentation strings to suit your
specific needs, add support for new languages by defining their documentation
formats, or just use codedocs as it is! :)

## 📖 Table of contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Supported languages](#supported-languages)
- [Roadmap](#roadmap)
- [Technical documentation](./lua/codedocs/README.md)
- [Contributing](#contributing)
- [Motivation](#motivation)
- [License](#license)

### <a id="features"></a>🚀 Features

- Works out-of-the-box.
- Detects and documents code structures with a simple keybind.
- Supports multiple [languages and styles](#supported-languages).
- Easily customize existing formats or add new ones.

### <a id="requirements"></a>📋 Requirements

Codedocs relies on Treesitter for its core functionality. Neovim includes
built-in Treesitter parsers for the following languages—meaning no extra setup
is needed for:

- Lua
- C

For any other language, you'll need to install the corresponding Treesitter
parser. The simplest way to do this is with
**[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**.

### <a id="installation"></a>📦 Installation

Use the snippet for your plugin manager:

#### [vim.pack](https://neovim.io/doc/user/pack.html#vim.pack)

```lua
vim.pack.add({
    { src = "https://github.com/jeangiraldoo/codedocs.nvim" }
})
```

#### [lazy.nvim](http://www.lazyvim.org/)

```lua
{
    "jeangiraldoo/codedocs.nvim",
}
```

#### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    "jeangiraldoo/codedocs.nvim",
}
```

#### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'jeangiraldoo/codedocs.nvim'
```

#### [mini.deps](https://github.com/echasnovski/mini.deps)

```lua
require("mini.deps").add({
    source = "jeangiraldoo/codedocs.nvim",
})
```

#### [minpac](https://github.com/k-takata/minpac)

```vim
packadd minpac
call minpac#add('jeangiraldoo/codedocs.nvim')
```

#### [paq-nvim](https://github.com/savq/paq-nvim)

```lua
require("paq") {
    "jeangiraldoo/codedocs.nvim",
}
```

### <a id="configuration"></a>⚙️ Configuration

#### Change a language's default annotation style

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

> [!WARNING]
> Keep in mind that the name of the annotation style must be spelled exactly as
> shown in the table of [supported languages](#supported-languages).

#### Customize an annotation style

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

To customize an annotation style, you have to keep in mind that it is nothing
but a table where each key is an option, spread across many sections:

| Structure | Sections                                    |
| --------- | ------------------------------------------- |
| `func`    | `general`, `title`, `params`, `return_type` |
| `class`   | `general`, `title`, `attrs`                 |
| `comment` | `general`, `title`                          |

##### Options common to all sections

| Option Name | Expected Value Type | Behavior                                                           |
| ----------- | ------------------- | ------------------------------------------------------------------ |
| layout      | `table`             | Defines the base lines that compose an annotation section          |
| gap         | `table`             | Sets up a gap in between the current section and the section below |

###### `gap` suboptions

| Suboption Name | Expected Value Type | Behavior                    |
| -------------- | ------------------- | --------------------------- |
| enabled        | `boolean`           | Whether the gap is inserted |
| text           | `string`            | String used as the gap      |

##### General section

As you can see, all structures have a `general` section, as it is used for configuring
all other sections in a given structure by defining options that are available
to all structures.

All other sections are focused on configuring how the items they contain are displayed.

The `general` section supports the following options:

| Option Name     | Expected Value Type | Behavior                                                                          |
| --------------- | ------------------- | --------------------------------------------------------------------------------- |
| `direction`     | boolean             | Determines where the annotation is inserted. `true` for above, `false` for below. |
| `insert_at`     | boolean             | Position in the `layout` option to insert the annotation content into             |
| `section_order` | table               | Specifies the order in which sections are added to the annotation.                |

##### Title section

| Option Name  | Expected Value Type | Behavior                                                             |
| ------------ | ------------------- | -------------------------------------------------------------------- |
| `cursor_pos` | number              | Determines what line from the `layout` option to place the cursor on |

##### Item-based sections

An `item` is a part of a structure, having a `name` that identifies it, and a
`data type`.

The following is a mapping of structures to their respective items:

- Function: Parameters (`params` section), return type (`return_type` section).
- Class: Attributes (`attrs` section).

| Option Name | Expected Value Type | Behavior                                   |
| ----------- | ------------------- | ------------------------------------------ |
| `items`     | table               | Controls how individual items are rendered |

###### `items` suboptions

| Suboption                    | Expected Type | Description                                      |
| ---------------------------- | ------------- | ------------------------------------------------ |
| `insert_gap_between`         | `table`       | Controls spacing between consecutive items       |
| `insert_gap_between.enabled` | `boolean`     | Whether to insert a gap between items            |
| `insert_gap_between.text`    | `string`      | String inserted between items                    |
| `include_type`               | `boolean`     | Whether to include the item’s type               |
| `indent`                     | `boolean`     | Whether item lines are indented                  |
| `template`                   | `table`       | List of lines describing how an item is rendered |

##### Attrs section extension for classes

The following `attrs` options are exclusive to classes, as they only apply to
class attributes:

| Option Name                               | Expected Value Type | Behavior                                                               |
| ----------------------------------------- | ------------------- | ---------------------------------------------------------------------- |
| `include_class_attrs`                     | boolean             | Include class-level attributes in the annotation                       |
| `include_instance_attrs`                  | boolean             | Include instance attributes in the annotation                          |
| `include_only_constructor_instance_attrs` | boolean             | Only include instance attributes from the constructor, or annotate all |

##### Customization example

Say we want to make the following changes to Python's Google annotation style
for functions:

- Add a gap in between all items.
- Add a gap in between sections (functions have a `params` and `return_type` section)
- Include the parameter types.

This is what such customization would look like:

```lua
require("codedocs").setup({
    styles = { -- Modifications to styles are done in the `styles` key
        python = { -- language name
            Google = { -- name of the style to customize
                func = { -- structure name
                    general = {
                        gap = {
                            enabled = true
                        },
                    },
                    params = {
                        gap = {
                            enabled = true
                        },
                        items = {
                            insert_gap_between = {
                                enabled = true
                            },
                            include_type = true
                        },
                    },
                    return_type = {
                        items = {
                            insert_gap_between = {
                                enabled = true
                            }
                        },
                    }
                }
            },
        },
    }
})
```

### <a id="usage"></a>💻 Usage

When an annotation insertion is triggered, the plugin generates one for the
structure under the cursor. If no supported structure is detected, it inserts an
inline comment instead.

An annotation insertion can be triggered in the following ways:

#### Command

The simplest way to use the plugin is with the following command:

```lua
:Codedocs
```

#### Keymap

For a more convenient experience, you can bind the annotation insertion to a
keymap. For example:

```lua
vim.keymap.set(
    "n", "<leader>k", require('codedocs').insert_docs,
    { desc = "Insert annotation" }
)
```

### <a id="supported-languages"></a>🌐 Supported languages

> [!TIP]
> Want to see how annotations look by default? Take a look at the [Annotation Examples](./ANNOTATION_EXAMPLES.md)

<!-- prettier-ignore -->
> [!NOTE]
> \* indicates the default style for that language

| Languages  | Annotation styles           | Supported automatic annotation |
| ---------- | --------------------------- | ------------------------------ |
| Bash       | \*Google                    | `comment`, `function`          |
| C          | \*Doxygen                   | `comment`, `function`          |
| C++        | \*Doxygen                   | `comment`, `function`          |
| Go         | \*Godoc                     | `comment`, `function`          |
| JavaScript | \*JSDoc                     | `comment`, `function`, `class` |
| Java       | \*JavaDoc                   | `comment`, `function`, `class` |
| Kotlin     | \*KDoc                      | `comment`, `function`, `class` |
| Lua        | \*EmmyLua, LDoc             | `comment`, `function`          |
| Python     | Google, NumPy/SciPy, \*reST | `comment`, `function`, `class` |
| PHP        | \*PHPDoc                    | `comment`, `function`          |
| Ruby       | \*YARD                      | `comment`, `function`          |
| Rust       | \*RustDoc                   | `comment`, `function`          |
| TypeScript | \*TSDoc                     | `comment`, `function`, `class` |

### <a id="roadmap"></a>🗺️ Roadmap

You can see what's being worked on and which features are planned by checking
the
[GitHub Milestones](https://github.com/jeangiraldoo/codedocs.nvim/milestones).

### <a id="contributing"></a>🤝 Contributing

Thank you for your interest in contributing to **Codedocs**! There are several
ways you can help improve the project:

- **Propose new features**: If you have an idea for a new feature, please open a
  discussion in the
  [Discussions section](https://github.com/jeangiraldoo/codedocs.nvim/discussions).
- **Contribute to feature development**: You can help by working on features
  listed in the [Roadmap](#roadmap). For a deeper understanding of the codebase,
  check out the [Technical documentation](./lua/codedocs/README.md).
- **Report or fix bugs**: If you encounter a bug, you can report it by creating
  a new discussion or GitHub issue. If you're able to fix the bug yourself, your
  help in resolving it is greatly appreciated!
- **Enhance the documentation**: If you spot any typos, outdated information, or
  areas where the documentation could be clearer, feel free to suggest
  improvements.

Every contribution, no matter how big or small, is valuable and highly
appreciated!

### <a id="motivation"></a>💡 Motivation

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

### <a id="license"></a>📜 License

Codedocs is licensed under the MIT License. This means you are free to download,
install, modify, share, and use the plugin for both personal and commercial
purposes.

The only requirement is that if you modify and redistribute the code, you must
include the same LICENSE file found in this repository.
