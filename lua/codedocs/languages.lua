--- Here are all the available settings for all languages
--- A setting is composed of 2 parts: Its value or name, and the data type it expects
local settings = {
			struct = {val = "structure", type = "table"}, -- Base structure of a docstring, represented as a table with 2 or more elements
		  	type_goes_first = {val = "type_goes_first", type = "boolean"},
		  	direction = {val = "direction", type = "boolean"}, -- Position to place the docstring relative to the function declaration. Either true (above) or false (below)
		  	title_pos = {val = "title_pos", type = "number"}, -- Line offset of the title within the docstring, relative to its start
		  	empty_line_after_title = {val = "empty_line_after_title", type = "boolean"}, -- Inserts an empty line after the title if true
		  	section_underline = {val = "section_underline", type = "string"}, -- Creates a string of the specified char to underline the section title
		  	params_title = {val = "params_title", type = "string"}, -- Title displayed before the parameters section in the docstring
			return_title = {val = "return_title", type = "string"}, -- Ttitle displayed at the beggining of the return section
		  	is_param_one_line = {val = "is_param_one_line", type = "boolean"}, -- Determines if the param name and type go on the same line or not
			is_type_below_name_first = {val = "is_type_below_name_first", type = "boolean"}, -- Determines if the type below starts with the param name or just the type. This setting is used whenever is_param_one_line is false
			is_type_in_docs = {val = "is_type_in_docs", type = "boolean"}, -- Determines wether or not to document the parameter type in the docstring
		  	param_keyword = {val = "param_keyword", type = "string"}, -- Keyword prefixed to each parameter name in the docstring
			type_keyword = {val = "type_keyword", type = "string"}, -- Keyword prefixed to each parameter type in the docstring
			return_keyword = {val = "return_keyword", type = "string"}, -- Keyword prefixed to the return line
			return_type_keyword = {val = "return_type_keyword", type = "string"},
			is_return_type_in_docs = {val = "is_return_type_in_docs", type = "boolean"}, -- Determines wether or not to include the return type
		  	param_indent = {val = "param_indent", type = "boolean"}, -- Determines wether or not the parameters should be indented
		  	name_wrapper = {val = "name_wrapper", type = "table"}, -- Strings that will surround every parameter name within the docstring
		  	type_wrapper = {val = "type_wrapper", type = "table"}, -- Strings that will surround every parameter type within the docstring
			return_type_wrapper = {val = "return_type_wrapper", type = "table"} -- Strings that will surround the return type
			}

local default_lang_styles = {
			python = "Google",
			javascript = "JSDoc",
			typescript = "TSDoc",
			lua = "LDoc",
			ruby = "YARD",
			php = "PHPDoc",
			java = "JavaDoc",
			kotlin = "KDoc"
			}

local styles = {
		python = {
			Google = {
				[settings.struct.val] = {'"""', "", '"""'},
				[settings.is_type_in_docs.val] = true,
				[settings.is_return_type_in_docs.val] = true,
				[settings.type_goes_first.val] = false,
				[settings.direction.val] = false,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "Args:",
				[settings.return_title.val] = "Returns:",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "",
				[settings.type_keyword.val] = "",
				[settings.return_keyword.val] = "",
				[settings.return_type_keyword.val] = "",
				[settings.param_indent.val] = true,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"(", "):"},
				[settings.return_type_wrapper.val] = {"", ":"}
				},
			Numpy = {
				[settings.struct.val] = {'"""', "", '"""'},
				[settings.is_type_in_docs.val] = true,
				[settings.is_return_type_in_docs.val] = true,
				[settings.type_goes_first.val] = false,
				[settings.direction.val] = false,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "-",
				[settings.params_title.val] = "Parameters",
				[settings.return_title.val] = "Returns",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "",
				[settings.type_keyword.val] = "",
				[settings.return_keyword.val] = "",
				[settings.return_type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {": ", ""},
				[settings.return_type_wrapper.val] = {"", ""}
				},
			reST = {
				[settings.struct.val] = {'"""', "", '"""'},
				[settings.is_type_in_docs.val] = true,
				[settings.is_return_type_in_docs.val] = true,
				[settings.type_goes_first.val] = false,
				[settings.direction.val] = false,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.return_title.val] = "",
				[settings.is_param_one_line.val] = false,
				[settings.is_type_below_name_first.val] = true,
				[settings.param_keyword.val] = ":param",
				[settings.type_keyword.val] = ":type",
				[settings.return_keyword.val] = ":return:",
				[settings.return_type_keyword.val] = ":rtype:",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ":"},
				[settings.type_wrapper.val] = {"", ""},
				[settings.return_type_wrapper.val] = {"", ""}
				}
		},
		javascript = {
			JSDoc = {
				[settings.struct.val] = {"/**", " * ", " */"},
				[settings.is_type_in_docs.val] = true,
				[settings.is_return_type_in_docs.val] = true,
				[settings.type_goes_first.val] = true,
				[settings.direction.val] = true,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.return_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "",
				[settings.type_keyword.val] = "@param",
				[settings.return_keyword.val] = "@returns",
				[settings.return_type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"{", "}"},
				[settings.return_type_wrapper.val] = {"{", "}"}
				}
		},
		typescript = {
			TSDoc = {
				[settings.struct.val] = {"/**", " * ", " */"},
				[settings.is_type_in_docs.val] = false,
				[settings.is_return_type_in_docs.val] = false,
				[settings.type_goes_first.val] = false,
				[settings.direction.val] = true,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.return_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "@param",
				[settings.type_keyword.val] = "",
				[settings.return_keyword.val] = "@returns",
				[settings.return_type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", " -"},
				[settings.type_wrapper.val] = {"", ""},
				[settings.return_type_wrapper.val] = {"{", "}"}
				}
		},
		lua = {
			LDoc = {
				[settings.struct.val] = {"--- ", "-- "},
				[settings.is_type_in_docs.val] = true,
				[settings.is_return_type_in_docs.val] = false,
				[settings.type_goes_first.val] = false,
				[settings.direction.val] = true,
				[settings.title_pos.val] = 1,
				[settings.empty_line_after_title.val] = false,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.return_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "@param",
				[settings.type_keyword.val] = "",
				[settings.return_keyword.val] = "@return",
				[settings.return_type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"", ""},
				[settings.return_type_wrapper.val] = {"", ""}
				}
		},
		ruby = {
			YARD = {
				[settings.struct.val] = {" # ", " # "},
				[settings.is_type_in_docs.val] = false,
				[settings.is_return_type_in_docs.val] = false,
				[settings.type_goes_first.val] = false,
				[settings.direction.val] = true,
				[settings.title_pos.val] = 1,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.return_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "@param",
				[settings.type_keyword.val] = "",
				[settings.return_keyword.val] = "@return",
				[settings.return_type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"[", "]"},
				[settings.return_type_wrapper.val] = {"[", "]"}
				}
		},
		php = {
			PHPDoc = {
				[settings.struct.val] = {"/**", " * ", " */"},
				[settings.is_type_in_docs.val] = true,
				[settings.is_return_type_in_docs.val] = true,
				[settings.type_goes_first.val] = true,
				[settings.direction.val] = true,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.return_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "",
				[settings.type_keyword.val] = "@param",
				[settings.return_keyword.val] = "@return",
				[settings.return_type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"", ""},
				[settings.return_type_wrapper.val] = {"", ""}
				}
		},
		java = {
			JavaDoc = {
				[settings.struct.val] = {"/**", " * ", " */"},
				[settings.is_type_in_docs.val] = false,
				[settings.is_return_type_in_docs.val] = false,
				[settings.type_goes_first.val] = false,
				[settings.direction.val] = true,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.return_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "@param",
				[settings.type_keyword.val] = "",
				[settings.return_keyword.val] = "@return",
				[settings.return_type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"", ""},
				[settings.return_type_wrapper.val] = {"", ""}
				}
		},
		kotlin = {
			KDoc = {
				[settings.struct.val] = {"/**", " * ", " */"},
				[settings.is_type_in_docs.val] = false,
				[settings.is_return_type_in_docs.val] = false,
				[settings.type_goes_first.val] = false,
				[settings.direction.val] = true,
				[settings.title_pos.val] = 2,
				[settings.empty_line_after_title.val] = true,
				[settings.section_underline.val] = "",
				[settings.params_title.val] = "",
				[settings.return_title.val] = "",
				[settings.is_param_one_line.val] = true,
				[settings.is_type_below_name_first.val] = false,
				[settings.param_keyword.val] = "@param",
				[settings.type_keyword.val] = "",
				[settings.return_keyword.val] = "@return",
				[settings.return_type_keyword.val] = "",
				[settings.param_indent.val] = false,
				[settings.name_wrapper.val] = {"", ""},
				[settings.type_wrapper.val] = {"", ""},
				[settings.return_type_wrapper.val] = {"", ""}
				}
			}
}

return {settings, default_lang_styles, styles}
