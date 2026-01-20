--- Here are all the available opts for all languages
--- An option is composed of 3 parts:
--- Its value or name, the data type it expects and a description

local general = {
	structure = "table", --Defines the docstring structure with at least two parts
	direction = "boolean", -- True for above, false for below the function
	title_pos = "number", -- Title line offset within the docstring
	title_gap = "boolean", -- Adds a blank line after the title if there's a section
	section_gap = "boolean", -- Adds spacing between sections if more than one exists
	section_gap_text = "string", -- String to be inserted in between 2 sections
	section_underline = "string", -- Character used to underline section titles
	section_title_gap = "boolean", -- Adds spacing after the title if there's an item
	item_gap = "boolean", -- Adds spacing between items if multiple exist
	section_order = "table", -- Specifies the order of docstring sections
}

local item = {
	title = "string", -- Section title
	inline = "boolean", -- True if name and type are on the same line
	indent = "boolean", -- Indents items if true
	include_type = "boolean", -- Includes item type if true
	type_first = "boolean", -- Places type before name if true
	name_kw = "string", -- Keyword prefixed to item names
	type_kw = "string", -- Keyword prefixed to item types
	name_wrapper = "table", -- Strings surrounding item names
	type_wrapper = "table", -- Strings surrounding item types
	is_type_below_name_first = "boolean", -- TODO: Verify logic and update description
}

local class_general = {
	include_class_body_attrs = "boolean", -- Includes class attributes if true
	include_instance_attrs = "boolean", -- Includes instance attributes if true
	include_only_constructor_instance_attrs = "boolean", -- Includes only constructor-defined attributes if true
}

local opts = vim.tbl_extend("error", general, class_general, item)
return opts
