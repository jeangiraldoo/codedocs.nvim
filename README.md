# codedocs.nvim

<p align="center">
    <img src="https://img.shields.io/badge/Lua-darkblue?logo=lua"/>
    <img src="https://img.shields.io/badge/Neovim-v0.10.0%2B-green?logo=neovim" alt="Neovim version 0.10.0 and up"/>
    <a href = "https://github.com/jeangiraldoo/codedocs.nvim/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/jeangiraldoo/codedocs.nvim?color=red" alt="Latest version"/>
    </a>
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
| Lua | LDoc | `function parameters` |
| Python | Google, NumPy/SciPy | `function parameters` |
| Javascript | JSDoc | `function parameters` |

### Motivation

I started workng on Codedocs because I wanted to enhance my experience with Neovim, which I started using daily for my side projects and university assignments. I wanted a tool to make documenting my code easier and to contribute something useful to the community! :D

While I found a few plugins with similar functionality, none of them offered the level of customization and simplicity I was looking for. Sometimes, I feel that apps and plugins could be more intuitive and user-friendly while still providing the same powerful features.

TL;DR: I built Codedocs to improve productivity by automatically generating documentation strings, allowing for easy customization, and providing a simple yet powerful solution for both personal and community use. Plus, it is a fun project to work on!

### License

Codedocs is licensed under the MIT License. This means you are free to download, install, modify, share, and use the plugin for both personal and commercial purposes. The only requirement is that if you modify and redistribute the code, you must include the same LICENSE file found in this repository.
