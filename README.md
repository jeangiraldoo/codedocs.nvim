# codedocs.nvim

<p align="center">
    <img src="https://img.shields.io/badge/%20Lua-%23D0B8EB?style=for-the-badge&logo=lua"/>
    <img src="https://img.shields.io/github/last-commit/jeangiraldoo/codedocs.nvim?style=for-the-badge&labelColor=%232E3A59&color=%23A6D8FF" alt="When was the last commit made">
    <img src="https://img.shields.io/badge/v0.10%2B-%238BD5CA?style=for-the-badge&logo=neovim&label=Neovim&labelColor=%232E3A59&color=%238BD5CA" alt="Neovim version 0.10.0 and up"/>
    <a href = "https://github.com/jeangiraldoo/codedocs.nvim/blob/main/LICENSE" alt="Licensed under MIT">
        <img src="https://img.shields.io/badge/MIT-%232E3A59?style=for-the-badge&label=License&labelColor=%232E3A59&color=%23F4A6A6" alt="Latest version"/>
    </a>
    <img src="https://img.shields.io/github/repo-size/jeangiraldoo/codedocs.nvim?style=for-the-badge&logo=files&logoColor=yellow&label=SIZE&labelColor=%232E3A59&color=%23A8D8A1" alt="Repository size in KB">
</p>

Codedocs.nvim automatically recognizes various language structures such as functions, classes, variables, and more, and inserts appropriate documentation strings based on the [programming language](#supported-languages) you are using.

You can easily modify the structure of the documentation strings to suit your specific needs, add support for new languages by defining their documentation formats, or just use codedocs as it is! :)

# Table of contents
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Supported languages/structures](#supported-languages-and-structures)
- [Docstring examples](#docstring-examples)
- [Customize docstrings](#customize-docstrings)
- [Roadmap](#roadmap)
- [Technical documentation](./lua/codedocs/README.md)
- [Contributing](#contributing)
- [Motivation](#motivation)
- [License](#license)

### Features

- Automatic Recognition: Detects and documents the structure under the cursor using a keybind.
- Multi-Language Support: Generates documentation strings for various programming languages.
- Customizable Structures: Modify existing documentation formats or define new ones for additional languages.

### Requirements

Codedocs relies on Treesitter for its core functionality. The easiest way to install Treesitter parsers is by using [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter). Simply install **nvim-treesitter** and the parsers for the programming languages you use, and you're ready to install Codedocs.

If you already have the Treesitter parsers you want installed, you can proceed with installing Codedocs directly.

### Installation

To install Codedocs with your plugin manager, follow the instructions for the relevant manager below:


#### [lazy.nvim](http://www.lazyvim.org/)
```lua
{
    "jeangiraldoo/codedocs.nvim"
}
```

#### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use {
    "jeangiraldoo/codedocs.nvim"
}
```

### Configuration

Configuring Codedocs is not mandatory, as it works out of the box. However, if the default settings don’t meet your needs, you can easily customize the plugin.

#### Change the default docstring style used in a language

You can change the docstring style for any language that supports more than one style.

Keep in mind that the name of the docstring style must be spelled exactly as shown in the table of [supported languages](#supported-languages). For example, `reST` must be written as `reST` (not `ReST` or any other variation).

Although this example demonstrates changing the style for a single language, you can customize as many languages as you want by adding their names to the table and assigning the respective style names.

In this case, we are changing Python's docstring style from the default to "reST":

```lua
require("codedocs").setup {
    default_styles = {python = "reST"}
}
```

#### Customize a docstring style

You can refer to the [Customize docstring style](#customize-docstrings) section for detailed information about the process and the options available!

### Usage

When your cursor is placed on top of a language's structure (e.g., a function declaration, class, etc.) that you want to document and you trigger the docstring insertion, Codedocs will check if it has a [docstring style for such structure in the programming language you are using](#supported-languages). If a docstring style is available, it will generate and insert a docstring above or below the structure, depending on the language's docstring style.

If the structure under the cursor isn't supported by Codedocs, an empty single-line comment will be inserted.

You can start the docstring insertion either by using a command or a keymap:

##### Command:

Codedocs creates the `:Codedocs` command, which can be called manually like this:

```lua
:Codedocs
```

##### Keymap:

For a more convenient experience, you can bind the docstring insertion to a keymap. For example:

```lua
vim.keymap.set("n", "<leader>k", require('codedocs').insert_docs, { desc = "Inserts a docstring into the buffer" })
```
This keymap will insert a docstring when pressing ```<leader>k```. Feel free to customize the key combination to your liking.

### Supported languages and structures

Codedocs supports a variety of programming languages and provides automatic annotations tailored to each language's style. Below is a breakdown of how Codedocs handles annotations for different code structures:  

#### 1. **Function**  
   - **Parameters**: Included if present in the function signature.  
   - **Parameter Type**: Added if specified through a type hint or if the language is statically typed.  
   - **Return Section**: Included only if a return type is explicitly defined in the function signature.  

#### 2. **Class**  
   - **Attributes**: Class attributes are documented when available.  

#### 3. **Comment**
   - If no supported structure is detected under the cursor, Codedocs will insert an empty inline comment as a shortcut for adding regular comments.

This table lists the structures and their supported docstring styles for each language:

| Languages | Annonation styles | Supported automatic annotation |
|----------|----------|----------|
| Lua | [LDoc](#lua-ldoc) | `function`, `comment`|
| Python | [Google](#google), [NumPy/SciPy](#numpy-scipy), [reST](#restructuredtext-rest) | `class`, `function`, `comment` |
| JavaScript | [JSDoc](#javascript-jsdoc) | `class`, `function`, `comment` |
| TypeScript | [TSDoc](#typescript-tsdoc) | `class`, `function`, `comment` |
| Ruby | [YARD](#ruby-yard) | `function`, `comment`|
| PHP | [PHPDoc](#php-phpdoc) | `function`, `comment` |
| Java | [JavaDoc](#java-javadoc) | `class`, `function`, `comment` |
| Kotlin | [KDoc](#kotlin-kdoc) | `class`, `function`, `comment` |
| Rust | [RustDoc](#rust-kdoc) | `function`, `comment` |

### Docstring examples:

Here are some examples of docstrings generated by Codedocs for different languages and scenarios. These show how Codedocs handles various styles and annotations by default, so you can see what it might look like in your own code.

Feel free to [customize any docstring style](#customize-docstrings) in case these default styles don't fit your needs!

##### Lua (LDoc):
[Official LDoc documentation](https://lunarmodules.github.io/ldoc/manual/manual.md.html#Introduction)

```lua
--- <title goes here>
-- @param a
-- @param b
-- @return
local function cool_function(a, b)
    <code goes here>
    return <value>
end
```

##### JavaScript (JSDoc):
[Official JSDoc documentation](https://jsdoc.app/)

```javascript
/**
 *
 */
class SomeClass {
    /**
     * <title goes here>
     *
     * @param {} a
     * @param {} b
     * @returns
     */
    function cool_function(a, b){
        this.name = ""
        return <value>
    }
}
```

##### TypeScript (TSDoc):
[Official TSDoc documentation](https://tsdoc.org/)

```typescript
/**
 *
 */
class SomeClass {
    name: String;
    /**
     * <title goes here>
     *
     * @param a -
     * @param b -
     * @returns
     */
    function cool_function(a: number, b: string): number{
        this.name = ""
        return <value>
    }
}
```

##### Python:

- Google:

[Official Google documentation for Python](https://google.github.io/styleguide/pyguide.html#38-Comments-and-Documentation)

```python
class some_class:
    """
    <title goes here>

    Attributes:
        name ():
        sum ():
        another_sum ():
    """
    name = ""

    def cool_function_with_type_hints(a: int, b: bool) -> str:
        """
        <title goes here>

        Args:
            a (int):
            b (bool):
        Returns:
            str:
        """
        self.sum = 1 + 1
        return <value>

    def cool_function_without_type_hints(a, b):
        """
        <title goes here>

        Args:
            a ():
            b ():
        Returns:
        """
        self.another_sum = 2 + 2
        return <value>
```

- NumPy/SciPy:

[Official Numpy documentation for Python](https://numpydoc.readthedocs.io/en/latest/format.html#docstring-standard)

```python
class some_class:
    """
        

    Attributes:
    -----------
    name :
    sum :
    another_sum :
    """
    name = ""
    def cool_function_with_type_hints(a: list, b: str) -> bool:
        """
        <title goes here>

        Parameters
        ----------
        a : list
        b : str

        Returns
        ------
        bool
        """
        self.sum = 1 + 1
        return <value>

    def cool_function_without_type_hints(a, b):
        """
        <title goes here>

        Parameters
        ----------
        a :
        b :

        Returns
        ------
        """
        self.another_sum = 2 + 2
        return <value>
```

- reStructuredText (reST):

[Official reST documentation for Python](https://docutils.sourceforge.io/rst.html)

`:ivar` should be used instead of `:var` when documenting instance attributes. However, **Codedocs** currently cannot differentiate between instance attributes and class-level attributes, so `:var` is used in both cases for now. This is a temporary workaround until Codedocs is updated to handle class-level and instance-level attributes separately, providing more accurate documentation in the future.

```python
class some_class:
    """


    :var name:
    :vartype name:
    :var sum:
    :vartype sum:
    :var another_sum:
    :vartype another_sum:
    """
    name = ""
    def cool_function_with_type_hints(a: list, b: str) -> bool:
        """
        <title goes here>

        :param a:
        :type a: list
        :param b:
        :type b: str
        :return:
        :rtype: bool
        """
        self.sum = 1 + 1
        return <value>

    def cool_function_without_type_hints(a, b):
        """
        <title goes here>

        :param a:
        :type a:
        :param b:
        :type b:
        :return:
        :rtype:
        """
        self.another_sum = 2 + 2
        return <value>
```

##### Ruby (YARD):

[Official YARD documentation for Ruby](https://rubydoc.info/gems/yard/file/docs/GettingStarted.md#documenting-code-with-yard)

```ruby
 # <title goes here>
 #
 # @param a []
 # @param b []
 # @return
def cool_function(a, b)
    <code goes here>
    return <value>
end
```

##### PHP (PHPDoc):

[Official PHPDoc documentation for PHP](https://docs.phpdoc.org/guide/getting-started/what-is-a-docblock.html#what-is-a-docblock)

```php
/**
 * <title goes here>
 *
 * @param int $a
 * @param int $b
 * @return bool
 */
function cool_function_with_type_hints(int $a, int $b): bool {
    <code goes here>
    return <value>
}

/**
 * <title goes here>
 *
 * @param $a
 * @param $b
 * @return
 */
function cool_function_without_type_hints($a, $b) {
    <code goes here>
    return <value>
}
```

##### Java (JavaDoc):
[Official JavaDoc documentation](https://www.oracle.com/technical-resources/articles/java/javadoc-tool.html#format)

```java
/**
 *
 */
public class SomeClass {
    public String name;
    /**
     * <title goes here>
     *
     * @param a
     * @param b
     * @return
     */
    public void cool_function(int a, String b){
        this.name = b
        return <value>
    }
}
```

##### Kotlin (KDoc):
[Official KDoc documentation](https://kotlinlang.org/docs/kotlin-doc.html)

```kotlin
/**
 *
 */
class SomeClass {
    var name: String = ""
    /*
     * <title goes here>
     *
     * @param a
     * @param b
     * @return
     */
    fun cool_function(a: Int, b: String): Boolean {
        <code goes here>
        return <value>
    }
}
```

##### Rust (RustDoc):
[Official RustDoc documentation](https://doc.rust-lang.org/rust-by-example/meta/doc.html)

```rust
/// <title goes here>
///
/// # Arguments
///
/// * `a`
/// * `b`
///
/// # Returns
///
fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

### Customize docstrings

In Codedocs, you can customize almost (for now!) every aspect of a docstring style. Whether you want to make a simple change, like modifying the characters wrapping the parameter type:

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

In this case, we added spacing between the items in the parameter section, wrapped the parameter types with two [Kaomojis](https://kaomoji.ru/en/), and added a third one wrapping the left side of the return type. The titles for the return and parameter sections were also customized.

No matter your preference, Codedocs has at least one customization option for you! 😊

To customize a docstring style, you need to consider both the target section in the docstring and the available options for it.

#### Options:

First, let's focus on the available options. There are three types of options: **General**, **Item**, and **Class General**.

##### General  
These options control general aspects of a docstring, without focusing on specific items.

| Option Name | Expected Value Type | Behavior |
|-------------|---------------------|-----------|
| `structure`   | table   | Defines the structure of a docstring. Each item in the table represents one line. At least two items are required. |
| `direction`   | boolean | Determines where the docstring is inserted relative to the structure. `true` for above, `false` for below. |
| `title_pos`   | number  | Specifies the cursor position after inserting the docstring, relative to its first line. |
| `title_gap`   | boolean | Determines whether there is an empty line between the docstring's title and its content. |
| `section_gap` | boolean | Determines whether there is an empty line between sections. |
| `section_underline` | string  | Represents a character placed underneath each section title. Assign an empty string (`""`) to disable underlining. |
| `section_title_gap` | boolean | Determines whether there is an empty line between a section title and its content. |
| `item_gap` | boolean | Determines whether there is an empty line between items. |
| `section_order` | table   | Specifies the order in which sections are added to the docstring. |

##### Item  
An **item** refers to a piece of data being documented. In a function docstring, for example, parameters and the return type are considered items. These options control the formatting of such items.

| Option Name | Expected Value Type | Behavior |
|-------------|---------------------|-----------|
| `title` | string | Defines a section's title. |
| `inline` | boolean | Determines whether the item name and type appear on the same line or across two lines. |
| `indent` | boolean | Determines whether items should be indented. |
| `include_type` | boolean | Specifies whether the item type is included in the docstring when available. |
| `type_first` | boolean | Determines whether the item type is placed before the item name. |
| `name_kw` | string | Defines a string prefixed to the item name. |
| `type_kw` | string | Defines a string prefixed to the item type. |
| `name_wrapper` | table  | Specifies the strings that surround the item name. The table must contain two strings. Assign two empty strings (`""`) to disable wrapping. |
| `type_wrapper` | table  | Specifies the strings that surround the item type. The table must contain two strings. Assign two empty strings (`""`) to disable wrapping. |

##### Class General  
This set of options is specific to the **general section** of a class.

| Option Name | Expected Value Type | Behavior |
|-------------|---------------------|-----------|
| `include_class_attrs` | boolean | Determines whether class-level attributes are included in the class docstring. |
| `include_instance_attrs` | boolean | Determines whether instance attributes are included in the class docstring. |
| `include_only_construct_instance_attrs` | boolean | Determines whether only instance attributes found in the class constructor are included, or if all instance attributes should be documented. |

#### Docstring sections:

Each docstring for a specific language structure (e.g., functions, classes, etc.) is composed of sections. Below are the sections found in docstring styles for different structures:

| Structure | Sections |
|-----------|------------------------------|
| `func`    | `general`, `params`, `return_type` |
| `class`   | `general`, `attrs` |
| `comment` | `general` |

### Available Options for Each Section

Each section has specific options that can be customized:

| Section         | Available Options  |
|----------------|--------------------|
| `general`      | `general`          |
| `general (class)` | `class general` |
| `params`       | `item`             |
| `return_type`  | `item`             |
| `attrs`        | `item`             |

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

1. Define the styles key – This holds a table containing the programming languages you want to target.
2. Specify the language – In this case, "python".
3. Choose the docstring style to customize – Here, it is "Google".
4. Specify the structure to modify – In this example, "func".
5. Modify sections within the structure – For "func", the general and params sections are customized.

        - general section:
            - item_gap = true (adds spacing between items)
            - section_gap = true (adds spacing between sections)
        - params section:
            - include_type = true (includes parameter types in the docstring)

⚠️ Important Notes:

Ensure that the option names are spelled correctly and that the values match their expected data types (e.g., true/false for booleans).
If an option is misspelled or the wrong data type is used, an error will occur.

This procedure applies to all supported languages, considering the information provided in this section.

### Roadmap

This diagram outlines the features and improvements planned for the project at different stages. Please note that this roadmap is flexible and will be updated as the project evolves, reflecting its current state at any given time.

```mermaid
flowchart LR
    1[Current stage (Alpha)]
    2[Beta
    - Support for documenting files/modules
    - Support for documenting variables
    - Unit tests]
    3[Stable
    - More unit tests
    - Design a logo]
    4[Beyond*
    - Automatically updating docstrings when the structure they document changes, such as updating parameters when they are renamed or removed in a function declaration]
    1 --> 2 --> 3 --> 4
```

*Beyond: Refers to all the features planned for Codedocs after the plugin reaches a stable and mature state. They will be appropriately split into stages when the moment comes.

### Contributing

Thank you for your interest in contributing to **Codedocs**! There are several ways you can help improve the project:

- **Propose new features**: If you have an idea for a new feature, please open a discussion in the [Discussions section](https://github.com/jeangiraldoo/codedocs.nvim/discussions).
- **Contribute to feature development**: You can help by working on features listed in the [Roadmap](#roadmap). For a deeper understanding of the codebase, check out the [documentation explaining how Codedocs works under the hood](./lua/codedocs/README.md).
- **Report or fix bugs**: If you encounter a bug, you can report it by creating a new discussion or GitHub issue. If you're able to fix the bug yourself, your help in resolving it is greatly appreciated!
- **Enhance the documentation**: If you spot any typos, outdated information, or areas where the documentation could be clearer, feel free to suggest improvements.

Every contribution, no matter how big or small, is valuable and highly appreciated!


### Motivation

I started workng on Codedocs because I wanted to enhance my experience with Neovim, which I started using daily for my side projects and university assignments. I wanted a tool to make documenting my code easier and to contribute something useful to the community! :D

While I found a few plugins with similar functionality, none of them offered the level of customization and simplicity I was looking for. Sometimes, I feel that apps and plugins could be more intuitive and user-friendly while still providing the same powerful features.

TL;DR: I built Codedocs to improve productivity by automatically generating documentation strings, allowing for easy customization, and providing a simple yet powerful solution for both personal and community use. Plus, it is a fun project to work on!

### License

Codedocs is licensed under the MIT License. This means you are free to download, install, modify, share, and use the plugin for both personal and commercial purposes. The only requirement is that if you modify and redistribute the code, you must include the same LICENSE file found in this repository.
