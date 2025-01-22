--- Here are all the available opts for all languages
--- A setting is composed of 2 parts: Its value or name, and the data type it expects


local general = {
	struct = {val = "structure", type = "table"}, -- Base structure of a function docstring, with 2 or more parts
	direction = {val = "direction", type = "boolean"}, -- True to place the docstring above, false for below
	title_pos = {val = "title_pos", type = "number"}, -- Line offset of the title within the docstring, relative to its start
	title_gap = {val = "title_gap", type = "boolean"}, -- Adds an empty line after the title if true, but only if there’s at least one section
	section_gap = {val = "section_gap", type = "boolean"}, -- Adds a gap between sections if true and more than one section exists
	section_underline = {val = "section_underline", type = "string"}, -- Character used to underline each letter in a section title
	section_title_gap = {val = "section_title_gap", type = "boolean"}, -- Adds a gap after the title if true and there’s at least one item
	item_gap = {val = "item_gap", type = "boolean"}, -- Adds a gap between items if true and there’s more than one item
	section_order = {val = "section_order", type = "table"}
}

local item = {
	title = {val = "params_title", type = "string"}, -- Title of the parameter section
	inline = {val = "param_inline", type = "boolean"}, -- Determines if the parameter name and type appear on the same line
	indent = {val = "param_indent", type = "boolean"}, -- Determines wether or not the parameters should be indented
	include_type = {val = "include_param_type", type = "boolean"}, -- Determines if the parameter type is included
	type_first = {val = "param_type_first", type = "boolean"}, -- Determines if the parameter type is placed before the name
	kw = {val = "param_kw", type = "string"}, -- Keyword prefixed to each parameter name in the docstring
	type_kw = {val = "param_type_kw", type = "string"}, -- Keyword prefixed to each parameter type in the docstring
	name_wrapper = {val = "param_name_wrapper", type = "table"}, -- Strings that surround each parameter name
	type_wrapper = {val = "param_type_wrapper", type = "table"}, -- Strings that surround each parameter type
	is_type_below_name_first = {val = "is_type_below_name_first", type = "boolean"}, -- TODO: Check logic and add description accordingly
}

local class_item = {
	include_non_constructor_attrs = {val = "include_non_constructor_attrs", type = "boolean"}
}

local generic = {
	struct = {val = "structure", type = "table"}, -- Base structure of a generic docstring, with one or more parts
	title_pos = {val = "title_pos", type = "number"}, -- Line offset of the title within the docstring, relative to its start
	direction = {val = "direction", type = "boolean"}, -- True to place the docstring above, false for below
}

-- return {
-- 	func = func,
-- 	class = class,
-- 	generic = generic
-- }

return {
	generic = generic,
	item = item,
	class_item = class_item,
	general = general
}
