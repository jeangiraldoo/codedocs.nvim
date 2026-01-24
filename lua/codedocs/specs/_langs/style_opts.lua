--- Here are all the available opts for all languages

local general = {
	layout = "table", --Defines the docstring structure with at least two parts
	direction = "boolean", -- True for above, false for below the function
	annotation_title = {
		line_offset = "number", -- Title line offset within the docstring
		gap = "boolean", -- Adds a blank line after the title if there's a section
	},
	section = {
		gap = "boolean", -- Adds spacing between sections if more than one exists
		gap_text = "string", -- String to be inserted in between 2 sections
		order = "table", -- Specifies the order of docstring sections
	},
	item_gap = "boolean", -- Adds spacing between items if multiple exist
}

local item = {
	section_title = "string", -- Section title
	indent = "boolean", -- Indents items if true
	item_name = {
		keyword = "string", -- Keyword prefixed to item names
		delimiters = "table", -- Strings surrounding item names
	},
	item_type = {
		include = "boolean", -- Includes item type if true
		keyword = "string", -- Keyword prefixed to item types
		delimiters = "table", -- Strings surrounding item types
		is_before_name = "boolean", -- Places type before name if true
	},
	is_type_below_name_first = "boolean", -- TODO: Verify logic and update description
}

local class_attr_section_items = {
	include_class_attrs = "boolean", -- Includes class attributes if true
	include_instance_attrs = "boolean", -- Includes instance attributes if true
	include_only_constructor_instance_attrs = "boolean", -- Includes only constructor-defined attributes if true
}

local opts = vim.tbl_extend("error", general, class_attr_section_items, item)
return opts
