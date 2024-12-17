# codedocs.nvim

Document your code in a fun and efficient way!

## What is the purpose of codedocs?

Codedocs.nvim automatically recognizes functions and methods in your code, creating structured documentation strings based on the programming language you are using (e.g., docstrings for Python, JSDoc for JavaScript, etc.).

You can easily modify the structure of the documentation strings to suit your specific needs, add support for new languages by defining their documentation formats, or just use codedocs as it is! :)

### Key Features

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
| Python | Google docstrings | `function parameters` |
| Javascript | JSDoc | `function parameters` |

