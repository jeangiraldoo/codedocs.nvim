--- Here are all the available opts for all languages
--- An option is composed of 3 parts:
--- Its value or name, the data type it expects and a description

local general = {
	struct = {
		val = "structure",
		type = "table",
		description = "Defines the docstring structure with at least two parts",
	},
	direction = {
		val = "direction",
		type = "boolean",
		description = "True for above, false for below the function",
	},
	title_pos = {
		val = "title_pos",
		type = "number",
		description = "Title line offset within the docstring",
	},
	title_gap = {
		val = "title_gap",
		type = "boolean",
		description = "Adds a blank line after the title if there's a section",
	},
	section_gap = {
		val = "section_gap",
		type = "boolean",
		description = "Adds spacing between sections if more than one exists",
	},
	section_underline = {
		val = "section_underline",
		type = "string",
		description = "Character used to underline section titles",
	},
	section_title_gap = {
		val = "section_title_gap",
		type = "boolean",
		description = "Adds spacing after the title if there's an item",
	},
	item_gap = {
		val = "item_gap",
		type = "boolean",
		description = "Adds spacing between items if multiple exist",
	},
	section_order = {
		val = "section_order",
		type = "table",
		description = "Specifies the order of docstring sections",
	},
}

local item = {
	title = {
		val = "title",
		type = "string",
		description = "Section title",
	},
	inline = {
		val = "inline",
		type = "boolean",
		description = "True if name and type are on the same line",
	},
	indent = {
		val = "indent",
		type = "boolean",
		description = "Indents items if true",
	},
	include_type = {
		val = "include_type",
		type = "boolean",
		description = "Includes item type if true",
	},
	type_first = {
		val = "type_first",
		type = "boolean",
		description = "Places type before name if true",
	},
	name_kw = {
		val = "name_kw",
		type = "string",
		description = "Keyword prefixed to item names",
	},
	type_kw = {
		val = "type_kw",
		type = "string",
		description = "Keyword prefixed to item types",
	},
	name_wrapper = {
		val = "name_wrapper",
		type = "table",
		description = "Strings surrounding item names",
	},
	type_wrapper = {
		val = "type_wrapper",
		type = "table",
		description = "Strings surrounding item types",
	},
	is_type_below_name_first = {
		val = "is_type_below_name_first",
		type = "boolean",
		description = "TODO: Verify logic and update description",
	},
}

local class_general = {
	include_class_body_attrs = {
		val = "include_class_attrs",
		type = "boolean",
		description = "Includes class attributes if true",
	},
	include_instance_attrs = {
		val = "include_instance_attrs",
		type = "boolean",
		description = "Includes instance attributes if true",
	},
	include_only_constructor_instance_attrs = {
		val = "include_only_construct_instance_attrs",
		type = "boolean",
		description = "Includes only constructor-defined attributes if true",
	},
}

local opts = vim.tbl_extend("error", general, class_general, item)
return opts
