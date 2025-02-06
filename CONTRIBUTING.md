# Contributing to Codedocs

Thanks for your interest in contributing to Codedocs!
This guide will walk you through the guidelines and best practices to keep in mind
when making contributions.

## Table of Contents

- [General Guidelines](#general-guidelines)
- [Code Guidelines](#code-guidelines)
- [Markdown Docs Guidelines](#markdown-docs-guidelines)

### General Guidelines

To ensure a smooth review and merge process, please follow these guidelines when
submitting a pull request:

- If you're contributing to the codebase, check out the
    [Technical documentation](./lua/codedocs/README.md) to better understand its
    structure and components.
- **Follow Conventional Commits** – All commits and pull requests must follow the
    [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard.
- **Formatting & Linting** – Both code and Markdown documentation must be properly
    formatted and linted. GitHub Actions will automatically check this on each pull
    request. You can find more details in the [Code](#code-guidelines) and
    [Markdown Documentation](#markdown-docs-guidelines) sections.

### Code Guidelines

Codedocs is built using **Lua** and **Treesitter**. Since Neovim natively supports
Lua, you don’t need to install anything extra. For Treesitter, Neovim has
[built-in support](https://neovim.io/doc/user/treesitter.html), so you'll just need
to install the appropriate parsers for the languages you're working with.

#### Style & Formatting

To maintain code consistency, follow these formatting and linting rules:

- **Formatting**: Use [Stylua](https://github.com/JohnnyMorganz/StyLua) (or manually
    follow its guidelines).
    Formatting rules that override Stylua's defaults are defined in the
    `.stylua.toml` file at the root of the repository.
- **Linting**: Run [Luacheck](https://github.com/mpeterv/luacheck) to catch issues
    like unused variables and syntax errors.

#### Best Practices

- **No global variables** – If you must use a global variable, explain why in your
    pull request.
- **Use snake_case** for module, directory, and variable names.

### Markdown Docs Guidelines

You're welcome to contribute to documentation improvements, whether it's fixing a
typo, updating outdated sections, or any other type of improvement.

To maintain consistency and avoid common issues (e.g., broken links), Codedocs uses
[markdownlint](https://github.com/DavidAnson/markdownlint) for linting.

[Mermaid](https://mermaid.js.org/) is used for diagrams because it's easy to iterate
on them, and since it's just plain text, you can edit them manually and they will
be automatically formatted and rendered.

Before submitting, make sure your Markdown files pass linting checks.
