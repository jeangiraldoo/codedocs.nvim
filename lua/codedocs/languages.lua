--- Here are all the available opts for all languages
--- A setting is composed of 2 parts: Its value or name, and the data type it expects
local opts = {
			struct = {val = "structure", type = "table"}, -- Base structure of a docstring, represented as a table with 2 or more elements
		  	type_goes_first = {val = "type_goes_first", type = "boolean"},
		  	direction = {val = "direction", type = "boolean"}, -- Position to place the docstring relative to the function declaration. Either true (above) or false (below)
		  	title_pos = {val = "title_pos", type = "number"}, -- Line offset of the title within the docstring, relative to its start
		  	empty_line_after_title = {val = "empty_line_after_title", type = "boolean"}, -- Inserts an empty line after the title if true
			empty_line_between_sections = {val = "empty_line_between_sections", type = "boolean"},
			empty_line_after_section_item = {val = "empty_line_after_section_item", type = "boolean"},
		  	section_underline = {val = "section_underline", type = "string"}, -- Creates a string of the specified char to underline the section title
		  	params_title = {val = "params_title", type = "string"}, -- Title displayed before the parameters section in the docstring
			return_title = {val = "return_title", type = "string"}, -- Ttitle displayed at the beggining of the return section
			empty_line_after_section_title = {val = "empty_line_after_section_title", type = "boolean"},
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

local default_styles = {
			python = "Google",
			javascript = "JSDoc",
			typescript = "TSDoc",
			lua = "LDoc",
			ruby = "YARD",
			php = "PHPDoc",
			java = "JavaDoc",
			kotlin = "KDoc",
			rust = "RustDoc"
			}

local styles = {
		python = {
			Google = {
				[opts.struct.val] = {'"""', "", '"""'},
				[opts.is_type_in_docs.val] = true,
				[opts.is_return_type_in_docs.val] = true,
				[opts.type_goes_first.val] = false,
				[opts.direction.val] = false,
				[opts.title_pos.val] = 2,
				[opts.empty_line_after_title.val] = true,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item] = false,
				[opts.section_underline.val] = "",
				[opts.params_title.val] = "Args:",
				[opts.return_title.val] = "Returns:",
				[opts.is_param_one_line.val] = true,
				[opts.is_type_below_name_first.val] = false,
				[opts.param_keyword.val] = "",
				[opts.type_keyword.val] = "",
				[opts.return_keyword.val] = "",
				[opts.return_type_keyword.val] = "",
				[opts.param_indent.val] = true,
				[opts.name_wrapper.val] = {"", ""},
				[opts.type_wrapper.val] = {"(", "):"},
				[opts.return_type_wrapper.val] = {"", ":"}
				},
			Numpy = {
				[opts.struct.val] = {'"""', "", '"""'},
				[opts.is_type_in_docs.val] = true,
				[opts.is_return_type_in_docs.val] = true,
				[opts.type_goes_first.val] = false,
				[opts.direction.val] = false,
				[opts.title_pos.val] = 2,
				[opts.empty_line_after_title.val] = true,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item.val] = false,
				[opts.section_underline.val] = "-",
				[opts.params_title.val] = "Parameters",
				[opts.return_title.val] = "Returns",
				[opts.is_param_one_line.val] = true,
				[opts.is_type_below_name_first.val] = false,
				[opts.param_keyword.val] = "",
				[opts.type_keyword.val] = "",
				[opts.return_keyword.val] = "",
				[opts.return_type_keyword.val] = "",
				[opts.param_indent.val] = false,
				[opts.name_wrapper.val] = {"", ""},
				[opts.type_wrapper.val] = {": ", ""},
				[opts.return_type_wrapper.val] = {"", ""}
				},
			reST = {
				[opts.struct.val] = {'"""', "", '"""'},
				[opts.is_type_in_docs.val] = true,
				[opts.is_return_type_in_docs.val] = true,
				[opts.type_goes_first.val] = false,
				[opts.direction.val] = false,
				[opts.title_pos.val] = 2,
				[opts.empty_line_after_title.val] = true,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item.val] = false,
				[opts.section_underline.val] = "",
				[opts.params_title.val] = "",
				[opts.return_title.val] = "",
				[opts.is_param_one_line.val] = false,
				[opts.is_type_below_name_first.val] = true,
				[opts.param_keyword.val] = ":param",
				[opts.type_keyword.val] = ":type",
				[opts.return_keyword.val] = ":return:",
				[opts.return_type_keyword.val] = ":rtype:",
				[opts.param_indent.val] = false,
				[opts.name_wrapper.val] = {"", ":"},
				[opts.type_wrapper.val] = {"", ""},
				[opts.return_type_wrapper.val] = {"", ""}
				}
		},
		javascript = {
			JSDoc = {
				[opts.struct.val] = {"/**", " * ", " */"},
				[opts.is_type_in_docs.val] = true,
				[opts.is_return_type_in_docs.val] = true,
				[opts.type_goes_first.val] = true,
				[opts.direction.val] = true,
				[opts.title_pos.val] = 2,
				[opts.empty_line_after_title.val] = true,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item.val] = false,
				[opts.section_underline.val] = "",
				[opts.params_title.val] = "",
				[opts.return_title.val] = "",
				[opts.is_param_one_line.val] = true,
				[opts.is_type_below_name_first.val] = false,
				[opts.param_keyword.val] = "",
				[opts.type_keyword.val] = "@param",
				[opts.return_keyword.val] = "@returns",
				[opts.return_type_keyword.val] = "",
				[opts.param_indent.val] = false,
				[opts.name_wrapper.val] = {"", ""},
				[opts.type_wrapper.val] = {"{", "}"},
				[opts.return_type_wrapper.val] = {"{", "}"}
				}
		},
		typescript = {
			TSDoc = {
				[opts.struct.val] = {"/**", " * ", " */"},
				[opts.is_type_in_docs.val] = false,
				[opts.is_return_type_in_docs.val] = false,
				[opts.type_goes_first.val] = false,
				[opts.direction.val] = true,
				[opts.title_pos.val] = 2,
				[opts.empty_line_after_title.val] = true,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item.val] = false,
				[opts.section_underline.val] = "",
				[opts.params_title.val] = "",
				[opts.return_title.val] = "",
				[opts.is_param_one_line.val] = true,
				[opts.is_type_below_name_first.val] = false,
				[opts.param_keyword.val] = "@param",
				[opts.type_keyword.val] = "",
				[opts.return_keyword.val] = "@returns",
				[opts.return_type_keyword.val] = "",
				[opts.param_indent.val] = false,
				[opts.name_wrapper.val] = {"", " -"},
				[opts.type_wrapper.val] = {"", ""},
				[opts.return_type_wrapper.val] = {"{", "}"}
				}
		},
		lua = {
			LDoc = {
				[opts.struct.val] = {"--- ", "-- "},
				[opts.is_type_in_docs.val] = true,
				[opts.is_return_type_in_docs.val] = false,
				[opts.type_goes_first.val] = false,
				[opts.direction.val] = true,
				[opts.title_pos.val] = 1,
				[opts.empty_line_after_title.val] = false,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item.val] = false,
				[opts.section_underline.val] = "",
				[opts.params_title.val] = "",
				[opts.return_title.val] = "",
				[opts.is_param_one_line.val] = true,
				[opts.is_type_below_name_first.val] = false,
				[opts.param_keyword.val] = "@param",
				[opts.type_keyword.val] = "",
				[opts.return_keyword.val] = "@return",
				[opts.return_type_keyword.val] = "",
				[opts.param_indent.val] = false,
				[opts.name_wrapper.val] = {"", ""},
				[opts.type_wrapper.val] = {"", ""},
				[opts.return_type_wrapper.val] = {"", ""}
				}
		},
		ruby = {
			YARD = {
				[opts.struct.val] = {" # ", " # "},
				[opts.is_type_in_docs.val] = false,
				[opts.is_return_type_in_docs.val] = false,
				[opts.type_goes_first.val] = false,
				[opts.direction.val] = true,
				[opts.title_pos.val] = 1,
				[opts.empty_line_after_title.val] = true,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item.val] = false,
				[opts.section_underline.val] = "",
				[opts.params_title.val] = "",
				[opts.return_title.val] = "",
				[opts.is_param_one_line.val] = true,
				[opts.is_type_below_name_first.val] = false,
				[opts.param_keyword.val] = "@param",
				[opts.type_keyword.val] = "",
				[opts.return_keyword.val] = "@return",
				[opts.return_type_keyword.val] = "",
				[opts.param_indent.val] = false,
				[opts.name_wrapper.val] = {"", ""},
				[opts.type_wrapper.val] = {"[", "]"},
				[opts.return_type_wrapper.val] = {"[", "]"}
				}
		},
		php = {
			PHPDoc = {
				[opts.struct.val] = {"/**", " * ", " */"},
				[opts.is_type_in_docs.val] = true,
				[opts.is_return_type_in_docs.val] = true,
				[opts.type_goes_first.val] = true,
				[opts.direction.val] = true,
				[opts.title_pos.val] = 2,
				[opts.empty_line_after_title.val] = true,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item.val] = false,
				[opts.section_underline.val] = "",
				[opts.params_title.val] = "",
				[opts.return_title.val] = "",
				[opts.is_param_one_line.val] = true,
				[opts.is_type_below_name_first.val] = false,
				[opts.param_keyword.val] = "",
				[opts.type_keyword.val] = "@param",
				[opts.return_keyword.val] = "@return",
				[opts.return_type_keyword.val] = "",
				[opts.param_indent.val] = false,
				[opts.name_wrapper.val] = {"", ""},
				[opts.type_wrapper.val] = {"", ""},
				[opts.return_type_wrapper.val] = {"", ""}
				}
		},
		java = {
			JavaDoc = {
				[opts.struct.val] = {"/**", " * ", " */"},
				[opts.is_type_in_docs.val] = false,
				[opts.is_return_type_in_docs.val] = false,
				[opts.type_goes_first.val] = false,
				[opts.direction.val] = true,
				[opts.title_pos.val] = 2,
				[opts.empty_line_after_title.val] = true,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item.val] = false,
				[opts.section_underline.val] = "",
				[opts.params_title.val] = "",
				[opts.return_title.val] = "",
				[opts.is_param_one_line.val] = true,
				[opts.is_type_below_name_first.val] = false,
				[opts.param_keyword.val] = "@param",
				[opts.type_keyword.val] = "",
				[opts.return_keyword.val] = "@return",
				[opts.return_type_keyword.val] = "",
				[opts.param_indent.val] = false,
				[opts.name_wrapper.val] = {"", ""},
				[opts.type_wrapper.val] = {"", ""},
				[opts.return_type_wrapper.val] = {"", ""}
				}
		},
		kotlin = {
			KDoc = {
				[opts.struct.val] = {"/**", " * ", " */"},
				[opts.is_type_in_docs.val] = false,
				[opts.is_return_type_in_docs.val] = false,
				[opts.type_goes_first.val] = false,
				[opts.direction.val] = true,
				[opts.title_pos.val] = 2,
				[opts.empty_line_after_title.val] = true,
				[opts.empty_line_after_section_title.val] = false,
				[opts.empty_line_between_sections.val] = false,
				[opts.empty_line_after_section_item.val] = false,
				[opts.section_underline.val] = "",
				[opts.params_title.val] = "",
				[opts.return_title.val] = "",
				[opts.is_param_one_line.val] = true,
				[opts.is_type_below_name_first.val] = false,
				[opts.param_keyword.val] = "@param",
				[opts.type_keyword.val] = "",
				[opts.return_keyword.val] = "@return",
				[opts.return_type_keyword.val] = "",
				[opts.param_indent.val] = false,
				[opts.name_wrapper.val] = {"", ""},
				[opts.type_wrapper.val] = {"", ""},
				[opts.return_type_wrapper.val] = {"", ""}
				}
			}
}

return {opts, default_styles, styles}
