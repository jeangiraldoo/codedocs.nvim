# Contributing to Codedocs

Thanks for your interest in contributing to Codedocs!
This guide will walk you through the guidelines and best practices to keep in mind
when making contributions.

## Table of Contents

- [Getting started](#getting-started)
- [Guidelines](#guidelines)
  - [Commits](#commits)
  - [Documentation](#documentation)
  - [Code](#code)

## Getting started

There's many ways to help the project:

- You can propose new features, documentation improvements, bug fixes, or
  anything that can help the project in the long run.
- You can check the currently opened [issues](https://github.com/jeangiraldoo/codedocs.nvim/issues)
  and help fix any bugs or implement features.
- You can also code support for new languages, structures, or styles!

## Guidelines

In order to maintain a good level of quality across the codebase a series of
guidelines has been defined, all of which are checked using CI (Github Actions).

The guidelines are described below:

### Commits

[Commitlint](https://commitlint.js.org/) is used to ensure that all commits
comply with the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
standard. This makes skimming commit messages and filtering commits simpler.

Linting rules are defined in the `.commitlintrc.yaml` file at the root of the repository.

### Documentation

Documentation is written entirely in `Markdown` and is linted using
[Markdownlint](https://github.com/DavidAnson/markdownlint).

Linting rules are defined in the `.markdownlint.yaml` file at the root of the repository.

The following guidelines are not technical, but are still important to ensure
users have a good experience while using the plugin:

- Documentation should be easy to read and understand.
- Documentation should be well organized into sections.
- Examples should be included when explaining how to configure, fix, or use something.

### Code

Codedocs is built using **Lua** and **Treesitter**. Since Neovim natively supports
Lua, you don’t need to install anything extra. For Treesitter, Neovim has
[built-in support](https://neovim.io/doc/user/treesitter.html), so you'll just need
to install the appropriate parsers for the languages you're working with.

#### Style & Formatting

To maintain code consistency, follow these formatting and linting rules:

- **Formatting**: Use [Stylua](https://github.com/JohnnyMorganz/StyLua).
  Formatting rules that override Stylua's defaults are defined in the `.stylua.toml`
  file at the root of the repository.
- **Linting**: Run [Luacheck](https://github.com/mpeterv/luacheck) to catch issues
  like unused variables and syntax errors.

#### Best Practices

- **No global variables** – If you must use a global variable, explain why in your
  pull request.
- **Use snake_case** for module, directory, and variable names.
