--- Language-specific settings for generating docstrings.
---
--- The available settings for each language are as follows:
---
--- struct (table): The base structure of a docstring, represented as a table with three elements:
---   1. The first element is the opening line of the docstring
---   2. The middle element is the string prefixed to every line within the docstring body
---   3. The third element is the closing line of the docstring
---
--- func (string): The keyword used in the language to declare a function
---
--- is_type_before_name (bool): Wether or not the parametre type is to the left (before the name)
--- in the function declaration, the parametre name will be on the opposite side.
---
--- param_type_separator (string): The separator found in between the parametre name and type
---
--- direction (string): Specifies where to place the docstring relative to the function declaration
---   Valid values are:
---     - "above": Place the docstring before the function declaration
---     - "below": Place the docstring after the function declaration
---
--- title_pos (number): The line offset of the title within the docstring, relative to its start
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
---
--- param_indent (bool): Determines wether or not the parametres should be indented.
---
--- type_wrapper (string): Defines the characters that will surround the parametre type for each parametre within the docstring


return {
		python = {
			struct = {'"""', "", '"""'},
			func = "def",
			is_type_before_name = false,
			type_goes_before_name = false,
			param_type_separator = ":",
			direction = "below",
			title_pos = 2,
			params_title = "Args:",
			param_keyword = "",
			param_indent = true,
			type_wrapper = "()"
		},
		javascript = {
			struct = {"/**", " * ", " */"},
			func = "function",
			is_type_before_name = false,
			type_goes_before_name = true,
			param_type_separator = ":",
			direction = "above",
			title_pos = 2,
			params_title = "",
			param_keyword = "@param",
			param_indent = false,
			type_wrapper = "{}"
		},
		lua = {
			struct = {"--- ", "-- "},
			func = "function",
			is_type_before_name = false,
			type_goes_before_name = false,
			param_type_separator = "",
			direction = "above",
			title_pos = 1,
			params_title = "",
			param_keyword = "@param",
			param_indent = false,
			type_wrapper = ""
		}
}
