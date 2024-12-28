--- Here are all the available settings for all languages
--- A setting is composed of 2 parts: Its value or name, and the data type it expects
local settings = {
			struct = {val = "structure", type = "table"}, -- Base structure of a docstring, represented as a table with 2 or more elements
		  	func_keyword = {val = "function", type = "string"}, -- Keyword used in the language to declare a function
		  	is_type_first = {val = "is_type_first", type = "boolean"}, -- Parameter type's positon in function signature. true is before the name, false is after it. The name will be on the opposite side
		  	type_goes_first = {val = "type_goes_first", type = "boolean"},
		  	param_type_separator = {val = "param_type_separator", type = "string"}, -- Separator in between the parameter name and type
		  	direction = {val = "direction", type = "boolean"}, -- Position to place the docstring relative to the function declaration. Either true (above) or false (below)
		  	title_pos = {val = "title_pos", type = "number"}, -- Line offset of the title within the docstring, relative to its start
		  	empty_line_after_title = {val = "empty_line_after_title", type = "boolean"}, -- Inserts an empty line after the title if true
		  	section_underline = {val = "section_underline", type = "string"}, -- Creates a string of the specified char to underline the section title
		  	params_title = {val = "params_title", type = "string"}, -- Title displayed before the parameters section in the docstring
		  	is_param_one_line = {val = "is_param_one_line", type = "boolean"}, -- Determines if the param name and type go on the same line or not
			is_type_below_name_first = {val = "is_type_below_name_first", type = "boolean"}, -- Determines if the type below starts with the param name or just the type. This setting is used whenever is_param_one_line is false
			is_type_in_docs = {val = "is_type_in_docs", type = "boolean"}, -- Determines wether or not to document the parameter type in the docstring
		  	param_keyword = {val = "param_keyword", type = "string"}, -- Keyword prefixed to each parameter name in the docstring
			type_keyword = {val = "type_keyword", type = "string"}, -- Keyword prefixed to each parameter type in the docstring
		  	param_indent = {val = "param_indent", type = "boolean"}, -- Determines wether or not the parameters should be indented
		  	name_wrapper = {val = "name_wrapper", type = "table"}, -- Strings that will surround every parameter name within the docstring
		  	type_wrapper = {val = "type_wrapper", type = "table"} -- Strings that will surround every parameter type within the docstring
			}

local default_lang_styles = {
			python = "Google",
			javascript = "JSDoc",
			typescript = "TSDoc",
			lua = "LDoc",
			java = "JavaDoc"
			}

local styles = {
		python = {
			Google = {
				[settings.struct.val] = {'"""', "", '"""'},
				[settings.func_keyword.val] = "def",
				[settings.is_type_first.val] = false,
				[settings.is_type_in_docs.val] = true,
				[settings.type_goes_first.val] = false,
				[settings.param_type_separator.val] = ":",
				[settings.direction.val] = false,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "Args:",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "",
				[settings.type_keyword.val] = "",
				[settings.param_indent.val] = true,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"(", "):"}
				},
			Numpy = {
				[settings.struct.val] = {'"""', "", '"""'},
				[settings.func_keyword.val] = "def",
				[settings.is_type_first.val] = false,
				[settings.is_type_in_docs.val] = true,
				[settings.type_goes_first.val] = false,
				[settings.param_type_separator.val] = ":",
				[settings.direction.val] = false,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "-",
				[settings.params_title.val] = "Parameters:",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "",
				[settings.type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {": ", ""}
				},
			reST = {
				[settings.struct.val] = {'"""', "", '"""'},
				[settings.func_keyword.val] = "def",
				[settings.is_type_first.val] = false,
				[settings.is_type_in_docs.val] = true,
				[settings.type_goes_first.val] = false,
				[settings.param_type_separator.val] = ":",
				[settings.direction.val] = false,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.is_param_one_line.val] = false,
				[settings.is_type_below_name_first.val] = true,
				[settings.param_keyword.val] = ":param",
				[settings.type_keyword.val] = ":type",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ":"},
				[settings.type_wrapper.val] = {"", ""}
				}
		},
		javascript = {
			JSDoc = {
				[settings.struct.val] = {"/**", " * ", " */"},
				[settings.func_keyword.val] = "function",
				[settings.is_type_first.val] = false,
				[settings.is_type_in_docs.val] = true,
				[settings.type_goes_first.val] = true,
				[settings.param_type_separator.val] = ":",
				[settings.direction.val] = true,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "",
				[settings.type_keyword.val] = "@param",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"{", "}"}
				}
		},
		typescript = {
			TSDoc = {
				[settings.struct.val] = {"/**", " * ", " */"},
				[settings.func_keyword.val] = "function",
				[settings.is_type_first.val] = false,
				[settings.is_type_in_docs.val] = false,
				[settings.type_goes_first.val] = false,
				[settings.param_type_separator.val] = ":",
				[settings.direction.val] = true,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "@param",
				[settings.type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", " -"},
				[settings.type_wrapper.val] = {"", ""}
				}
		},
		lua = {
			LDoc = {
				[settings.struct.val] = {"--- ", "-- "},
				[settings.func_keyword.val] = "function",
				[settings.is_type_first.val] = false,
				[settings.is_type_in_docs.val] = true,
				[settings.type_goes_first.val] = false,
				[settings.param_type_separator.val] = "",
				[settings.direction.val] = true,
				[settings.title_pos.val] = 1,
				[settings.empty_line_after_title.val] = false,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "@param",
				[settings.type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"", ""}
				}
		},
		java = {
			JavaDoc = {
				[settings.struct.val] = {"/**", " * ", " */"},
				[settings.func_keyword.val] = "function",
				[settings.is_type_first.val] = true,
				[settings.is_type_in_docs.val] = true,
				[settings.type_goes_first.val] = false,
				[settings.param_type_separator.val] = ":",
				[settings.direction.val] = true,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "@param",
				[settings.type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", " "},
				[settings.type_wrapper.val] = {"", ""}
				}
		}
}

return {settings, default_lang_styles, styles}
