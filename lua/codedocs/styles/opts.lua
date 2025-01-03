--- Here are all the available opts for all languages
--- A setting is composed of 2 parts: Its value or name, and the data type it expects

local func = {
	-- general = {
			struct = {val = "structure", type = "table"}, -- Base structure of a docstring, with 2 or more parts
		  	direction = {val = "direction", type = "boolean"}, -- True to place the docstring above, false to place it below
		  	title_pos = {val = "title_pos", type = "number"}, -- Line offset of the title within the docstring, relative to its start
		  	empty_ln_after_title = {val = "empty_ln_after_title", type = "boolean"}, -- Inserts an empty line after the title if true
			empty_ln_between_sections = {val = "empty_ln_between_sections", type = "boolean"},
			empty_ln_after_section_item = {val = "empty_ln_after_section_item", type = "boolean"},
			empty_ln_after_section_title = {val = "empty_ln_after_section_title", type = "boolean"},
			section_underline = {val = "section_underline", type = "string"}, -- Creates a string of the specified char to underline the section title
	-- },
	-- params = {
			params_title = {val = "params_title", type = "string"}, -- Title displayed before the parameters section in the docstring
		  	param_indent = {val = "param_indent", type = "boolean"}, -- Determines wether or not the parameters should be indented
			is_type_in_docs = {val = "is_type_in_docs", type = "boolean"}, -- Determines wether or not to document the parameter type in the docstring
		  	param_kw = {val = "param_kw", type = "string"}, -- Keyword prefixed to each parameter name in the docstring
			type_kw = {val = "type_kw", type = "string"}, -- Keyword prefixed to each parameter type in the docstring
		  	name_wrapper = {val = "name_wrapper", type = "table"}, -- Strings that will surround every parameter name within the docstring
		  	type_wrapper = {val = "type_wrapper", type = "table"}, -- Strings that will surround every parameter type within the docstring
		  	is_param_one_ln = {val = "is_param_one_ln", type = "boolean"}, -- Determines if the param name and type go on the same line or not
			is_type_below_name_first = {val = "is_type_below_name_first", type = "boolean"}, -- Determines if the type below starts with the param name or just the type. This setting is used whenever is_param_one_line is false
		  	type_goes_first = {val = "type_goes_first", type = "boolean"},
	-- },
	-- returns = {
			return_title = {val = "return_title", type = "string"}, -- Ttitle displayed at the beggining of the return section
			return_kw = {val = "return_kw", type = "string"}, -- Keyword prefixed to the return line
			return_type_kw = {val = "return_type_kw", type = "string"},
			is_return_type_in_docs = {val = "is_return_type_in_docs", type = "boolean"}, -- Determines wether or not to include the return type
			return_type_wrapper = {val = "return_type_wrapper", type = "table"} -- Strings that will surround the return type
	-- }
}

return func
