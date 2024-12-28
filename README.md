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

Codedocs.nvim automatically recognizes functions and methods in your code, creating structured documentation strings based on the programming language you are using (e.g., docstrings for Python, JSDoc for JavaScript, etc.).

You can easily modify the structure of the documentation strings to suit your specific needs, add support for new languages by defining their documentation formats, or just use codedocs as it is! :)

# Table of contents
- [Features](#features)
- [Supported languages](#supported-languages)
- [Motivation](#motivation)
- [License](#license)

### Features

- Automatic Recognition: Detects functions and methods in your codebase.
- Multi-Language Support: Generates documentation strings for various programming languages.
- Customizable Structures: Modify existing documentation formats or define new ones for additional languages.
- No Dependencies: Designed to be straightforward and self-contained, making integration seamless.

### Supported languages

This section lists the languages supported by Codedocs, along with the supported annotation styles and the automatic annotations that can be inserted into the documentation for each language.

Feel free to create your own custom styles if the options provided here don't meet your needs! :)

| Languages | Annonation styles | Supported automatic annotation |
|----------|----------|----------|
| Lua | [LDoc](#lua-ldoc) | `function parameters` |
| Python | [Google](#google), [NumPy/SciPy](#numpy-scipy), [reST](#restructuredtext-rest) | `function parameters` |
| JavaScript | [JSDoc](#javascript-jsdoc) | `function parameters` |
| TypeScript | [TSDoc](#typescript-tsdoc) | `function parameters` |
| Ruby | [YARD](#ruby-yard) | `function parameters` |

#### Styles per language:

##### Lua (LDoc):
[Official LDoc documentation](https://lunarmodules.github.io/ldoc/manual/manual.md.html#Introduction)

Example:
```lua
--- <title goes here>
-- param_1
-- param_2
local function cool_function(param_1, param_2)
    <code goes here>
end
```

##### JavaScript (JSDoc):
[Official JSDoc documentation](https://jsdoc.app/)

Example:
```javascript
/*
 * <title goes here>
 *
 * @param {} param_1
 * @param {} param_2
*/
function cool_function(param_1, param_2){
    <code goes here>
}
```

##### TypeScript (TSDoc):
[Official TSDoc documentation](https://tsdoc.org/)

Example:
```typescript
/*
 * <title goes here>
 *
 * @param param_1 -
 * @param param_2 -
*/
function cool_function(param_1: number, param_2: string){
    <code goes here>
}
```

##### Python:

- Google:

[Official Google documentation for Python](https://google.github.io/styleguide/pyguide.html#38-Comments-and-Documentation)

Example:
```python
def cool_function(param_1: int, param_2: bool):
    """
        <title goes here>

        Args:
            param_1 (int):
            param_2 (bool):
    """
    <code goes here>
```

- NumPy/SciPy:

[Official Numpy documentation for Python](https://numpydoc.readthedocs.io/en/latest/format.html#docstring-standard)

Example:
```python
def cool_function(param_1: list, param_2: str):
    """
        <title goes here>

        Parameters
        ----------
        param_1 : list
        param_2 : str
    """
    <code goes here>
```

- reStructuredText (reST):

[Official reST documentation for Python](https://docutils.sourceforge.io/rst.html)

Example:
```python
def cool_function(param_1: list, param_2: str):
    """
        <title goes here>

        :param param_1:
        :type param_1: list
        :param param_2:
        :type param_2: str
    """
    <code goes here>
```

##### Ruby (YARD):

[Official YARD documentation for Ruby](https://rubydoc.info/gems/yard/file/docs/GettingStarted.md#documenting-code-with-yard)

Example:
```ruby
 # <title goes here>
 #
 # @param param_1 []
 # @param param_2 []
def cool_function(param_1, param_2)
    <code goes here>
end
```

### Motivation

I started workng on Codedocs because I wanted to enhance my experience with Neovim, which I started using daily for my side projects and university assignments. I wanted a tool to make documenting my code easier and to contribute something useful to the community! :D

While I found a few plugins with similar functionality, none of them offered the level of customization and simplicity I was looking for. Sometimes, I feel that apps and plugins could be more intuitive and user-friendly while still providing the same powerful features.

TL;DR: I built Codedocs to improve productivity by automatically generating documentation strings, allowing for easy customization, and providing a simple yet powerful solution for both personal and community use. Plus, it is a fun project to work on!

### License

Codedocs is licensed under the MIT License. This means you are free to download, install, modify, share, and use the plugin for both personal and commercial purposes. The only requirement is that if you modify and redistribute the code, you must include the same LICENSE file found in this repository.
