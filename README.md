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
- [Customize docstrings](#customize-docstrings)
- [Roadmap](#roadmap)
- [Technical documentation](./lua/codedocs/README.md)
- [Contributing](#contributing)
- [Motivation](#motivation)
- [License](#license)

### <a id="features"></a>🚀 Features

- Works out-of-the-box: Integrates with Neovim instantly—no configuration
  needed.
- Auto Documentation: Detects and documents code structures with a simple
  keybind.
- Multi-language Support: Generates docstrings for various programming
  languages.
- Customizable: Easily modify existing formats or add new ones in just a few
  simple steps.

### <a id="requirements"></a>📋 Requirements

Codedocs relies on Treesitter for its core functionality. Neovim includes
built-in Treesitter parsers for the following languages—meaning no extra setup
is needed for:

- Lua
- C

For any other language, you'll need to install the corresponding Treesitter
parser. The simplest way to do this is with
**[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**.

Once you have the necessary parsers, you're all set to install Codedocs.

### <a id="installation"></a>📦 Installation

To install Codedocs with your plugin manager, follow the instructions for your
preferred manager below. As noted in the [Requirements section](#requirements),
nvim-treesitter is only needed if you plan to use it for installing additional
Treesitter parsers. If you're only working with Lua and C, or prefer to manage
parsers manually, you can safely omit it.

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
    -- Remove the 'dependencies' section if you don't plan on using nvim-treesitter
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    }
}
```

#### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    "jeangiraldoo/codedocs.nvim",
    -- Remove the 'requires' section if you don't plan on using nvim-treesitter
    requires = {
        "nvim-treesitter/nvim-treesitter"
    }
}
```

#### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'jeangiraldoo/codedocs.nvim'
" Remove the 'Plug' line below if you don't plan on using nvim-treesitter
Plug 'nvim-treesitter/nvim-treesitter'
```

#### [mini.deps](https://github.com/echasnovski/mini.deps)

```lua
require("mini.deps").add({
    source = "jeangiraldoo/codedocs.nvim",
    -- Remove the 'depends' section if you don't plan on using nvim-treesitter
    depends = { "nvim-treesitter/nvim-treesitter" }
})
```

#### [minpac](https://github.com/k-takata/minpac)

```vim
packadd minpac
call minpac#add('jeangiraldoo/codedocs.nvim')
" Remove the 'call minpac#add' line below if you don't plan on using nvim-treesitter
call minpac#add('nvim-treesitter/nvim-treesitter')
```

#### [paq-nvim](https://github.com/savq/paq-nvim)

```lua
require("paq") {
    "jeangiraldoo/codedocs.nvim",
    -- Remove the line below if you don't plan on using nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
}
```

### <a id="configuration"></a>⚙️ Configuration

Configuring Codedocs is not mandatory, as it works out of the box. However, if
the default settings don’t meet your needs, you can easily customize the plugin.

#### Change the default docstring style used in a language

You can change the docstring style for any language that supports more than one
style.

Keep in mind that the name of the docstring style must be spelled exactly as
shown in the table of [supported languages](#supported-languages). For example,
`reST` must be written as `reST` (not `ReST` or any other variation).

Although this example demonstrates changing the style for a single language, you
can customize as many languages as you want by adding their names to the table
and assigning the respective style names.

In this case, we are changing Python's docstring style from the default to
"reST":

```lua
require("codedocs").setup {
    default_styles = {python = "reST"}
}
```

#### Customize a docstring style

You can refer to the [Customize docstring style](#customize-docstrings) section
for detailed information about the process and the options available!

### <a id="usage"></a>💻 Usage

When your cursor is placed on top of a language's structure (e.g., a function
declaration, class, etc.) that you want to document and you trigger the
docstring insertion, Codedocs will check if it has a
[docstring style](#supported-languages) for such structure in the programming
language you are using. If a docstring style is available, it will generate and
insert a docstring above or below the structure, depending on the language's
docstring style.

If the structure under the cursor isn't supported by Codedocs, an empty
single-line comment will be inserted.

You can start the docstring insertion either by using a command or a keymap:

#### Command

Codedocs creates the `:Codedocs` command, which can be called manually like
this:

```lua
:Codedocs
```

#### Keymap

For a more convenient experience, you can bind the docstring insertion to a
keymap. For example:

```lua
vim.keymap.set(
    "n", "<leader>k", require('codedocs').insert_docs,
    { desc = "Insert docstring" }
)
```

This keymap will insert a docstring when pressing `<leader>k`. Feel free to
customize the key combination to your liking.

### <a id="supported-languages"></a>🌐 Supported languages

Codedocs supports a variety of programming languages and provides automatic
annotations tailored to each language's style. Below is a breakdown of how
Codedocs handles annotations for different code structures:

#### 1. **Function**

- **Parameters**: Included if present in the function signature.
- **Parameter Type**: Added if specified through a type hint or if the language
  is statically typed.
- **Return Section**: Included only if a return type is explicitly defined in
  the function signature.

#### 2. **Class**

- **Attributes**: Class attributes are documented when available.

#### 3. **Comment**

- If no supported structure is detected under the cursor, Codedocs will insert
  an empty inline comment as a shortcut for adding regular comments.

This table lists the structures and their supported docstring styles for each
language:

| Languages  | Annotation styles         | Supported automatic annotation |
| ---------- | ------------------------- | ------------------------------ |
| Lua        | LDoc                      | `function`, `comment`          |
| Python     | Google, NumPy/SciPy, reST | `class`, `function`, `comment` |
| JavaScript | JSDoc                     | `class`, `function`, `comment` |
| TypeScript | TSDoc                     | `class`, `function`, `comment` |
| Ruby       | YARD                      | `function`, `comment`          |
| PHP        | PHPDoc                    | `function`, `comment`          |
| Java       | JavaDoc                   | `class`, `function`, `comment` |
| Kotlin     | KDoc                      | `class`, `function`, `comment` |
| Rust       | RustDoc                   | `function`, `comment`          |
| Go         | Godoc                     | `function`, `comment`          |
| C          | Doxygen                   | `function`, `comment`          |
| C++        | Doxygen                   | `function`, `comment`          |

Want to see what docstrings look like by default? Check out the
[Docstring Examples](./DOCSTRING_EXAMPLES.md) to explore different formats
across multiple languages.

### <a id="customize-docstrings"></a>🎨 Customize docstrings

In Codedocs, you can customize almost (for now!) every aspect of a docstring
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

In this case, we added spacing between the items in the parameter section,
wrapped the parameter types with two [Kaomojis](https://kaomoji.ru/en/), and
added a third one wrapping the left side of the return type. The titles for the
return and parameter sections were also customized.

No matter your preference, Codedocs has at least one customization option for
you! 😊

To customize a docstring style, you need to consider both the target section in
the docstring and the available options for it.

#### Options

First, let's focus on the available options. There are three types of options:
**General**, **Item**, and **Class General**.

##### General

These options control general aspects of a docstring, without focusing on
specific items.

| Option Name         | Expected Value Type | Behavior                                                                                                           |
| ------------------- | ------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `structure`         | table               | Defines the structure of a docstring. Each item in the table represents one line. At least two items are required. |
| `direction`         | boolean             | Determines where the docstring is inserted relative to the structure. `true` for above, `false` for below.         |
| `title_pos`         | number              | Specifies the cursor position after inserting the docstring, relative to its first line.                           |
| `title_gap`         | boolean             | Determines whether there is an empty line between the docstring's title and its content.                           |
| `section_gap`       | boolean             | Determines whether there is an empty line between sections.                                                        |
| `section_underline` | string              | Represents a character placed underneath each section title. Assign an empty string (`""`) to disable underlining. |
| `section_title_gap` | boolean             | Determines whether there is an empty line between a section title and its content.                                 |
| `item_gap`          | boolean             | Determines whether there is an empty line between items.                                                           |
| `section_order`     | table               | Specifies the order in which sections are added to the docstring.                                                  |

##### Item

An **item** refers to a piece of data being documented. In a function docstring,
for example, parameters and the return type are considered items. These options
control the formatting of such items.

| Option Name    | Expected Value Type | Behavior                                                                      |
| -------------- | ------------------- | ----------------------------------------------------------------------------- |
| `title`        | string              | Section title                                                                 |
| `inline`       | boolean             | Show item name and type on the same line or separate lines                    |
| `indent`       | boolean             | Indent items                                                                  |
| `include_type` | boolean             | Include item type in the docstring if available                               |
| `type_first`   | boolean             | Place item type before item name                                              |
| `name_kw`      | string              | Prefix for item name                                                          |
| `type_kw`      | string              | Prefix for item type                                                          |
| `name_wrapper` | table               | Strings surrounding item name (must contain two). Use empty string to disable |
| `type_wrapper` | table               | Strings surrounding item type (must contain two). Use empty string to disable |

##### Class General

This set of options is specific to the **general section** of a class.

| Option Name                             | Expected Value Type | Behavior                                                               |
| --------------------------------------- | ------------------- | ---------------------------------------------------------------------- |
| `include_class_attrs`                   | boolean             | Include class-level attributes in the docstring                        |
| `include_instance_attrs`                | boolean             | Include instance attributes in the docstring                           |
| `include_only_construct_instance_attrs` | boolean             | Only include instance attributes from the constructor, or document all |

#### Docstring sections

Each docstring for a specific language structure (e.g., functions, classes,
etc.) is composed of sections. Below are the sections found in docstring styles
for different structures:

| Structure | Sections                           |
| --------- | ---------------------------------- |
| `func`    | `general`, `params`, `return_type` |
| `class`   | `general`, `attrs`                 |
| `comment` | `general`                          |

### Available Options for Each Section

Each section has specific options that can be customized:

| Section           | Available Options |
| ----------------- | ----------------- |
| `general`         | `general`         |
| `general (class)` | `class general`   |
| `params`          | `item`            |
| `return_type`     | `item`            |
| `attrs`           | `item`            |

---

### Customizing a Docstring

To customize a docstring style, follow a structure similar to this:

```lua
require("codedocs").setup {
    styles = {
        python = {
            Google = {
                func = {
                    general = {
                        item_gap = true,
                        section_gap = true
                    },
                    params = {
                        include_type = true
                    },
                }
            },
        },
    }
}
```

Explanation:

1. Define the styles key – This holds a table containing the programming
   languages you want to target.
2. Specify the language – In this case, "python".
3. Choose the docstring style to customize – Here, it is "Google".
4. Specify the structure to modify – In this example, "func".
5. Modify sections within the structure – For "func", the general and params
   sections are customized.
    - general section:
        - item_gap = true (adds spacing between items)
        - section_gap = true (adds spacing between sections)
    - params section:
        - include_type = true (includes parameter types in the docstring)

⚠️ Important Notes:

Ensure that the option names are spelled correctly and that the values match
their expected data types (e.g., true/false for booleans).

If an option is misspelled or the wrong data type is used, an error will occur.

This procedure applies to all supported languages, considering the information
provided in this section.

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
