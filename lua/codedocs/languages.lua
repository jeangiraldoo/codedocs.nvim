--- Here are all the available settings for all languages
--- A setting is composed of 2 parts: Its value or name, and the data type it expects
local settings = {
			  structure = {val = "struct", type = "table"}, -- Base structure of a docstring, represented as a table with 2 or more elements
			  func_keyword = {val = "func", type = "string"}, -- Keyword used in the language to declare a function
			  is_type_before_name = {val = "is_type_before_name", type = "boolean"}, --- Wether or not the parameter type is to the left (before the name) in the function declaration, the parameter name will be on the opposite side.
			  type_goes_before_name = {val = "type_before_name", type = "boolean"},
			  param_type_separator = {val = "param_type_separator", type = "string"}, --- Separator in between the parameter name and type
			  direction = {val = "direction", type = "string"}, -- Position to place the docstring relative to the function declaration. Either "above" and "below"
			  title_pos = {val = "title_pos", type = "number"}, -- Line offset of the title within the docstring, relative to its start
			  params_title = {val = "params_title", type = "string"}, -- Title displayed before the parameters section in the docstring. 
			  param_keyword = {val = "param_keyword", type = "string"}, -- Keyword prefixed to each parameter in the docstring
			  param_indent = {val = "param_indent", type = "boolean"}, -- Determines wether or not the parameters should be indented.
			  type_wrapper = {val = "type_wrapper", type = "string"} -- Characters that will surround every parameter type within the docstring
			}

local templates = {
		python = {
			[settings.structure.val] = {'"""', "", '"""'},
			[settings.func_keyword.val] = "def",
			[settings.is_type_before_name.val] = false,
			[settings.type_goes_before_name.val] = false,
			[settings.param_type_separator.val] = ":",
			[settings.direction.val] = "below",
			[settings.title_pos.val] = 2,
			[settings.params_title.val] = "Args:",
			[settings.param_keyword.val] = "",
			[settings.param_indent.val] = true,
			[settings.type_wrapper.val] = "()"
		},
		javascript = {
			[settings.structure.val] = {"/**", " * ", " */"},
			[settings.func_keyword.val] = "function",
			[settings.is_type_before_name.val] = false,
			[settings.type_goes_before_name.val] = true,
			[settings.param_type_separator.val] = ":",
			[settings.direction.val] = "above",
			[settings.title_pos.val] = 2,
			[settings.params_title.val] = "",
			[settings.param_keyword.val] = "@param",
			[settings.param_indent.val] = false,
			[settings.type_wrapper.val] = "{}"
		},
		lua = {
			[settings.structure.val] = {"--- ", "-- "},
			[settings.func_keyword.val] = "function",
			[settings.is_type_before_name.val] = false,
			[settings.type_goes_before_name.val] = false,
			[settings.param_type_separator.val] = "",
			[settings.direction.val] = "above",
			[settings.title_pos.val] = 1,
			[settings.params_title.val] = "",
			[settings.param_keyword.val] = "@param",
			[settings.param_indent.val] = false,
			[settings.type_wrapper.val] = ""
		}
}

return {settings, templates}
