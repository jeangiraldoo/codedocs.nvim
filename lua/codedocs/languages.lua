--- Language-specific settings for generating docstrings.
---
--- The available settings for each language are as follows:
---
--- struct (table): The base structure of a docstring, represented as a table with three elements:
---   1. The first element is the opening line of the docstring.
---   2. The middle element is the string prefixed to every line within the docstring body.
---   3. The third element is the closing line of the docstring.
---
--- func (string): The keyword used in the language to declare a function.
---
--- direction (string): Specifies where to place the docstring relative to the function declaration.
---   Valid values are:
---     - "above": Place the docstring before the function declaration.
---     - "below": Place the docstring after the function declaration.
---
--- params_title (string): The title displayed before the parametres section in the docstring. 
---   Some languages or docstring styles include a title for the parametres (e.g., "Args:" in Python),
---   while others list parametres directly without a title. For the latter case, set "params_title"
---   to an empty string ("").
---
--- param_keyword (string): The keyword prefixed to each parametre in the docstring. 
---   For instance, some languages (e.g., JavaScript) use a specific keyword like "@param" before each
---   parametre, while others list parametres without a keyword. For the latter case, set "param_keyword"
---   to an empty string ("").


return {
		python = {
			struct = {'"""', '\t', '"""'},
			func = "def",
			direction = "below",
			params_title = "Args:",
			param_keyword = ""
		},
		javascript = {
			struct = {"/**", " * ", " */"},
			func = "function",
			direction = "above",
			params_title = "",
			param_keyword = "@param {} "
		}
}
